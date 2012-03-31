//
//  MapViewController.h
//  FindLocation
//
//  Created by Andrey Poznyak on 3/31/12.
//  Copyright (c) 2012 bsuir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreLocation/CoreLocation.h"
#import "MapKit/MapKit.h"

@interface MapViewController : UIViewController <CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
}

@property (nonatomic, strong) NSArray *annotations;
@property (unsafe_unretained, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, readonly) CLLocationManager *locationManager;
@property (nonatomic) double currentLatitude;
@property (nonatomic) double currentLongitude;

@end
