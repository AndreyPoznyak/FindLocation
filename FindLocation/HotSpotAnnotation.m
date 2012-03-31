//
//  HotSpotAnnotation.m
//  FindLocation
//
//  Created by Andrey Poznyak on 3/31/12.
//  Copyright (c) 2012 bsuir. All rights reserved.
//

#import "HotSpotAnnotation.h"

@implementation HotSpotAnnotation

- (NSString *)title
{
    return @"Titile of HotSpot";
}

- (NSString *)subtitle
{
    return @"Subtitile of HotSpot";
}

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.longitude = 0;
    coordinate.latitude = 0;
    return coordinate;
}

@end
