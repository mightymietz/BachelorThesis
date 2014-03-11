//
//  FirstViewController.m
//  TudorGame
//
//  Created by David Joerg on 09.01.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import "FirstViewController.h"
#import "Websocket.h"
#import "DataManager.h"
#import "TLogInViewController.h"
#import "AppSpecificValues.h"
#import "SpinnerView.h"

@interface FirstViewController ()
@property(nonatomic,retain)DataManager *dataManager;
@end

@implementation FirstViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    

  
    
    
   
   
}

-(void)viewDidAppear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(userStatusChanged:)
     name: USER_STATUS_CHANGED
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(productsUpdated:)
     name: PRODUCTS_UPDATED
     object:nil];
     
    self.dataManager = [DataManager sharedManager];
    if(![self.dataManager.player.status isEqualToString:USER_LOGGED_IN])
    {
        //Hat USer bereits einen Name und Passwort eingegeben, versuche mit server zu connecten
        //ansonsten pushe loginView
        if(self.dataManager.hasLoginNameAndPassword)
        {
            [self connectUser];
        }
        else
        {
            [self pushLoginViewController];
            
        }
    }

}

-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:USER_STATUS_CHANGED
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:PRODUCTS_UPDATED
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
                                
                                       [self.dataManager connectUser];
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

-(void)loadProducts
{
    
    [SpinnerView updateLoadingStatus:self withText:@"loading products..."];
    
    if(self.dataManager.player.products == nil)
    {
        dispatch_queue_t myNewQueue = dispatch_queue_create("loadingCards", NULL);
        
        // Dispatch work to your queue
        dispatch_async(myNewQueue, ^
                       {
                           
                           
                           
                           // Dispatch work back to the main queue for your UIKit changes
                           dispatch_async(dispatch_get_main_queue(), ^{
                               
                               [self.dataManager getProductsViaWebsocket];
                               
                               
                           });
                           
                           
                       });
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"successful" message:@"you are logged in" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
        [SpinnerView removeSpinnerFromViewController:self];
    }
    
    
}


-(void)pushLoginViewController
{
    TLogInViewController *logInViewController =
    [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil]
     instantiateViewControllerWithIdentifier:LOGINVIEWCONTROLLER_ID];
    
    [self presentViewController:logInViewController animated:YES completion:nil ];

}

//////////////////////////////////
////// UIAlertView delegate//////
/////////////////////////////////

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1)
    {
        if(buttonIndex == 1)    //ok or retry button
        {

              [self pushLoginViewController];
        }
    }
    else if(alertView.tag == 2)
    {
        if(buttonIndex == 1) //retry button
        {
            [self connectUser];
        }
    }
}



-(void)userStatusChanged:(NSDictionary *)userInfo
{
    NSString *newStatus = self.dataManager.player.status;
    UIAlertView *alert;
    if([newStatus isEqualToString:USERNAME_OR_PASSWORD_WRONG])
    {
        alert = [[UIAlertView alloc] initWithTitle:@"connection failed" message:@"username and/or password wrong" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:@"retype", nil];
        [alert setTag:1];
        [SpinnerView removeSpinnerFromViewController:self];


    }
    
    if([newStatus isEqualToString:USER_ALREADY_LOGGED_IN])
    {
        alert = [[UIAlertView alloc] initWithTitle:@"error" message:@"user already logged in" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [SpinnerView removeSpinnerFromViewController:self];


    }
    if([newStatus isEqualToString:USER_LOGGED_IN])
    {
      
        /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"successful" message:@"you are logged in" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
        [SpinnerView removeSpinnerFromViewController:self];*/

        [self loadProducts];
        
    }
    if([newStatus isEqualToString:USER_CONNECTION_FAIL])
    {
        alert = [[UIAlertView alloc] initWithTitle:@"unable to connect to server" message:@"please check your internetconnection" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:@"retry", nil];
        [alert setTag:2];
        [SpinnerView removeSpinnerFromViewController:self];

        
    }
   
    
    [alert show];
}

-(void)productsUpdated:(NSDictionary *)updatedProducts
{
       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"successful" message:@"you are logged in" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alert show];
     [SpinnerView removeSpinnerFromViewController:self];
}

@end
