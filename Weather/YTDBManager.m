//
//  YTDBManager.m
//  Weather
//
//  Created by Yuriy T on 22.03.16.
//  Copyright © 2016 Yuriy T. All rights reserved.
//

#import "YTDBManager.h"

@implementation YTDBManager

#pragma mark - SingleTone Constructor

+ (YTDBManager *) sharedManager {
    static YTDBManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YTDBManager alloc] init];
    });
    
    return manager;
}

#pragma mark - Queries

- (CurrentWeather*) updateCurrentWeatherForToday: (NSDictionary*) data {
    
    CurrentWeather *currentWeather = [self getCurrentWeatherForToday];
    if (currentWeather != nil) {
        [currentWeather initWithCurrentWeatherDictionary:data];
    } else {
        currentWeather = [NSEntityDescription insertNewObjectForEntityForName:[[CurrentWeather class] description] inManagedObjectContext:self.managedObjectContext];
        [currentWeather initWithCurrentWeatherDictionary:data];
    }
    
    NSError *err = nil;
    if(![self.managedObjectContext save:&err]){
        NSLog(@"%@", [err localizedDescription]);
    }
    
    return currentWeather;
}

- (nullable CurrentWeather*) getCurrentWeatherForToday {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *description = [NSEntityDescription entityForName:[[CurrentWeather class] description] inManagedObjectContext:self.managedObjectContext];
    [request setEntity:description];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitTimeZone) fromDate:[NSDate date]];
    comps.hour = 0;
    comps.minute = 0;
    comps.second = 0;
    NSDate *date = [calendar dateFromComponents:comps];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"createdAt = %@", date];
    [request setPredicate:predicate];
    
    NSError *errorReq = nil;
    NSArray *res = nil;
    
    if (!(res = [self.managedObjectContext executeFetchRequest:request error:&errorReq])) {
        NSLog(@"Get all current Weather error: %@", [errorReq localizedDescription]);
    }
    
    CurrentWeather *currentWeather = nil;
    if ([res count] > 0) {
        currentWeather = [res firstObject];
    }
    
    return currentWeather;
}

- (NSArray*) updateForecastWeather: (NSArray*) data {
    
    NSArray *oldData = [self getForecastWeatherFromDate:[NSDate date]];
    if ([oldData count] > 0) {
        [self removeOldForecastWeather:oldData];
    }
    
    NSMutableArray *result = [NSMutableArray array];
    for (NSDictionary *forecastData in data) {
        ForecastWeather *forecastWeather = [NSEntityDescription insertNewObjectForEntityForName:[[ForecastWeather class] description] inManagedObjectContext:self.managedObjectContext];
        [forecastWeather initWithForecastWeatherDictionary:forecastData];
        
        NSError *err = nil;
        if(![self.managedObjectContext save:&err]){
            NSLog(@"%@", [err localizedDescription]);
        }
        [result addObject:forecastWeather];
    }
    
    return result;
}

- (NSArray*) getForecastWeatherFromDate:(NSDate*) dateFrom {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *description = [NSEntityDescription entityForName:[[ForecastWeather class] description] inManagedObjectContext:self.managedObjectContext];
    [request setEntity:description];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"createdAt >= %@", dateFrom];
    [request setPredicate:predicate];
    
    NSError *errorReq = nil;
    NSArray *res = nil;
    
    if (!(res = [self.managedObjectContext executeFetchRequest:request error:&errorReq])) {
        res = @[];
        NSLog(@"Get all current Weather error: %@", [errorReq localizedDescription]);
    }
    
    return res;
}

- (void) removeOldForecastWeather: (NSArray *) data {
    
    //  Delete
    for (id object in data) {
        [self.managedObjectContext deleteObject:object];
    }
    
    NSError *errorReq = nil;
    if(![self.managedObjectContext save:&errorReq]){
        NSLog(@"Error on remove old forecast objects %@", [errorReq localizedDescription]);
    }
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.GH.iOS.Diplom.Weather.proj.Weather" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Weather" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Weather.sqlite"];
    NSError *error = nil;
//    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
       
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
        [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];

        
//        // Report any error we got.
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
//        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
//        dict[NSUnderlyingErrorKey] = error;
//        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
//        // Replace this with code to handle the error appropriately.
//        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
