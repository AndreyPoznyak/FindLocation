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

- (NSArray *)getListOfHotSpots
{
    NSMutableArray *hotSpots = [NSMutableArray array];
    NSString *currentBssid = [[NSString alloc] init];
    //NSArray *hotSpots = [NSArray arrayWithObjects:@"1", @"2", nil];
    
    if(!TARGET_IPHONE_SIMULATOR)
    {
    CFArrayRef interfaces = CNCopySupportedInterfaces();
    //NSLog(@"here it is %@", interfaces);
    CFIndex count = CFArrayGetCount(interfaces);
    
    for (int i = 0; i < count; i++)
    {
        CFStringRef interface = CFArrayGetValueAtIndex(interfaces, i);
        CFDictionaryRef netinfo = CNCopyCurrentNetworkInfo(interface);
        if (netinfo && CFDictionaryContainsKey(netinfo, kCNNetworkInfoKeySSID))
        {
          //  NSString *ssid = (__bridge NSString *)CFDictionaryGetValue(netinfo, kCNNetworkInfoKeySSID);
            currentBssid = (__bridge NSString *)CFDictionaryGetValue(netinfo, kCNNetworkInfoKeyBSSID);
          //  NSString *ssiddata = (__bridge NSString *)CFDictionaryGetValue(netinfo, kCNNetworkInfoKeySSIDData);
            // Compare with your needed ssid here
         //   NSLog(@"\n------\n%@\n%@\n%@", ssid, currentBssid, ssiddata);
        }
        if (netinfo) CFRelease(netinfo);
    }
    CFRelease(interfaces);
    }
    
    //---------------------------stuff with private library-----------------------------
    NSMutableArray *networks;
    void *libHandle;
    void *airportHandle;
    networks = [[NSMutableArray alloc] init];
    int (*open)(void *);
    int (*bind)(void *, NSString *);
    int (*close)(void *);
    //int (*scan)(void *, NSArray **, void *);
    int (*scan)(void *, NSArray **, NSDictionary *);
    //#if !(TARGET_IPHONE_SIMULATOR)
    
    // libHandle = dlopen("/System/Library/SystemConfiguration/WiFiManager.bundle/WiFiManager", RTLD_LAZY);
    libHandle = dlopen("/System/Library/SystemConfiguration/IPConfiguration.bundle/IPConfiguration", RTLD_LAZY);
    
    char *error;
    if (libHandle == NULL && (error = dlerror()) != NULL) {
        NSLog(@"%s", error);
        //exit(-1);
    }
    
    open = dlsym(libHandle, "Apple80211Open");
    bind = dlsym(libHandle, "Apple80211BindToInterface");
    close = dlsym(libHandle, "Apple80211Close");
    scan = dlsym(libHandle, "Apple80211Scan");
    
    open(&airportHandle);
    bind(airportHandle, @"en0");
    
    NSDictionary *parameters = [[NSDictionary alloc] init];
    //void *parameters;
    //NSArray *scan_networks;
    
    //#if !(TARGET_IPHONE_SIMULATOR)
    
    scan(airportHandle, &networks, parameters);
    
    //NSMutableString *result = [[NSMutableString alloc] initWithString:@"Networks:\n"];
    BOOL ind = NO;
    
    for (id key in networks) 
    {
       // [result appendString:[NSString stringWithFormat:@"%@ %@ %@\n", 
        if([currentBssid isEqualToString:[key objectForKey:@"BSSID"]]) ind = YES;
        [hotSpots addObject:[NetworkInfo newNetwork:[key objectForKey:@"SSID_STR"] 
                                        andStrength:[key objectForKey:@"RSSI"]
                                           andBssid:[key objectForKey:@"BSSID"]
                                         andCurrent:ind]];
    }
    //NSLog(result);
    
    return hotSpots;
}

- (IBAction)viewList
{
    NSLog(@"Inside action of button viewList");
    ListTableViewController *listController = [[ListTableViewController alloc] initWithNibName:@"ListTableViewController" bundle:nil];
    [listController setCurrentListOrHistory:YES];
    [listController setListOfHotSpots:[self getListOfHotSpots]];
    if([listController.listOfHotSpots count] == 0)
    {//just stuff with modal view instead of navigation controller
        StuffViewController *controller = [[StuffViewController alloc] initWithNibName:@"StuffViewController" bundle:nil];
        //UINavigationController *stuffNavController = [[UINavigationController alloc] initWithRootViewController:controller];
        //[self presentModalViewController:stuffNavController animated:YES];//define "cancel" button in stuffViewController
        [self.navigationController pushViewController:controller animated:YES];
    }else
    {
        [self.navigationController pushViewController:listController animated:YES];
    }
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
    //NSLog([NSString stringWithFormat:@"quantity of future annotations - %d", [fetchResults count]]);
    for(HotSpot *hot in fetchResults)
    {
        if(![hot.latitude isEqualToNumber:[NSNumber numberWithDouble:0]])
        {
            HotSpotAnnotation *annotation = [[HotSpotAnnotation alloc] init];
            [annotation setCustomLongitude:[hot.longitude doubleValue]];
            [annotation setCustomLatitude:[hot.latitude doubleValue]];
            [temp addObject:annotation];
        }
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
    // Do any additional setup after loading the view from its nib.
    //from Reachability:
//    NetworkStatus currentStatus = [[Reachability reachabilityForInternetConnection] 
//                                   currentReachabilityStatus];
//    if(currentStatus == kReachableViaWWAN) // 3G
//    {}
//        else if(currentStatus == kReachableViaWifi) // ...wifi
//        {}
//            else if(currentStatus == kNotReachable) // no connection currently possible
//            {}
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
