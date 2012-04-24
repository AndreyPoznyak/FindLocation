//
//  HotSpot+Network.h
//  FindLocation
//
//  Created by Andrey Poznyak on 4/24/12.
//  Copyright (c) 2012 bsuir. All rights reserved.
//

#import "HotSpot.h"
#import "NetworkInfo.h"

@interface HotSpot (Network)

+ (HotSpot*)hotSpotWithNetworkInfo:(NetworkInfo*)network inManagedObjectContext:(NSManagedObjectContext*)context;

@end
