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
#import "CardGenerator.h"
#import "TDetailCardViewController.h"


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
    self.pointsLabel.text = [NSString stringWithFormat:@"%d", self.dataManager.player.points];
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
    else if(alertView.tag == 3) //Buy new card
    {
        if(buttonIndex == 1)
        {
            [[NSNotificationCenter defaultCenter]
             addObserver:self
             selector:@selector(productReceived:)
             name: PRODUCT_RECEIVED
             object:nil];
            DataManager *dataManager = [DataManager sharedManager];
            [dataManager getNewProductViaWebsocket];
        }
        
    }
}

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOS7AlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    NSLog(@"Button at position %d is clicked on alertView %d.", buttonIndex, [alertView tag]);
    [alertView close];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:PRODUCT_RECEIVED
     object:nil];
}


-(void)productReceived:(NSDictionary *)userInfo
{
     DataManager *dataManager = [DataManager sharedManager];
     Product *receivedProduct = dataManager.receivedProduct;
    
    //Add received products to players products
    [dataManager.player.products addObject:receivedProduct];
    dataManager.player.points -= 1000;
    self.pointsLabel.text = [NSString stringWithFormat:@"%d", self.dataManager.player.points];
    TDetailCardViewController *card = [CardGenerator generateDetailCard:receivedProduct];
    
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    float resizeFactor = 0.4f;
    UIImageView *cardImageView =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, alertView.frame.size.width * resizeFactor, alertView.frame.size.height * resizeFactor)];
    cardImageView.image = [card snapshotView];
    [alertView setContainerView:cardImageView];
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"add to deck", nil]];
    [alertView setDelegate:self];
    
    [alertView show];
    
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

- (IBAction)buyNewCardBtnTouched:(id)sender
{
    DataManager *manager = [DataManager sharedManager];
    int points = manager.player.points;
    
    if(points - 1000 >= 0)
    {
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"Buy new Card for your deck" message:@"Do you want to spend 1000 points for a new card?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        alertview.tag = 3;
        [alertview show];
    }
    else
    {
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"Not enough points" message:@"You don`t have enough points to buy a new card! \n scan new products to gain more points" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        alertview.tag = 4;
        [alertview show];
    }
}

@end
