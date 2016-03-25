//
//  YTRequestManager.h
//  Weather
//
//  Created by Yuriy T on 24.03.16.
//  Copyright © 2016 Yuriy T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>

@interface YTRequestManager : NSObject

+ (YTRequestManager*) sharedManager;

- (void) getCurrentWeatherDataByCity:(NSString*) city
                         onSuccess:(void(^)(NSDictionary* data)) success
                         onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) getForecastWeatherByCity:(NSString*) city
                            onSuccess:(void(^)(NSDictionary* data)) success
                            onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) getCurrentWeatherDataByCoordinates:(CLLocation*) location
                            onSuccess:(void(^)(NSDictionary* data)) success
                            onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) getForecastWeatherByCoordinates:(CLLocation*) location
                         onSuccess:(void(^)(NSArray* data)) success
                         onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

@end
