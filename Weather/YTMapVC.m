//
//  YTMapVC.m
//  Weather
//
//  Created by Yuriy T on 23.03.16.
//  Copyright © 2016 Yuriy T. All rights reserved.
//

#import "YTMapVC.h"

@implementation YTMapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithImage:[UIImage imageNamed:@"menu-icon"]
                                              style:UIBarButtonItemStylePlain
                                              target:self
                                              action:@selector(showMenuAction)
                                              ];
    
}

# pragma mark - Actions

- (void) showMenuAction {
    [self.menuContainerViewController toggleRightSideMenuCompletion:nil];
}

@end
