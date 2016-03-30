//
//  YTStatisticsVC.m
//  Weather
//
//  Created by Yuriy T on 31.03.16.
//  Copyright © 2016 Yuriy T. All rights reserved.
//

#import "YTStatisticsVC.h"
#import "BEMSimpleLineGraphView.h"

@interface YTStatisticsVC () <BEMSimpleLineGraphDelegate, BEMSimpleLineGraphDataSource>

@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *statsView;

@property (strong, nonatomic) NSArray *statResult;
@end

@implementation YTStatisticsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *dic1 = @{
                           @"temp": @3.2f,
                           @"date": @"2 December 2016"
                         };
    NSDictionary *dic2 = @{
                           @"temp": @18.6f,
                           @"date": @"12 May 2016"
                           };
    NSDictionary *dic3 = @{
                           @"temp": @-3.2f,
                           @"date": @"13 May 2016"
                           };
    NSDictionary *dic4 = @{
                           @"temp": @22.2f,
                           @"date": @"15 July 2016"
                           };
    
    self.statResult = [NSArray arrayWithObjects:dic1, dic2, dic3, dic4, nil];
    
    self.statsView.enableXAxisLabel = YES;
    self.statsView.enablePopUpReport = YES;
    self.statsView.enableTouchReport = YES;
    self.statsView.enableReferenceXAxisLines = NO;
    self.statsView.enableReferenceYAxisLines = YES;
    self.statsView.alwaysDisplayDots = YES;
    self.statsView.alwaysDisplayPopUpLabels = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - BEMSimpleLineGraphDataSource

/** The number of points along the X-axis of the graph.
 @param graph The graph object requesting the total number of points.
 @return The total number of points in the line graph. */
- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    
    return [self.statResult count];
}


/** The vertical position for a point at the given index. It corresponds to the Y-axis value of the Graph.
 @param graph The graph object requesting the point value.
 @param index The index from left to right of a given point (X-axis). The first value for the index is 0.
 @return The Y-axis value at a given index. */
- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    NSDictionary *currentStatInfo = [self.statResult objectAtIndex:index];
    
    return [[currentStatInfo objectForKey:@"temp"] floatValue];
}

- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    NSDictionary *currentStatInfo = [self.statResult objectAtIndex:index];
    
    return  [NSString stringWithFormat:@"%@", [[currentStatInfo objectForKey:@"date"] stringByReplacingOccurrencesOfString:@" " withString:@"\n"]];
}

- (NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return 0;
}

#pragma mark - BEMSimpleLineGraphDelegate

- (NSString *)popUpSuffixForlineGraph:(BEMSimpleLineGraphView *)graph {
    return @"°C";
}

- (BOOL)lineGraph:(BEMSimpleLineGraphView *)graph alwaysDisplayPopUpAtIndex:(CGFloat)index {
//    if (index == 0 || index == 10) return YES;
//    else return NO;
//    
    return YES;
}

- (NSInteger)numberOfYAxisLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return 7;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
