//
//  ViewController.m
//  HuntSmart
//
//  Created by Wildlife Management Services on 3/15/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import "BaseCtrl.h"

@interface BaseCtrl () {
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

@implementation BaseCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkImportedImages:) name:@"EnterForeground" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"EnterForeground" object:nil];
}

#pragma mark - instance methods

- (void)checkImportedImages:(NSNotification *)notification {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"label == %@ AND inImages == YES", @"unlabeled"];
    NSMutableArray<ImageModel *> *photos = [CoreDataModel.sharedInstance getData:@"ImageModel" predicate:predicate sortKey:@"createdAt" ascending:false];
    
    if (photos.count > 0) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                       message:@"Pictures Imported from Photo Gallery."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Sort Photos" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  NSMutableArray *photos2= [[NSMutableArray alloc]init];
                                                                  [self arraysplitter:photos : photos2];
                                                              }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
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
        [self processUnlabeledImages:photos2 : photos];
    }
    
}





- (void)processUnlabeledImages:(NSMutableArray<ImageModel *> *)photos2 : (NSMutableArray *) photos {
    [self showProgress:[NSString stringWithFormat:@"Processed: %d Images \n Deer: %d \n Black Bear: %d \n Turkey: %d \n Hog: %d \n Other: %d" , recCount, deercount, bearcount, turkeycount, hogcount, noncount]];
    
    [self runInBackground:^{
        
        // Create path.
        NSURL *imageURL = [CoreDataModel.sharedInstance.applicationDocumentsDirectory URLByAppendingPathComponent:@"image.png"];
        
        // initialize
        predict_image *mPredictor = [predict_image new];
        
        for (ImageModel *image in photos2) {
            // Save image.
            UIImage *uiImage = [UIImage imageWithData:image.data];
            [UIImagePNGRepresentation(uiImage) writeToFile:imageURL.path atomically:YES];
            processedCount += 1;
            lastImageID += 1;
            recCount += 1;
            NSDictionary *predictResult = [mPredictor RunInferenceOnImage:imageURL.path];
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
            
            image.label = label;
            [CoreDataModel.sharedInstance saveData];
        }
        
        [self runInMainQueue:^{
            
            [self hideProgress];
            NSMutableArray *photos2= [[NSMutableArray alloc]init];
            
            [self arraysplitter:photos : photos2];
        }];
        
    } afterDelay:0.1];
}

#pragma mark - run block in various conditions

- (void)runInMainQueue:(block)block {
    dispatch_async(dispatch_get_main_queue(), block);
}

- (void)run:(block)block afterDelay:(double)delayInSeconds {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}

- (void)runAsync:(block)block afterDelay:(double)delayInSeconds {
    dispatch_async(dispatch_get_main_queue(), ^{
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), block);
    });
}

- (void)runInBackground:(block)block afterDelay:(double)delayInSeconds {
    dispatch_queue_t backgroundQ = dispatch_queue_create("com.dccast.background_delay", nil);
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, backgroundQ, block);
}

#pragma mark - view utils

- (void)showProgress:(NSString *)message {
    self.progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // Change the background view style and color.
    self.progressHUD.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.1f];
    if (message) {
        self.progressHUD.label.text = message;
    }
}

- (void)hideProgress {
    [self.progressHUD hideAnimated:true];
}

#pragma mark - handle keyboard

- (void)setupKeyboard {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
    [tap setCancelsTouchesInView:false];
}

// method to hide keyboard when touch out of textfield
- (void)handleTap:(UITapGestureRecognizer *)tapRecognizer {
    [self.view endEditing:true];
}

- (void)keyboardWillShow: (NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.keybaordHeight = keyboardSize.height;
}

- (void)keyboardDidShow: (NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.keybaordHeight = keyboardSize.height;
    [self keyboardDidShow];
}

- (void)keyboardDidShow {
}

- (void)moveViewForKeyboard:(UIView *)textField {
    CGRect frame = [textField convertRect:textField.frame toView:self.view];
    CGFloat deltaHeight = frame.origin.y + frame.size.height + self.keybaordHeight - self.view.frame.size.height;
    [self moveView:deltaHeight];
}

- (void)moveView:(CGFloat)deltaHeight {
    if (deltaHeight < 0) {
        deltaHeight = 0;
    }
    CGRect frame = self.view.frame;
    frame.origin.y = -deltaHeight;
    self.view.frame = frame;
}

- (void)keyboardWillHide: (NSNotification *)notification {
    self.keybaordHeight = 0;
    [self moveView:0];
}

#pragma mark - view click actions

- (IBAction)onClickBtnBack:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)onClickBtnHome:(id)sender {
    [self.view.window.rootViewController dismissViewControllerAnimated:true completion:nil];
}

@end
