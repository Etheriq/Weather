//
//  YTLocationManager.h
//  Weather
//
//  Created by Yuriy T on 25.03.16.
//  Copyright © 2016 Yuriy T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface YTLocationManager : NSObject

+ (YTLocationManager*) sharedManager;

-(CLLocation*) updateLocation;

@end
