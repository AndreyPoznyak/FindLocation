//
//  NetworkInfo.m
//  FindLocation
//
//  Created by Andrey Poznyak on 4/6/12.
//  Copyright (c) 2012 bsuir. All rights reserved.
//

#import "NetworkInfo.h"

@implementation NetworkInfo

@synthesize networkName = _networkName;
@synthesize networkBSSID = _networkBSSID;
@synthesize signalStrength = _signalStrength;
@synthesize isCurrent = _isCurrent;

+ (void)writeToDBifNew:(NetworkInfo *)network
{
    //check if new and put in db if yes
}

+ (NetworkInfo *)newNetwork:(NSString *)name andStrength:(NSString *)strength andBssid:(NSString *)bssid andCurrent:(BOOL)current
{
    //NSLog(@"%@ - %@", name, strength);
    NetworkInfo *net = [[NetworkInfo alloc] init];
    [net setNetworkName:name];
    [net setSignalStrength:[NSString stringWithFormat:@"%@", strength]];
    [net setNetworkBSSID:bssid];
    [net setIsCurrent:current];
    [self writeToDBifNew:net];
    return net;
}

@end
