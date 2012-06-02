//
//  HotSpot.h
//  FindLocation
//
//  Created by Andrey Poznyak on 6/2/12.
//  Copyright (c) 2012 bsuir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Coordinates;

@interface HotSpot : NSManagedObject

@property (nonatomic, retain) NSString * bssid;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *encounters;
@end

@interface HotSpot (CoreDataGeneratedAccessors)

- (void)addEncountersObject:(Coordinates *)value;
- (void)removeEncountersObject:(Coordinates *)value;
- (void)addEncounters:(NSSet *)values;
- (void)removeEncounters:(NSSet *)values;
@end
