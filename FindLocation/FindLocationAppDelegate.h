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

@interface FindLocationAppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSURL *urlOfDatabase;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic) double currentLatitude;
@property (nonatomic) double currentLongitude;

- (void) refreshLocation;

@end
