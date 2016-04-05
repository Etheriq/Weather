//
//  YTForecastWeatherVC.m
//  Weather
//
//  Created by Yuriy T on 28.03.16.
//  Copyright © 2016 Yuriy T. All rights reserved.
//

#import "YTForecastWeatherVC.h"
#import "ForecastWeather.h"
#import "YTForecastWeatherCell.h"
#import "YTMRDBManager.h"
#import "YTRequestManager.h"
#import "YTLocationManager.h"
#import "YTDateHelper.h"

@interface YTForecastWeatherVC () <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *frc;

@end

@implementation YTForecastWeatherVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[YTLocationManager sharedManager] updateLocation];
    self.clearsSelectionOnViewWillAppear = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithImage:[UIImage imageNamed:@"menu-icon"]
                                              style:UIBarButtonItemStylePlain
                                              target:self
                                              action:@selector(showMenuAction)
                                              ];
    
    UIRefreshControl *refreshCtr = [[UIRefreshControl alloc] init];
    [refreshCtr addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshCtr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Actions

- (void) showMenuAction {
    [self.menuContainerViewController toggleRightSideMenuCompletion:nil];
}

-(void) makeRequestToWeatherAPI {
    
    CLLocation *coord = [[YTLocationManager sharedManager] updateLocation];
    
    [[YTRequestManager sharedManager] getForecastWeatherByCoordinates:coord onSuccess:^(NSArray *data) {
        [[YTMRDBManager sharedManager] saveAndUpdateForecastWeather:data];
    } onFailure:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.frc.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    id<NSFetchedResultsSectionInfo> sectionInfo = self.frc.sections[section];
    
    return sectionInfo.numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cell";
    
    YTForecastWeatherCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    if (!cell) {
        cell = [[YTForecastWeatherCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    ForecastWeather *forecastWeather = [self.frc objectAtIndexPath:indexPath];
    cell.forecastWeather = forecastWeather;
    
    return cell;
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = self.frc.sections[section];
    ForecastWeather *forecastWeather = [sectionInfo.objects firstObject];
    
    return [NSString stringWithFormat:@"%@", [[YTDateHelper sharedHelper] getFormattedDateStringFromDate:forecastWeather.orderDate withFormat:@"d MMMM yyyy"]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIRefreshControl 

- (void)refresh:(UIRefreshControl *)refreshControl
{
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self makeRequestToWeatherAPI];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *lastUpdate = [NSString stringWithFormat:@"Last updated on %@", [[YTDateHelper sharedHelper] getFormattedDateStringFromDate:[NSDate date] withFormat:@"d MMM, kk:mm"]];
            refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdate];
            
            [self.tableView reloadData];
            [refreshControl endRefreshing];
        });
    });
}

#pragma mark - NSFetchResultController

-(NSFetchedResultsController *) frc {
    if (_frc) {
        return _frc;
    }
    
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:[[ForecastWeather class] description]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"createdAt >= %@", [NSDate date]];
    [request setPredicate:predicate];
    NSSortDescriptor *sortByCreated = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:YES];
    [request setSortDescriptors:@[sortByCreated]];
    [request setFetchBatchSize:25];
    
    _frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:@"orderDate" cacheName:nil];
    _frc.delegate = self;
    
    NSError *error = nil;
    
    if (![_frc performFetch:&error]) {
        NSLog(@"GetAll error: %@", [error localizedDescription]);
    }
    
    return _frc;
}

#pragma mark - NSFetchedResultsControllerDelegate

-(void) controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

-(void) controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationLeft];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationRight];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
            
        default:
            break;
    }
}

-(void) controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationLeft];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationRight];
            break;
            
        case NSFetchedResultsChangeUpdate:
            //            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
            //                             withRowAnimation:UITableViewRowAnimationFade];
            //            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            //            if (cell != nil) {
            //                [self configureCell:cell withObject:anObject];
            //            }
            
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

-(void) controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

@end
