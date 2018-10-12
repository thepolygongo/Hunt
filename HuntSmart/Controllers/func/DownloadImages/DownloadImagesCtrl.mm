//
//  DownloadImagesCtrl.mm
//  HuntSmart
//
//  Created by Wildlife Management Services on 3/15/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import "DownloadImagesCtrl.h"
#define PI            3.141592654
#define twoPI        ( 2 * PI )
#define RADEG        ( 180.0 / PI )
#define DEGRAD        ( PI / 180.0 )
#define sind(x)  sin((x)*DEGRAD)
#define cosd(x)  cos((x)*DEGRAD)

NSString* riseTime;
NSString* setTime;
NSString* overTime;

@interface DownloadImagesCtrl () {
    int processedCount;
    int lastImageID;
    int recCount;
    int photonumber;
    int deercount;
    int hogcount;
    int turkeycount;
    int noncount;
    int bearcount;
}

@end

@implementation DownloadImagesCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    lastImageID = [SettingUtils lastImageID];
    
    self.mTableView.layoutMargins = UIEdgeInsetsZero;
    self.mTableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
    mPredictor = [predict_image new];
    
    self.mImages = [NSMutableArray new];
    if (![[NSUserDefaults standardUserDefaults]
          boolForKey:@"download_instruction"]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Instructions" message:@"Use the Load button at the top right to select photos from the photo gallery." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"download_instruction"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark - instance methods

- (void)pickMultipleImage {
    DLFPhotosPickerViewController *photosPicker = [[DLFPhotosPickerViewController alloc] init];
    [photosPicker setPhotosPickerDelegate:self];
    [photosPicker setMultipleSelections:YES];
    [self presentViewController:photosPicker animated:YES completion:nil];
}

#pragma mark - instance methods

- (IBAction)onClickBtnAction:(id)sender {
    if ([self.btnAction.titleLabel.text isEqualToString:@"Load"]) {
        [self pickMultipleImage];
    }
    else if ([self.btnAction.titleLabel.text isEqualToString:@"Weather"]) {
        [self getWeatherDataOfImages];
    }
}

- (void)processImages:(NSMutableArray *)assets : (NSMutableArray *)photos completion:(block)completion {
    __block NSUInteger count = assets.count;
    processedCount = 0;
    
    for (PHAsset *asset in assets) {
        [asset requestContentEditingInputWithOptions:nil
                                   completionHandler:^(PHContentEditingInput *contentEditingInput, NSDictionary *info)
            {
                NSURL *imageURL = contentEditingInput.fullSizeImageURL;
                NSString *imagePath = imageURL.path;
                processedCount += 1;
                lastImageID += 1;
                recCount += 1;
                
                NSDictionary *predictResult = [mPredictor RunInferenceOnImage:imagePath];
                NSString *label = @"Other";
                
                if (predictResult) {
                    float bestValue = 0;
                    for (NSString *key in predictResult.allKeys) {
                        NSNumber *valueNumber = [predictResult valueForKey:key];
                        float value = valueNumber.floatValue;
                        if (bestValue < value) {
                            bestValue = value;
                            label = key;
                        }
                    }
                    if ([label  isEqual: @"Whitetail Deer"]){
                        deercount +=1;
                    }
                    if ([label  isEqual: @"Black Bear"]){
                        bearcount +=1;
                    }
                    if ([label  isEqual: @"Turkey"]){
                        turkeycount +=1;
                    }
                    if ([label  isEqual: @"Hog"]){
                        hogcount +=1;
                    }
                    if ([label  isEqual: @"Other"]){
                        noncount +=1;
                    }
                    if ([label  isEqual: @"raccoon"]){
                        label = @"Other";
                        noncount +=1;
                    }
                    if ([label  isEqual: @"people"]){
                        label = @"Other";
                        noncount +=1;
                    }
                    if ([label  isEqual: @"cow"]){
                        label = @"Other";
                        noncount +=1;
                    }
                    if ([label  isEqual: @"bird"]){
                        label = @"Other";
                        noncount +=1;
                    }
                        
                    if (bestValue < required_score) {
                        label = @"Other";
                    }
                }
                
                ImageModel *image = [CoreDataModel.sharedInstance insertItem:@"ImageModel"];
                image.id = lastImageID;
                image.hasWeather = false;
                image.camera = self.mCamera.id;
                image.path = imagePath;
                image.label = label;
                image.createdAt = asset.creationDate;
                image.hour = asset.creationDate.hour;
                image.data = [NSData dataWithContentsOfURL:imageURL];
                image.inImages = true;
                image.inCharts = true;
                
                [self.mImages addObject:image];
                [CoreDataModel.sharedInstance saveData];
                
                if (processedCount == count) {
                    completion();
                }
           }];
    }
}


- (void)processImages:(NSMutableArray *)assets : (NSMutableArray *)photos {
    [self showProgress:[NSString stringWithFormat:@"Processed: %d Images \n Deer: %d \n Black Bear: %d \n Turkey: %d \n Hog: %d \n Other: %d" , recCount, deercount, bearcount, turkeycount, hogcount, noncount]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self processImages:assets: photos completion:^{
            
            [self runInMainQueue:^{
                [self.btnAction setTitle:@"Weather" forState:UIControlStateNormal];
                [SettingUtils saveLastImageID:lastImageID];
                [self.mTableView reloadData];
                [self hideProgress];
                NSMutableArray *photos2= [[NSMutableArray alloc]init];
                
                [self arraysplitter:photos : photos2];
            }];
        }];
    });
}

- (void)getWeatherDataOfImages {
    [self showProgress:@"Getting Weather Data..."];
    NSTimeInterval timeZoneOffset = [[NSTimeZone defaultTimeZone] secondsFromGMT];
    processedCount = 0;
    
    for (ImageModel *image in self.mImages) {
        NSTimeInterval gmtTime = [image.createdAt timeIntervalSince1970] - timeZoneOffset;
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake(self.mCamera.latitude, self.mCamera.longitude);
        
        [NetworkUtils getWeatherAt:gmtTime in:location success:^(id response) {
            Weather *weather = [Weather getFromDictionary:response];
            weather.camera = self.mCamera.id;
            weather.image = image.id;
            NSDate* currentdate = image.createdAt;
            [self main2: currentdate];
            if ([riseTime isEqualToString:@""]) {
                riseTime = @"None";
            }
            if ([setTime isEqualToString:@""]) {
                setTime = @"None";
            }
            if ([overTime isEqualToString:@""]) {
                overTime = @"None";
            }
            weather.moonrise = riseTime;
            weather.moonset = setTime;
            weather.moonover = overTime;
            image.hasWeather = true;
            [CoreDataModel.sharedInstance saveWeather:weather];
            
            [self checkProcessing];
            
        } failure:^(id error) {
            [self checkProcessing];
        }];
    }
}

- (void)checkProcessing {
    processedCount += 1;
    if (processedCount == self.mImages.count) {
        [self.btnAction setTitle:@"Done" forState:UIControlStateNormal];
        [self hideProgress];
    }
}

#pragma mark - DLFPhotosPickerViewControllerDelegate

//- (void)photosPicker:(DLFPhotosPickerViewController *)photosPicker detailViewController:(DLFDetailViewController *)detailViewController didSelectPhoto:(PHAsset *)photo {
//    [photosPicker dismissViewControllerAnimated:YES completion:^{
//        [self processImages:@[photo]];
//    }];
//}

- (void)photosPickerDidCancel:(DLFPhotosPickerViewController *)photosPicker {
    [photosPicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)photosPicker:(DLFPhotosPickerViewController *)photosPicker detailViewController:(DLFDetailViewController *)detailViewController didSelectPhotos:(NSMutableArray *)photos {
    NSLog(@"selected %d photos", (int)photos.count);
    [photosPicker dismissViewControllerAnimated:YES completion:^{
        NSMutableArray *photos2= [[NSMutableArray alloc]init];
        [self arraysplitter:photos : photos2];
        
    }];
    
}

-(void) arraysplitter: (NSMutableArray *) photos : (NSMutableArray *) photos2
{
    //NSMutableArray *photos2= [[NSMutableArray alloc]init];
    int maxnumber = 25;
    int numberofphotos = 0;
    photonumber = 0;
    if (photos.count > 0) {
        NSLog(@"\nHere1");
        if (photos.count > 25){
            NSLog(@"\nHere2");
            maxnumber = 25;
        }else {
            NSLog(@"\nHere3");
            maxnumber = photos.count;}
        NSLog(@"\n%d", maxnumber);
        while (photonumber < maxnumber ){
            NSLog(@"\nHere5");
            [photos2 addObject:photos[0]];
            NSLog(@"\nHere6");
            [photos removeObjectAtIndex:0];
            NSLog(@"\nHere7");
            photonumber++;
        }
    }
    if (photonumber > 0){
        photonumber = 0;
        [self processImages:photos2 : photos];
    }
    
}

#pragma mark - UITableView delegate and datasource

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.mImages)
        return 0;
    return self.mImages.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    LoadedImageCell *cell = [self.mTableView dequeueReusableCellWithIdentifier:@"LoadedImageCell"];
    
    ImageModel *image = [self.mImages objectAtIndex:indexPath.row];
    cell.imgAnimal.image = [UIImage imageWithData:image.data];
    cell.lblAnimalLabel.text = image.label;
    cell.lblImageName.text = [self getNameFromPath:image.path];
    cell.lblCaptureDate.text = getDateTimeStringFromDate(image.createdAt);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.mTableView deselectRowAtIndexPath:indexPath animated:false];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    ImageModel *image = [self.mImages objectAtIndex:indexPath.row];
    image.inImages = false;
    [CoreDataModel.sharedInstance saveData];
    
    [self.mImages removeObject:image];
    [self.mTableView beginUpdates];
    [self.mTableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationRight];
    [self.mTableView endUpdates];
}

- (NSString *)getNameFromPath:(NSString *)path {
    return [path.lastPathComponent stringByDeletingPathExtension];
}

-(int) main2: (NSDate*) currentdate
{
    int year;
    int month;
    int day;
    int tz;                    // time zone
    double ourlong;
    double ourlat;
    double date;
    double underlong, zone, JD;
    // modified julian date, days since 1858 Nov 17 00:00, 1858 Nov 17 00:00 is JD 2400000.5
    double UT;
    double moonrise, moontransit, moonunder, moonset, moonphase, sunrise, suntransit, sunset;
    int object = 1;         //1 IS MOON, 0 IS SUN
    int soldayscale, phasedayscale;
    double minorstart1, minorstop1, minorstart2, minorstop2;
    double majorstart1, majorstop1, majorstart2, majorstop2;
    char mnst1[10] = "00:00", mnsp1[10] = "00:00", mnst2[10] = "00:00", mnsp2[10] = "00:00";
    char mjst1[10] = "00:00", mjsp1[10] = "00:00", mjst2[10] = "00:00", mjsp2[10] = "00:00";
    double loc_lat = self.mCamera.latitude;
    double loc_long = self.mCamera.longitude;
    NSTimeZone* systemTimeZone = [NSTimeZone systemTimeZone];
    NSTimeInterval offset2 = [systemTimeZone daylightSavingTimeOffset];
    
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM/dd/YYYY"];
    //self.datePicker.text=[NSString stringWithFormat:@"%@", [formatter stringFromDate:currentdate.date]];
    [formatter setDateFormat:@"yyyy"];
    NSString *yearDate = [formatter stringFromDate:currentdate];
    year = [yearDate intValue];
    [formatter setDateFormat:@"MM"];
    NSString *monthDate = [formatter stringFromDate:currentdate];
    month = [monthDate intValue];
    [formatter setDateFormat:@"dd"];
    NSString *dayDate = [formatter stringFromDate:currentdate];
    day = [dayDate intValue];
    //year = 0;
    //month = 0;
    //day = 0;
    
    
    //******************************************************************************
    
    //******************************************************************************
    //get date and position from user.
    
    //printf("\n\n");
    //printf( "Input Year ( yyyy ) : " );
    //scanf( "%d", &year );
    //printf( "Input Month ( mm ) : " );
    //scanf( "%d", &month );
    //printf( "Input Day ( dd ) : " );
    //scanf( "%d", &day );
    //printf( "Input Longitude (- is west) : " );
    //scanf( "%lf", &underlong );
    //printf( "Input Latitude (- is south) : " );
    ///scanf( "%lf", &ourlat );
    //printf( "Input Time zone offset ( EST = -5 ) : " );
    //scanf( "%d", &tz );
    
    //year = 2018;
    //month = 06;
    //day = 10;
    underlong = loc_long;
    printf("\nunderlong = %f", underlong);
    ourlat = loc_lat;
    tz = (((timezone-offset2)/3600)*-1);
    printf("\n\nSolunar data for ");
    printf ("%d / %d / %d\n", year, month, day);
    printf("\n%d", tz);
    printf("\n%f", offset2);
    
    //init some values
    UT = 0.0;
    ourlong = 0.0 - underlong;  //equations use east longitude negative convention
    zone = tz / 24.0;
    JD = get_julian_date (year, month, day, UT);
    date = (JD - 2400000.5 - zone);
    //get rise set times for moon and sun
    //    object = 0;    //moon
    //    [self get_rst:object :date :ourlong :ourlat :&sunrise :&sunset :&suntransit];
    object = 0;    //moon
    [self get_rst:object :date :ourlong :ourlat :&moonrise :&moonset :&moontransit];
    return 0;
}


//astro.c
- (double) get_rst: (int) object : (double) date : (double) ourlong : (double) ourlat : (double *) Rise : (double *) Set : (double *) Transit
//get rise, set and transit times of object sun or moon
{
    double sl;          //sin lat
    double cl;          //cos lat
    double xe, ye, z1, z2;
    double riseTime = 0, setTime = 0, transitTime = 0;
    double above = 0;
    double ym = 0, y0, yp;
    double sinho[2];        //0 IS MOON, 1 IS SUN
    int doesRise = 0, doesSet = 0, doesTransit = 0, hour = 1, check = 0;
    int nz = 0;
    char eventName[8];
    //******************************************************************************
    // init some values
    sl = sind(ourlat); cl = cosd(ourlat);  //sin and cos of latitude
    sinho[0] = .002327;         //moonrise - average diameter used
    sinho[1] = -0.014544;       //sunrise - classic value for refraction
    
    ym = sinalt(object, date, hour - 1, ourlong, cl, sl) - sinho[object];
    if (ym > 0) {
        above = 1;
    }
    else {
        above = 0;
    }
    //start rise-set loop
    do
    {
        y0 = sinalt(object, date, hour, ourlong, cl, sl) - sinho[object];
        yp = sinalt(object, date, hour + 1, ourlong, cl, sl) - sinho[object];
        xe = 0;
        ye = 0;
        z1 = 0;
        z2 = 0;
        nz = 0;
        quad (ym, y0, yp, &xe, &ye, &z1, &z2, &nz);
        switch (nz)
        {
            case 0:    //nothing  - go to next time slot
                break;
            case 1:                      //simple rise / set event
                if (ym < 0) {       //must be a rising event
                    riseTime = hour + z1;
                    doesRise = 1;
                }
                else {    //must be setting
                    setTime = hour + z1;
                    doesSet = 1;
                }
                break;
            case 2:                      //rises and sets within interval
                if (ye < 0) {       //minimum - so set then rise
                    riseTime = hour + z2;
                    setTime = hour + z1;
                }
                else {    //maximum - so rise then set
                    riseTime = hour + z1;
                    setTime = hour + z2;
                }
                doesRise = 1;
                doesSet = 1;
                break;
        }
        
        ym = yp;     //reuse the ordinate in the next interval
        hour = hour + 2;
        check = (doesRise * doesSet);
    }
    while ((hour != 25) && (check != 1));
    // end rise-set loop
    //GET TRANSIT TIME
    hour = 0; //reset hour
    //transitTime = get_transit(object, date, hour, ourlong);
    transitTime = [self get_transit:object :date :hour :ourlong];
    if (transitTime != 0.0) {
        doesTransit = 1;
    }
    if (object == 0){
        printf("\nMOON");
    }
    else {
        printf("\n\nSUN");
    }
    //logic to sort the various rise, transit set states
    // nested if's...sorry
    if ((doesRise == 1) || (doesSet == 1) || (doesTransit == 1)) {   //current object rises, sets or transits today
        if (doesRise == 1) {
            *Rise = riseTime;
            printf ("riseTime: %d", Rise);
            snprintf(eventName, 6, "rise");
            //display_event_time(riseTime, eventName);
            [self display_event_time:riseTime :eventName];
        }
        else {
            *Rise = 0.0;
            printf ("\ndoes not rise");
            //self.riseLbl.text = [NSString stringWithFormat:@"None"];
        }
        if (doesTransit == 1) {
            *Transit = transitTime;
            snprintf(eventName, 8, "transit");
            //display_event_time(transitTime, eventName);
            [self display_event_time:transitTime :eventName];
        }
        else {
            *Transit = 0.0;
            printf ("\ndoes not transit");
            //self.transitLbl.text = [NSString stringWithFormat:@"None"];
            
        }
        if (doesSet == 1) {
            *Set = setTime;
            snprintf(eventName, 6, "set");
            //display_event_time(setTime, eventName);
            [self display_event_time:setTime :eventName];
        }
        else {
            *Set = 0.0;
            printf ("\ndoes not set");
            //self.setLbl.text = [NSString stringWithFormat:@"None"];
        }
        
    }
    else { //current object not so simple
        if (above == 1) {
            printf ("\nalways above horizon");
        }
        else {
            printf ("\nalways below horizon");
        }
    }
    //thats it were done.
    return 0;
}

/******************************************************************************/
double get_julian_date(int year, int month, int day, double UT)
{
    double locJD, a, b, c, d, e, f, g;
    a = modf((month + 9)/12, &b);
    a = modf((7 * (year + b))/4, &c);
    a = modf((275 * month)/9, &d);
    e = 367 * year - c + d + day + 1721013.5 + UT/24;
    f = (100 * year + month - 190002.5);
    g = f/fabs(f);
    locJD = e - 0.5 * g + 0.5;
    return (locJD);
}

/******************************************************************************/
-(void) display_event_time : (double) time : (char[6]) event
{
    char sTime[10];
    //char riseTime[10];
    //char setTime[10];
    //char overTime[10]
    convert_time_to_string (sTime, time);
    printf("\n %s = %s",event, sTime);
    if (strcmp(event, "rise")==0){
        //self.riseLbl.text = [NSString stringWithFormat:@"%s", sTime];
        riseTime = [NSString stringWithUTF8String:sTime];
        //snprintf(riseTime, 10, "%s",riseTime);
    }
    if (strcmp(event, "transit")==0){
        //self.transitLbl.text = [NSString stringWithFormat:@"%s", sTime];
        overTime = [NSString stringWithUTF8String:sTime];
    }
    if (strcmp(event, "set")==0){
        //self.setLbl.text = [NSString stringWithFormat:@"%s", sTime];
        setTime = [NSString stringWithUTF8String:sTime];
    }
    //    if (strcmp(event, "under foot")==0){
    //        self.underLbl.text = [NSString stringWithFormat:@"%s", sTime];
    //    }
    return;
}






/******************************************************************************/
float ipart (double x)
//returns the true integer part, even for negative numbers
{
    float a;
    if (x != 0) {
        a = x/fabs(x) * floor(fabs(x));
    }
    else {
        a=0;
    }
    return a;
}

/******************************************************************************/
double fpart (double x)
//returns fractional part of a number
{
    x = x - floor(x);
    if ( x < 0) {
        x = x + 1;
    }
    return x;
}

/******************************************************************************/
double sinalt (int object, double mjd0, int hour, double ourlong, double cphi,
               double sphi )
/*
 returns sine of the altitude of either the sun or the moon given the modified
 julian day number at midnight UT and the hour of the UT day, the longitude of
 the observer, and the sine and cosine of the latitude of the observer
 */
{
    double loc_sinalt;   //sine of the altitude, return value;
    double ra = 0.0;
    double dec = 0.0;
    double instant, t;
    double lha;            //hour angle
    instant = mjd0 + hour / 24.0;
    t = (instant - 51544.5) / 36525;
    if (object == 0) {
        get_moon_pos (t, &ra, &dec);
    }
    else {
        get_sun_pos (t, &ra, &dec);
    }
    lha = 15.0 * (lmst(instant, ourlong) - ra);    //hour angle of object
    loc_sinalt = sphi * sind(dec) + cphi * cosd(dec) * cosd(lha);
    return (loc_sinalt);
}

/******************************************************************************/
double lmst (double mjd, double ourlong)
//returns the local siderial time for the modified julian date and longitude
{
    double value;
    float mjd0;
    double ut;
    double t;
    double gmst;
    mjd0 = ipart(mjd);
    ut = (mjd - mjd0) * 24;
    t = (mjd0 - 51544.5) / 36525;
    gmst = 6.697374558 + 1.0027379093 * ut;
    gmst = gmst + (8640184.812866 + (.093104 - .0000062 * t) * t) * t / 3600;
    value = 24.0 * fpart((gmst - ourlong / 15.0) / 24.0);
    return (value);
}

/******************************************************************************/
void get_sun_pos (double t, double *ra, double *dec)
/*
 Returns RA and DEC of Sun to roughly 1 arcmin for few hundred years either side
 of J2000.0
 */
{
    double COSEPS = 0.91748;
    double SINEPS = 0.39778;
    double m, dL, L, rho, sl;
    double RA, DEC;
    double x, y, z;
    m = twoPI * fpart(0.993133 + 99.997361 * t);        //Mean anomaly
    dL = 6893 * sin(m) + 72 * sin(2 * m);          //Eq centre
    L = twoPI * fpart(0.7859453 + m / twoPI + (6191.2 * t + dL) / 1296000);
    sl = sin(L);
    x = cos(L);
    y = COSEPS * sl;
    z = SINEPS * sl;
    rho = sqrt(1 - z * z);
    DEC = (360 / twoPI) * atan2(z , rho);
    RA = (48 / twoPI) * atan2(y , (x + rho));
    if (RA < 0) {
        RA = RA + 24;
    }
    *ra = RA;
    *dec = DEC;
    return;
}

/******************************************************************************/
void get_moon_pos (double t, double *ra, double *dec)
/*
 returns ra and dec of Moon to 5 arc min (ra) and 1 arc min (dec) for a few
 centuries either side of J2000.0 Predicts rise and set times to within minutes
 for about 500 years in past - TDT and UT time diference may become significant
 for long times
 */
{
    double ARC = 206264.8062;
    double COSEPS = 0.91748;
    double SINEPS = 0.39778;
    double L0, L, LS, d, F;
    L0 = fpart(.606433 + 1336.855225 * t);    //'mean long Moon in revs
    L = twoPI * fpart(.374897 + 1325.55241 * t); //'mean anomaly of Moon
    LS = twoPI * fpart(.993133 + 99.997361 * t); //'mean anomaly of Sun
    d = twoPI * fpart(.827361 + 1236.853086 * t); //'diff longitude sun and moon
    F = twoPI * fpart(.259086 + 1342.227825 * t); //'mean arg latitude
    //' longitude correction terms
    double dL, h;
    dL = 22640 * sin(L) - 4586 * sin(L - 2 * d);
    dL = dL + 2370 * sin(2 * d) + 769 * sin(2 * L);
    dL = dL - 668 * sin(LS) - 412 * sin(2 * F);
    dL = dL - 212 * sin(2 * L - 2 * d) - 206 * sin(L + LS - 2 * d);
    dL = dL + 192 * sin(L + 2 * d) - 165 * sin(LS - 2 * d);
    dL = dL - 125 * sin(d) - 110 * sin(L + LS);
    dL = dL + 148 * sin(L - LS) - 55 * sin(2 * F - 2 * d);
    //' latitude arguments
    double S, N, lmoon, bmoon;
    S = F + (dL + 412 * sin(2 * F) + 541 * sin(LS)) / ARC;
    h = F - 2 * d;
    //' latitude correction terms
    N = -526 * sin(h) + 44 * sin(L + h) - 31 * sin(h - L) - 23 * sin(LS + h);
    N = N + 11 * sin(h - LS) - 25 * sin(F - 2 * L) + 21 * sin(F - L);
    lmoon = twoPI * fpart(L0 + dL / 1296000); //  'Lat in rads
    bmoon = (18520 * sin(S) + N) / ARC;  //     'long in rads
    //' convert to equatorial coords using a fixed ecliptic
    double CB, x, V, W, y, Z, rho, DEC, RA;
    CB = cos(bmoon);
    x = CB * cos(lmoon);
    V = CB * sin(lmoon);
    W = sin(bmoon);
    y = COSEPS * V - SINEPS * W;
    Z = SINEPS * V + COSEPS * W;
    rho = sqrt(1.0 - Z * Z);
    DEC = (360.0 / twoPI) * atan2(Z , rho);
    RA = (48.0 / twoPI) * atan2(y , (x + rho));
    if (RA < 0) {
        RA = RA + 24.0;
    }
    *ra = RA;
    *dec = DEC;
    return;
}

/******************************************************************************/
void quad (double ym, double y0, double yp, double *xe, double *ye, double *z1,
           double *z2, int *nz)
/*
 finds a parabola through three points and returns values of coordinates of
 extreme value (xe, ye) and zeros if any (z1, z2) assumes that the x values are
 -1, 0, +1
 */
{
    double a, b, c, dx, dis, XE, YE, Z1, Z2;
    int NZ;
    NZ = 0;
    XE = 0;
    YE = 0;
    Z1 = 0;
    Z2 = 0;
    a = .5 * (ym + yp) - y0;
    b = .5 * (yp - ym);
    c = y0;
    XE = (0.0 - b) / (a * 2.0); //              'x coord of symmetry line
    YE = (a * XE + b) * XE + c; //      'extreme value for y in interval
    dis = b * b - 4.0 * a * c;   //    'discriminant
    //more nested if's
    if ( dis > 0.000000 ) {                 //'there are zeros
        dx = (0.5 * sqrt(dis)) / (fabs(a));
        Z1 = XE - dx;
        Z2 = XE + dx;
        if (fabs(Z1) <= 1) {
            NZ = NZ + 1 ;   // 'This zero is in interval
        }
        if (fabs(Z2) <= 1) {
            NZ = NZ + 1  ;   //'This zero is in interval
        }
        if (Z1 < -1) {
            Z1 = Z2;
        }
    }
    *xe = XE;
    *ye = YE;
    *z1 = Z1;
    *z2 = Z2;
    *nz = NZ;
    return;
}

/******************************************************************************/

/******************************************************************************/
//double get_transit (int object, double mjd0, int hour, double ourlong)
- (double) get_transit: (int) object : (double) mjd0 : (int) hour : (double) ourlong
{
    double ra = 0.0;
    double dec = 0.0;   //not used here but the pos functions return it.
    double instant, t;
    double lha;            //local hour angle
    double loc_transit;    // transit time, return value.
    int min = 0;
    int hourarray2[25];
    //int* hourarray2 = calloc(sizeof(int), 24);
    //int *hourarray2 = (int*) malloc(24 * sizeof(int));
    int minarray2[61];
    //int* minarray2 = calloc(sizeof(int), 60);
    //int *minarray2 = (int*) malloc(60 * sizeof(int));
    double LA;  //local angle
    int sLA;    //sign of angle
    double mintime;
    
    //loop through all 24 hours of the day and store the sign of the angle in an array
    //actually loop through 25 hours if we reach the 25th hour with out a transit then no transit condition today.
    
    while (hour < 25.0)
    {
        instant = mjd0 + hour / 24.0;
        t = (instant - 51544.5) / 36525;
        if (object == 0) {
            get_moon_pos (t, &ra, &dec);
        }
        else {
            get_sun_pos (t, &ra, &dec);
        }
        lha = (lmst(instant, ourlong) - ra);
        LA = lha * 15.04107;    //convert hour angle to degrees
        sLA = LA/fabs(LA);      //sign of angle
        hourarray2[hour] = sLA;
        hour++;
    }
    //search array for the when the angle first goes from negative to positive
    int i = 0;
    while (i < 25)
    {
        loc_transit = i;
        if (hourarray2[i] - hourarray2[i+1] == -2) {
            //we found our hour
            break;
        }
        
        i++;
    }
    //check for no transit, return zero
    if (loc_transit > 23) {
        // no transit today
        loc_transit = 0.0;
        return loc_transit;
    }
    
    //loop through all 60 minutes of the hour and store sign of the angle in an array
    mintime = loc_transit;
    while (min < 60)
    {
        instant = mjd0 + mintime / 24.0;
        t = (instant - 51544.5) / 36525;
        if (object == 0) {
            get_moon_pos (t, &ra, &dec);
        }
        else {
            get_sun_pos (t, &ra, &dec);
        }
        lha = (lmst(instant, ourlong) - ra);
        LA = lha * 15.04107;
        sLA = (int)(LA/fabs(LA));
        minarray2[min] = sLA;
        min++;
        mintime = mintime + 0.016667;        //increment 1 minute
    }
    
    i = 0;
    while (i < 60)
    {
        if (minarray2[i] - minarray2[i+1] == -2) {
            //we found our min
            break;
        }
        i++;
        loc_transit = loc_transit + 0.016667;
    }
    //free(hourarray2);
    //free(minarray2);
    return loc_transit;
}


//******************************************************************************

void convert_time_to_string (char stringtime[10], double doubletime)
{
    double i, d;
    double twelveTime;
    /*split the time into hours (i) and minutes (d)*/
    d = modf(doubletime, &i);
    d = d * 60;
    if (d >= 59.5) {
        i = i + 1;
        d = 0;
    }
    if (i == 12){
        twelveTime =i;
        if (d < 9.5){
            snprintf(stringtime, 9, "%.0f:0%.0f PM",twelveTime , d);
        }else {
            snprintf(stringtime, 9, "%.0f:%.0f PM",twelveTime , d);
        }
    }
    if (i > 12){
        twelveTime = i -12;
        if (d < 9.5){
            snprintf(stringtime, 9, "%.0f:0%.0f PM",twelveTime , d);
        }else {
            snprintf(stringtime, 9, "%.0f:%.0f PM",twelveTime , d);
        }
    }
    if (i < 12) {
        twelveTime = i;
        if (d < 9.5){
            snprintf(stringtime, 9, "%.0f:0%.0f AM",twelveTime , d);
        }else {
            snprintf(stringtime, 9, "%.0f:%.0f AM",twelveTime , d);
        }
    }
    /*convert times to a string*/
    //    if (d < 9.5) {
    //        snprintf(stringtime, 6, "%.0f:0%.0f",twelveTime , d);
    //    }
    //    else {
    //        snprintf(stringtime, 6, "%.0f:%.0f",twelveTime , d);
    //    }
    return;
}
//******************************************************************************



@end
