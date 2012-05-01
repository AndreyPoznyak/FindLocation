//
//  NetworkDetailViewController.h
//  FindLocation
//
//  Created by Andrey Poznyak on 4/7/12.
//  Copyright (c) 2012 bsuir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkInfo.h"
#import "HotSpot.h"

@interface NetworkDetailViewController : UIViewController

@property (unsafe_unretained, nonatomic) IBOutlet UITextField *nameField;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *bssidFiled;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *signalField;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *strengthLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *fieldTwo;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *fieldThree;

@property (nonatomic, strong) NetworkInfo *currentNetwork;
@property (nonatomic, strong) HotSpot *currentHotSpot;

@end
