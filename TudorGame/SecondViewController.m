//
//  SecondViewController.m
//  TudorGame
//
//  Created by David Joerg on 09.01.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import "SecondViewController.h"
#import "AppSpecificValues.h"
#import "Player.h"
#import "DataManager.h"
#import "SpinnerView.h"
@interface SecondViewController ()
@property(nonatomic, retain) Player *player;
@property(nonatomic, retain) DataManager *dataManager;
@end

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    self.dataManager = [DataManager sharedManager];
    self.player = self.dataManager.player;
}

-(void)viewDidAppear:(BOOL)animated
{
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(gameUpdated:)
     name: GAME_UPDATED
     object:nil];
    
  
    [self updateButtons];
    
}

-(void)viewDidDisappear:(BOOL)animatedview
{
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:DID_RECEIVE_REMOTE_NOTIFICATION
     object:nil];
    
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:GAME_UPDATED
     object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)searchGame
{
    [SpinnerView loadSpinnerIntoViewController:self
                                      withText:@"searching Game..."
                                 andBtnTouched:@selector(abortSearchingForGame)];
    
    
    dispatch_queue_t myNewQueue = dispatch_queue_create("searchingGame", NULL);
    
    // Dispatch work to your queue
    dispatch_async(myNewQueue, ^
                   {
  
                       // Dispatch work back to the main queue for your UIKit changes
                       dispatch_async(dispatch_get_main_queue(), ^{
                           
                           [self.dataManager searchGameViaWebsocket];
                          
                       });
                       
                       
                   });
    
    
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{

    
     if([identifier isEqualToString:SEGUE_QUICKGAME])
     {
         if(self.dataManager.game == nil)
         {
             
             [self searchGame];
         }
         else
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"abort game" message:@"You are already in a running game. Do you want to abort it?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
             alert.tag = 1;
             [alert show];
         }
         
     }
    
    
    return NO;
}

-(void)abortSearchingForGame
{
    [SpinnerView removeSpinnerFromViewController:self];
}

///////////////////////////////////
///////ButtonActions///////////////
//////////////////////////////////
-(void)abortLoading
{
    [SpinnerView removeSpinnerFromViewController:self];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:SEGUE_QUICKGAME])
    {
       
    }
}

-(void)didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // RemoteNotification wurde empfangen. Check ob aktueller viewcontroller sichtbar ist
    //gameData bereit
    if (self.isViewLoaded && self.view.window)
    {
        
      [SpinnerView removeSpinnerFromViewController:self];
      [self performSegueWithIdentifier:SEGUE_QUICKGAME sender:self];
       
    }
}

-(void)gameUpdated:(NSDictionary *)userInfo
{
    
    
    
    [SpinnerView removeSpinnerFromViewController:self];
    [self performSegueWithIdentifier:SEGUE_QUICKGAME sender:self];
}

-(void)updateButtons
{
    bool hasActiveGame = self.dataManager.game != nil;
    
    self.abortGameBtn.enabled = hasActiveGame;
    self.resumeGameBtn.enabled = hasActiveGame;
}



////////////////////////////
///////alertview delegate///
////////////////////////////
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
 
    if(alertView.tag == 1) //Quit running game
    {
        if(buttonIndex == 0)
        {
            [self.dataManager quitRunningGame];
            
            [self updateButtons];
        }
        
    }
}

- (IBAction)abortGameBtnTouched:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"abort game" message:@"You are already in a running game. Do you want to abort it?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
    alert.tag = 1;
    [alert show];
}

- (IBAction)resumGameBtnTouched:(id)sender
{
       [self performSegueWithIdentifier:SEGUE_QUICKGAME sender:self];
}
@end
