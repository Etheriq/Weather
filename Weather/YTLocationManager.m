//
//  YTLocationManager.m
//  Weather
//
//  Created by Yuriy T on 25.03.16.
//  Copyright © 2016 Yuriy T. All rights reserved.
//

#import "YTLocationManager.h"

@interface YTLocationManager() <CLLocationManagerDelegate>

@property(strong, nonatomic) CLLocationManager* locationManager;

@end

@implementation YTLocationManager

+ (YTLocationManager*) sharedManager {
    static YTLocationManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YTLocationManager alloc] init];
    });
    
    return manager;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    return self;
}

#pragma mark - Methods

-(CLLocation*) updateLocation {
    [self.locationManager startUpdatingLocation];
    
    CLLocation* location = [self.locationManager location];
    
    return location;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *currentLocation = [locations lastObject];
    
    if (currentLocation != nil) {
        
        [self.locationManager stopUpdatingLocation];
    }
}

@end
