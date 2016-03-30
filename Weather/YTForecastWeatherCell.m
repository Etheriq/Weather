//
//  YTForecastWeatherCell.m
//  Weather
//
//  Created by Yuriy T on 28.03.16.
//  Copyright © 2016 Yuriy T. All rights reserved.
//

#import "YTForecastWeatherCell.h"
#import "ForecastWeather.h"

@implementation YTForecastWeatherCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setForecastWeather:(ForecastWeather *)forecastWeather {
    _forecastWeather = forecastWeather;
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HH:mm"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    
    self.timeLabel.text = [timeFormatter stringFromDate:forecastWeather.createdAt];
    self.dateLabel.text = [dateFormatter stringFromDate:forecastWeather.createdAt];
    self.descriptionLabel.text = forecastWeather.weatherDescription;
    self.tempLabel.text = [NSString stringWithFormat:@"%.0f", [forecastWeather.temp floatValue]];
    self.windSpeedLabel.text = [NSString stringWithFormat:@" S: %li m/s", [forecastWeather.speed integerValue]];
    self.humidityLabel.text = [NSString stringWithFormat:@" H: %li %%", [forecastWeather.humidity integerValue]];
    self.pressureLabel.text = [NSString stringWithFormat:@" P: %.1f hPa", [forecastWeather.pressure floatValue]];
    
    self.weatherTypeImage.image = [UIImage imageNamed:forecastWeather.icon];
}

@end
