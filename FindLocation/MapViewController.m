//
//  MapViewController.m
//  FindLocation
//
//  Created by Andrey Poznyak on 3/31/12.
//  Copyright (c) 2012 bsuir. All rights reserved.
//

#import "MapViewController.h"
#import "HotSpot.h"

@implementation MapViewController

@synthesize mapView = _mapView;
@synthesize annotations = _annotations;

- (void) initializeMapView
{
    FindLocationAppDelegate *appDelegate = (FindLocationAppDelegate*)[[UIApplication sharedApplication] delegate];
    CLLocationCoordinate2D mapCenter = CLLocationCoordinate2DMake(appDelegate.currentLatitude, appDelegate.currentLongitude);
    MKCoordinateSpan mapSpan = MKCoordinateSpanMake(0.005, 0.010);
    MKCoordinateRegion mapRegion = MKCoordinateRegionMake(mapCenter, mapSpan);
    self.mapView.region = mapRegion;
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.showsUserLocation = YES;
}

- (void)updateMapView
{
    if(self.mapView.annotations) [self.mapView removeAnnotations:self.mapView.annotations];
    if(self.annotations){
        [self.mapView addAnnotations:self.annotations];
        NSLog(@"adding an array of annotations to map here");
    }
}

//- (void)setMapView:(MKMapView *)mapView
//{
//    _mapView = mapView;
//    [self updateMapView];
//}
//
//-(void)setAnnotations:(NSArray *)annotations
//{
//    _annotations = annotations;
//    [self updateMapView];
//}

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
    FindLocationAppDelegate *appDelegate = (FindLocationAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate refreshLocation];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Map";
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
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.mapView addAnnotations:self.annotations];
    //NSLog([NSString stringWithFormat:@"trying to add %d annotations", [self.annotations count]]);
    [self initializeMapView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
