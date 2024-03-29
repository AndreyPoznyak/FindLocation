//
//  ListTableViewController.m
//  FindLocation
//
//  Created by Andrey Poznyak on 3/31/12.
//  Copyright (c) 2012 bsuir. All rights reserved.
//

#import "ListTableViewController.h"
#import "FindLocationAppDelegate.h"
#import "Coordinates+Location.h"
#include <dlfcn.h>
#include "StuffViewController.h"


@implementation ListTableViewController           //currentListOrHistory: YES - current list, NO - history

@synthesize listOfHotSpots = _listOfHotSpots;
@synthesize managedObjectContext = _managedObjectContext;
//@synthesize hotSpotsDatabase = _hotSpotsDatabase;

@synthesize currentListOrHistory = _currentListOrHistory;

StuffViewController *controller;//message about error
UINavigationController *stuffNavController;
BOOL nothingToShow = NO; //if list of hotspots is empty we need to push navigation controller back

- (void)setListOfHotSpots:(NSArray*)listOfHotSpots
{
    if(_listOfHotSpots != listOfHotSpots) {
        _listOfHotSpots = listOfHotSpots;
        if(self.tableView.window) [self.tableView reloadData];
    }
}

- (NSArray *)getListOfHotSpots
{
//    NSString *currentBssid = [[NSString alloc] init];
//    //NSArray *hotSpots = [NSArray arrayWithObjects:@"1", @"2", nil];
//    
//    if(!TARGET_IPHONE_SIMULATOR)
//    {
//        CFArrayRef interfaces = CNCopySupportedInterfaces();
//        //NSLog(@"here it is %@", interfaces);
//        CFIndex count = CFArrayGetCount(interfaces);
//        
//        for (int i = 0; i < count; i++)
//        {
//            CFStringRef interface = CFArrayGetValueAtIndex(interfaces, i);
//            CFDictionaryRef netinfo = CNCopyCurrentNetworkInfo(interface);
//            if (netinfo && CFDictionaryContainsKey(netinfo, kCNNetworkInfoKeySSID))
//            {
//                currentBssid = (__bridge NSString *)CFDictionaryGetValue(netinfo, kCNNetworkInfoKeyBSSID);
//            }
//            if (netinfo) CFRelease(netinfo);
//        }
//        CFRelease(interfaces);
//    }
    
    //---------------------------stuff with private library-----------------------------
    NSMutableArray *hotSpots = [NSMutableArray array];
    NSMutableArray *networks = [[NSMutableArray alloc] init];;
    void *libHandle;
    void *airportHandle;
    int (*open)(void *);
    int (*bind)(void *, NSString *);
    int (*close)(void *);
    int (*scan)(void *, NSArray **, NSDictionary *);
    //#if !(TARGET_IPHONE_SIMULATOR)
    
    // libHandle = dlopen("/System/Library/SystemConfiguration/WiFiManager.bundle/WiFiManager", RTLD_LAZY);
    libHandle = dlopen("/System/Library/SystemConfiguration/IPConfiguration.bundle/IPConfiguration", RTLD_LAZY);
    
    char *error;
    if (libHandle == NULL && (error = dlerror()) != NULL) {
        NSLog(@"%s", error);
        //exit(-1);
    }
    
    NSDictionary *parameters = [[NSDictionary alloc] init];
    
    open = dlsym(libHandle, "Apple80211Open");
    bind = dlsym(libHandle, "Apple80211BindToInterface");
    close = dlsym(libHandle, "Apple80211Close");
    scan = dlsym(libHandle, "Apple80211Scan");
    
    //#if !(TARGET_IPHONE_SIMULATOR)
    open(&airportHandle);
    bind(airportHandle, @"en0");
    scan(airportHandle, &networks, parameters);
    close(airportHandle);
    
    //NSLog([NSString stringWithFormat:@"quantity of scanned networks: %d", [networks count]]);
    BOOL ind = NO;
    
    for (id key in networks) 
    {
//        if([currentBssid isEqualToString:[key objectForKey:@"BSSID"]]) ind = YES;
        [hotSpots addObject:[NetworkInfo newNetwork:[key objectForKey:@"SSID_STR"] 
                                        andStrength:[key objectForKey:@"RSSI"]
                                           andBssid:[key objectForKey:@"BSSID"]
                                         andCurrent:ind]];
    }
    
    if([hotSpots count] == 0) {
 //       [[NSNotificationCenter defaultCenter] postNotificationName:@"NoHotSpots" object:self];
        [self presentModalViewController:stuffNavController animated:YES];
        nothingToShow = YES;
    }
    return hotSpots;
}

- (void)setupFetchedResultController
{
    //NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"HotSpot"];   //only iOS 5.0
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"HotSpot" inManagedObjectContext:self.managedObjectContext];
	[request setEntity:entity];
    request.sortDescriptors = [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];//sortDescriptorWithKey:@"name" ascending:YES]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request 
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

- (void)fetchDataIntoContext:(NSManagedObjectContext*)context
{
    NSLog(@"fetchDataIntoDocument function");
    //dispatch_queue_t fetchQ = dispatch_queue_create("Fetcher", NULL);
    //dispatch_async(fetchQ, ^{
    //    [context performBlock:^{
            for(NetworkInfo *network in self.listOfHotSpots)
            {
                [Coordinates coordinatesWithNetworkInfo:network inManagedObjectContext:context];
            }
     //   }];
    //});
}

- (void)useDocument
{
    NSLog(@"useDocument:");

    FindLocationAppDelegate *appDelegate = (FindLocationAppDelegate*)[[UIApplication sharedApplication] delegate];
    if([[NSFileManager defaultManager] fileExistsAtPath:[appDelegate.urlOfDatabase path]])
    {
        NSLog(@"Trying to work with DB");
//            if(self.currentListOrHistory == YES) {
//                [self fetchDataIntoContext:self.managedObjectContext];
//            }
//            else 
            if(!self.currentListOrHistory) {
                [self setupFetchedResultController];
            }
    } else {
        NSLog(@"There is no database!!");
    }
}

- (IBAction)refresh:(id)sender
{
    //NSLog(@"refresh was pressed");
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    dispatch_queue_t refreshQ = dispatch_queue_create("Refresher", NULL);
    dispatch_async(refreshQ, ^{
        //NSArray *newList = [self getListOfHotSpots];
        dispatch_async(dispatch_get_main_queue(), ^{
            //if([newList count] != 0) {
                self.listOfHotSpots = [self getListOfHotSpots];
            if([self.listOfHotSpots count] != 0) {
                [self fetchDataIntoContext:self.managedObjectContext];
            }
            self.navigationItem.rightBarButtonItem = sender;
        });
    });
    dispatch_release(refreshQ);
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    controller = [[StuffViewController alloc] initWithNibName:@"StuffViewController" bundle:nil];
    [controller setIsMessageAboutError:YES];
    stuffNavController = [[UINavigationController alloc] initWithRootViewController:controller];
    [super viewDidLoad];
    self.navigationItem.title = @"WiFi networks";
    FindLocationAppDelegate *appDelegate = (FindLocationAppDelegate*)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    if(self.currentListOrHistory) {
        UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStylePlain target:self action:@selector(refresh:)];
        self.navigationItem.rightBarButtonItem = refreshButton;
        self.listOfHotSpots = [self getListOfHotSpots];
        [self fetchDataIntoContext:self.managedObjectContext];
    }
    else {
        [self useDocument];
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(nothingToShow) {
        [self.navigationController popViewControllerAnimated:YES];
        nothingToShow = NO;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.currentListOrHistory == YES) {
        return [self.listOfHotSpots count];
    } else {
        return [super tableView:tableView numberOfRowsInSection:section];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (self.currentListOrHistory == YES) {
        NetworkInfo *temp = [self.listOfHotSpots objectAtIndex:indexPath.row];
        //if(!temp.isCurrent) {
            cell.textLabel.text = temp.networkName;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"Strength: %@", temp.signalStrength];
        //} else {
        //    cell.textLabel.text = [temp.networkName stringByAppendingString:@" +"];
        //}
    } else {
        HotSpot *hotSpot = [self.fetchedResultsController objectAtIndexPath:indexPath];
        cell.textLabel.text = hotSpot.name;
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Coordinates" inManagedObjectContext:self.managedObjectContext];
        [request setEntity:entity];
        request.predicate = [NSPredicate predicateWithFormat:@"correspBssid = %@", hotSpot.bssid];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"correspBssid" ascending:YES];
        request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        NSError *error = nil;
        int num = [self.managedObjectContext countForFetchRequest:request error:&error];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Number of detections: %d", num];
    }
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if(self.currentListOrHistory) return NO;
    else return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.managedObjectContext deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        //[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate
//- (void)viewDidLoad
//{
//    NSLog(@"ViewDidLoad of list");
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    NetworkDetailViewController *detailViewController = [[NetworkDetailViewController alloc] initWithNibName:@"NetworkDetailViewController"
                                                                                                      bundle:nil];
    if(self.currentListOrHistory == YES)
    {
        NetworkInfo *temp = [self.listOfHotSpots objectAtIndex:indexPath.row];
        [detailViewController setCurrentNetwork:temp];
        // Pass the selected object to the new view controller.
        [self.navigationController pushViewController:detailViewController animated:YES];
    } else {
        HotSpot *hotSpot = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [detailViewController setCurrentHotSpot:hotSpot];
        // Pass the selected object to the new view controller.
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}

@end
