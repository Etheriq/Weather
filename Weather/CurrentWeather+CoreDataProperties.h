//
//  CurrentWeather+CoreDataProperties.h
//  Weather
//
//  Created by Yuriy T on 26.03.16.
//  Copyright © 2016 Yuriy T. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CurrentWeather.h"

NS_ASSUME_NONNULL_BEGIN

@interface CurrentWeather (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *temp;
@property (nullable, nonatomic, retain) NSNumber *pressure;
@property (nullable, nonatomic, retain) NSNumber *humidity;
@property (nullable, nonatomic, retain) NSNumber *speed;
@property (nullable, nonatomic, retain) NSNumber *windOrientation;
@property (nullable, nonatomic, retain) NSString *icon;
@property (nullable, nonatomic, retain) NSString *weatherDescription;
@property (nullable, nonatomic, retain) NSDate *sunrise;
@property (nullable, nonatomic, retain) NSDate *sunset;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSDate *createdAt;
@property (nullable, nonatomic, retain) NSNumber *latitude;
@property (nullable, nonatomic, retain) NSNumber *longitude;

@end

NS_ASSUME_NONNULL_END
