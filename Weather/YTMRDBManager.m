//
//  YTMRDBManager.m
//  Weather
//
//  Created by Yuriy T on 04.04.16.
//  Copyright © 2016 Yuriy T. All rights reserved.
//

#import "YTMRDBManager.h"
#import "YTDateHelper.h"

@interface YTMRDBManager()

@property (strong, nonatomic) NSManagedObjectContext *context;

@end

@implementation YTMRDBManager

+ (YTMRDBManager *) sharedManager {
    static YTMRDBManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YTMRDBManager alloc] init];
    });
    
    return manager;
}

-(instancetype) init {
    self = [super init];

    if (self) {
        [MagicalRecord setupCoreDataStack];
        self.context = [NSManagedObjectContext MR_defaultContext];
    }
    
    return self;
}

#pragma mark CurrentWeather queries

-(CurrentWeather *) saveAndUpdateCurrentWeatherForToday: (YTCurrentWeatherModel *) model {
    CurrentWeather *currentWeather = [self getCurrentWeatherForToday];
    
    if (currentWeather == nil) {
        currentWeather = [CurrentWeather MR_createEntityInContext:self.context];
        [currentWeather MR_importValuesForKeysWithObject:model];
        currentWeather.createdAt = [[YTDateHelper sharedHelper] getStartDayFromDate:[NSDate date]];
        [self.context MR_saveToPersistentStoreAndWait];
        
    } else {
        [currentWeather MR_importValuesForKeysWithObject:model];
        currentWeather.createdAt = [[YTDateHelper sharedHelper] getStartDayFromDate:[NSDate date]];
        [self.context MR_saveToPersistentStoreAndWait];
    }
    
    return currentWeather;
}

-(CurrentWeather*) getCurrentWeatherForToday {
    
    CurrentWeather *currentWeather = [CurrentWeather MR_findFirstByAttribute:@"createdAt" withValue:[[YTDateHelper sharedHelper] getStartDayFromDate:[NSDate date]]];
    
    return currentWeather;
}

#pragma mark ForecastWeather queries

-(NSArray*) saveAndUpdateForecastWeather: (NSArray*) models {
    
    NSArray* oldData = [self getForecastWeatherFromDate:[NSDate date]];
    if ([oldData count] > 0) {
        [self removeOldForecastWeather:oldData];
    }
    
    NSMutableArray *result = [NSMutableArray array];
    for (YTForecastWeatherModel* model in models) {
        ForecastWeather *fw = [ForecastWeather MR_createEntityInContext:self.context];
        [fw MR_importValuesForKeysWithObject:model];
        fw.orderDate = [[YTDateHelper sharedHelper] getStartDayFromDate:fw.createdAt];
        
        [result addObject:fw];
    }
    
    [self.context MR_saveToPersistentStoreAndWait];
    
    return result;
}

- (NSArray*) getForecastWeatherFromDate:(NSDate*) dateFrom {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"createdAt >= %@", dateFrom];
    
    return [ForecastWeather MR_findAllWithPredicate:predicate inContext:self.context];
}

- (void) removeOldForecastWeather: (NSArray *) data {
    for (ForecastWeather *fw in data) {
        [fw MR_deleteEntityInContext:self.context];
    }
    
    [self.context MR_saveToPersistentStoreAndWait];
}

- (NSArray*) getAverageForecastStatisticsForLastThreeMonths {
    NSDate *startToday = [[YTDateHelper sharedHelper] getStartDayFromDate:[NSDate date]];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth: -1];
    NSDate *threeMothsAgo = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:startToday options:0];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"orderDate >= %@ AND orderDate < %@", threeMothsAgo, startToday];
      
    return [ForecastWeather MR_aggregateOperation:@"average:" onAttribute:@"temp" withPredicate:predicate groupBy:@"orderDate" inContext:self.context];
}

@end
