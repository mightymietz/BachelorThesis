//
//  TLobbyViewController.m
//  TudorGame
//
//  Created by David Joerg on 09.01.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import "TLobbyViewController.h"
#import "TGameViewController.h"
#import "Player.h"
#import "Player.h"
#import "AppSpecificValues.h"
#import "SpinnerView.h"
#import "DataManager.h"
@interface TLobbyViewController ()
@property (nonatomic) int countdown;
@property (nonatomic, retain) DataManager *dataManager;
@property (nonatomic, retain) Player *player;
@end

@implementation TLobbyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
  
    self.dataManager = [DataManager sharedManager];
    self.player = self.dataManager.player;
    self.playerNameLabel.text = self.player.name;

    self.opponentNameLabel.text = @"waiting for player...";

    [self loadGame];
  
}

-(void)viewDidAppear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(gameUpdate)
     name: GAME_UPDATED
     object:nil];
}
-(void)viewDidDisappear:(BOOL)animatedview
{
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


-(void)loadGame
{
    if([self.dataManager.game.gameStatus isEqualToString:GAMESTATUS_WAITING_FOR_PLAYERS])
    {
        
    }
    
    
    
    if([self.dataManager.game.gameStatus isEqualToString:GAMESTATUS_READY_TO_START])
    {
        self.opponentNameLabel.text = self.dataManager.game.opponent.name;
        [self gameReadyToStart:YES];
    }
    
    
    //ist game fertig zum starten (genug spieler im spiel)?
    
    if([self.dataManager.game.gameStatus isEqualToString:GAMESTATUS_RUNNING])
    {
        [SpinnerView loadSpinnerIntoViewController:self
                                          withText:@"starting Game..."
                                     andBtnTouched:@selector(abort)];
        
        [self startCountdown];
        
        
    }
    
}

- (IBAction)backBtnTouched:(UIBarButtonItem *)sender
{
    
    [self dismissViewControllerAnimated:NO completion:nil];
}


-(void)gameUpdate
{

    [self loadGame];
    
    
}

-(void)gameReadyToStart:(BOOL)ready
{
    self.startBtn.enabled = ready;
}

-(void)startGame
{

  
    
    
    dispatch_queue_t myNewQueue = dispatch_queue_create("startingGame", NULL);
    
    // Dispatch work to your queue
    dispatch_async(myNewQueue, ^
                   {
                       
                       // Dispatch work back to the main queue for your UIKit changes
                       dispatch_async(dispatch_get_main_queue(), ^{
                           
                           [self.dataManager startGameViaWebsocket];
                           
                       });
                       
                       
                   });
    
    
}


-(void)abort
{
    [SpinnerView removeSpinnerFromViewController:self];
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if([identifier isEqualToString:SEGUE_GAMEVIEW])
    {
        self.startBtn.enabled = NO;
        [self startGame];
    }
    return NO;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([segue.identifier isEqualToString:SEGUE_GAMEVIEW])
    {
        [SpinnerView removeSpinnerFromViewController:self];

   
    }
    
}

- (void)startCountdown
{
    self.countdown = 5;
    NSTimer *countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self  selector:@selector(advanceTimer:) userInfo:nil repeats:YES];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:countdownTimer forMode:NSDefaultRunLoopMode];
}

- (void)advanceTimer:(NSTimer *)timer
{
    self.countdown--;
    [SpinnerView updateLoadingStatus:self withText:[NSString stringWithFormat:@"game starts in: %i", self.countdown]];
    if (self.countdown == 0)
    {
        // code to stop the timer
        [timer invalidate];
        [self performSegueWithIdentifier:SEGUE_GAMEVIEW sender:self];
    }
}

@end
