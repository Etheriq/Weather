//
//  YTCurrentWeatherModel.h
//  Weather
//
//  Created by Yuriy T on 03.04.16.
//  Copyright © 2016 Yuriy T. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface YTCurrentWeatherModel : JSONModel

@property(assign, nonatomic) float temp;
@property(assign, nonatomic) float pressure;
@property(assign, nonatomic) int humidity;
@property(assign, nonatomic) int speed;
@property(assign, nonatomic) int windOrientation;
@property(assign, nonatomic) double latitude;
@property(assign, nonatomic) double longitude;
@property(strong, nonatomic) NSDate *sunrise;
@property(strong, nonatomic) NSDate *sunset;
@property(strong, nonatomic) NSDate<Optional> *createdAt;
@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) NSString *icon;
@property(strong, nonatomic) NSString *weatherDescription;

@end
