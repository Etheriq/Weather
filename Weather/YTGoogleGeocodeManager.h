//
//  YTGoogleGeocodeManager.h
//  Weather
//
//  Created by Yuriy T on 25.03.16.
//  Copyright © 2016 Yuriy T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>

@interface YTGoogleGeocodeManager : NSObject

+ (YTGoogleGeocodeManager*) sharedManager;

- (void) getGeocodeInformationByCoordinates:(CLLocation*) location
                           onSuccess:(void(^)(NSString* info)) success
                           onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

@end
