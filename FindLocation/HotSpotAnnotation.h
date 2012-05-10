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

+ (HotSpotAnnotation *)getAnnotationWithCoordinates:(double)longitude withLatitude:(double)latitude;
@property (nonatomic) double customLatitude;
@property (nonatomic) double customLongitude;
+ (HotSpotAnnotation *)annotationForHotSpot:(HotSpot*)hotSpot;

@end
