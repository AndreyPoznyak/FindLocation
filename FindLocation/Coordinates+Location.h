//
//  Coordinates+Location.h
//  FindLocation
//
//  Created by Andrey Poznyak on 6/2/12.
//  Copyright (c) 2012 bsuir. All rights reserved.
//

#import "Coordinates.h"
#import "NetworkInfo.h"

@interface Coordinates (Location)

+ (Coordinates*)coordinatesWithNetworkInfo:(NetworkInfo*)network inManagedObjectContext:(NSManagedObjectContext*)context;

@end
