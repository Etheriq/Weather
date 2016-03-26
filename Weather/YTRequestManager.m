//
//  YTRequestManager.m
//  Weather
//
//  Created by Yuriy T on 24.03.16.
//  Copyright © 2016 Yuriy T. All rights reserved.
//

#import "YTRequestManager.h"
#import <AFNetworking/AFNetworking.h>
#import "AFNetworkActivityIndicatorManager.h"

@interface YTRequestManager()

@property(strong, nonatomic) AFHTTPSessionManager* sessionManager;

@end

@implementation YTRequestManager

static NSString* apikey = @"09c71b13e609e4d0f3dee60245695d46";
static NSString* baseUrl = @"http://api.openweathermap.org/data/2.5/";

+ (YTRequestManager*) sharedManager {
    static YTRequestManager* manager = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YTRequestManager alloc] init];
    });
    
    return manager;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseUrl] sessionConfiguration:configuration];
    }
    
    return self;
}

#pragma mark - Weather API methods

- (void) getCurrentWeatherDataByCity:(NSString*) city onSuccess:(void(^)(NSDictionary* data)) success onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
 
    NSDictionary* params = @{
                             @"units": @"metric",
                             @"appid": apikey,
                             @"q": city
                         };
    
    [self.sessionManager GET:@"weather"
                    parameters:params
                    progress:^(NSProgress * downloadProgress) {}
                    success:^(NSURLSessionDataTask* task, NSDictionary* responseObject) {
                        if (success) {
                            success(responseObject);
                        }
                    }
                    failure:^(NSURLSessionDataTask* task, NSError* error) {
                        if (failure) {
                            failure(error, 404);
                        }
                    }
     ];
}

- (void) getForecastWeatherByCity:(NSString*) city
                        onSuccess:(void(^)(NSDictionary* data)) success
                        onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    NSDictionary* params = @{
                             @"units": @"metric",
                             @"appid": apikey,
                             @"q": city
                             };
    
    [self.sessionManager GET:@"forecast/weather"
                  parameters:params
                    progress:^(NSProgress * downloadProgress) {}
                     success:^(NSURLSessionDataTask* task, NSDictionary* responseObject) {
                         if (success) {
                             
                             success(responseObject);
                         }
                     }
                     failure:^(NSURLSessionDataTask* task, NSError* error) {
                         if (failure) {
                             failure(error, 404);
                         }
                     }
     ];
}

- (void) getCurrentWeatherDataByCoordinates:(CLLocation*) location
                                  onSuccess:(void(^)(NSDictionary* data)) success
                                  onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    NSDictionary* params = @{
                             @"units": @"metric",
                             @"appid": apikey,
                             @"lat": [NSString stringWithFormat:@"%.8f", location.coordinate.latitude],
                             @"lon": [NSString stringWithFormat:@"%.8f", location.coordinate.longitude]
                             };
    
    [self.sessionManager GET:@"weather"
                  parameters:params
                    progress:^(NSProgress * downloadProgress) {}
                     success:^(NSURLSessionDataTask* task, NSDictionary* responseObject) {
                         if (success) {
//                             NSLog(@"%@", responseObject);
                             if ([responseObject[@"cod"] integerValue] == 200) {
                                 NSDictionary* response = @{
                                                            @"temp": responseObject[@"main"][@"temp"],
                                                            @"pressure": responseObject[@"main"][@"pressure"],  // давление в hPa
                                                            @"humidity": responseObject[@"main"][@"humidity"],  // влажность в %
                                                            @"speed": responseObject[@"wind"][@"speed"],        // скорость ветра в м/с
                                                            @"deg": responseObject[@"wind"][@"deg"],            // направление ветра в градусах
                                                            @"icon": responseObject[@"weather"][0][@"icon"],
                                                            @"description": responseObject[@"weather"][0][@"description"],
                                                            @"sunrise": responseObject[@"sys"][@"sunrise"],     // восход в timestamp
                                                            @"sunset": responseObject[@"sys"][@"sunset"],       // закат в timestamp
                                                            @"name": responseObject[@"name"],                   // название местности
                                                        };
                                 success(response);
                             } else {
                                 NSError* error = [[NSError alloc] initWithDomain:@"geocodeError" code:100 userInfo:nil];
                                 if (failure) {
                                     failure(error, 404);
                                 }
                             }
                         }
                     }
                     failure:^(NSURLSessionDataTask* task, NSError* error) {
                         if (failure) {
                             failure(error, 404);
                         }
                     }
     ];
    
}

- (void) getForecastWeatherByCoordinates:(CLLocation*) location
                               onSuccess:(void(^)(NSArray* data)) success
                               onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
}


@end
