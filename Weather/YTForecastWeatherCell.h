//
//  YTForecastWeatherCell.h
//  Weather
//
//  Created by Yuriy T on 28.03.16.
//  Copyright © 2016 Yuriy T. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ForecastWeather;
@interface YTForecastWeatherCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherTypeImage;
@property (weak, nonatomic) IBOutlet UILabel *windSpeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *pressureLabel;

@property (strong, nonatomic) ForecastWeather *forecastWeather;

@end
