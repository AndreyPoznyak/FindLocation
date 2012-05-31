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
#import "SystemConfiguration/CaptiveNetwork.h"
//#import "SystemConfiguration/SystemConfiguration.h"
#include <dlfcn.h>

//!Class ListTableViewController
/*!Class for handling listTable of hotspots*/
@interface ListTableViewController : CoreDataTableViewController

/*!This array contains list of hotspots*/
@property (nonatomic, strong) NSArray *listOfHotSpots;
/*!context for out data storage*/
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
//@property (nonatomic, strong) UIManagedDocument *hotSpotsDatabase; //available only on iOS 5.0
/*!This property of bool indicates kind of shown list, whether it's history or currently available hotspots*/
@property BOOL currentListOrHistory;

@end
