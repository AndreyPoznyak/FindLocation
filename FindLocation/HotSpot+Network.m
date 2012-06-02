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
