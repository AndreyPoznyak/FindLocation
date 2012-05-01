//
//  ListTableViewController.m
//  FindLocation
//
//  Created by Andrey Poznyak on 3/31/12.
//  Copyright (c) 2012 bsuir. All rights reserved.
//

#import "ListTableViewController.h"
#import "FindLocationAppDelegate.h"
#import "HotSpot+Network.h"
#include <dlfcn.h>


@implementation ListTableViewController           //currentListOrHistory: YES - current list, NO - history

@synthesize listOfHotSpots = _listOfHotSpots;
@synthesize managedObjectContext = _managedObjectContext;
//@synthesize hotSpotsDatabase = _hotSpotsDatabase;

@synthesize currentListOrHistory = _currentListOrHistory;

- (void)setupFetchedResultController
{
    //NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"HotSpot"];   //only iOS 5.0
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"HotSpot" inManagedObjectContext:self.managedObjectContext];
	[request setEntity:entity];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
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
                [HotSpot hotSpotWithNetworkInfo:network inManagedObjectContext:context];
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
            if(self.currentListOrHistory == YES) {
                [self fetchDataIntoContext:self.managedObjectContext];
            }
            else {
                [self setupFetchedResultController];
            }
    } else {
        NSLog(@"There is no database to write anything!!");
    }
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"WiFi networks";
    
    FindLocationAppDelegate *appDelegate = (FindLocationAppDelegate*)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    [self useDocument];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (self.currentListOrHistory == YES) {
        NetworkInfo *temp = [self.listOfHotSpots objectAtIndex:indexPath.row];
        if(!temp.isCurrent){
            cell.textLabel.text = temp.networkName;
        } else {
            cell.textLabel.text = [temp.networkName stringByAppendingString:@" +"];
        }
    } else {
        HotSpot *hotSpot = [self.fetchedResultsController objectAtIndexPath:indexPath];
        cell.textLabel.text = hotSpot.name;
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
