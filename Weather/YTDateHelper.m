//
//  YTDateHelper.m
//  Weather
//
//  Created by Yuriy T on 01.04.16.
//  Copyright © 2016 Yuriy T. All rights reserved.
//

#import "YTDateHelper.h"

@implementation YTDateHelper

+ (YTDateHelper*)sharedHelper {
    static YTDateHelper *helper = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[YTDateHelper alloc] init];
    });
    
    return helper;
}

#pragma mark - Methods

-(NSDate*) getStartDayFromDate:(NSDate*) from {
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    NSDateComponents *comps = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitTimeZone) fromDate:from];
    comps.hour = 0;
    comps.minute = 0;
    comps.second = 0;
    return [calendar dateFromComponents:comps];
}

-(NSString *) getFormattedDateStringFromDate:(NSDate *) date withFormat:(NSString*) format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    
    return [NSString stringWithFormat:@"%@", [formatter stringFromDate:date]];
}

@end
