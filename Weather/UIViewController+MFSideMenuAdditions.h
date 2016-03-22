//
//  UIViewController+MFSideMenuAdditions.h
//  Weather
//
//  Created by Yuriy T on 22.03.16.
//  Copyright © 2016 Yuriy T. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MFSideMenuContainerViewController;

// category on UIViewController to provide reference to the menuContainerViewController in any of the contained View Controllers
@interface UIViewController (MFSideMenuAdditions)

@property(nonatomic,readonly,retain) MFSideMenuContainerViewController *menuContainerViewController;

@end