//
//  YTMainVC.m
//  Weather
//
//  Created by Yuriy T on 22.03.16.
//  Copyright © 2016 Yuriy T. All rights reserved.
//

#import "YTMainVC.h"
#import "YTRequestManager.h"
#import "YTLocationManager.h"
#import "YTGoogleGeocodeManager.h"

@interface YTMainVC()


@end

@implementation YTMainVC

- (void) viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshView)];
    [[YTLocationManager sharedManager] updateLocation];
}

#pragma mark - Actions

- (IBAction)showSideMenuAction:(UIBarButtonItem *)sender {
    [self.menuContainerViewController toggleRightSideMenuCompletion:nil];
}

- (void) refreshView {
    
    CLLocation* coord = [[YTLocationManager sharedManager] updateLocation];
    NSLog(@"ZZZ = lat = %.8f, lng = %.8f", coord.coordinate.latitude, coord.coordinate.longitude);
    
//    [[YTRequestManager sharedManager] getCurrentWeatherDataByCity:@"London" onSuccess:^(NSDictionary *data) {
//    } onFailure:^(NSError *error, NSInteger statusCode) {
//        NSLog(@"%@", [error localizedDescription]);
//    }];
    [[YTRequestManager sharedManager] getCurrentWeatherDataByCoordinates:coord onSuccess:^(NSDictionary *data) {
        
        if ([data[@"message"] isEqualToString:@"ok"]) {
            NSLog(@"Weather by ccord %@", data);
        } else {
            //  something wrong
        }
    } onFailure:^(NSError *error, NSInteger statusCode) {
        
    }];
    
    [[YTGoogleGeocodeManager sharedManager] getGeocodeInformationByCoordinates:coord onSuccess:^(NSString *info) {
        NSLog(@"current city is %@", info);
    } onFailure:^(NSError *error, NSInteger statusCode) {
        NSLog(@"%@", [error localizedDescription]);
    }];
}

@end
