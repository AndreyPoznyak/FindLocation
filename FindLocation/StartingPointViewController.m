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
#import "StuffViewController.h"
#import "HotSpotAnnotation.h"

@implementation StartingPointViewController

//- (void)pushEmtyView:(NSNotification*)notif
//{
//    NSLog(@"received notification about empty list");
//    //{//just stuff with modal view instead of navigation controller
//    StuffViewController *controller = [[StuffViewController alloc] initWithNibName:@"StuffViewController" bundle:nil];
//    UINavigationController *stuffNavController = [[UINavigationController alloc] initWithRootViewController:controller];
//    [self presentModalViewController:stuffNavController animated:YES];//define "cancel" button in stuffViewController
//}

- (IBAction)viewList
{
    NSLog(@"Inside action of button viewList");
    ListTableViewController *listController = [[ListTableViewController alloc] initWithNibName:@"ListTableViewController" bundle:nil];
    [listController setCurrentListOrHistory:YES];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushEmtyView:) name:@"NoHotSpots" object:nil];
    [self.navigationController pushViewController:listController animated:YES];
}

- (NSArray *)mapAnnotations                          //interaction with the HotSpotAnnotation should be here
{
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    FindLocationAppDelegate *myApp = (FindLocationAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"longitude > 0"];
    [request setPredicate:predicate];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"HotSpot" inManagedObjectContext:myApp.managedObjectContext];
    [request setEntity:entity];
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *descriptors = [[NSArray alloc] initWithObjects:descriptor, nil];
    [request setSortDescriptors:descriptors];
    NSError *error = nil;
    NSMutableArray *fetchResults = [[myApp.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    //NSLog([NSString stringWithFormat:@"quantity of possible annotations - %d", [fetchResults count]]);
    for(HotSpot *hot in fetchResults)
    {
        //NSLog(hot.name);
        [temp addObject:[HotSpotAnnotation annotationForHotSpot:hot]];
    }
    return temp;
}

- (IBAction)viewMap
{
    NSLog(@"Inside action of button viewMap");
    MapViewController *mapController = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
    mapController.annotations = [self mapAnnotations];            //uncomment then!!!
    [self.navigationController pushViewController:mapController animated:YES];
}

- (IBAction)viewHistory
{
    NSLog(@"Inside action of button viewHistory");
    ListTableViewController *listController = [[ListTableViewController alloc] initWithNibName:@"ListTableViewController" bundle:nil];
    [listController setCurrentListOrHistory:NO];
    [self.navigationController pushViewController:listController animated:YES];
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
    self.navigationItem.title = @"Menu";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"01.png"]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
