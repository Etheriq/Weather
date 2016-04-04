//
//  YTForecastWeatherModel.h
//  Weather
//
//  Created by Yuriy T on 05.04.16.
//  Copyright © 2016 Yuriy T. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface YTForecastWeatherModel : JSONModel

@property(assign, nonatomic) float temp;
@property(assign, nonatomic) float pressure;
@property(assign, nonatomic) int humidity;
@property(assign, nonatomic) int speed;
@property(assign, nonatomic) int windOrientation;
@property(assign, nonatomic) double latitude;
@property(assign, nonatomic) double longitude;
@property(strong, nonatomic) NSDate *createdAt;
@property(strong, nonatomic) NSDate<Optional> *orderDate;
@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) NSString *icon;
@property(strong, nonatomic) NSString *weatherDescription;

+(NSArray*)arrayOfDictionariesFromResponse:(NSArray*)array andParams:(NSDictionary*) params;

@end
