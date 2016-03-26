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
    
    [[YTRequestManager sharedManager] getCurrentWeatherDataByCoordinates:coord
       onSuccess:^(NSDictionary *data) {
            NSLog(@"Weather by ccord %@", data);
       }
       onFailure:^(NSError *error, NSInteger statusCode) {
           NSLog(@"%@", [error localizedDescription]);
    }];
    
    [[YTGoogleGeocodeManager sharedManager] getGeocodeInformationByCoordinates:coord onSuccess:^(NSString *info) {
        NSLog(@"current city is %@", info);
    } onFailure:^(NSError *error, NSInteger statusCode) {
        NSLog(@"%@", [error localizedDescription]);
    }];
    
    
    /*
     convert timestamp to nsdate and formatter
     
     NSString * timeStampString =@"1304245000";
     NSTimeInterval _interval=[timeStampString doubleValue];
     NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
     NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
     [_formatter setDateFormat:@"dd.MM.yyyy"];
     NSString *_date=[_formatter stringFromDate:date];
     
     */
    
}

@end
