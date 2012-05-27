//
//  StuffViewController.h
//  FindLocation
//
//  Created by Andrey Poznyak on 4/14/12.
//  Copyright (c) 2012 bsuir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StuffViewController : UIViewController

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *mainLabel;
@property (nonatomic) BOOL isMessageAboutError;

@end
