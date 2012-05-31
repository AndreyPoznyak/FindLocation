//
//  MapViewController.h
//  FindLocation
//
//  Created by Andrey Poznyak on 3/31/12.
//  Copyright (c) 2012 bsuir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"
#import "FindLocationAppDelegate.h"

//!Class MapViewController
/*!Provides ViewController for map*/
@interface MapViewController : UIViewController

/*!Property of array which contains annotations to show on map*/
@property (nonatomic, strong) NSArray *annotations;
/*!Outlet to handle mapView*/
@property (unsafe_unretained, nonatomic) IBOutlet MKMapView *mapView;

@end
