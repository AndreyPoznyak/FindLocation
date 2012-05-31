//
//  NetworkInfo.h
//  FindLocation
//
//  Created by Andrey Poznyak on 4/6/12.
//  Copyright (c) 2012 bsuir. All rights reserved.
//

#import <Foundation/Foundation.h>

//!Class NetworkInfo
/*!Class to store info about currently available networks*/
@interface NetworkInfo : NSObject

@property (nonatomic, strong) NSString *networkName;
@property (nonatomic, strong) NSString *signalStrength;
@property (nonatomic, strong) NSString *networkBSSID;
/*!This indicates whether device is attached to network or not*/
@property (nonatomic) BOOL isCurrent;

/*!Method to create new object for stroring info about network*/
+ (NetworkInfo *)newNetwork: (NSString *)name andStrength:(NSString *)strength andBssid:(NSString *)bssid andCurrent:(BOOL)current;

@end
