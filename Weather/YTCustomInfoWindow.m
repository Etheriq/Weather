//
//  YTCustomInfoWindow.m
//  Weather
//
//  Created by Yuriy T on 28.03.16.
//  Copyright © 2016 Yuriy T. All rights reserved.
//

#import "YTCustomInfoWindow.h"

@implementation YTCustomInfoWindow

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)showForecastAction:(UIButton *)sender {
    
    NSLog(@"coord: %@", self.coordinateLabel.text);
}

@end
