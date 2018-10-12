//
//  solunar_predict.h
//  HuntSmart
//
//  Created by Jason Ray on 6/19/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//


#include <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "CameraModel+CoreDataProperties.h"
#import "MenuRowView.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>


@interface solunar_predict : UIViewController {
    UIDatePicker *dateSelector;

}
@property (strong, nonatomic) CameraModel *mCamera;
@property(readonly) NSTimeInterval daylightSavingTimeOffset;
@property(readonly) NSInteger secondsFromGMT;
@property (nonatomic) int cameraLocationIndex;
@property (strong, nonatomic) NSArray<NSString *> *cameraLocationTypes;
@property (weak, nonatomic) IBOutlet UILabel *riseLbl;
@property (weak, nonatomic) IBOutlet UILabel *transitLbl;
@property (weak, nonatomic) IBOutlet UILabel *setLbl;
@property (weak, nonatomic) IBOutlet UILabel *major1Lbl;
@property (weak, nonatomic) IBOutlet UILabel *major2Lbl;
@property (weak, nonatomic) IBOutlet UILabel *minor1Lbl;
@property (weak, nonatomic) IBOutlet UILabel *minor2Lbl;
@property (weak, nonatomic) IBOutlet UILabel *activityLbl;
@property (weak, nonatomic) IBOutlet UILabel *illuminLbl;
@property (weak, nonatomic) IBOutlet UILabel *phaseLbl;
@property (weak, nonatomic) IBOutlet UITextField *datePicker;


double get_julian_date(int year, int month, int day, double UT);
float ipart (double x);
double fpart (double x);
double sinalt (int object, double mjd0, int hour, double ourlong, double cphi,
               double sphi );
double lmst (double mjd, double ourlong);
double get_transit (int object, double mjd0, int hour, double ourlong);
void get_sun_pos (double t, double *ra, double *dec);
void get_moon_pos (double t, double *ra, double *dec);
void quad (double ym, double y0, double yp, double *xe, double *ye, double *z1,
           double *z2, int *nz);
void display_event_time (double time, char event [6]);
double get_moon_phase (double date);
double get_underfoot (double date, double underlong);
int get_rst (int object, double date, double ourlong, double ourlat,
             double *Rise, double *Set, double *Transit);
double get_sun_long (double t);
double get_moon_long (double t);

//solunar functions
void sol_display_minors (char mnst1[6], char mnsp1[6], char mnst2[6],
                         char mnsp2[6], double moonrise, double moonset);
void sol_display_majors (char mjst1[6], char mjsp1[6], char mjst2[6],
                         char mjsp2[6], double moontransit, double moonunder);
void sol_get_minor1 (char mnst1[6], char mnsp1[6], double moonrise);
void convert_time_to_string (char stringtime[6], double doubletime);
void sol_get_minor2 (char mnst2[6], char mnsp2[6], double moonset);
void sol_get_major2(char mjst2[6], char mjsp2[6], double moontransit);
void sol_get_major1(char mjst1[6], char mjsp1[6], double moontransit);
int phase_day_scale (double moonphase);
int sol_get_dayscale (double moonrise, double moonset, double moontransit,
                      double moonunder, double sunrise, double sunset);
void sol_display_dayscale (int soldayscale, int phasedayscale);



@end
