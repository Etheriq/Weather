//
//  ForecastWeather.h
//  Weather
//
//  Created by Yuriy T on 27.03.16.
//  Copyright © 2016 Yuriy T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface ForecastWeather : NSManagedObject

- (void)initWithForecastWeatherDictionary:(NSDictionary*) data;

@end

NS_ASSUME_NONNULL_END

#import "ForecastWeather+CoreDataProperties.h"
