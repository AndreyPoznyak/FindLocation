//
//  Coordinates+Location.m
//  FindLocation
//
//  Created by Andrey Poznyak on 6/2/12.
//  Copyright (c) 2012 bsuir. All rights reserved.
//

#import "Coordinates+Location.h"
#import "HotSpot+Network.h"
#import "FindLocationAppDelegate.h"

@implementation Coordinates (Location)

+ (void)evaluateLocation:(NSString*)bssid inManagedObjectContext:(NSManagedObjectContext*)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Coordinates" inManagedObjectContext:context];
	[request setEntity:entity];
    request.predicate = [NSPredicate predicateWithFormat:@"correspBssid = %@", bssid];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"correspBssid" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    int numOfCoord = [matches count];
    int sumOfStrengths = 0;
    int index = 0;
    double x = 0, y = 0;
    Coordinates *coord = nil;
    for(index = 0; index < numOfCoord; index++)
    {
        coord = [matches objectAtIndex:index];
        sumOfStrengths += (100 - [coord.strength intValue]);
    }
    for(index = 0; index < numOfCoord; index++)
    {
        coord = [matches objectAtIndex:index];
        x += [coord.latitude doubleValue]*(100 - [coord.strength intValue])/sumOfStrengths;
        y += [coord.longitude doubleValue]*(100 - [coord.strength intValue])/sumOfStrengths;
    }
    [HotSpot recordNewLocation:bssid withLongitude:y withLatitude:x inManagedObjectContext:context];
}

+ (Coordinates*)coordinatesWithNetworkInfo:(NetworkInfo*)network inManagedObjectContext:(NSManagedObjectContext*)context
{
    FindLocationAppDelegate *appDelegate = (FindLocationAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate refreshLocation];
    NSNumber *latitude = [NSNumber numberWithDouble:appDelegate.currentLatitude];
    NSNumber *longitude = [NSNumber numberWithDouble:appDelegate.currentLongitude];
    Coordinates *newCoordinates = nil;
    //NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"HotSpot"];        //only iOS 5.0
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Coordinates" inManagedObjectContext:context];
	[request setEntity:entity];
    request.predicate = [NSPredicate predicateWithFormat:@"(longitude = %f) AND (latitude = %f) AND (correspBssid = %@)", [longitude doubleValue], [latitude doubleValue], network.networkBSSID];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"correspBssid" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if(!matches || [matches count] > 1)
    {
        //handle this error somehow here
    }
    else if([matches count] == 0)
    {
        NSLog(@"Adding new coordinates of network to DB here!");
        newCoordinates = [NSEntityDescription insertNewObjectForEntityForName:@"Coordinates" inManagedObjectContext:context];
        newCoordinates.correspBssid = network.networkBSSID;
        newCoordinates.strength = [NSNumber numberWithInt:(-1)*([network.signalStrength intValue])];
        newCoordinates.latitude = latitude;
        newCoordinates.longitude = longitude;
        newCoordinates.whichHotSpot = [HotSpot hotSpotWithName:network.networkName withBssid:network.networkBSSID inManagedObjectContext:context];
        request.predicate = [NSPredicate predicateWithFormat:@"correspBssid = %@", network.networkBSSID];
        int num = [context countForFetchRequest:request error:&error];
        if(num > 2)
        {
            [self evaluateLocation:network.networkBSSID inManagedObjectContext:context];
        }
    }
    else
    {
        newCoordinates = [matches lastObject];
    }
    return newCoordinates;
}

@end
