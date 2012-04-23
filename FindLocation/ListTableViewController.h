//
//  ListTableViewController.h
//  FindLocation
//
//  Created by Andrey Poznyak on 3/31/12.
//  Copyright (c) 2012 bsuir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkInfo.h"
#import "NetworkDetailViewController.h"
#import "CoreDataTableViewController.h"

@interface ListTableViewController : CoreDataTableViewController

@property (nonatomic, strong) NSArray *listOfHotSpots;
@property (nonatomic, strong) UIManagedDocument *hotSpotsDatabase;

@end
