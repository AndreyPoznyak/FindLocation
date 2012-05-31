//
//  StuffViewController.h
//  FindLocation
//
//  Created by Andrey Poznyak on 4/14/12.
//  Copyright (c) 2012 bsuir. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!Class for ViewController, this is to display text, e.g. error or stats*/
@interface StuffViewController : UIViewController

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *mainLabel;
@property (nonatomic) BOOL isMessageAboutError;

@end
