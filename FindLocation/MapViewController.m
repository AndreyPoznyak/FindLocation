//
//  MapViewController.m
//  FindLocation
//
//  Created by Andrey Poznyak on 3/31/12.
//  Copyright (c) 2012 bsuir. All rights reserved.
//

#import "MapViewController.h"
#import "HotSpotAnnotation.h"

@implementation MapViewController

@synthesize mapView = _mapView;
@synthesize locationManager = _locationManager;
@synthesize currentLatitude = _currentLatitude;
@synthesize currentLongitude = _currentLongitude;
@synthesize annotations = _annotations;

- (CLLocation*)locationManager
{
    if(_locationManager == nil)
    {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        _locationManager.delegate = self;
        [_locationManager startUpdatingLocation];
    }
    return _locationManager;
}

- (void) initializeMapView
{
    CLLocationCoordinate2D mapCenter = CLLocationCoordinate2DMake(self.currentLatitude, self.currentLongitude);
    MKCoordinateSpan mapSpan = MKCoordinateSpanMake(0.005, 0.010);
    MKCoordinateRegion mapRegion = MKCoordinateRegionMake(mapCenter, mapSpan);
    self.mapView.region = mapRegion;
    self.mapView.mapType = MKMapTypeStandard;
}

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

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation*)oldLocation
{
    NSLog(@"Core location claims to have a position");
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
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
    HotSpotAnnotation *currentAnn = [[HotSpotAnnotation alloc] init];
    [currentAnn setCustomLongitude:self.currentLongitude];
    [currentAnn setCustomLatitude:self.currentLatitude];
    NSLog(@"Inside viewWillAppear");
    //NSLog([NSString stringWithFormat:@"Latitude: %f, longitude: %f", self.currentLatitude, self.currentLongitude]);
    [self.mapView addAnnotation:currentAnn];
    [self initializeMapView];
    //[self.mapView addAnnotation([HotSpotAnnotation co])];//foreach
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
