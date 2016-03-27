//
//  YTDBManager.h
//  Weather
//
//  Created by Yuriy T on 22.03.16.
//  Copyright © 2016 Yuriy T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CurrentWeather.h"

@interface YTDBManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

+ (YTDBManager *) sharedManager;

- (CurrentWeather*) updateCurrentWeatherForToday: (NSDictionary*) data;
- (nullable CurrentWeather*) getCurrentWeatherForToday;

@end
