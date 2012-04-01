//
//  HotSpotAnnotation.m
//  FindLocation
//
//  Created by Andrey Poznyak on 3/31/12.
//  Copyright (c) 2012 bsuir. All rights reserved.
//

#import "HotSpotAnnotation.h"

@implementation HotSpotAnnotation

@synthesize customLatitude = _customLatitude, customLongitude = _customLongitude;

- (void)setCustomLatitude:(double)customLatitude
{
    _customLatitude = customLatitude;
}

- (void)setCustomLongitude:(double)customLongitude
{
    _customLongitude = customLongitude;
}

- (NSString *)title
{
    return @"Title of HotSpot";
}

- (NSString *)subtitle
{
    return @"Subtitile of HotSpot";
}

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.longitude = self.customLongitude;//longitude;
    coordinate.latitude = self.customLatitude;//latitude;
    return coordinate;
}

+ (HotSpotAnnotation *)annotationForHotSpot:(NSDictionary *)hotSpot
{
    HotSpotAnnotation *annotation = [[HotSpotAnnotation alloc] init];
    return annotation;
}

+ (HotSpotAnnotation *)getAnnotationWithCoordinates:(double)longitude withLatitude:(double)latitude
{
    HotSpotAnnotation *annotation = [[HotSpotAnnotation alloc] init];
//    annotation.coordinate.longitude = longitude;
//    annotation.coordinate.latitude = latitude;
    return annotation;
}

@end
