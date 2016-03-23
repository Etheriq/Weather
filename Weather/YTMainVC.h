//
//  YTMainVC.h
//  Weather
//
//  Created by Yuriy T on 22.03.16.
//  Copyright © 2016 Yuriy T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFSideMenu.h"
#import <CoreLocation/CoreLocation.h>

@interface YTMainVC : UIViewController <CLLocationManagerDelegate>

- (IBAction)showSideMenuAction:(UIBarButtonItem *)sender;


@end
