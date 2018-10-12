//
//  Weather.h
//  HuntSmart
//
//  Created by Wildlife Management Services on 5/11/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CameraModel+CoreDataProperties.h"
#import "WeatherModel+CoreDataProperties.h"


@interface Weather : NSObject

@property (strong, nonatomic) CameraModel *mCamera;
@property(readonly) NSTimeInterval daylightSavingTimeOffset;
@property(readonly) NSInteger secondsFromGMT;
@property (nonatomic) int cameraLocationIndex;
@property (strong, nonatomic) NSArray<NSString *> *cameraLocationTypes;

@property (nonatomic) int camera;
@property (nonatomic) int image;

@property (strong, nonatomic) NSString *timezone;
@property (nonatomic) float time;
@property (strong, nonatomic) NSString *summary;
@property (strong, nonatomic) NSString *icon;
@property (strong, nonatomic) NSString *precipType;

@property (nonatomic) float moonPhase;
@property (nonatomic) int sunriseTime;
@property (nonatomic) int sunsetTime;

@property (nonatomic) float temperature;
@property (nonatomic) float humidity;
@property (nonatomic) float pressure;
@property (nonatomic) float windSpeed;
@property (nonatomic) float windBearing;
@property (nonatomic) float offset;

@property (nonatomic) NSString* moonrise;
@property (nonatomic) NSString* moonset;
@property (nonatomic) NSString* moonover;

+ (Weather *)getFromDictionary:(NSDictionary *)dict;

@end


@interface WeatherModel(Extension)

- (NSString *)weatherString;
- (NSString *)temperatureString;
- (NSString *)humidityString;
- (NSString *)pressureString;
- (NSString *)moonPhaseIcon;
- (NSString *)windSpeedString;
- (NSString *)windDirectionString;
- (NSString *)sunriseString;
- (NSString *)sunsetString;

@end
