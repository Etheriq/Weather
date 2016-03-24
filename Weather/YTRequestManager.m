//
//  YTRequestManager.m
//  Weather
//
//  Created by Yuriy T on 24.03.16.
//  Copyright © 2016 Yuriy T. All rights reserved.
//

#import "YTRequestManager.h"
#import <AFNetworking/AFNetworking.h>

@interface YTRequestManager ()

@property(strong, nonatomic) AFHTTPSessionManager* sessionManager;

@end

@implementation YTRequestManager

+ (YTRequestManager*) sharedManager {
    static YTRequestManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YTRequestManager alloc] init];
    });
    
    return manager;
}

-(id)init {
    self = [super init];
    
    if (self) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://dsds.com/"] sessionConfiguration:configuration];
    }
    
    return self;
}

- (void) refreshWeatherDataForCity:(NSString*) city onSuccess:(void(^)(NSArray* data)) success onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
 
    [self.sessionManager GET:@"" parameters:nil
                    progress:^(NSProgress * downloadProgress) {
        
    } success:^(NSURLSessionDataTask* task, id responseObject) {
        if (success) {
            success();
        }
        
        
    } failure:^(NSURLSessionDataTask* task, NSError* error) {
        
    }];
    
}


@end
