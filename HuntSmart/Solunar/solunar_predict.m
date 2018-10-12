//
//  solunar_predict.m
//  HuntSmart
//
//  Created by Jason Ray on 6/19/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import "solunar_predict.h"
#define PI            3.141592654
#define twoPI        ( 2 * PI )
#define RADEG        ( 180.0 / PI )
#define DEGRAD        ( PI / 180.0 )
#define sind(x)  sin((x)*DEGRAD)
#define cosd(x)  cos((x)*DEGRAD)



@interface solunar_predict ()

@end

@implementation solunar_predict

- (void)viewDidLoad {
    [super viewDidLoad];
    int16_t camera = self.mCamera.id;
    dateSelector = [[UIDatePicker alloc]init];
    dateSelector.datePickerMode=UIDatePickerModeDate;
    [self.datePicker setInputView:dateSelector];
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(ShowDate)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    [self.datePicker setInputAccessoryView:toolBar];
    
    if (![[NSUserDefaults standardUserDefaults]
          boolForKey:@"solunar_instruction"]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Instructions" message:@"Select the date above and press Get Times at the bottom to see the Solunar information for this camera location." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"solunar_instruction"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [self main2];
    
}

-(void)ShowDate
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM/dd/YYYY"];
    self.datePicker.text=[NSString stringWithFormat:@"%@", [formatter stringFromDate:dateSelector.date]];
    [formatter setDateFormat:@"yyyy"];
    NSString *year = [formatter stringFromDate:dateSelector.date];
    //printf("\ncurrent year: %s", [year UTF8String]);
    //printf [NSString [stringWithFormat:@"\n Current Year: %s", year]];
    [self.datePicker resignFirstResponder];
    NSTimeInterval currentDate = [dateSelector.date timeIntervalSince1970];
    //printf("\ncurrent date: %f", currentDate);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClickBtnBack:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
- (IBAction)calculate:(id)sender {
    [self main2];
}

-(int) main2 {
    int year;
    int month;
    int day;
    int tz;                    // time zone
    double ourlong;
    double ourlat;
    double underlong, zone, JD;
    double date;            // modified julian date, days since 1858 Nov 17 00:00, 1858 Nov 17 00:00 is JD 2400000.5
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
    //Get Year From Date Picker
    [formatter setDateFormat:@"YYYY"];
    NSString *yearDate = [formatter stringFromDate:dateSelector.date];
    printf("\ncurrent year: %s", [yearDate UTF8String]);
    year = [yearDate intValue];
    //Get Month From Date Picker
    [formatter setDateFormat:@"MM"];
    NSString *monthDate = [formatter stringFromDate:dateSelector.date];
    printf("\ncurrent Month: %s", [monthDate UTF8String]);
    month = [monthDate intValue];
    //Get Day From Date Picker
    [formatter setDateFormat:@"dd"];
    NSString *dayDate = [formatter stringFromDate:dateSelector.date];
    printf("\ncurrent Day: %s", [dayDate UTF8String]);
    day = [dayDate intValue];
    
    
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
    //get_rst ( object, date, ourlong, ourlat, &moonrise, &moonset, &moontransit);
    //get moon under-foot time
    //moonunder = get_underfoot(date, underlong);
    moonunder = [self get_underfoot:date :underlong];
    //get moon phase
    //moonphase = get_moon_phase (date);
    moonphase = [self get_moon_phase:date];
    //get solunar minor periods
    //only calculate if the minor periods do not overlap prev or next days
    printf ("\n Moonrise: %f", moonrise);
    printf ("\n Moonset: %f", moonset);
    printf ("\n Moontransit: %f", moontransit);
    printf ("\n Moonunder: %f", moonunder);
    sol_get_minor1(mnst1, mnsp1, moonrise);
    sol_get_minor2(mnst2, mnsp2, moonset);
//    if (moonrise >= 1.0 & moonrise <= 23.0) {
//        sol_get_minor1(mnst1, mnsp1, moonrise);
//    }
//    if (moonset >= 1.0 & moonset <= 23.0) {
//        sol_get_minor2(mnst2, mnsp2, moonset);
//    }
    //sol_display_minors (mnst1, mnsp1, mnst2, mnsp2, moonrise, moonset);
    [self sol_display_minors:mnst1 :mnsp1 :mnst2 :mnsp2 :moonrise :moonset];
    //get solunar major periods
    //only calculate if the major periods do not overlap prev and next days*/
//    sol_get_major1(mjst1, mjsp1, moontransit);
//    sol_get_major2(mjst2, mjsp2, moonunder);
    if (moontransit >= 1.5 & moontransit <= 22.5) {
        sol_get_major1(mjst1, mjsp1, moontransit);
    }
    if (moonunder >= 1.5 & moonunder <= 22.5) {
        sol_get_major2(mjst2, mjsp2, moonunder);
    }
    //sol_display_majors (mjst1, mjsp1, mjst2, mjsp2, moontransit, moonunder);
    [self sol_display_majors:mjst1 :mjsp1 :mjst2 :mjsp2 :moontransit :moonunder];
    //get day scale
    //phasedayscale = phase_day_scale (moonphase);
    phasedayscale = [self phase_day_scale:moonphase];
    //soldayscale = sol_get_dayscale (moonrise, moonset, moontransit, moonunder, sunrise, sunset);
    soldayscale = [self sol_get_dayscale:moonrise :moonset :moontransit :moonunder :sunrise :sunset];
    //sol_display_dayscale (soldayscale, phasedayscale);
    [self sol_display_dayscale:soldayscale :phasedayscale];
    /*thats it, we are done*/
    printf("\n");
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
            self.riseLbl.text = [NSString stringWithFormat:@"None"];
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
            self.transitLbl.text = [NSString stringWithFormat:@"None"];
            
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
            self.setLbl.text = [NSString stringWithFormat:@"None"];
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
    convert_time_to_string (sTime, time);
    printf("\n %s = %s",event, sTime);
    if (strcmp(event, "rise")==0){
        self.riseLbl.text = [NSString stringWithFormat:@"%s", sTime];
    }
    if (strcmp(event, "transit")==0){
        self.transitLbl.text = [NSString stringWithFormat:@"%s", sTime];
    }
    if (strcmp(event, "set")==0){
        self.setLbl.text = [NSString stringWithFormat:@"%s", sTime];
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
//double get_moon_phase (double date)
- (double) get_moon_phase: (double) date
{
    int PriPhaseOccurs; //1 = yes, 0 = no
    int i = 0;
    double ourhour;
    double hour = -1;
    double ls, lm, diff;
    double instant, t, ra, dec;
    double phase;
    double hourarray[104];
    //double* hourarray = calloc(sizeof(double), 100);
    //double *hourarray = (double*) calloc(100 * sizeof(double));
    double minarray[119];
    //double* minarray = calloc(sizeof(double), 119);
    //double *minarray = (double*) malloc(119 * sizeof(double));
    double illumin, age = 0.0, PriPhaseTime;
    char PhaseName[16];
    /*some notes on structure of hourarray[]
     *  increment is 15mins
     * i =  0, hourarray[0] = hour -1, hour 23 of prev day.
     * i =  1, hourarry[1] = hour -0.75, hour 23.15 of prev day.
     * i = 4, hourarray[4] = hour 0 of today.
     * i = 52, hourarray[52] = hour 12 of today.
     * i = 99, hourarray[99] = hour 23.75 of today.
     * i = 100, hourarray[100] = hour 0 of nextday.
     *
     * to convert i to todays hour = (i/4 -1)
     */
    
    //find and store illumination for every 1/4 hour in an array
    while (i < 104)
    {
        instant = date + hour / 24.0;
        t = (instant - 51544.5) / 36525;
        lm = get_moon_long (t);
        ls = get_sun_long (t);
        diff = lm - ls;
        phase = (1.0 - cosd(lm - ls))/2;
        phase *=100;
        if (diff < 0) {
            diff += 360;
        }
        if (diff > 180) {
            phase *= -1;
        }
        illumin = fabs(phase);
        hourarray[i] = illumin;
        i++;
        hour+= 0.25;
    }
    i = 0;
    while (i < 104)
    {
        ourhour = i;
        ourhour = ((ourhour/4) - 1);
        //check for a new moon
        if ((hourarray[i] < hourarray[i+1]) && (hourarray[i] < 0.001)) {
            break;
        }
        //check for a full moon
        if ( (hourarray[i] > hourarray[i+1]) && (hourarray[i] > 99.9999) ){
            break;
        }
        //check for a first quarter
        if ( (hourarray[i] < hourarray[i+1]) && (hourarray[i] > 50) && (hourarray[i] < 50.5)){
            break;
        }
        //check for a last quarter
        if ( (hourarray[i] > hourarray[i+1]) && (hourarray[i] < 50) && (hourarray[i] > 49.5) ){
            break;
        }
        
        i++;
    }
    if ( ourhour < 0 || ourhour >= 24 ) {
        PriPhaseOccurs = 0;
    }
    else {
        PriPhaseOccurs = 1;
    }
    
    if (PriPhaseOccurs == 1){
        //check every min start with the previous hour
        if (ourhour > 0) {
            hour = ipart(ourhour) - 1;
        }
        else {
            hour = ipart(ourhour);
        }
        
        PriPhaseTime = hour;
        i = 0;
        while (i < 120)
        {
            instant = date + hour / 24.0;
            t = (instant - 51544.5) / 36525;
            lm = get_moon_long (t);
            ls = get_sun_long (t);
            diff = lm - ls;
            phase = (1.0 - cosd(lm - ls))/2;
            phase *=100;
            if (diff < 0) {
                diff += 360;
            }
            if (diff > 180) {
                phase *= -1;
            }
            // we are getting age at the wrong time here, maybe for a primary phase
            // we should use a static age, like we do for illumin.
            //age = fabs(diff/13);
            illumin = fabs(phase);
            minarray[i] = illumin;
            hour = hour + 0.016667;
            i++;
        }
        
        i = 0;
        int ourmin;
        while (i < 120)
        {
            ourmin = i;
            //check for a new moon
            if ((minarray[i] < minarray[i+1]) && (minarray[i] < 0.1)) {
                illumin = 0;
                age = 0.0;
                snprintf(PhaseName, 16, "NEW");
                break;
            }
            //check for a full moon
            if ( (minarray[i] > minarray[i+1]) && (minarray[i] > 99) ){
                illumin = 100;
                age = 14.0;
                snprintf(PhaseName, 16, "FULL");
                break;
            }
            //check for a first quarter
            if ( (minarray[i] < minarray[i+1]) && (minarray[i] > 50) && (minarray[i] < 51)){
                illumin = 50;
                age = 7.0;
                snprintf(PhaseName, 16, "First Quarter");
                break;
            }
            //check for a last quarter
            if ( (minarray[i] > minarray[i+1]) && (minarray[i] < 50) && (minarray[i] > 49) ){
                illumin = 50;
                age = 21.0;
                snprintf(PhaseName, 16, "Last Quarter");
                break;
            }
            PriPhaseTime = PriPhaseTime + 0.016667;
            i++;
        }
        
    }
    else {
        //if we didn't find a primary phase, check the phase at noon.
        //    date = (JD - 2400000.5);
        instant = date + .5;//check at noon
        t = (instant - 51544.5) / 36525;
        lm = get_moon_long (t);
        ls = get_sun_long (t);
        diff = lm - ls;
        phase = (1.0 - cosd(lm - ls))/2;
        phase *=100;
        if (diff < 0) {
            diff += 360;
        }
        if (diff > 180) {
            phase *= -1;
        }
        //age = fabs((lm - ls)/13);
        age = fabs(diff/13);
        illumin = fabs(phase);
        //Get phase type
        if( fabs(phase) <  50 && phase < 0 ) {
            snprintf(PhaseName, 16, "Waning Crescent");
        }
        else if( fabs(phase) <  50 && phase > 0 ) {
            snprintf(PhaseName, 16, "Waxing Crescent");
        }
        else if( fabs(phase) < 100 && phase < 0 ) {
            snprintf(PhaseName, 16, "Waning Gibbous");
        }
        else if( fabs(phase) < 100 && phase > 0 ) {
            snprintf(PhaseName, 16, "Waxing Gibbous");
        }
        else {
            printf("\nERROR, no moon phase was found\n");
        }
    }
    if (PriPhaseOccurs == 1){
        char sTime[6];
        convert_time_to_string (sTime, PriPhaseTime);
        printf("\n phase is %s at %s, ", PhaseName, sTime);
        self.phaseLbl.text = [NSString stringWithFormat:@"%s", PhaseName];
    }
    else{
        printf("\n phase is %s, ", PhaseName);
        self.phaseLbl.text = [NSString stringWithFormat:@"%s", PhaseName];
    }
    printf("%2.1f%% illuminated, ", illumin);
    self.illuminLbl.text = [NSString stringWithFormat:@"%2.1f%%", illumin];
    printf("%2.1f days since new\n", age);
    //free(hourarray);
    //free(minarray);
    return (illumin);
    
}
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

//double get_underfoot (double date, double underlong)
- (double) get_underfoot: (double) date : (double) underlong
{
    double moonunderTime;
    int doesUnderfoot;
    char eventName[11];
    double underlong2 = underlong * -1;
    //moonunderTime = get_transit (0, date, 0, underlong);
    moonunderTime = [self get_transit: 0 : date : 0 :underlong2];
    double moonunderTime2 = moonunderTime +12.2333;
    printf("\nget_under_foot: %f", moonunderTime2);
    if (moonunderTime2 != 0.0) {
        snprintf(eventName, 11, "under foot");
        //display_event_time(moonunderTime, eventName);
        [self display_event_time:moonunderTime2 :eventName];
        
        
    }
    else {
        printf ("\nMoon does not transit under foot");
        //self.underLbl.text = [NSString stringWithFormat:@"None"];
    }
    return moonunderTime2;
}

/******************************************************************************/
double get_moon_long (double t)
{
    double ARC = 206264.8062;
    double COSEPS = 0.91748;
    double SINEPS = 0.39778;
    double L0, L, LS, d, F;
    double moonlong;
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
    moonlong = lmoon * RADEG;
    return moonlong;
}

/******************************************************************************/
double get_sun_long (double t)
{
    double COSEPS = 0.91748;
    double SINEPS = 0.39778;
    double m, dL, L, rho, sl;
    double RA, DEC;
    double x, y, z;
    double sunlong;
    m = twoPI * fpart(0.993133 + 99.997361 * t);        //Mean anomaly
    dL = 6893 * sin(m) + 72 * sin(2 * m);          //Eq centre
    L = twoPI * fpart(0.7859453 + m / twoPI + (6191.2 * t + dL) / 1296000);
    sunlong = L * RADEG;
    return sunlong;
}

//sol.c

void sol_get_minor1 (char mnst1[10], char mnsp1[10], double moonrise)
{
    double minorstart1, minorstop1;
    minorstart1 = moonrise - 1.0;
    if (minorstart1 < 0.0) {
        minorstart1 = 0.0;
    }
    printf ("\n MinorStart1: %f", minorstart1);
    minorstop1 = moonrise + 1.0;
    if (minorstop1 < 0.0) {
        minorstop1 = 0.0;
    }
    printf ("\n MinorStop1: %f", minorstop1);
    convert_time_to_string (mnst1, minorstart1);
    convert_time_to_string (mnsp1, minorstop1);
    return;
}
//******************************************************************************

void sol_get_minor2 (char mnst2[10], char mnsp2[10], double moonset)
{
    double minorstart2, minorstop2;
    minorstart2 = moonset - 1.0;
    printf ("\n MinorStart2: %f", minorstart2);
    if (minorstart2 < 0.0) {
        minorstart2 = 0.0;
    }
    minorstop2 = moonset + 1.0;
    printf ("\n MinorStop2: %f", minorstop2);
    if (minorstop2 < 0.0) {
        minorstop2 = 0.0;
    }
    convert_time_to_string (mnst2, minorstart2);
    convert_time_to_string (mnsp2, minorstop2);
    return;
}
//******************************************************************************

void sol_get_major1(char mjst1[10], char mjsp1[10], double moontransit)
{
    double majorstart1, majorstop1;
    majorstart1 = moontransit - 1.5;
    if (majorstart1 < 0.0) {
        majorstart1 = 0.0;
    }
    majorstop1 = moontransit + 1.5;
    if (majorstop1 < 0.0) {
        majorstop1 = 0.0;
    }
    convert_time_to_string (mjst1, majorstart1);
    convert_time_to_string (mjsp1, majorstop1);
    return;
}
//******************************************************************************


void sol_get_major2(char mjst2[10], char mjsp2[10], double moontransit)
{
    double majorstart2, majorstop2;
    majorstart2 = moontransit - 1.5;
    if (majorstart2 < 0.0) {
        majorstart2 = 0.0;
    }
    majorstop2 = moontransit + 1.5;
    if (majorstop2 < 0.0) {
        majorstop2 = 0.0;
    }
    convert_time_to_string (mjst2, majorstart2);
    convert_time_to_string (mjsp2, majorstop2);
    return;
}

//******************************************************************************

//void sol_display_majors (char mjst1[10], char mjsp1[10], char mjst2[10], char mjsp2[10], double moontransit, double moonunder)
- (void) sol_display_majors: (char[10]) mjst1 : (char[10]) mjsp1 : (char[10]) mjst2 : (char[10]) mjsp2 : (double) moontransit : (double) moonunder
{
    printf ("\n\n");
    printf ("Major Times");
    /*display earlier major time first*/
    if (moontransit < moonunder){
        printf ("\n%s - %s", mjst1, mjsp1);
        //self.major1Lbl.text = [NSString stringWithFormat:@"%s - %s", mjst1, mjsp1];
        printf ("\n%s - %s", mjst2, mjsp2);
        //self.major2Lbl.text = [NSString stringWithFormat:@"%s - %s", mjst2, mjsp2];
        if (strcmp(mjst1, "00:00")==0 && strcmp(mjsp1, "00:00")==0) {
            self.major1Lbl.text = [NSString stringWithFormat:@""];
        } else {
            self.major1Lbl.text = [NSString stringWithFormat:@"%s - %s", mjst1, mjsp1];
        }
        if (strcmp(mjst2, "00:00")==0 && strcmp(mjsp2, "00:00")==0) {
            self.major2Lbl.text = [NSString stringWithFormat:@""];
        } else {
            self.major2Lbl.text = [NSString stringWithFormat:@"%s - %s", mjst2, mjsp2];
        }
    }
    else {
        printf ("\n%s - %s", mjst2, mjsp2);
        //self.major1Lbl.text = [NSString stringWithFormat:@"%s - %s", mjst2, mjsp2];
        printf ("\n%s - %s", mjst1, mjsp1);
        //self.major2Lbl.text = [NSString stringWithFormat:@"%s - %s", mjst1, mjsp1];
        if (strcmp(mjst2, "00:00")==0 && strcmp(mjsp2, "00:00")==0) {
            self.major1Lbl.text = [NSString stringWithFormat:@""];
        } else {
            self.major1Lbl.text = [NSString stringWithFormat:@"%s - %s", mjst2, mjsp2];
        }
        if (strcmp(mjst1, "00:00")==0 && strcmp(mjsp1, "00:00")==0) {
            self.major2Lbl.text = [NSString stringWithFormat:@""];
        } else {
            self.major2Lbl.text = [NSString stringWithFormat:@"%s - %s", mjst1, mjsp1];
        }
    }
    return;
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

//void sol_display_minors (char mnst1[10], char mnsp1[10], char mnst2[10], char mnsp2[10], double moonrise, double moonset)
- (void) sol_display_minors: (char[10]) mnst1 : (char[10]) mnsp1 : (char[10]) mnst2 : (char[10]) mnsp2 : (double) moonrise : (double) moonset
{
    printf ("\n");
    printf ("Minor Times");
    /*display earlier minor time first*/
    if (moonrise < moonset){
        printf ("\n%s - %s", mnst1, mnsp1);
        printf ("\n%s - %s", mnst2, mnsp2);
        if (strcmp(mnst1, "00:00")==0 && strcmp(mnsp1, "00:00")==0) {
            self.minor1Lbl.text = [NSString stringWithFormat:@""];
        } else {
            self.minor1Lbl.text = [NSString stringWithFormat:@"%s - %s", mnst1, mnsp1];
        }
        if (strcmp(mnst2, "00:00")==0 && strcmp(mnsp2, "00:00")==0) {
            self.minor2Lbl.text = [NSString stringWithFormat:@""];
        } else {
            self.minor2Lbl.text = [NSString stringWithFormat:@"%s - %s", mnst2, mnsp2];
        }
        //self.minor1Lbl.text = [NSString stringWithFormat:@"%s - %s", mnst1, mnsp1];
        //self.minor2Lbl.text = [NSString stringWithFormat:@"%s - %s", mnst2, mnsp2];
    }
    else {
        printf ("\n%s - %s", mnst2, mnsp2);
        printf ("\n%s - %s", mnst1, mnsp1);
        if (strcmp(mnst2, "00:00")==0 && strcmp(mnsp2, "00:00")==0) {
            self.minor1Lbl.text = [NSString stringWithFormat:@""];
        } else {
            self.minor1Lbl.text = [NSString stringWithFormat:@"%s - %s", mnst2, mnsp2];
        }
        if (strcmp(mnst1, "00:00")==0 && strcmp(mnsp1, "00:00")==0) {
            self.minor2Lbl.text = [NSString stringWithFormat:@""];
        } else {
            self.minor2Lbl.text = [NSString stringWithFormat:@"%s - %s", mnst1, mnsp1];
        }
        //self.minor1Lbl.text = [NSString stringWithFormat:@"%s - %s", mnst2, mnsp2];
        //self.minor2Lbl.text = [NSString stringWithFormat:@"%s - %s", mnst1, mnsp1];
    }
    return;
}
//******************************************************************************

//int phase_day_scale (double moonphase)
- (int) phase_day_scale: (double) moonphase
{
    int scale = 0;
    if( fabs(moonphase) <  0.9 ) {        //new
        scale = 3;
    }
    else if( fabs(moonphase) <  6.0 ) {
        scale = 2;
    }
    else if( fabs(moonphase) <  9.9 ) {
        scale = 1;
    }
    else if( fabs(moonphase) > 99 ) {        //full
        scale = 3;
    }
    else if( fabs(moonphase) > 94 ) {
        scale = 2;
    }
    else if( fabs(moonphase) > 90.1 ) {
        scale = 1;
    }
    else {
        scale = 0;
    }
    
    return scale;
}
//******************************************************************************

//int sol_get_dayscale (double moonrise, double moonset, double moontransit, double moonunder, double sunrise, double sunset)
- (int) sol_get_dayscale: (double) moonrise : (double) moonset : (double) moontransit : (double) moonunder : (double) sunrise : (double) sunset
{
    int locsoldayscale = 0;
    //check minor1 and sunrise
    if ((sunrise >= (moonrise - 1.0)) && (sunrise <= (moonrise + 1.0))){
        locsoldayscale++;
    }
    //check minor1 and sunset
    if ((sunset >= (moonrise - 1.0)) && (sunset <= (moonrise + 1.0))){
        locsoldayscale++;
    }
    //check minor2 and sunrise
    if ((sunrise >= (moonset - 1.0)) && (sunrise <= (moonset + 1.0))){
        locsoldayscale++;
    }
    //check minor2 and sunset
    if ((sunset >= (moonset - 1.0)) && (sunset <= (moonset + 1.0))){
        locsoldayscale++;
    }
    //check major1 and sunrise
    if ((sunrise >= (moontransit - 2.0)) && (sunrise <= (moontransit + 2.0))){
        locsoldayscale++;
    }
    //check major1 and sunset
    if ((sunset >= (moontransit - 2.0)) && (sunset <= (moontransit + 2.0))){
        locsoldayscale++;
    }
    //check major2 and sunrise
    if ((sunrise >= (moonunder - 2.0)) && (sunrise <= (moonunder + 2.0))){
        locsoldayscale++;
    }
    //check major2 and sunset
    if ((sunset >= (moonunder - 2.0)) && (sunset <= (moonunder + 2.0))){
        locsoldayscale++;
    }
    
    //catch a >2 scale, tho this shouldn't happen.
    if (locsoldayscale > 2) {
        locsoldayscale = 2;
    }
    
    return locsoldayscale;
}
/*********************************************************************/

//void sol_display_dayscale (int soldayscale, int phasedayscale)
- (void) sol_display_dayscale: (int) soldayscale : (int) phasedayscale
{
    int dayscale;
    printf ("\nphase scale = %d", phasedayscale);
    printf ("\nsol scale = %d", soldayscale);
    dayscale = (soldayscale + phasedayscale);
    printf ("\n\nTodays action is rated a %d (scale is 0 thru 5, 5 is the best)", dayscale);
    self.activityLbl.text = [NSString stringWithFormat:@"%d out of 5", dayscale];
    return;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
