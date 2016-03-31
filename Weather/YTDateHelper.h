//
//  YTDateHelper.h
//  Weather
//
//  Created by Yuriy T on 01.04.16.
//  Copyright © 2016 Yuriy T. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTDateHelper : NSObject

+ (YTDateHelper *) sharedHelper;

-(NSDate*) getStartDayFromDate:(NSDate*) from;

@end
