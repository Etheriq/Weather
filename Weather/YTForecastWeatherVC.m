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
#import "YTDBManager.h"
#import "YTRequestManager.h"
#import "YTLocationManager.h"

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
        [[YTDBManager sharedManager] updateForecastWeather:data];
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

-(nullable NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = self.frc.sections[section];
    ForecastWeather *forecastWeather = [sectionInfo.objects firstObject];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"d MMMM yyyy"];
    
    return [NSString stringWithFormat:@"%@", [formatter stringFromDate:forecastWeather.orderDate]];
}

#pragma mark - UIRefreshControl 

- (void)refresh:(UIRefreshControl *)refreshControl
{
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self makeRequestToWeatherAPI];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"d MMM, kk:mm"];
            NSString *lastUpdate = [NSString stringWithFormat:@"Last updated on %@", [formatter stringFromDate:[NSDate date]]];
            
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
    
    NSManagedObjectContext *context = [YTDBManager sharedManager].managedObjectContext;
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
