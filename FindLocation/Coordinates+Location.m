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

+ (int)strengthToLength:(int)str
{
    return pow(10, (str/21.5))*(3/(4*3.14159*24));
}

//+ (HotSpot*)evaluateLocation:(HotSpot*)network
//{
//    double x1, x2, x3, y1, y2, y3;
//    x1 = [network.latitude1 doubleValue];
//    y1 = [network.longitude1 doubleValue];
//    x2 = [network.latitude2 doubleValue];
//    y2 = [network.longitude2 doubleValue];
//    x3 = [network.latitude3 doubleValue];
//    y3 = [network.longitude3 doubleValue];
//    int s1 = 100 - [network.strength1 intValue];
//    int s2 = 100 - [network.strength2 intValue];
//    int s3 = 100 - [network.strength3 intValue];
////    int radius1, radius2, radius3;
////    radius1 = [self strengthToLength:[network.strength1 intValue]];
////    radius2 = [self strengthToLength:[network.strength2 intValue]];
////    radius3 = [self strengthToLength:[network.strength3 intValue]];
////    double lengthAB, lengthBC;
////    lengthAB = sqrt(pow((x2-x1), 2) + pow((y2-y1), 2));
////    lengthBC = sqrt(pow((x3-x2), 2) + pow((y3-y2), 2));
//    int summOfStrengths = s1 + s2 + s3;
//    double x = 0;     //desired latitude of hotspot
//    double y = 0;     //desired longitude of hotspot
//    x = (x1*s1 + x2*s2 + x3*s3)/summOfStrengths;
//    y = (y1*s1 + y2*s2 + y3*s3)/summOfStrengths;
////    double a, b, c, d, e, f;
////    a = 2*(x2-x1);
////    b = 2*(y2-y1);
////    c = pow(radius1, 2) - pow(radius2, 2) - x1*x1 - y1*y1 + x2*x2 + y2*y2;
////    d = 2*(x3-x1);
////    e = 2*(y3-y1);
////    f = pow(radius1, 2) - pow(radius3, 2) - x1*x1 - y1*y1 + x3*x3 + y3*y3;
////    y = (c*d - f*a)/(b*d - e*a);
////    x = (c*e - f*b)/(a*e - d*b);
//    network.latitude = [NSNumber numberWithDouble:x];
//    network.longitude = [NSNumber numberWithDouble:y];
//    return network;
//}

+ (NSArray*)countForThree:(NSArray*)str withLon:(NSArray*)lon withLat:(NSArray*)lat
{
    double x1, x2, x3, y1, y2, y3;
    x1 = [[lat objectAtIndex:0] doubleValue];
    y1 = [[lon objectAtIndex:0] doubleValue];
    x2 = [[lat objectAtIndex:1] doubleValue];
    y2 = [[lon objectAtIndex:1] doubleValue];
    x3 = [[lat objectAtIndex:2] doubleValue];
    y3 = [[lon objectAtIndex:2] doubleValue];
    int streng = ([[str objectAtIndex:0] intValue] + [[str objectAtIndex:1] intValue] + [[str objectAtIndex:2] intValue])/6;
    int radius1, radius2, radius3;
    radius1 = [self strengthToLength:[[str objectAtIndex:0] intValue]];
    radius2 = [self strengthToLength:[[str objectAtIndex:1] intValue]];
    radius3 = [self strengthToLength:[[str objectAtIndex:2] intValue]];
    double lengthAB, lengthBC;
    lengthAB = sqrt(pow((x2-x1), 2) + pow((y2-y1), 2));
    lengthBC = sqrt(pow((x3-x2), 2) + pow((y3-y2), 2));
    double x = 0;     //desired latitude of hotspot
    double y = 0;     //desired longitude of hotspot
    double a, b, c, d, e, f;
    a = 2*(x2-x1);
    b = 2*(y2-y1);
    c = pow(radius1, 2) - pow(radius2, 2) - x1*x1 - y1*y1 + x2*x2 + y2*y2;
    d = 2*(x3-x1);
    e = 2*(y3-y1);
    f = pow(radius1, 2) - pow(radius3, 2) - x1*x1 - y1*y1 + x3*x3 + y3*y3;
    y = (c*d - f*a)/(b*d - e*a);
    x = (c*e - f*b)/(a*e - d*b);
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    [temp addObject:[NSNumber numberWithDouble:x]];
    [temp addObject:[NSNumber numberWithDouble:y]];
    [temp addObject:[NSNumber numberWithDouble:streng]];
    return temp;
}

+ (void)evaluateLocation:(NSString*)bssid inManagedObjectContext:(NSManagedObjectContext*)context
{
    NSMutableArray *longitudes, *latitudes, *strengths;
    longitudes = [[NSMutableArray alloc] init];
    latitudes = [[NSMutableArray alloc] init];
    strengths = [[NSMutableArray alloc] init];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Coordinates" inManagedObjectContext:context];
	[request setEntity:entity];
    request.predicate = [NSPredicate predicateWithFormat:@"correspBssid = %@", bssid];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"correspBssid" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    int numOfCoord = [matches count];
    //int sumOfStrengths = 0;
    int index = 0;
    double x = 0, y = 0;
    Coordinates *coord = nil;
//    for(index = 0; index < numOfCoord; index++)          //simple method of evaluation
//    {
//        coord = [matches objectAtIndex:index];
//        sumOfStrengths += (100 - [coord.strength intValue]);
//    }
//    for(index = 0; index < numOfCoord; index++)
//    {
//        coord = [matches objectAtIndex:index];
//        x += [coord.latitude doubleValue]*(100 - [coord.strength intValue])/sumOfStrengths;
//        y += [coord.longitude doubleValue]*(100 - [coord.strength intValue])/sumOfStrengths;
//    }
    NSMutableArray *newArray = [[NSMutableArray alloc] initWithArray:matches];
    int i = 0;
    Coordinates *newCoord = nil;
    //NSLog([NSString stringWithFormat:@" mathes: %d", [newArray count]]);
    for(;;)
    {
        //NSLog([NSString stringWithFormat:@" mathes: %d", [newArray count]]);
        //double lat = 0, lon = 0, str = 0;
        coord = [newArray lastObject];
        [longitudes addObject:coord.longitude];
        [latitudes addObject:coord.latitude];
        [strengths addObject:coord.strength];
        i++;
        [newArray removeLastObject];
        if(i == 3)
        {
            NSArray *arr = [[NSArray alloc] initWithArray:[self countForThree:strengths withLon:longitudes withLat:latitudes]];
            coord.latitude = [NSNumber numberWithDouble:[[arr objectAtIndex:0] doubleValue]];
            coord.longitude = [NSNumber numberWithDouble:[[arr objectAtIndex:1] doubleValue]];
            coord.strength = [NSNumber numberWithInt:[[arr objectAtIndex:2] intValue]];
            [newArray addObject:coord];
            i = 0;
            [longitudes removeAllObjects];
            [latitudes removeAllObjects];
            [strengths removeAllObjects];
        } //else 
        //
        //}
        if([newArray count] == 2)
        {
            Coordinates *c1 = nil, *c2 = nil;
            c1 = [newArray objectAtIndex:0];
            c2 = [newArray objectAtIndex:1];
            y = ([c1.longitude doubleValue]+ [c2.longitude doubleValue])/2;
            x = ([c1.latitude doubleValue]+ [c2.latitude doubleValue])/2;
            break;
        }
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
