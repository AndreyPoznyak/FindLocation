//
//  HotSpot+Network.m
//  FindLocation
//
//  Created by Andrey Poznyak on 4/24/12.
//  Copyright (c) 2012 bsuir. All rights reserved.
//

#import "HotSpot+Network.h"
#import "FindLocationAppDelegate.h"

@implementation HotSpot (Network)

+ (HotSpot*)hotSpotWithNetworkInfo:(NetworkInfo*)network inManagedObjectContext:(NSManagedObjectContext*)context
{
    FindLocationAppDelegate *appDelegate = (FindLocationAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSNumber *latitude = [NSNumber numberWithDouble:appDelegate.currentLatitude];
    NSNumber *longitude = [NSNumber numberWithDouble:appDelegate.currentLongitude];
    HotSpot *newNetwork = nil;
    //NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"HotSpot"];        //only iOS 5.0
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"HotSpot" inManagedObjectContext:context];
	[request setEntity:entity];
    request.predicate = [NSPredicate predicateWithFormat:@"bssid = %@", network.networkBSSID];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if(!matches || [matches count] > 1)
    {
        //handle this error somehow here
    }
    else if([matches count] == 0)
    {
        NSLog(@"Adding new network to DB here!");
        newNetwork = [NSEntityDescription insertNewObjectForEntityForName:@"HotSpot" inManagedObjectContext:context];
        newNetwork.name = network.networkName;
        newNetwork.bssid = network.networkBSSID;
        newNetwork.strength1 = [NSNumber numberWithInt:(-1)*([network.signalStrength intValue])];
        newNetwork.latitude1 = latitude;
        newNetwork.longitude1 = longitude;
    }
    else
    {
        newNetwork = [matches lastObject];
        if([newNetwork.latitude2 isEqualToNumber:[NSNumber numberWithDouble:0]]) {
            if(newNetwork.latitude1 != latitude || newNetwork.longitude1 != longitude) {
                newNetwork.latitude2 = latitude;
                newNetwork.longitude2 = longitude;
                newNetwork.strength2 = [ NSNumber numberWithInt:(-1)*([network.signalStrength intValue])];
            }
        } else if([newNetwork.longitude3 isEqualToNumber:[NSNumber numberWithDouble:0]]) {
            if(newNetwork.latitude1 != latitude || newNetwork.longitude1 != longitude) {
                if(newNetwork.latitude2 != latitude || newNetwork.longitude2 != longitude) {
                    newNetwork.latitude3 = latitude;
                    newNetwork.longitude3 = longitude;
                    newNetwork.strength3 = [ NSNumber numberWithInt:(-1)*([network.signalStrength intValue])];
                //[self evaluateLocation];
                }
            }
        }
    }
    
    return newNetwork;
}

@end
