//
//  ForecastWeather.m
//  Weather
//
//  Created by Yuriy T on 27.03.16.
//  Copyright © 2016 Yuriy T. All rights reserved.
//

#import "ForecastWeather.h"

@implementation ForecastWeather

- (void)initWithForecastWeatherDictionary:(NSDictionary*) data {
    
    self.temp = [NSNumber numberWithFloat:[[data objectForKey:@"temp"] floatValue]];
    self.pressure = [NSNumber numberWithFloat:[[data objectForKey:@"pressure"] floatValue]];
    self.humidity = [NSNumber numberWithInteger:[[data objectForKey:@"humidity"] integerValue]];
    self.speed = [NSNumber numberWithInteger:[[data objectForKey:@"speed"] integerValue]];
    self.windOrientation = [NSNumber numberWithInteger:[[data objectForKey:@"deg"] integerValue]];
    self.icon = [data objectForKey:@"icon"];
    self.weatherDescription = [data objectForKey:@"description"];
    self.name = [data objectForKey:@"name"];
    self.latitude = [NSNumber numberWithDouble:[[data objectForKey:@"lat"] doubleValue]];
    self.longitude = [NSNumber numberWithDouble:[[data objectForKey:@"lng"] doubleValue]];
    NSTimeInterval interval = [[data objectForKey:@"fromDate"] integerValue];
    self.createdAt = [NSDate dateWithTimeIntervalSince1970:interval];
//    
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
//    NSDateComponents *comps = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitTimeZone) fromDate:[NSDate date]];
//    comps.hour = 0;
//    comps.minute = 0;
//    comps.second = 0;
//    NSDate *date = [calendar dateFromComponents:comps];
//    self.orderDate = date;
//    
    NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents* dateComponents = [gregorian components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:[NSDate date]];
    dateComponents.hour = 0;
    dateComponents.minute = 0;
    dateComponents.second = 0;
    
    self.orderDate = [gregorian dateFromComponents:dateComponents];
}

@end
