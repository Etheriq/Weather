//
//  YTSideMenuVC.m
//  Weather
//
//  Created by Yuriy T on 22.03.16.
//  Copyright © 2016 Yuriy T. All rights reserved.
//

#import "YTSideMenuVC.h"
#import "MFSideMenu.h"
#import "YTMainVC.h"

@interface YTSideMenuVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonnull) NSArray* menu;

@end

@implementation YTSideMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.menu = @[
                  @{@"vcID": @"YTMainVC", @"menuTitle": @"main View"},
                  @{@"vcID": @"secondVC", @"menuTitle": @"second View"},
                  @{@"vcID": @"thirdVC", @"menuTitle": @"Map VC"}
                ];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.menu count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    
    cell.textLabel.text = [[self.menu objectAtIndex:indexPath.row] valueForKey:@"menuTitle"];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:[[self.menu objectAtIndex:indexPath.row] valueForKey:@"vcID"]];
    vc.title = [NSString stringWithFormat:@"Demo #%ld-%ld", (long)indexPath.section, (long)indexPath.row];
    
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    
//    [navigationController pushViewController:vc animated:YES];

    NSArray *controllers = [NSArray arrayWithObject:vc];
    navigationController.viewControllers = controllers;
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
}

@end
