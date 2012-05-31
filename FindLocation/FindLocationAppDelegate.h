//
//  FindLocationAppDelegate.h
//  FindLocation
//
//  Created by Andrey Poznyak on 3/31/12.
//  Copyright (c) 2012 bsuir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreData/CoreData.h"
#import "CoreLocation/CoreLocation.h"

//!Class FindLocationAppDelegate
/*!Main class of application, its properties and methods are reachable from any part of code*/
@interface FindLocationAppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;

/*!work with database*/
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
/*!work with database*/
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
/*!work with database*/
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
/*!path of database*/
@property (nonatomic, strong) NSURL *urlOfDatabase;

/*!in order to determine location of device*/
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic) double currentLatitude;
@property (nonatomic) double currentLongitude;

/*!Method to refresh current longitude and latitude of device*/
- (void) refreshLocation;

@end
