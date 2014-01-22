//
//  TLogInViewController.m
//  TudorGame
//
//  Created by David Joerg on 17.01.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import "TLogInViewController.h"
#import "User.h"
#import "SHACode.h"
@interface TLogInViewController ()

@end

@implementation TLogInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginBtnTouched:(id)sender
{
    User *sharedManager = [User sharedManager];
    NSString *username = self.usernameTextfield.text;
    NSString *password = [SHACode getHash:self.passwordTextfield.text];
    NSLog(@"%@",self.passwordTextfield.text);
    [sharedManager connectUserWith:username andPassword:password completion:^(BOOL finished)
     {
       
             [self dismissViewControllerAnimated:YES completion:nil];
        
     }];
    

    
}

- (IBAction)backBtnTouched:(id)sender
{
    User *sharedManager = [User sharedManager];
    sharedManager.cancelledLogIn = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
