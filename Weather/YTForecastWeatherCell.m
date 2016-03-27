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
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM.yyyy kk:mm:ss"];
    
    self.textLabel.text = [NSString stringWithFormat:@"T: %.1f, c: %@", [forecastWeather.temp floatValue], [formatter stringFromDate:forecastWeather.createdAt]];
}

@end
