//
//  YTMRDBManager.h
//  Weather
//
//  Created by Yuriy T on 04.04.16.
//  Copyright © 2016 Yuriy T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MagicalRecord/MagicalRecord.h>
#import "YTCurrentWeatherModel.h"
#import "YTForecastWeatherModel.h"
#import "CurrentWeather.h"
#import "ForecastWeather.h"

@interface YTMRDBManager : NSObject

+(YTMRDBManager *) sharedManager;

-(CurrentWeather*) saveAndUpdateCurrentWeatherForToday: (YTCurrentWeatherModel*) model;
-(CurrentWeather*) getCurrentWeatherForToday;
-(NSArray*) saveAndUpdateForecastWeather: (NSArray*) models;
-(NSArray*) getForecastWeatherFromDate: (NSDate*) dateFrom;
-(NSArray*) getAverageForecastStatisticsForLastThreeMonths;

@end
