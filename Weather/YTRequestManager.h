//
//  YTRequestManager.h
//  Weather
//
//  Created by Yuriy T on 24.03.16.
//  Copyright © 2016 Yuriy T. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTRequestManager : NSObject

+ (YTRequestManager*) sharedManager;
- (void) refreshWeatherDataForCity:(NSString*) city
                         onSuccess:(void(^)(NSArray* data)) success
                         onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

@end
