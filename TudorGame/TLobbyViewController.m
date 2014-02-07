//
//  TLobbyViewController.m
//  TudorGame
//
//  Created by David Joerg on 09.01.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import "TLobbyViewController.h"
#import "TGameViewController.h"
#import "User.h"
#import "TeamMember.h"
#import "AppSpecificValues.h"

@interface TLobbyViewController ()
@property (nonatomic, retain) NSArray *dataArrayTeam1;
@property (nonatomic, retain) NSArray *dataArrayTeam2;
@property (nonatomic, retain) Game *currentGame;
@end

@implementation TLobbyViewController

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
    
    [self loadGame];
    //[self loadDataFromUser];

  
}

-(void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(didReceiveRemoteNotification:)
     name: DID_RECEIVE_REMOTE_NOTIFICATION
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(gameUpdated:)
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return self.dataArrayTeam1.count;
    
    return self.dataArrayTeam2.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    TeamMember *currentMember;
    
    switch (indexPath.section)
    {
        case 0:
              currentMember = [self.dataArrayTeam1 objectAtIndex:indexPath.row];
            break;
            
        default:
              currentMember = [self.dataArrayTeam2 objectAtIndex:indexPath.row];

            break;
    }
    
    
    cell.textLabel.text = currentMember.name;
    return cell;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = @"Team 1";
            break;
        case 1:
            sectionName = @"Team 2";
            break;
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}

-(void)loadGame
{
    User *user = [User sharedManager];
    NSArray *team1 = [user.currentGame.team1 allObjects];
    NSArray *team2 = [user.currentGame.team2 allObjects];
    self.currentGame = user.currentGame;
    self.dataArrayTeam1 = team1;
    self.dataArrayTeam2 = team2;
    
     //ist game fertig zum starten (genug spieler im spiel)?
    //dann aktivere start button
    BOOL readyToStart = [self.currentGame.gameState isEqualToString:@"READYTOSTART"];
   [self gameReadyToStart:readyToStart];
    
    
}

- (IBAction)backBtnTouched:(UIBarButtonItem *)sender
{
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // RemoteNotification wurde empfangen. Check ob aktueller viewcontroller sichtbar ist
    // da gamedata geupdated wurde
    if (self.isViewLoaded && self.view.window)
    {
        
       
        //[self loadDataFromUser];
        [self.tableView reloadData];

        
     
        
    }
}

-(void)gameUpdated:(NSDictionary *)userInfo
{
    
    [self loadGame];
    [self.tableView reloadData];

   
}

-(void)gameReadyToStart:(BOOL)ready
{
    self.startBtn.enabled = ready;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([segue.identifier isEqualToString:SEGUE_GAMEVIEW])
    {
        User *user = [User sharedManager];
        TGameViewController *vc = (TGameViewController*) segue.destinationViewController;
        vc.user = user;
        vc.currentGame = self.currentGame;
    }
    
}

@end
