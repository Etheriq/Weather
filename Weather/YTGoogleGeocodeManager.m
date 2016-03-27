//
//  YTGoogleGeocodeManager.m
//  Weather
//
//  Created by Yuriy T on 25.03.16.
//  Copyright © 2016 Yuriy T. All rights reserved.
//

#import "YTGoogleGeocodeManager.h"
#import <AFNetworking/AFNetworking.h>

@interface YTGoogleGeocodeManager()

@property(strong, nonatomic) AFHTTPSessionManager* sessionManager;

@end

@implementation YTGoogleGeocodeManager

static NSString* apikey = @"AIzaSyDpRSfqj0r3Zkvr3fcCA-YbrxB8RgS_mvo";
static NSString* baseUrl = @"https://maps.googleapis.com/maps/api/geocode/";

+ (YTGoogleGeocodeManager*) sharedManager {
    static YTGoogleGeocodeManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YTGoogleGeocodeManager alloc] init];
    });
    
    return manager;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseUrl] sessionConfiguration:configuration];
    }
    
    return self;
}

#pragma mark - Methods to Google geocode API

- (void) getGeocodeInformationByCoordinates:(CLLocation*) location
                                  onSuccess:(void(^)(NSString* info)) success
                                  onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {

    NSDictionary* params = @{
                             @"latlng": [NSString stringWithFormat:@"%.8f,%.8f", location.coordinate.latitude, location.coordinate.longitude],
                             @"key": apikey,
                             @"result_type": @"locality",
                             @"language": @"en"
                            };
    
    [self.sessionManager GET:@"json"
                  parameters:params
                    progress:^(NSProgress * downloadProgress) {}
                     success:^(NSURLSessionDataTask* task, NSDictionary* responseObject) {
                         
                         if ([responseObject objectForKey:@"status"] && [[responseObject objectForKey:@"status"] isEqualToString:@"OK"]) {
                             NSDictionary *jsonData = [[responseObject valueForKey:@"results"] firstObject];
                             
                             if (success) {
                                 success(jsonData[@"formatted_address"]);
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

@end
