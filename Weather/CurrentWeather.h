//
//  CurrentWeather.h
//  Weather
//
//  Created by Yuriy T on 26.03.16.
//  Copyright © 2016 Yuriy T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface CurrentWeather : NSManagedObject

- (void)initWithCurrentWeatherDictionary:(NSDictionary*) data;

@end

NS_ASSUME_NONNULL_END

#import "CurrentWeather+CoreDataProperties.h"
