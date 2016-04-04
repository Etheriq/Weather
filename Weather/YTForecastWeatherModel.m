//
//  YTForecastWeatherModel.m
//  Weather
//
//  Created by Yuriy T on 05.04.16.
//  Copyright © 2016 Yuriy T. All rights reserved.
//

#import "YTForecastWeatherModel.h"

@implementation YTForecastWeatherModel

+(JSONKeyMapper*) keyMapper {
    
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"deg": @"windOrientation",
                                                       @"description": @"weatherDescription",
                                                       @"lat": @"latitude",
                                                       @"lng": @"longitude",
                                                       @"fromDate": @"createdAt"
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

+(NSArray*)arrayOfDictionariesFromResponse:(NSArray*)array andParams:(NSDictionary*) params {
    
    NSString *name = params[@"name"] ? params[@"name"] : @"Narnia";
    NSMutableArray *response = [NSMutableArray array];
    
    for (NSDictionary *currentListItem in array) {
        NSDictionary *responseTmp = @{
                                      @"temp": currentListItem[@"main"][@"temp"] ? currentListItem[@"main"][@"temp"] : @"0",                    // температура в градусах цельсия
                                      @"pressure": currentListItem[@"main"][@"pressure"] ? currentListItem[@"main"][@"pressure"] : @"0",        // давление в hPa
                                      @"humidity": currentListItem[@"main"][@"humidity"] ? currentListItem[@"main"][@"humidity"] : @"0",        // влажность в %
                                      @"speed": currentListItem[@"wind"][@"speed"] ? currentListItem[@"wind"][@"speed"] : @"0",                 // скорость ветра в м/с
                                      @"deg": currentListItem[@"wind"][@"deg"] ? currentListItem[@"wind"][@"deg"] : @"0",                       // направление ветра в градусах
                                      @"icon": currentListItem[@"weather"][0][@"icon"] ? currentListItem[@"weather"][0][@"icon"] : @"01d",      // иконка
                                      @"description": currentListItem[@"weather"][0][@"description"],                                           // описание погоды
                                      @"name": name,                                                                                            // название местности
                                      @"lat": params[@"lat"],
                                      @"lng": params[@"lon"],
                                      @"fromDate": currentListItem[@"dt"] ? currentListItem[@"dt"] : @"1451606400"
                                      };
        
        [response addObject:responseTmp];
    }
    
    return response;
}

@end
