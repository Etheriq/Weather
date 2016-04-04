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
                               @"lat": @"latitude",
                               @"lng": @"longitude"
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

-(instancetype)initWithDictionary:(NSDictionary*)dict error:(NSError **)err {
    
    NSDictionary* response = @{
                               @"temp": dict[@"main"][@"temp"] ? dict[@"main"][@"temp"] : @"0",                    // температура в градусах цельсия
                               @"pressure": dict[@"main"][@"pressure"] ? dict[@"main"][@"pressure"] : @"0",        // давление в hPa
                               @"humidity": dict[@"main"][@"humidity"] ? dict[@"main"][@"humidity"] : @"0",        // влажность в %
                               @"speed": dict[@"wind"][@"speed"] ? dict[@"wind"][@"speed"] : @"0",                 // скорость ветра в м/с
                               @"deg": dict[@"wind"][@"deg"] ? dict[@"wind"][@"deg"] : @"0",                       // направление ветра в градусах
                               @"icon": dict[@"weather"][0][@"icon"] ? dict[@"weather"][0][@"icon"] : @"01d",      // иконка
                               @"description": dict[@"weather"][0][@"description"],                                          // описание погоды
                               @"sunrise": dict[@"sys"][@"sunrise"] ? dict[@"sys"][@"sunrise"] : @"1451606400",    // восход в timestamp
                               @"sunset": dict[@"sys"][@"sunset"] ? dict[@"sys"][@"sunset"] : @"1451606400",       // закат в timestamp
                               @"name": dict[@"name"] ? dict[@"name"] : @"Narnia",                                 // название местности
                               @"lat": @0.f,
                               @"lng": @0.f
                               };
    
    self = [super initWithDictionary:response error:err];
    
    return self;
}

@end
