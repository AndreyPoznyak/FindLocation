//
//  FindLocationMasterViewController.h
//  FindLocation
//
//  Created by Andrey Poznyak on 3/31/12.
//  Copyright (c) 2012 bsuir. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FindLocationDetailViewController;

@interface FindLocationMasterViewController : UITableViewController

@property (strong, nonatomic) FindLocationDetailViewController *detailViewController;

@end
