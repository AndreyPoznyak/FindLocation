//
//  NetworkInfo.h
//  FindLocation
//
//  Created by Andrey Poznyak on 4/6/12.
//  Copyright (c) 2012 bsuir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkInfo : NSObject

@property (nonatomic, strong) NSString *networkName;
@property (nonatomic) int signalStrength;
@property (nonatomic, strong) NSString *networkBSSID;
@property (nonatomic) BOOL isCurrent;

+ (NetworkInfo *)newNetwork: (NSString *)name andStrength:(int)strength andBssid:(NSString *)bssid andCurrent:(BOOL)current;

@end
