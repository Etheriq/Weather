//
//  YTCurrentWeatherModel.m
//  Weather
//
//  Created by Yuriy T on 03.04.16.
//  Copyright © 2016 Yuriy T. All rights reserved.
//

#import "YTCurrentWeatherModel.h"

@implementation YTCurrentWeatherModel

+(JSONKeyMapper*) keyMapper {
    
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                               @"deg": @"windOrientation",
                               @"description": @"weatherDescription",
                               @"lng": @"longitude",
                               @"lat": @"latitude",
                            }];
}

- (NSDate *)NSDateFromNSString:(NSString*)string {
    double unixTimeStamp =[string doubleValue];
    NSTimeInterval _interval=unixTimeStamp;
    
    return [NSDate dateWithTimeIntervalSince1970:_interval];
}

- (NSString *)JSONObjectFromNSDate:(NSDate *)date {
    
    return [NSString stringWithFormat:@"%f", [date timeIntervalSince1970]];
}

@end
