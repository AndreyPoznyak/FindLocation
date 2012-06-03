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

//+(int)strengthToLength:(int)strength
//{
//    int length = 0;
//    if(strength <= 40) length = strength/10;
//    else if(strength <=50) length = strength/10;
//    else if(strength <=60) length = strength/12;
//    else if(strength <=70) length = strength/8;
//    else if(strength <=80) length = strength/3;
//    else if(strength <=90) length = strength/1.3;
//    else if(strength > 90) length = strength;
//    return length;
//}

+ (void)recordNewLocation:(NSString*)bssid withLongitude:(double)longitude withLatitude:(double)latitude inManagedObjectContext:(NSManagedObjectContext*)context
{
    HotSpot *hotSpot = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"HotSpot" inManagedObjectContext:context];
	[request setEntity:entity];
    request.predicate = [NSPredicate predicateWithFormat:@"bssid = %@", bssid];
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
        return;
    }
    else
    {
        hotSpot = [matches lastObject];
        hotSpot.longitude = [NSNumber numberWithDouble:longitude];
        hotSpot.latitude = [NSNumber numberWithDouble:latitude];
    }
}

+ (HotSpot*)hotSpotWithName:(NSString*)name withBssid:(NSString*)bssid inManagedObjectContext:(NSManagedObjectContext*)context
{
    HotSpot *newNetwork = nil;
    //NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"HotSpot"];        //only iOS 5.0
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"HotSpot" inManagedObjectContext:context];
	[request setEntity:entity];
    request.predicate = [NSPredicate predicateWithFormat:@"bssid = %@", bssid];
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
        newNetwork.name = name;
        newNetwork.bssid = bssid;
    }
    else
    {
        newNetwork = [matches lastObject];
    }
    return newNetwork;
}

@end
