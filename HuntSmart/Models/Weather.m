//
//  Weather.m
//  HuntSmart
//
//  Created by Wildlife Management Services on 5/11/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import "Weather.h"

@implementation Weather

+ (Weather *)getFromDictionary:(NSDictionary *)dict {
    Weather *weather = [Weather new];
    weather.timezone = [dict valueForKey:@"timezone"];
    weather.offset = [[dict valueForKey:@"offset"] floatValue];
    
    NSDictionary *daily = [[[dict valueForKey:@"daily"] valueForKey:@"data"] objectAtIndex:0];
    weather.moonPhase = [[daily valueForKey:@"moonPhase"] floatValue];
    weather.sunriseTime = [[daily valueForKey:@"sunriseTime"] floatValue];
    weather.sunsetTime = [[daily valueForKey:@"sunsetTime"] floatValue];
    
    NSDictionary *currently = [dict valueForKey:@"currently"];
    weather.time = [[currently valueForKey:@"time"] floatValue];
    weather.summary = [currently valueForKey:@"summary"];
    weather.icon = [currently valueForKey:@"icon"];
    weather.precipType = [currently valueForKey:@"precipType"];
    
    weather.temperature = [[currently valueForKey:@"temperature"] floatValue];
    weather.humidity = [[currently valueForKey:@"humidity"] floatValue];
    weather.pressure = [[currently valueForKey:@"pressure"] floatValue];
    weather.windSpeed = [[currently valueForKey:@"windSpeed"] floatValue];
    weather.windBearing = [[currently valueForKey:@"windBearing"] floatValue];
    return weather;
}

@end

@implementation WeatherModel(Extension)

-(void) testfunc{
    
}

- (NSString *)weatherString {
    return [NSString stringWithFormat:@"%@  %@  %@  %@", [self temperatureString], [self windSpeedString], [self windDirectionString], [self pressureString]];
}

- (NSString *)temperatureString {
    return [NSString stringWithFormat:@"%.1f°F", self.temperature];
}

- (NSString *)humidityString {
    return [NSString stringWithFormat:@"%.0f%@", self.humidity*100, @"%"];
}

- (NSString *)pressureString {
    return [NSString stringWithFormat:@"%.1f", self.pressure];
}

- (NSString *)moonPhaseIcon {
    int moonIndex = roundf(self.moonPhase * 8);
    moonIndex = moonIndex % 8;
    
    NSString *moonPhaseIcon = [NSString stringWithFormat:@"moon_%d.png", moonIndex];
    return moonPhaseIcon;
}

- (NSString *)windSpeedString {
    return [NSString stringWithFormat:@"%.1fMPH", self.windSpeed];
}

- (NSString *)windDirectionString {
    int index = roundf(self.windBearing * 8 / 360);
    index = index % 8;
    NSArray *directions = @[@"N", @"NE", @"E", @"SE", @"S", @"SW", @"W", @"NW"];
    
    return directions[index];
}

- (NSString *)sunriseString {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.sunriseTime];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"hh:mma"];
    
    return [formatter stringFromDate:date];
}

- (NSString *)sunsetString {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.sunsetTime];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"hh:mma"];
    
    return [formatter stringFromDate:date];
}

@end
