//
//  YTMainVC.m
//  Weather
//
//  Created by Yuriy T on 22.03.16.
//  Copyright © 2016 Yuriy T. All rights reserved.
//

#import "YTMainVC.h"
#import "YTRequestManager.h"

@interface YTMainVC()


@end

@implementation YTMainVC

CLLocationManager* locationManager;

- (void) viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshView)];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestWhenInUseAuthorization];
    
    
}

#pragma mark - Actions

- (IBAction)showSideMenuAction:(UIBarButtonItem *)sender {
    [self.menuContainerViewController toggleRightSideMenuCompletion:nil];
}

- (void) refreshView {
    
    [locationManager startUpdatingLocation];
    [[YTRequestManager sharedManager] getCurrentWeatherDataByCity:@"London" onSuccess:^(NSDictionary *data) {
        NSLog(@"%@", data);
    } onFailure:^(NSError *error, NSInteger statusCode) {
        NSLog(@"%@", [error localizedDescription]);
    }];
    
    NSLog(@"refresh upd");
    
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *currentLocation = [locations lastObject];
    
    if (currentLocation != nil) {
    
        NSLog(@"lat = %.8f, lng = %.8f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
        
        [locationManager stopUpdatingLocation];
    }
}

@end
