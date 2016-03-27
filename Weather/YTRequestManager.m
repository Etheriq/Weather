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
                                                            @"temp": responseObject[@"main"][@"temp"] ? responseObject[@"main"][@"temp"] : @"0",                    // температура в градусах цельсия
                                                            @"pressure": responseObject[@"main"][@"pressure"] ? responseObject[@"main"][@"pressure"] : @"0",        // давление в hPa
                                                            @"humidity": responseObject[@"main"][@"humidity"] ? responseObject[@"main"][@"humidity"] : @"0",        // влажность в %
                                                            @"speed": responseObject[@"wind"][@"speed"] ? responseObject[@"wind"][@"speed"] : @"0",                 // скорость ветра в м/с
                                                            @"deg": responseObject[@"wind"][@"deg"] ? responseObject[@"wind"][@"deg"] : @"0",                       // направление ветра в градусах
                                                            @"icon": responseObject[@"weather"][0][@"icon"] ? responseObject[@"weather"][0][@"icon"] : @"01d",      // иконка
                                                            @"description": responseObject[@"weather"][0][@"description"],                                          // описание погоды
                                                            @"sunrise": responseObject[@"sys"][@"sunrise"] ? responseObject[@"sys"][@"sunrise"] : @"1451606400",    // восход в timestamp
                                                            @"sunset": responseObject[@"sys"][@"sunset"] ? responseObject[@"sys"][@"sunset"] : @"1451606400",       // закат в timestamp
                                                            @"name": responseObject[@"name"] ? responseObject[@"name"] : @"Narnia",                                 // название местности
                                                            @"lat": params[@"lat"],
                                                            @"lng": params[@"lon"]
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
