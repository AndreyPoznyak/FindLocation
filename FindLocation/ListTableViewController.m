//
//  ListTableViewController.m
//  FindLocation
//
//  Created by Andrey Poznyak on 3/31/12.
//  Copyright (c) 2012 bsuir. All rights reserved.
//

#import "ListTableViewController.h"
#import "HotSpot.h"
#include <dlfcn.h>


@implementation ListTableViewController

@synthesize listOfHotSpots = _listOfHotSpots;
@synthesize hotSpotsDatabase = _hotSpotsDatabase;


- (void)setupFetchedResultController
{
}

- (void)fetchDataIntoDocument:(UIManagedDocument*)document
{
    dispatch_queue_t fetchQ = dispatch_queue_create("Fetcher", NULL);
    dispatch_async(fetchQ, ^{
        [document.managedObjectContext performBlock:^{
            for(NetworkInfo *network in self.listOfHotSpots) //!!!!!!!!!!!!!!!!!!!!continue here
            {
                HotSpot *newNetwork = [NSEntityDescription insertNewObjectForEntityForName:@"HotSpot" inManagedObjectContext:document];
                newNetwork.name = network.networkName;
                newNetwork.bssid = network.networkBSSID;
            }
        }];
    });
}

- (void)useDocument
{
    if(![[NSFileManager defaultManager] fileExistsAtPath:[self.hotSpotsDatabase.fileURL path]])
    {
        [self.hotSpotsDatabase saveToURL:self.hotSpotsDatabase.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
            [self setupFetchedResultController];
            [self fetchDataIntoDocument:self.hotSpotsDatabase];
        }];
    } else if(self.hotSpotsDatabase.documentState == UIDocumentStateClosed)
    {
        [self.hotSpotsDatabase openWithCompletionHandler:^(BOOL success){
            [self setupFetchedResultController];
        }];
    } else if(self.hotSpotsDatabase.documentState == UIDocumentStateNormal)
    {
        [self setupFetchedResultController];
    }
}

- (void)setHotSpotsDatabase:(UIManagedDocument *)hotSpotsDatabase
{
    if(_hotSpotsDatabase != hotSpotsDatabase)
    {
        _hotSpotsDatabase = hotSpotsDatabase;
        [self useDocument];
    }
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"WiFi networks";
    
    NSURL *url = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    url = [url URLByAppendingPathComponent:@"Default Hot Spots Database"];
    self.hotSpotsDatabase = [[UIManagedDocument alloc] initWithFileURL:url];

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
    return [self.listOfHotSpots count];
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
    NetworkInfo *temp = [self.listOfHotSpots objectAtIndex:indexPath.row];
    if(!temp.isCurrent){
        cell.textLabel.text = temp.networkName;
    }else{
        cell.textLabel.text = [temp.networkName stringByAppendingString:@" - current"];
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
    NetworkInfo *temp = [self.listOfHotSpots objectAtIndex:indexPath.row];
    NetworkDetailViewController *detailViewController = [[NetworkDetailViewController alloc] initWithNibName:@"NetworkDetailViewController" bundle:nil];
    [detailViewController setCurrentNetwork:temp];
     // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
