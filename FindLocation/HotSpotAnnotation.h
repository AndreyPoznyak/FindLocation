//
//  HotSpotAnnotation.h
//  FindLocation
//
//  Created by Andrey Poznyak on 3/31/12.
//  Copyright (c) 2012 bsuir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapKit/MapKit.h"
#import "HotSpot.h"

@interface HotSpotAnnotation : NSObject <MKAnnotation>

//@property (nonatomic) double customLatitude;
//@property (nonatomic) double customLongitude;
@property (nonatomic, strong) HotSpot *hotSpot;
+ (HotSpotAnnotation *)annotationForHotSpot:(HotSpot*)hotSpot;

@end
