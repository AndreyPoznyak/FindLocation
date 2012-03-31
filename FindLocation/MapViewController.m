//
//  MapViewController.m
//  FindLocation
//
//  Created by Andrey Poznyak on 3/31/12.
//  Copyright (c) 2012 bsuir. All rights reserved.
//

#import "MapViewController.h"

@implementation MapViewController

@synthesize mapView = _mapView;
@synthesize locationManager = _locationManager;
@synthesize currentLatitude = _currentLatitude;
@synthesize currentLongitude = _currentLongitude;
@synthesize annotations = _annotations;

//- (CLLocation*)locationManager
//{
//    if(_locationManager == nil)
//    {
//        _locationManager = [[CLLocationManager alloc] init];
//        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
//        _locationManager.delegate = self;
//    }
//    return _locationManager;
//}

- (void)updateMapView
{
    if(self.mapView.annotations) [self.mapView removeAnnotations:self.mapView.annotations];
    if(self.annotations){
        [self.mapView addAnnotations:self.annotations];
        NSLog(@"adding an array of annotations to map here");
    }
}

- (void)setMapView:(MKMapView *)mapView
{
    _mapView = mapView;
    [self updateMapView];
}

-(void)setAnnotations:(NSArray *)annotations
{
    _annotations = annotations;
    [self updateMapView];
}

- (void)locationManager:(CLLocationManager *)manager 
     didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation*)oldLocation
{
    NSLog(@"Core location claims to have a position");
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"Core location can't get a fix");
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"Inside viewDidLoad");
    CLLocation *curPosition = self.locationManager.location;
    self.currentLatitude = curPosition.coordinate.latitude;
    self.currentLongitude = curPosition.coordinate.longitude;
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"Shutting down core location");
    [self.locationManager stopUpdatingLocation];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"inside viewWillAppear");
    NSString *temp = [NSString stringWithFormat:@"Latitude: %f, longitude: %f", self.currentLatitude, self.currentLongitude];
    NSLog(temp);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
