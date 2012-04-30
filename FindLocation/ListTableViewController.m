//
//  ListTableViewController.m
//  FindLocation
//
//  Created by Andrey Poznyak on 3/31/12.
//  Copyright (c) 2012 bsuir. All rights reserved.
//

#import "ListTableViewController.h"
#import "HotSpot+Network.h"
#include <dlfcn.h>


@implementation ListTableViewController//currentListOrHistory: YES - current list, NO - history

@synthesize listOfHotSpots = _listOfHotSpots;
@synthesize managedObjectContext = _managedObjectContext;
//@synthesize hotSpotsDatabase = _hotSpotsDatabase;

@synthesize currentListOrHistory = _currentListOrHistory;

- (void)setupFetchedResultController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"HotSpot"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request 
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

- (void)fetchDataIntoDocument:(NSManagedObjectContext*)context
{
    NSLog(@"fetchDataIntoDocument function");
    dispatch_queue_t fetchQ = dispatch_queue_create("Fetcher", NULL);
    dispatch_async(fetchQ, ^{
        [context performBlock:^{
            for(NetworkInfo *network in self.listOfHotSpots)
            {
                [HotSpot hotSpotWithNetworkInfo:network inManagedObjectContext:context];
            }
        }];
    });
}

- (void)useDocument
{
    NSLog(@"useDocument:");
    //-------------------------------------------------------------------------
    NSString *docsDir, *databasePath;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"contacts.db"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
		const char *dbpath = [databasePath UTF8String];
        
//        if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
//        {
//            char *errMsg;
//            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, ADDRESS TEXT, PHONE TEXT)";
//            
//            if (sqlite3_exec(contactDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
//            {
//                status.text = @"Failed to create table";
//            }
//            
//            sqlite3_close(contactDB);
//            
//        } else {
//            status.text = @"Failed to open/create database";
//        }
    }
    //-----------------------------------------
    if(![[NSFileManager defaultManager] fileExistsAtPath:[self.urlOfDatabase path]])
    {
        NSLog(@"case 1");
        [self.hotSpotsDatabase saveToURL:self.hotSpotsDatabase.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
            NSLog(@"creation completed successfully");
            if(self.currentListOrHistory == YES){
                [self fetchDataIntoDocument:self.hotSpotsDatabase];
            }
            else{
                [self setupFetchedResultController];
            }
        }];
    } else if(self.hotSpotsDatabase.documentState == UIDocumentStateClosed)
    {
        NSLog(@"case 2");
        [self.hotSpotsDatabase openWithCompletionHandler:^(BOOL success){
            if(self.currentListOrHistory == YES){
                [self fetchDataIntoDocument:self.hotSpotsDatabase];
            }
            else{
                [self setupFetchedResultController];
            }
        }];
    } else if(self.hotSpotsDatabase.documentState == UIDocumentStateNormal)
    {
        NSLog(@"case 3");
        if(self.currentListOrHistory == YES){
            [self fetchDataIntoDocument:self.hotSpotsDatabase];
        }
        else{
            [self setupFetchedResultController];
        }
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
    
    self.managedObjectContext = managedObjectContext;//???????
    
//    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
//    url = [url URLByAppendingPathComponent:@"hotspots.sqlite"];
//    self.urlOfDatabase = url;
//    self.hotSpotsDatabase = [[UIManagedDocument alloc] initWithFileURL:url]                                       ;//only on ios 5

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
    if(self.currentListOrHistory == YES){
        return [self.listOfHotSpots count];
    }else{
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
        }else{
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
    if(self.currentListOrHistory == YES)
    {
        NetworkInfo *temp = [self.listOfHotSpots objectAtIndex:indexPath.row];
        NetworkDetailViewController *detailViewController = [[NetworkDetailViewController alloc] initWithNibName:@"NetworkDetailViewController"
                                                                                                          bundle:nil];
        [detailViewController setCurrentNetwork:temp];
        // Pass the selected object to the new view controller.
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}

@end
