//
//  HotSpot+Network.h
//  FindLocation
//
//  Created by Andrey Poznyak on 4/24/12.
//  Copyright (c) 2012 bsuir. All rights reserved.
//

#import "HotSpot.h"
#import "NetworkInfo.h"

//!Category HotSpot+Network
/*!
 This category created in order to work with HotSpot object, which is generated from DB table
 It allows to add methods to class but not directly
 */
@interface HotSpot (Network)

//!Method hotSpotWithNetworkInfo
/*!This method provide hotSpot object to store it in DB*/
+ (HotSpot*)hotSpotWithName:(NSString*)name withBssid:(NSString*)bssid inManagedObjectContext:(NSManagedObjectContext*)context;

+ (void)recordNewLocation:(NSString*)bssid withLongitude:(double)longitude withLatitude:(double)latitude inManagedObjectContext:(NSManagedObjectContext*)context;

//!Method evaluateLocation
/*!This method estimates location of hotspot if amount of data allows to do it*/
//+ (HotSpot*)evaluateLocation:(HotSpot*)network;

@end
