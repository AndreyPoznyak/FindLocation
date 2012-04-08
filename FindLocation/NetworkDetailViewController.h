//
//  NetworkDetailViewController.h
//  FindLocation
//
//  Created by Andrey Poznyak on 4/7/12.
//  Copyright (c) 2012 bsuir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkInfo.h"

@interface NetworkDetailViewController : UIViewController
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *nameField;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *bssidFiled;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *signalField;

@property (nonatomic, strong) NetworkInfo *currentNetwork;

@end
