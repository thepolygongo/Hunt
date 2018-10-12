//
//  Utils.m
//  HuntSmart
//
//  Created by Wildlife Management Services on 3/15/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import "Utils.h"

BOOL validateEmail(NSString* checkString)
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

NSString* getDateTimeStringFromDate(NSDate* date) {
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"MM/dd hh:mm:ss a"];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

NSDate* getDateFromDateTimeString(NSString* dateString) {
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"MM/dd hh:mm:ss a"];
    NSDate *date = [formatter dateFromString:dateString];
    return date;
}

NSString* getTimeStringFor2Hours(NSDate* fromDate) {
    NSDateFormatter *formatter = [NSDateFormatter new];
    
    [formatter setDateFormat:@"HH"];
    NSString *fromTimeString = [formatter stringFromDate:fromDate];
    
    [formatter setDateFormat:@"HH"];
    NSString *toTimeString = [formatter stringFromDate:[fromDate dateByAddingTimeInterval:(2*60*60)]];
    fromTimeString = [NSString stringWithFormat:@"%@ - %@", fromTimeString, toTimeString];
    
    return fromTimeString;
}

NSString* getTimeStringFor4Hours(NSDate* fromDate) {
    NSDateFormatter *formatter = [NSDateFormatter new];
    
    [formatter setDateFormat:@"HH"];
    NSString *fromTimeString = [formatter stringFromDate:fromDate];
    
    [formatter setDateFormat:@"HH"];
    NSString *toTimeString = [formatter stringFromDate:[fromDate dateByAddingTimeInterval:(4*60*60)]];
    fromTimeString = [NSString stringWithFormat:@"%@ - %@", fromTimeString, toTimeString];
    
    return fromTimeString;
}

NSString* getDateStringFromDate(NSDate* date) {
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

NSDate* getDateFromDateString(NSString* dateString) {
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    NSDate *date = [formatter dateFromString:dateString];
    return date;
}

id getResourcesFromPlist(NSString* plistFile, NSString* key) {
    NSError* error = nil;
    NSURL* resourceFile = [[NSBundle mainBundle] URLForResource:plistFile withExtension:@"plist"];
    NSData* resourceData = [NSData dataWithContentsOfURL:resourceFile options:0 error:&error];
    if (resourceData) {
        NSDictionary* resources = [NSPropertyListSerialization propertyListWithData:resourceData options:0 format:NULL error:&error];
        if (resources) {
            return resources[key];
        } else {
            NSLog(@"Error: Could not read plist data from %@: %@", resourceFile, error);
        }
    } else {
        NSLog(@"Error: Could not read file data at %@: %@", resourceFile, error);
    }
    return nil;
}
