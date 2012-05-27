//
//  StuffViewController.m
//  FindLocation
//
//  Created by Andrey Poznyak on 4/14/12.
//  Copyright (c) 2012 bsuir. All rights reserved.
//

#import "StuffViewController.h"
#import "FindLocationAppDelegate.h"

@implementation StuffViewController

@synthesize mainLabel = _mainLabel;
@synthesize isMessageAboutError = _isMessageAboutError;

- (IBAction)cancel:(id)sender
{
    if(self.isMessageAboutError) [self dismissModalViewControllerAnimated:YES];
    else [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (NSString*)collectStats
{
    NSString *stats;
    FindLocationAppDelegate *myApp = (FindLocationAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"HotSpot" inManagedObjectContext:myApp.managedObjectContext];
    [request setEntity:entity];
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *descriptors = [[NSArray alloc] initWithObjects:descriptor, nil];
    [request setSortDescriptors:descriptors];
    NSError *error = nil;
    //NSMutableArray *fetchResults = [[myApp.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    int number = [myApp.managedObjectContext countForFetchRequest:request error:&error];
    //NSLog([NSString stringWithFormat:@"%d", number]);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"longitude1 > 0"];
    [request setPredicate:predicate];
    stats = [[NSString alloc] initWithFormat:@"Total number of hotspots: %d\n", number];
    predicate = [NSPredicate predicateWithFormat:@"longitude > 0"];
    [request setPredicate:predicate];
    number = [myApp.managedObjectContext countForFetchRequest:request error:&error];
    stats = [stats stringByAppendingString:[NSString stringWithFormat:@"Number of detected locations: %d", number]];
    //NSLog([NSString stringWithFormat:@"%d", number]);
    //stats stringByAppendingString:@""
    return stats;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"stuff_back.png"]];
    if(!self.isMessageAboutError) self.mainLabel.text = [self collectStats];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setMainLabel:nil];
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
