//
//  NetworkDetailViewController.m
//  FindLocation
//
//  Created by Andrey Poznyak on 4/7/12.
//  Copyright (c) 2012 bsuir. All rights reserved.
//

#import "NetworkDetailViewController.h"

@implementation NetworkDetailViewController

@synthesize currentNetwork = _currentNetwork;
@synthesize nameField = _nameField;
@synthesize bssidFiled = _bssidFiled;
@synthesize signalField = _signalField;

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
    self.navigationItem.title = self.nameField.text = self.currentNetwork.networkName;
    self.bssidFiled.text = self.currentNetwork.networkBSSID;
    self.signalField.text = self.currentNetwork.signalStrength;
}

- (void)viewDidUnload
{
    [self setNameField:nil];
    [self setBssidFiled:nil];
    [self setSignalField:nil];
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
