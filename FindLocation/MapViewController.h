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

@interface MapViewController : UIViewController

@property (nonatomic, strong) NSArray *annotations;
@property (unsafe_unretained, nonatomic) IBOutlet MKMapView *mapView;

@end
