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

+(int)strengthToLength:(int)strength
{
    int length = 0;
    if(strength <= 40) length = strength/10;
    else if(strength <=50) length = strength/10;
    else if(strength <=60) length = strength/12;
    else if(strength <=70) length = strength/8;
    else if(strength <=80) length = strength/3;
    else if(strength <=90) length = strength/1.3;
    else if(strength > 90) length = strength;
    return length;
}

+ (HotSpot*)evaluateLocation:(HotSpot*)network
{
    double x1, x2, x3, y1, y2, y3;
    x1 = [network.latitude1 doubleValue];
    y1 = [network.longitude1 doubleValue];
    x2 = [network.latitude2 doubleValue];
    y2 = [network.longitude2 doubleValue];
    x3 = [network.latitude3 doubleValue];
    y3 = [network.longitude3 doubleValue];
    int radius1, radius2, radius3;
    radius1 = [self strengthToLength:[network.strength1 intValue]];
    radius2 = [self strengthToLength:[network.strength2 intValue]];
    radius3 = [self strengthToLength:[network.strength3 intValue]];
//    double lengthAB, lengthBC;
//    lengthAB = sqrt(pow((x2-x1), 2) + pow((y2-y1), 2));
//    lengthBC = sqrt(pow((x3-x2), 2) + pow((y3-y2), 2));
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
    network.latitude = [NSNumber numberWithDouble:x];
    network.longitude = [NSNumber numberWithDouble:y];
    return network;
}

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
            if(![newNetwork.latitude1 isEqualToNumber:latitude] || ![newNetwork.longitude1 isEqualToNumber:longitude
                 ]) {
                newNetwork.latitude2 = latitude;
                newNetwork.longitude2 = longitude;
                newNetwork.strength2 = [ NSNumber numberWithInt:(-1)*([network.signalStrength intValue])];
            }
        } else if([newNetwork.longitude3 isEqualToNumber:[NSNumber numberWithDouble:0]]) {
            if(![newNetwork.latitude1 isEqualToNumber:latitude] || ![newNetwork.longitude1 isEqualToNumber:longitude]) {
                if(![newNetwork.latitude2 isEqualToNumber:latitude] || ![newNetwork.longitude2 isEqualToNumber:longitude]) {
                    newNetwork.latitude3 = latitude;
                    newNetwork.longitude3 = longitude;
                    newNetwork.strength3 = [ NSNumber numberWithInt:(-1)*([network.signalStrength intValue])];
                    newNetwork = [self evaluateLocation:newNetwork];
                }
            }
        } else {//temporary!!!!!
            newNetwork = [self evaluateLocation:newNetwork];
        }
    }
    return newNetwork;
}

@end
