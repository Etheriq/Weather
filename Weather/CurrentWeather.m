//
//  CurrentWeather.m
//  Weather
//
//  Created by Yuriy T on 26.03.16.
//  Copyright © 2016 Yuriy T. All rights reserved.
//

#import "CurrentWeather.h"
#import "YTDateHelper.h"

@implementation CurrentWeather

-(void)initWithCurrentWeatherDictionary:(NSDictionary *)data {

    self.temp = [NSNumber numberWithFloat:[[data objectForKey:@"temp"] floatValue]];
    self.pressure = [NSNumber numberWithFloat:[[data objectForKey:@"pressure"] floatValue]];
    self.humidity = [NSNumber numberWithInteger:[[data objectForKey:@"humidity"] integerValue]];
    self.speed = [NSNumber numberWithInteger:[[data objectForKey:@"speed"] integerValue]];
    self.windOrientation = [NSNumber numberWithInteger:[[data objectForKey:@"deg"] integerValue]];
    self.icon = [data objectForKey:@"icon"];
    self.weatherDescription = [data objectForKey:@"description"];
    NSTimeInterval intervalSunrise = [[data objectForKey:@"sunrise"] integerValue];
    self.sunrise = [NSDate dateWithTimeIntervalSince1970:intervalSunrise];
    NSTimeInterval intervalSunset = [[data objectForKey:@"sunset"] integerValue];
    self.sunset = [NSDate dateWithTimeIntervalSince1970:intervalSunset];
    self.name = [data objectForKey:@"name"];
    self.latitude = [NSNumber numberWithDouble:[[data objectForKey:@"lat"] doubleValue]];
    self.longitude = [NSNumber numberWithDouble:[[data objectForKey:@"lng"] doubleValue]];
    self.createdAt = [[YTDateHelper sharedHelper] getStartDayFromDate:[NSDate date]];
}

@end
