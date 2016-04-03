//
//  YTMainVC.m
//  Weather
//
//  Created by Yuriy T on 22.03.16.
//  Copyright © 2016 Yuriy T. All rights reserved.
//

#import "YTMainVC.h"
#import "YTDBManager.h"
#import "YTMRDBManager.h"
#import "YTRequestManager.h"
#import "YTLocationManager.h"
#import "YTGoogleGeocodeManager.h"
#import "CurrentWeather.h"
#import "YTDateHelper.h"

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
    
    CurrentWeather* currentWeather = [[YTMRDBManager sharedManager] getCurrentWeatherForToday];
    if (currentWeather != nil) {
        [self updateMainView:currentWeather];
        NSLog(@"loaded from DB");
    } else {
        NSLog(@"NOT loaded from DB");
    }
    
//    UIGraphicsBeginImageContext(self.view.frame.size);
//    [[UIImage imageNamed:@"image.png"] drawInRect:self.view.bounds];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
}

//+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
//    //UIGraphicsBeginImageContext(newSize);
//    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
//    // Pass 1.0 to force exact pixel size.
//    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
//    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return newImage;
//}

#pragma mark - Private methods

-(void) updateMainView:(CurrentWeather*) currentWeather {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tempLabel.text = [NSString stringWithFormat:@"%.1f", [currentWeather.temp floatValue]];
        self.descriptionLabel.text = [currentWeather.weatherDescription capitalizedString];
        self.humidityLabel.text = [NSString stringWithFormat:@"Humidity: %li %%", [currentWeather.humidity integerValue]];
        self.pressureLabel.text = [NSString stringWithFormat:@"Pressure: %.0f hPa", [currentWeather.pressure floatValue]];
        self.speedLabel.text = [NSString stringWithFormat:@"Wind speed: %li m/s", [currentWeather.speed integerValue]];
        self.sunriseLabel.text = [NSString stringWithFormat:@"Sunrise: %@", [[YTDateHelper sharedHelper] getFormattedDateStringFromDate:currentWeather.sunrise withFormat:@"kk:mm"]];
        self.sunsetLabel.text = [NSString stringWithFormat:@"Sunset: %@", [[YTDateHelper sharedHelper] getFormattedDateStringFromDate:currentWeather.sunset withFormat:@"kk:mm"]];
    });
}

#pragma mark - Actions

- (IBAction)showSideMenuAction:(UIBarButtonItem *)sender {
    [self.menuContainerViewController toggleRightSideMenuCompletion:nil];
}

- (void) refreshView {
    
    CLLocation* coord = [[YTLocationManager sharedManager] updateLocation];
    NSLog(@"Coordinates: lat = %.8f, lng = %.8f", coord.coordinate.latitude, coord.coordinate.longitude);
    
    [[YTRequestManager sharedManager] getCurrentWeatherDataByCoordinates:coord
       onSuccess:^(YTCurrentWeatherModel *dataModel) {
           
           CurrentWeather *currentWeather = [[YTMRDBManager sharedManager] saveAndUpdateCurrentWeatherForToday:dataModel];
           [self updateMainView:currentWeather];
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
}

@end
