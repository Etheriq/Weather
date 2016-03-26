//
//  YTMainVC.m
//  Weather
//
//  Created by Yuriy T on 22.03.16.
//  Copyright © 2016 Yuriy T. All rights reserved.
//

#import "YTMainVC.h"
#import "YTDBManager.h"
#import "YTRequestManager.h"
#import "YTLocationManager.h"
#import "YTGoogleGeocodeManager.h"
#import "CurrentWeather.h"

@interface YTMainVC()

@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *pressureLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UILabel *sunriseLabel;
@property (weak, nonatomic) IBOutlet UILabel *sunsetLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

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
           
           CurrentWeather* currentWeather = [[YTDBManager sharedManager] updateCurrentWeatherForToday:data];
           
           dispatch_async(dispatch_get_main_queue(), ^{
               self.tempLabel.text = [NSString stringWithFormat:@"%.1f", [currentWeather.temp floatValue]];
               self.descriptionLabel.text = [currentWeather.weatherDescription capitalizedString];
               self.humidityLabel.text = [NSString stringWithFormat:@"Humidity: %li %%", [currentWeather.humidity integerValue]];
               self.pressureLabel.text = [NSString stringWithFormat:@"Pressure: %.0f hPa", [currentWeather.pressure floatValue]];
               self.speedLabel.text = [NSString stringWithFormat:@"Wind speed: %li m/s", [currentWeather.speed integerValue]];
               NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
               [formatter setDateFormat:@"kk:mm"];
               self.sunriseLabel.text = [NSString stringWithFormat:@"Sunrise: %@", [formatter stringFromDate:currentWeather.sunrise]];
               self.sunsetLabel.text = [NSString stringWithFormat:@"Sunset: %@", [formatter stringFromDate:currentWeather.sunset]];
           });
           
//           NSLog(@"Weather data by ccord %@", data);
//           NSLog(@"Weather coreData object by ccord %@", currentWeather);
       }
       onFailure:^(NSError *error, NSInteger statusCode) {
           NSLog(@"%@", [error localizedDescription]);
    }];
    
    [[YTGoogleGeocodeManager sharedManager] getGeocodeInformationByCoordinates:coord onSuccess:^(NSString *info) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.cityLabel.text = [NSString stringWithFormat:@"%@", info];
        });
        NSLog(@"current city is %@", info);
    } onFailure:nil];
    
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
