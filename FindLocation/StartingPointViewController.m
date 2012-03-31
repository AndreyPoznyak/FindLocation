//
//  StartingPointViewController.m
//  FindLocation
//
//  Created by Andrey Poznyak on 3/31/12.
//  Copyright (c) 2012 bsuir. All rights reserved.
//

#import "StartingPointViewController.h"
#import "MapViewController.h"
#import "ListTableViewController.h"

@implementation StartingPointViewController

- (IBAction)viewList
{
    NSLog(@"Inside action of button viewList");
    NSArray *temp = [NSArray arrayWithObjects:@"1", @"2", @"3", nil];
    ListTableViewController *listController = [[ListTableViewController alloc] initWithNibName:@"ListTableViewController" bundle:nil];
    [listController setListOfHotSpots:temp];
    [self.navigationController pushViewController:listController animated:YES];
}

- (NSArray *)mapAnnotations                          //interaction with HotSpotAnnotation should be here
{
    NSArray *temp = [NSArray arrayWithObjects:@"1", @"2", nil];//get the list here (of hotspots coordinates)
    return temp;
}

- (IBAction)viewMap
{
    NSLog(@"Inside action of button viewMap");
    MapViewController *mapController = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
    //mapController.annotations = [self mapAnnotations];            //uncomment then!!!
    [self.navigationController pushViewController:mapController animated:YES];
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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
