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
#import "UserData.h"
#import "SpinnerView.h"
#import "Websocket.h"
#import <CoreData/CoreData.h>
@interface TLogInViewController ()
@property(nonatomic, retain)User *user;
@end

@implementation TLogInViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.user = [User sharedManager];

    self.usernameTextfield.text = self.user.username;
    self.passwordTextfield.text = self.user.password;

    self.usernameTextfield.delegate = self;
    self.passwordTextfield.delegate = self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(userStatusChanged:)
     name: USER_STATUS_CHANGED
     object:nil];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:USER_STATUS_CHANGED
     object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)connectUser
{
    [SpinnerView loadSpinnerIntoViewController:self withText:@"logging in..." andBtnTouched:@selector(backBtnTouched:)];
    
    
    dispatch_queue_t myNewQueue = dispatch_queue_create("loggingIn", NULL);
    
    // Dispatch work to your queue
    dispatch_async(myNewQueue, ^
                   {
                       
                       
                       
                       // Dispatch work back to the main queue for your UIKit changes
                       dispatch_async(dispatch_get_main_queue(), ^{
                           
                           [self.user connectUser];
                           /*if([self.user.status isEqualToString:LOGIN_CORRECT])
                            {
                            Websocket *websocket = [Websocket sharedManager];
                            [websocket reconnect];
                            }
                            else if([self.user.status isEqualToString:USERNAME_OR_PASSWORD_WRONG])
                            {
                            
                            }
                            
                            [SpinnerView removeSpinnerFromViewController:self];
                            NSLog(@"User connected");*/
                       });
                       
                       
                   });
    
    
}


- (IBAction)loginBtnTouched:(id)sender
{
    
    NSString *username = self.usernameTextfield.text;
    NSString *password = self.passwordTextfield.text;
  
    [self.user saveUsername:username andPassword:password];
    
    NSLog(@"%@",self.passwordTextfield.text);
    
    [self connectUser];

    
}



- (IBAction)backBtnTouched:(id)sender
{
    

    self.user.abortAllOperations = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    //bewege alles 50.0f nach oben wenn in textfield geschrieben wird
    float moveUp = 50.0f;
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.35];
	[UIView setAnimationBeginsFromCurrentState:YES];
	self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, (self.contentView.frame.origin.y - moveUp), self.contentView.frame.size.width, self.contentView.frame.size.height);
    
    
    
	[UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //bewege alles 50.0f nach unten wenn textfield nicht im focus ist
    float moveDown = 50.0f;
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.35];
	[UIView setAnimationBeginsFromCurrentState:YES];
	self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, (self.contentView.frame.origin.y + moveDown), self.contentView.frame.size.width, self.contentView.frame.size.height);
	[UIView commitAnimations];
    

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self.usernameTextfield resignFirstResponder];
    [self.passwordTextfield resignFirstResponder];
}


////////////////////////////
////////Core Data//////////
///////////////////////////

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)])
    {
        context = [delegate managedObjectContext];
    }
    return context;
}

-(void)userStatusChanged:(NSDictionary *)userInfo
{
    NSString *newStatus = self.user.status;
    UIAlertView *alert;
    if([newStatus isEqualToString:USERNAME_OR_PASSWORD_WRONG])
    {
        alert = [[UIAlertView alloc] initWithTitle:@"connection failed" message:@"username and/or password wrong" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:@"ok", nil];
        [alert setTag:1];
        
    }
    
    if([newStatus isEqualToString:USER_ALREADY_LOGGED_IN])
    {
        alert = [[UIAlertView alloc] initWithTitle:@"error" message:@"user already logged in" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        
    }
    if([newStatus isEqualToString:USER_LOGGED_IN])
    {
        alert = [[UIAlertView alloc] initWithTitle:@"successfull" message:@"you are logged in" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        
        [self dismissViewControllerAnimated:NO completion:nil];
        
    }
    if([newStatus isEqualToString:USER_CONNECTION_FAIL])
    {
        alert = [[UIAlertView alloc] initWithTitle:@"unable to connect to server" message:@"please check your internetconnection" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:@"retry", nil];
        [alert setTag:2];
        
    }
    [SpinnerView removeSpinnerFromViewController:self];
    
    
    [alert show];
}

@end
