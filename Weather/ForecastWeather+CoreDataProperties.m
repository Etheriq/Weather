//
//  ForecastWeather+CoreDataProperties.m
//  Weather
//
//  Created by Yuriy T on 27.03.16.
//  Copyright © 2016 Yuriy T. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ForecastWeather+CoreDataProperties.h"

@implementation ForecastWeather (CoreDataProperties)

@dynamic createdAt;
@dynamic temp;
@dynamic pressure;
@dynamic humidity;
@dynamic icon;
@dynamic weatherDescription;
@dynamic speed;
@dynamic windOrientation;
@dynamic name;
@dynamic latitude;
@dynamic longitude;

@end
