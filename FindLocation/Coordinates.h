//
//  Coordinates.h
//  FindLocation
//
//  Created by Andrey Poznyak on 6/2/12.
//  Copyright (c) 2012 bsuir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class HotSpot;

@interface Coordinates : NSManagedObject

@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * strength;
@property (nonatomic, retain) NSString * correspBssid;
@property (nonatomic, retain) HotSpot *whichHotSpot;

@end
