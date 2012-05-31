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

//!Class HotSpotAnnotation
/*!This class provides mechanism to put annotation on map*/
@interface HotSpotAnnotation : NSObject <MKAnnotation>

//@property (nonatomic) double customLatitude;
//@property (nonatomic) double customLongitude;

//!property of HotSpot
/*!This property contains object of current hotspot to show it on map*/
@property (nonatomic, strong) HotSpot *hotSpot;

//!method annotationForHotSpot
/*!returns annotation object with relevant info*/
+ (HotSpotAnnotation *)annotationForHotSpot:(HotSpot*)hotSpot;

@end
