//
//  SecondViewController.h
//  TudorGame
//
//  Created by David Joerg on 09.01.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMenuButton.h"
@interface SecondViewController : UIViewController <UIAlertViewDelegate>
- (IBAction)abortGameBtnTouched:(id)sender;
- (IBAction)resumGameBtnTouched:(id)sender;
@property (weak, nonatomic) IBOutlet TMenuButton *resumeGameBtn;
@property (weak, nonatomic) IBOutlet TMenuButton *abortGameBtn;

@end
