//
//  YTMRDBManager.m
//  Weather
//
//  Created by Yuriy T on 04.04.16.
//  Copyright © 2016 Yuriy T. All rights reserved.
//

#import "YTMRDBManager.h"
#import "YTDateHelper.h"

@implementation YTMRDBManager

+ (YTMRDBManager *) sharedManager {
    
    static YTMRDBManager *manager = nil;
    static NSString *db_name = @"weather.sqlite";
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YTMRDBManager alloc] init];
        [MagicalRecord setupCoreDataStackWithStoreNamed:db_name];
        
    });
    
    return manager;
}

-(CurrentWeather *) saveAndUpdateCurrentWeatherForToday: (YTCurrentWeatherModel *) model {
    CurrentWeather *currentWeather = [self getCurrentWeatherForToday];
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    
    if (currentWeather == nil) {
        currentWeather = [CurrentWeather MR_createEntityInContext:context];
        [currentWeather MR_importValuesForKeysWithObject:model];
        currentWeather.createdAt = [[YTDateHelper sharedHelper] getStartDayFromDate:[NSDate date]];
        [context MR_saveToPersistentStoreAndWait];
        
    } else {
        [currentWeather MR_importValuesForKeysWithObject:model];
        currentWeather.createdAt = [[YTDateHelper sharedHelper] getStartDayFromDate:[NSDate date]];
        [context MR_saveToPersistentStoreAndWait];
    }
    
    return currentWeather;
}

-(CurrentWeather*) getCurrentWeatherForToday {
    
    CurrentWeather *currentWeather = [CurrentWeather MR_findFirstByAttribute:@"createdAt" withValue:[[YTDateHelper sharedHelper] getStartDayFromDate:[NSDate date]]];
    
    return currentWeather;
}

@end
