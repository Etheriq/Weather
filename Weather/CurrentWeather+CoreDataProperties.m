//
//  CurrentWeather+CoreDataProperties.m
//  Weather
//
//  Created by Yuriy T on 26.03.16.
//  Copyright © 2016 Yuriy T. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CurrentWeather+CoreDataProperties.h"

@implementation CurrentWeather (CoreDataProperties)

@dynamic temp;
@dynamic pressure;
@dynamic humidity;
@dynamic speed;
@dynamic windOrientation;
@dynamic icon;
@dynamic weatherDescription;
@dynamic sunrise;
@dynamic sunset;
@dynamic name;
@dynamic createdAt;

@end
