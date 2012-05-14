//
//  StuffViewController.m
//  FindLocation
//
//  Created by Andrey Poznyak on 4/14/12.
//  Copyright (c) 2012 bsuir. All rights reserved.
//

#import "StuffViewController.h"

@implementation StuffViewController
@synthesize mainLabel;

- (IBAction)cancel:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"03.png"]];
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
