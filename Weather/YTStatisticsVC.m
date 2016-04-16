//
//  YTStatisticsVC.m
//  Weather
//
//  Created by Yuriy T on 31.03.16.
//  Copyright © 2016 Yuriy T. All rights reserved.
//

#import "YTStatisticsVC.h"
#import "BEMSimpleLineGraphView.h"
#import "YTMRDBManager.h"
#import "YTDateHelper.h"

@interface YTStatisticsVC () <BEMSimpleLineGraphDelegate, BEMSimpleLineGraphDataSource>

@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *statsView;

@property (strong, nonatomic) NSArray *statResult;
@end

@implementation YTStatisticsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithImage:[UIImage imageNamed:@"menu-icon"]
                                              style:UIBarButtonItemStylePlain
                                              target:self
                                              action:@selector(showMenuAction)
                                              ];
    
    self.statResult = [[YTMRDBManager sharedManager] getAverageForecastStatisticsForLastThreeMonths];
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


# pragma mark - Actions

- (void) showMenuAction {
    [self.menuContainerViewController toggleRightSideMenuCompletion:nil];
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
    
    return [[currentStatInfo objectForKey:@"result"] floatValue];
}

- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    NSDictionary *currentStatInfo = [self.statResult objectAtIndex:index];
    
    return  [NSString stringWithFormat:@"%@", [[
                                                [YTDateHelper sharedHelper]
                                                    getFormattedDateStringFromDate:[currentStatInfo objectForKey:@"orderDate"]
                                                    withFormat:@"dd MMM yyyy"]
                                               stringByReplacingOccurrencesOfString:@" " withString:@"\n"]];
}

- (NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return 0;
}

#pragma mark - BEMSimpleLineGraphDelegate

- (NSString *)popUpSuffixForlineGraph:(BEMSimpleLineGraphView *)graph {
    return @"°C";
}

- (BOOL)lineGraph:(BEMSimpleLineGraphView *)graph alwaysDisplayPopUpAtIndex:(CGFloat)index {
 
    return YES;
}

- (NSInteger)numberOfYAxisLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    
    return 10;
}

@end
