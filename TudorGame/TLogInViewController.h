//
//  TLogInViewController.h
//  TudorGame
//
//  Created by David Joerg on 17.01.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLogInViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
- (IBAction)loginBtnTouched:(id)sender;


- (IBAction)backBtnTouched:(id)sender;

@end
