//
//  NetworkDetailViewController.m
//  FindLocation
//
//  Created by Andrey Poznyak on 4/7/12.
//  Copyright (c) 2012 bsuir. All rights reserved.
//

#import "NetworkDetailViewController.h"

@interface NetworkDetailViewController()
@property BOOL currentHotSpotOrHistory;
@end

@implementation NetworkDetailViewController

@synthesize currentNetwork = _currentNetwork;
@synthesize currentHotSpot = _currentHotSpot;
@synthesize currentHotSpotOrHistory = _currentHotSpotOrHistory;
@synthesize nameField = _nameField;
@synthesize bssidFiled = _bssidFiled;
@synthesize signalField = _signalField;
@synthesize strengthLabel = _strengthLabel;
@synthesize fieldTwo = _fieldTwo;
@synthesize fieldThree = _fieldThree;

- (void)setCurrentNetwork:(NetworkInfo *)currentNetwork
{
    _currentNetwork = currentNetwork;
    self.currentHotSpotOrHistory = YES;
}

- (void)setCurrentHotSpot:(HotSpot *)currentHotSpot
{
    _currentHotSpot = currentHotSpot;
    self.currentHotSpotOrHistory = NO;
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
    if(self.currentHotSpotOrHistory == YES)
    {
        self.navigationItem.title = self.nameField.text = self.currentNetwork.networkName;
        self.bssidFiled.text = self.currentNetwork.networkBSSID;
        self.signalField.text = self.currentNetwork.signalStrength;
        self.fieldTwo.hidden = YES;
        self.fieldThree.hidden = YES;
    } else {
        self.strengthLabel.text = @"Locations:";
        self.bssidFiled.text = self.currentHotSpot.bssid;
        self.nameField.text = self.currentHotSpot.name;
        self.signalField.text = [NSString stringWithFormat:@"%@;%@ (%@)", 
                                 [self.currentHotSpot.latitude1 stringValue], [self.currentHotSpot.longitude1 stringValue],
                                 [self.currentHotSpot.strength1 stringValue]];
        self.fieldTwo.text = [NSString stringWithFormat:@"%@;%@ (%@)", 
                              [self.currentHotSpot.latitude2 stringValue], [self.currentHotSpot.longitude2 stringValue],
                              [self.currentHotSpot.strength2 stringValue]];
        self.fieldThree.text = [NSString stringWithFormat:@"%@;%@ (%@)", 
                                [self.currentHotSpot.latitude3 stringValue], [self.currentHotSpot.longitude3 stringValue],
                                [self.currentHotSpot.strength3 stringValue]];
    }
}

- (void)viewDidUnload
{
    [self setNameField:nil];
    [self setBssidFiled:nil];
    [self setSignalField:nil];
    [self setStrengthLabel:nil];
    [self setFieldTwo:nil];
    [self setFieldThree:nil];
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
