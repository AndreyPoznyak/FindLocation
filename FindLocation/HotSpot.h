//
//  HotSpot.h
//  FindLocation
//
//  Created by Andrey Poznyak on 4/23/12.
//  Copyright (c) 2012 bsuir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

//!Class HotSpot
/*!This class was automaticaly generated from DataBase model and corresponds to table*/
@interface HotSpot : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * bssid;
@property (nonatomic, retain) NSNumber * strength1;
@property (nonatomic, retain) NSNumber * latitude1;
@property (nonatomic, retain) NSNumber * latitude2;
@property (nonatomic, retain) NSNumber * latitude3;
@property (nonatomic, retain) NSNumber * longitude1;
@property (nonatomic, retain) NSNumber * longitude2;
@property (nonatomic, retain) NSNumber * longitude3;
@property (nonatomic, retain) NSNumber * strength2;
@property (nonatomic, retain) NSNumber * strength3;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;

@end
