//
//  TGameViewController.m
//  TudorGame
//
//  Created by David Joerg on 09.01.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import "TGameViewController.h"
#import "AppSpecificValues.h"
#import "Player.h"
#import "SpinnerView.h"
#import "CardGenerator.h"
#import "TCardCollectionViewCell.h"
#import "AppDelegate.h"
#import "TGameManager.h"
#import "DataManager.h"
dispatch_semaphore_t _animationSemaphore;

@interface TGameViewController ()
@property (nonatomic, retain) DataManager *dataManger;
@property (nonatomic, retain) TGameManager *gameManager;
@property (nonatomic, retain) UILabel *attackLabel;
@property (nonatomic, retain) UIImageView *cardDetailView;
@property (nonatomic, retain) TCardField *touchedCard;
@property (nonatomic, retain) TCardField *cardDublicate;
@property (nonatomic, retain) Game *gameData;
@property (nonatomic, retain) NSMutableArray *gameDataArray;
@property (atomic) BOOL isInOperation;

@end

@implementation TGameViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
   


    self.gameDataArray = [[NSMutableArray alloc] init];

    
    [self.singleTapRecognizer requireGestureRecognizerToFail:self.doubleTapRecognizer];


    
    self.attackLabel = [[UILabel alloc] init];
    [self.view addSubview:self.attackLabel];
    self.attackLabel.textColor = [UIColor redColor];
    self.attackLabel.textAlignment = NSTextAlignmentCenter;
    self.attackLabel.hidden = YES;
    
    self.playerField1.position = 1;
    self.playerField2.position = 2;
    self.playerField3.position = 3;
    self.playerField4.position = 4;
    self.playerField5.position = 5;
    self.playerField6.position = 6;
    self.playerHand1.position = 7;
    self.playerHand2.position = 8;
    self.playerHand3.position = 9;
    
    self.opponentField1.position = 1;
    self.opponentField2.position = 2;
    self.opponentField3.position = 3;
    self.opponentField4.position = 4;
    self.opponentField5.position = 5;
    self.opponentField6.position = 6;
    self.opponentHand1.position = 7;
    self.opponentHand2.position = 8;
    self.opponentHand3.position = 9;
  
    
    self.dataManger = [DataManager sharedManager];
    self.gameManager = [[TGameManager alloc] initGameManagerWithViewController:self];
    [self.gameManager setUp];

    self.playerNameLabel.text = self.dataManger.player.name;
   
    self.gameData = self.dataManger.game;

    self.playerDeckCounterLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.dataManger.player.cardsInGame.count];
    self.opponentDeckCounterLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[self.gameData.opponent.cardsInGame allObjects].count];
    self.playerLifepointsLabel.text = [NSString stringWithFormat:@"%@",  self.dataManger.player.lifePoints];
    self.opponentLifepointsLabel.text = [NSString stringWithFormat:@"%@", self.gameData.opponent.lifePoints];
    self.opponentNameLabel.text = self.gameData.opponent.name;
    //[self fillPlayersHand];
    [self activateUserActions:YES];
    [self.dataManger sendReadyViaSocket];
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(newGameDataReceived:)
     name: GAME_UPDATED
     object:nil];
}
-(void)viewDidDisappear:(BOOL)animatedview
{
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtnTouched:(UIBarButtonItem *)sender
{
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"abort game" message:@"You are in a running game. Do you really want to abort it?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
    alert.tag = 1;
    [alert show];
    
}

-(void)nextAction:(Game*)gameData withCompletition:(void (^) (BOOL success))completion
{

    
       // Game *gameData = [self.gameDataArray lastObject];
    
        BOOL isPlayersTurn = ![gameData.opponent.isInTurn boolValue];
        //self.opponentLifepointsLabel.text = [NSString stringWithFormat:@"%@", self.gameData.opponent.lifePoints];
        self.opponentDeckCounterLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[self.gameData.opponent.cardsInGame allObjects].count];
        // self.opponentLifepointsLabel.text = [NSString stringWithFormat:@"%@", self.gameData.opponent.lifePoints];

    
    
    
    
        //Nächste Karte wurde gezogen
        if([gameData.actionType isEqualToString:NEXT_CARD])
        {
            
            
            if(!self.opponentHand1.isTaken)
            {
                
                [self.opponentHand1 storeCardWithCardController:gameData.playedCard];
                [self.opponentHand1 showCardBack:YES];
            }
            else if(!self.opponentHand2.isTaken)
            {
               
                [self.opponentHand2 storeCardWithCardController:gameData.playedCard];
                 [self.opponentHand2 showCardBack:YES];
                
            }
            else if(!self.opponentHand3.isTaken)
            {
               
                [self.opponentHand3 storeCardWithCardController:gameData.playedCard];
                 [self.opponentHand3 showCardBack:YES];
                
            }
            
          
            completion(YES);

            
        }
        
        //Karte wurde bewegt
        if([gameData.actionType isEqualToString:MOVE_CARD])
        {
 
            int oldPos = [gameData.playedCard.product.oldPosition intValue];
            
            int newPos = [gameData.playedCard.product.position intValue];
            TCardField *movedCard;
            
            //Von welcher Position wird Karte verschoben?
            switch (oldPos)
            {
                case 1:
                    movedCard = self.opponentField1;
                    break;
                case 2:
                    movedCard = self.opponentField2;
                    break;
                case 3:
                    movedCard = self.opponentField3;
                    break;
                case 4:
                    movedCard = self.opponentField4;
                    break;
                case 5:
                    movedCard = self.opponentField5;
                    break;
                case 6:
                    movedCard = self.opponentField6;
                    break;
                case 7:
                    movedCard = self.opponentHand1;
                    break;
                case 8:
                    movedCard = self.opponentHand2;
                    break;
                default:
                    movedCard = self.opponentHand3;
                    break;
            }
            
            movedCard.product = gameData.playedCard.product;
            
       
            //Auf welche Position wird Karte verschoben
            switch (newPos)
            {
                case 1:
                {
                    [self moveCard:movedCard toCardField:self.opponentField1];
                    [self.opponentField1 showEmptyField:YES];
                }
                    break;
                case 2:
                {
                    [self moveCard:movedCard toCardField:self.opponentField2];
                    [self.opponentField2 showEmptyField:YES];
                }
                    break;
                
                case 3:
                {
                    [self moveCard:movedCard toCardField:self.opponentField3];
                    [self.opponentField3 showEmptyField:YES];
                }
                    break;
                
                case 4:
                {
                    [self moveCard:movedCard toCardField:self.opponentField4];
                    [self.opponentField4 showEmptyField:YES];
                }
                    break;
                
                case 5:
                {
                    [self moveCard:movedCard toCardField:self.opponentField5];
                    [self.opponentField5 showEmptyField:YES];
                }
                    break;
                
                default:
                {
                    [self moveCard:movedCard toCardField:self.opponentField6];
                    [self.opponentField6 showEmptyField:YES];
                }
                    break;
            }
            
            [self.opponentField1 showEmptyField:YES];
            [self.opponentField2 showEmptyField:YES];
            [self.opponentField3 showEmptyField:YES];
            [self.opponentField4 showEmptyField:YES];
            [self.opponentField5 showEmptyField:YES];
            [self.opponentField6 showEmptyField:YES];
            
            
           completion(YES);

            
        }
        
        //Karte wurde gedreht
        if([gameData.actionType isEqualToString:TURN_CARD])
        {
        
            int pos = [gameData.playedCard.product.position intValue];
            
            TCardField *turnedCard;
            
            //Von welcher Position wird Karte verschoben?
            switch (pos)
            {
                case 1:
                    turnedCard = self.opponentField1;
                    break;
                case 2:
                    turnedCard = self.opponentField2;
                    break;
                case 3:
                    turnedCard = self.opponentField3;
                    break;
                case 4:
                    turnedCard = self.opponentField4;
                    break;
                case 5:
                    turnedCard = self.opponentField5;
                    break;
                case 6:
                    turnedCard = self.opponentField6;
                    break;
                case 7:
                    turnedCard = self.opponentHand1;
                    break;
                case 8:
                    turnedCard = self.opponentHand2;
                    break;
                default:
                    turnedCard = self.opponentHand3;
                    break;
            }
            
            turnedCard.product = gameData.playedCard.product;
            
            [self turnCard:turnedCard];
            completion(YES);
            
        
        }
        
       /* //Spellkarte wurde gespielt
        if([gameData.actionType isEqualToString:SPELL_CARD])
        {
          
            
            int pos = [gameData.playedCard.product.position intValue];
            
            TCardField *spellCard;
            
            //Von welcher Position wird Karte verschoben?
            switch (pos)
            {
                    
                case 4:
                    spellCard = self.opponentField4;
                    break;
                case 5:
                    spellCard = self.opponentField5;
                    break;
                case 6:
                    spellCard = self.opponentField6;
                    break;
                    
            }
            
            spellCard.product = gameData.playedCard.product;

            [self opponentSpellCard:spellCard wthCompletition:^(BOOL finished)
             {
                 completion(YES);
                 
             }];
         
       
            
        }*/
        
        //Karte wurde angegriffen
        if([gameData.actionType isEqualToString:ATTACK_CARD])
        {
            if(self.opponentField1.isTaken)
                [self.opponentField1 showEmptyField:NO];
             if(self.opponentField2.isTaken)
                 [self.opponentField2 showEmptyField:NO];
             if(self.opponentField3.isTaken)
                 [self.opponentField3 showEmptyField:NO];
             if(self.opponentField4.isTaken)
                 [self.opponentField4 showEmptyField:NO];
             if(self.opponentField5.isTaken)
                 [self.opponentField5 showEmptyField:NO];
             if(self.opponentField6.isTaken)
                 [self.opponentField6 showEmptyField:NO];
            
            [self opponentAttackCards];
            completion(YES);
            
        }
        
        
        //erste Runde fülle Deck und aktivere Controls
        if([gameData.gameState isEqualToString:GAMESTATE_FIRST_ROUND] && [gameData.actionType isEqualToString:@""])
        {
   
            [self fillPlayersHand];
            [self activateUserActions:YES];
            completion(YES);
           

            
        }
        
        //Erste Runde vorbei. Wenn am Zug, dann attackiere Karten
        if([gameData.gameState isEqualToString:GAMESTATE_PHASE_ONE]  && [gameData.actionType isEqualToString:@""])
        {
 
            if(isPlayersTurn)
            {
                
                [self attackCards];
            }
            else
            {
                [self activateUserActions:NO];
                [self.dataManger sendReadyViaSocket];
                completion(YES);
            }

 
            
       
            
        }
        
        
        //Normale Runde. Wenn  Spieler am Zug ziehe KArten und aktiviere Controls. Ansonsten sende Ready an Server
        if([gameData.gameState isEqualToString:GAMESTATE_PHASE_TWO]  && [gameData.actionType isEqualToString:@""])
        {
           
            if(isPlayersTurn)
            {
                [self fillPlayersHand];
                [self activateUserActions:YES];
            }
            else
            {
                [self activateUserActions:NO];
                [self.dataManger sendReadyViaSocket];
                completion(YES);
            }
          
      
        }
        
        if([gameData.gameState isEqualToString:GAMESTATE_FINISHED])
        {
            //Player wins
            if([self.gameData.opponent.lifePoints intValue] <= 0)
            {
                [[NSNotificationCenter defaultCenter]
                 removeObserver:self];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You win" message:@"congratulations!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"THANK YOU", nil];
                alert.tag = 1;
                [alert show];
                completion(YES);
                return;
  
            }
            //Opponent wins
            else if([self.dataManger.player.lifePoints intValue] <= 0)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You lose" message:@"don`t be disappointed ;( " delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                alert.tag = 1;
                [alert show];
                completion(YES);
                return;
      
            }
            
            
        }
    
    
    
}

-(void)newGameDataReceived:(NSDictionary *)userInfo
{
    
    [self.gameManager updateGame:self.dataManger.game];

    
    //Opponent hat das Spiel abgebrochen
    if([self.dataManger.game.gameStatus isEqualToString:GAMESTATUS_WAITING_FOR_PLAYERS])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"opponent connection lost" message:@"You win" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 2;
        [alert show];
    }
    
    
}


-(void)updateGame:(Game*)gameData
{

 
   
        self.gameData = gameData;
    
    
   

    

                      [self doOperation:gameData];

  
   
  

    
   


    

    
}

-(void)doOperation:(Game*)gameData
{
  

        [self nextAction:gameData withCompletition:^(BOOL finished)
         {
             self.isInOperation = NO;
 
             NSLog(@"finished");
             
         }];
 
}

////////////////////////////////
/////PLAYER AND OPPONENT ACTIONS////////////////
///////////////////////////////
#pragma mark PLAYER_AND_OPPONENT_ACTIONS

-(void)moveCard:(TCardField*)cardField toCardField:(TCardField*)targetCardField
{
    
    if(targetCardField.isTaken)
    {
        TCardField *tempCard = [[TCardField alloc] initWithFrame:targetCardField.frame];
        tempCard.position = targetCardField.position;
        [tempCard storeCardWithCardController:targetCardField.ov];
        [targetCardField storeCardWithCardController:cardField.ov];
        
        [cardField storeCardWithCardController:tempCard.ov];
    }
    
    else
    {
        [targetCardField storeCardWithCardController:cardField.ov];
        [cardField releaseCard];
        
    }
}
-(void)buffOpponentsCard:(TCardField*)buffedCard withSpellCard:(TCardField*)spellCard andCompletition:(void (^)(BOOL finished))completion
{
    if(spellCard.isTaken && buffedCard.isTaken)
    {
        if([spellCard.spellType isEqualToString:SPELLTYPE_INCREMENT_ATK])
        {
            [self animatePlayerSpellWithCard:spellCard toCard:buffedCard andCompletition:^(BOOL finished)
             {
                 int spellValue = buffedCard.atk / 100 * spellCard.spellValue;
                 [buffedCard incrementATK:spellValue];
                 
                 [self animateCard:spellCard toGrave:self.opponentGrave andCompletition:^(BOOL finished)
                  {
                      
                      //Karte wird zerstört sobald sie gewirkt hat
                      [spellCard releaseCard];
                      completion(YES);
                  }];
                 
             }];
            
        }
        else if([spellCard.spellType isEqualToString:SPELLTYPE_INCREMENT_HP])
        {
            [self animatePlayerSpellWithCard:spellCard toCard:buffedCard andCompletition:^(BOOL finished)
             {
                 int spellValue = buffedCard.hp / 100 * spellCard.spellValue;
                 [buffedCard incrementHP:spellValue];
                 
                 [self animateCard:spellCard toGrave:self.opponentGrave andCompletition:^(BOOL finished)
                  {
                      
                      //Karte wird zerstört sobald sie gewirkt hat
                      [spellCard releaseCard];
                      completion(YES);
                  }];
                 
             }];
            
        }
        else if([spellCard.spellType isEqualToString:SPELLTYPE_INCREMENT_DEF])
        {
            [self animatePlayerSpellWithCard:spellCard toCard:buffedCard andCompletition:^(BOOL finished)
             {
                 int spellValue = buffedCard.def / 100 * spellCard.spellValue;
                 [buffedCard incrementDEF:spellValue];
                 
                 [self animateCard:spellCard toGrave:self.opponentGrave andCompletition:^(BOOL finished)
                  {
                      
                      //Karte wird zerstört sobald sie gewirkt hat
                      [spellCard releaseCard];
                      completion(YES);
                  }];
                 
             }];
            
        }
        //Debuffcard
        else
        {
            completion(YES);
        }
        
    }
    else
    {
        completion(YES);
    }

}


-(void)debuffOpponentsCard:(TCardField*)debuffedCard withSpellCard:(TCardField*)spellCard andCompletition:(void (^)(BOOL finished))completion
{
    if(debuffedCard.isTaken && spellCard.isTaken)
    {
        if([spellCard.spellType isEqualToString:SPELLTYPE_DECREMENT_ATK])
        {
            [self animatePlayerSpellWithCard:spellCard toCard:debuffedCard andCompletition:^(BOOL finished)
             {
                 int spellValue = debuffedCard.atk / 100 * abs(spellCard.spellValue);
                 [debuffedCard decrementATK:spellValue];
                 
                 
                 [self animateCard:spellCard toGrave:self.opponentGrave andCompletition:^(BOOL finished)
                  {
                      
                      [spellCard releaseCard];
                      completion(YES);
                      
                  }];
                 
                 
             }];
            
        }
        else if([spellCard.spellType isEqualToString:SPELLTYPE_DECREMENT_HP])
        {
            [self animatePlayerSpellWithCard:spellCard toCard:debuffedCard andCompletition:^(BOOL finished)
             {
                 int spellValue = debuffedCard.hp / 100 * abs(spellCard.spellValue);
                 [debuffedCard decrementHP:spellValue];
                 
                 
                 [self animateCard:spellCard toGrave:self.opponentGrave andCompletition:^(BOOL finished)
                  {
                      
                      [spellCard releaseCard];
                      completion(YES);
                      
                  }];
                 
                 
             }];
            
        }
        else if([spellCard.spellType isEqualToString:SPELLTYPE_DECREMENT_DEF])
        {
            [self animatePlayerSpellWithCard:spellCard toCard:debuffedCard andCompletition:^(BOOL finished)
             {
                 int spellValue = debuffedCard.def / 100 * abs(spellCard.spellValue);
                 [debuffedCard decrementHP:spellValue];
                 
                 
                 [self animateCard:spellCard toGrave:self.opponentGrave andCompletition:^(BOOL finished)
                  {
                      
                      [spellCard releaseCard];
                      completion(YES);
                      
                  }];
                 
                 
             }];
            
        }
        
    }
    else
    {
        completion(YES);
    }
}
-(void)buffPlayersCard:(TCardField*)buffedCard withSpellCard:(TCardField*)spellCard andCompletition:(void (^)(BOOL finished))completion
{
    if(spellCard.isTaken && buffedCard.isTaken)
    {
        if([spellCard.spellType isEqualToString:SPELLTYPE_INCREMENT_ATK])
        {
            [self animatePlayerSpellWithCard:spellCard toCard:buffedCard andCompletition:^(BOOL finished)
             {
                 int spellValue = buffedCard.atk / 100 * spellCard.spellValue;
                 [buffedCard incrementATK:spellValue];
                 
                 [self animateCard:spellCard toGrave:self.playerGrave andCompletition:^(BOOL finished)
                  {

                      //Karte wird zerstört sobald sie gewirkt hat
                      [spellCard releaseCard];
                      completion(YES);
                  }];
                 
             }];
          
        }
        else if([spellCard.spellType isEqualToString:SPELLTYPE_INCREMENT_HP])
        {
            [self animatePlayerSpellWithCard:spellCard toCard:buffedCard andCompletition:^(BOOL finished)
             {
                 int spellValue = buffedCard.hp / 100 * spellCard.spellValue;
                 [buffedCard incrementHP:spellValue];
                 
                 [self animateCard:spellCard toGrave:self.playerGrave andCompletition:^(BOOL finished)
                  {
                      
                      //Karte wird zerstört sobald sie gewirkt hat
                      [spellCard releaseCard];
                      completion(YES);
                  }];
                 
             }];
            
        }
        else if([spellCard.spellType isEqualToString:SPELLTYPE_INCREMENT_DEF])
        {
            [self animatePlayerSpellWithCard:spellCard toCard:buffedCard andCompletition:^(BOOL finished)
             {
                 int spellValue = buffedCard.def / 100 * spellCard.spellValue;
                 [buffedCard incrementDEF:spellValue];
                 
                 [self animateCard:spellCard toGrave:self.playerGrave andCompletition:^(BOOL finished)
                  {
                      
                      //Karte wird zerstört sobald sie gewirkt hat
                      [spellCard releaseCard];
                      completion(YES);
                  }];
                 
             }];
            
        }
        //Debuffcard
        else
        {
            completion(YES);
        }

    }
    else
    {
        completion(YES);
    }
}

-(void)debuffPlayersCard:(TCardField*)debuffedCard withSpellCard:(TCardField*)spellCard andCompletition:(void (^)(BOOL finished))completion
{
    if(debuffedCard.isTaken && spellCard.isTaken)
    {
        if([spellCard.spellType isEqualToString:SPELLTYPE_DECREMENT_ATK])
        {
            [self animatePlayerSpellWithCard:spellCard toCard:debuffedCard andCompletition:^(BOOL finished)
             {
                 int spellValue = debuffedCard.atk / 100 * abs(spellCard.spellValue);
                 [debuffedCard decrementATK:spellValue];
                 
                 
                 [self animateCard:spellCard toGrave:self.playerGrave andCompletition:^(BOOL finished)
                  {
          
                      [spellCard releaseCard];
                       completion(YES);
                      
                  }];
                 
                 
             }];

        }
        else if([spellCard.spellType isEqualToString:SPELLTYPE_DECREMENT_HP])
        {
            [self animatePlayerSpellWithCard:spellCard toCard:debuffedCard andCompletition:^(BOOL finished)
             {
                 int spellValue = debuffedCard.hp / 100 * abs(spellCard.spellValue);
                 [debuffedCard decrementHP:spellValue];
                 
                 
                 [self animateCard:spellCard toGrave:self.playerGrave andCompletition:^(BOOL finished)
                  {
                      
                      [spellCard releaseCard];
                       completion(YES);
                      
                  }];
                 
                 
             }];
            
        }
        else if([spellCard.spellType isEqualToString:SPELLTYPE_DECREMENT_DEF])
        {
            [self animatePlayerSpellWithCard:spellCard toCard:debuffedCard andCompletition:^(BOOL finished)
             {
                 int spellValue = debuffedCard.def / 100 * abs(spellCard.spellValue);
                 [debuffedCard decrementHP:spellValue];
                 
                 
                 [self animateCard:spellCard toGrave:self.playerGrave andCompletition:^(BOOL finished)
                  {
                      
                      [spellCard releaseCard];
                       completion(YES);
                      
                  }];
                 
                 
             }];
            
        }

    }
    else
    {
        completion(YES);
    }
}
-(void)playerSpellCard:(TCardField*)spellCard andCompletition:(void (^)(BOOL finished))completion
{
    //Spellcard ist auf playerField4, also kann entweder eine Karte auf playerfield1 oder eine Karte auf opponentField3 gebuffed werden
    if(spellCard == self.playerField4)
    {
            //opponent hat eine Spellkarte auf gegenüberliegender seite, checke ob diese des Spielers Karte debuffen kann
            [self debuffPlayersCard:self.playerField1 withSpellCard:self.opponentField6 andCompletition:^(BOOL finished)
            {
                //Buffe Karte
                [self buffPlayersCard:self.playerField1 withSpellCard:self.playerField4 andCompletition:^(BOOL finished)
                {
                    completion(YES);
                }];
                
            }];
    }
    else if(spellCard == self.playerField5)
    {
        
            //opponent hat eine Spellkarte auf gegenüberliegender seite, checke ob diese des Spielers Karte debuffen kann
            [self debuffPlayersCard:self.playerField2 withSpellCard:self.opponentField5 andCompletition:^(BOOL finished)
             {
                 //Buffe Karte
                 [self buffPlayersCard:self.playerField2 withSpellCard:self.playerField5 andCompletition:^(BOOL finished)
                  {
                      completion(YES);
                  }];
                 
             }];
    }
    else if(spellCard == self.playerField6)
    {
        
            //opponent hat eine Spellkarte auf gegenüberliegender seite, checke ob diese des Spielers Karte debuffen kann
            [self debuffPlayersCard:self.playerField3 withSpellCard:self.opponentField4 andCompletition:^(BOOL finished)
             {
                 //Buffe Karte
                 [self buffPlayersCard:self.playerField3 withSpellCard:self.playerField6 andCompletition:^(BOOL finished)
                  {
                      completion(YES);
                  }];
                 
             }];
       
        
    }
    
        
    //Spellcard ist auf playerField5, also kann entweder eine Karte auf playerfield2 oder eine Karte auf opponentField2 gebuffed werden
  /*  else if(spellCard == self.playerField5)
    {
        
        if(self.playerField2.isTaken)
        {
            //opponent hat eine Spellkarte auf gegenüberliegender seite, checke ob diese des Spielers Karte debuffen kann
            if(self.opponentField5.isTaken)
            {
                
                if([self.opponentField5.spellType isEqualToString:SPELLTYPE_DECREMENT_ATK])
                {
                    [self animatePlayerSpellWithCard:self.opponentField5 toCard:self.playerField2 andCompletition:^(BOOL finished)
                     {
                         int spellValue = self.playerField2.atk / 100 * self.opponentField5.spellValue;
                         [self.playerField2 decrementATK:spellValue];
                   
                         
                         [self animateCard:self.opponentField5 toGrave:self.opponentGrave andCompletition:^(BOOL finished)
                          {
                                    [self.opponentField5 releaseCard];
                            //  [self.gameManager buffWithCard:spellCard];
                 
                          }];
                     }];
                    //[self.gameManager buffCard:card withCard:spellCard];
                }
                else if([self.opponentField5.spellType isEqualToString:SPELLTYPE_DECREMENT_HP])
                {
                    [self animatePlayerSpellWithCard:self.opponentField5 toCard:self.playerField2 andCompletition:^(BOOL finished)
                     {
                         int spellValue = self.playerField2.hp / 100 * self.opponentField5.spellValue;
                         [self.playerField2 decrementHP:spellValue];
                
                         
                         [self animateCard:self.opponentField5 toGrave:self.opponentGrave andCompletition:^(BOOL finished)
                          {
                                       [self.opponentField5 releaseCard];
                               // [self.gameManager buffWithCard:spellCard];
             
                          }];
                     }];
                    //[self.gameManager buffCard:card withCard:spellCard];
                }
                else if([self.opponentField2.spellType isEqualToString:SPELLTYPE_DECREMENT_DEF])
                {
                    [self animatePlayerSpellWithCard:self.opponentField5 toCard:self.playerField2 andCompletition:^(BOOL finished)
                     {
                        int spellValue = self.playerField2.def / 100 * self.opponentField5.spellValue;
                         [self.playerField2 decrementDEF:spellValue];
  
                         
                         [self animateCard:self.opponentField5 toGrave:self.opponentGrave andCompletition:^(BOOL finished)
                          {
                                       [self.opponentField5 releaseCard];
                               // [self.gameManager buffWithCard:spellCard];
             
                          }];
                     }];
                    //[self.gameManager buffCard:card withCard:spellCard];
                }
              
                
            }
            
            
            if(spellCard.isTaken)
            {
                if([spellCard.spellType isEqualToString:SPELLTYPE_INCREMENT_ATK])
                {
                    [self animatePlayerSpellWithCard:spellCard toCard:self.playerField2 andCompletition:^(BOOL finished)
                     {
                         int spellValue = self.playerField2.atk / 100 * spellCard.spellValue;
                         [self.playerField2 incrementATK:spellValue];
                         
                         [self animateCard:spellCard toGrave:self.playerGrave andCompletition:^(BOOL finished)
                          {
                              
                             // [self.gameManager buffWithCard:spellCard];
                                  [spellCard releaseCard];
                              completion(YES);
                          }];
                     }];
                    //[self.gameManager buffCard:card withCard:spellCard];
                }
                else if([spellCard.spellType isEqualToString:SPELLTYPE_INCREMENT_HP])
                {
                    [self animatePlayerSpellWithCard:spellCard toCard:self.playerField2 andCompletition:^(BOOL finished)
                     {
                         int spellValue = self.playerField2.hp / 100 * spellCard.spellValue;
                         [self.playerField2 incrementHP:spellValue];
                         
                         [self animateCard:spellCard toGrave:self.playerGrave andCompletition:^(BOOL finished)
                          {
                              //[self.gameManager buffWithCard:spellCard];
                                  [spellCard releaseCard];
                              completion(YES);
                          }];
                     }];
                    //[self.gameManager buffCard:card withCard:spellCard];
                }
                else if([spellCard.spellType isEqualToString:SPELLTYPE_INCREMENT_DEF])
                {
                    [self animatePlayerSpellWithCard:spellCard toCard:self.playerField2 andCompletition:^(BOOL finished)
                     {
                         int spellValue = self.playerField2.def / 100 * spellCard.spellValue;
                         [self.playerField1 incrementDEF:spellValue];
                         
                         [self animateCard:spellCard toGrave:self.playerGrave andCompletition:^(BOOL finished)
                          {
                             // [self.gameManager buffWithCard:spellCard];
                                  [spellCard releaseCard];
                              completion(YES);
                          }];
                     }];
                    //[self.gameManager buffCard:card withCard:spellCard];
                }
                else
                {
                    completion(YES);
                }
            }
            else
            {
                completion(YES);
            }
          
        }
        else
        {
            completion(YES);
        }
    }
    
    //Spellcard ist auf playerField6, also kann entweder eine Karte auf playerfield3 oder eine Karte auf opponentField1 gebuffed werden
    else if(spellCard == self.playerField6)
    {
        
        if(self.playerField3.isTaken)
        {
            //opponent hat eine Spellkarte auf gegenüberliegender seite, checke ob diese des Spielers Karte debuffen kann
            if(self.opponentField4.isTaken)
            {
                if([self.opponentField4.spellType isEqualToString:SPELLTYPE_DECREMENT_ATK])
                {
                    [self animatePlayerSpellWithCard:self.opponentField4 toCard:self.playerField3 andCompletition:^(BOOL finished)
                     {
                         
                         int spellValue = self.playerField6.atk / 100 * self.opponentField4.spellValue;
                         [self.playerField3 decrementATK:spellValue];
      
                         
                         [self animateCard:self.opponentField4 toGrave:self.opponentGrave andCompletition:^(BOOL finished)
                          {
                            //  [self.gameManager buffWithCard:spellCard];
                    [self.opponentField4 releaseCard];
                 
                          }];
                     }];
                    //[self.gameManager buffCard:card withCard:spellCard];
                }
                else if([self.opponentField4.spellType isEqualToString:SPELLTYPE_DECREMENT_HP])
                {
                    [self animatePlayerSpellWithCard:self.opponentField4 toCard:self.playerField3 andCompletition:^(BOOL finished)
                     {
                         int spellValue = self.playerField3.hp / 100 * self.opponentField4.spellValue;
                         [self.playerField3 decrementHP:spellValue];
                 
                         
                         [self animateCard:self.opponentField4 toGrave:self.opponentGrave andCompletition:^(BOOL finished)
                          {
                            //  [self.gameManager buffWithCard:spellCard];
                                      [self.opponentField4 releaseCard];
          
                          }];

                     }];
                    //[self.gameManager buffCard:card withCard:spellCard];
                }
                else if([self.opponentField4.spellType isEqualToString:SPELLTYPE_DECREMENT_DEF])
                {
                    [self animatePlayerSpellWithCard:self.opponentField4 toCard:self.playerField3 andCompletition:^(BOOL finished)
                     {
                         int spellValue = self.playerField3.def / 100 * self.opponentField4.spellValue;
                         [self.playerField3 decrementDEF:spellValue];
       
                         
                         [self animateCard:self.opponentField4 toGrave:self.opponentGrave andCompletition:^(BOOL finished)
                          {
                             // [self.gameManager buffWithCard:spellCard];
                              [self.opponentField4 releaseCard];
                
                          }];
                     }];
                    
                    
                    //[self.gameManager buffCard:card withCard:spellCard];
                }
                

                
            }
            
            if(spellCard.isTaken)
            {
            
                if([spellCard.spellType isEqualToString:SPELLTYPE_INCREMENT_ATK])
                {
                    [self animatePlayerSpellWithCard:spellCard toCard:self.playerField3 andCompletition:^(BOOL finished)
                     {
                         int spellValue = self.playerField3.atk / 100 * spellCard.spellValue;
                         [self.playerField3 incrementATK:spellValue];
                         
                         
                         [self animateCard:spellCard toGrave:self.playerGrave andCompletition:^(BOOL finished)
                          {
                             // [self.gameManager buffWithCard:spellCard];
                              [spellCard releaseCard];
                              completion(YES);
                          }];
                     }];
                    //[self.gameManager buffCard:card withCard:spellCard];
                }
                else if([spellCard.spellType isEqualToString:SPELLTYPE_INCREMENT_HP])
                {
                    [self animatePlayerSpellWithCard:spellCard toCard:self.playerField3 andCompletition:^(BOOL finished)
                    {
                       int spellValue = self.playerField3.hp / 100 * spellCard.spellValue;
                       [self.playerField3 incrementHP:spellValue];
                        
                        
                        [self animateCard:spellCard toGrave:self.playerGrave andCompletition:^(BOOL finished)
                         {
                            // [self.gameManager buffWithCard:spellCard];
                             [spellCard releaseCard];
                             completion(YES);
                         }];
                    }];
                    //[self.gameManager buffCard:card withCard:spellCard];
                }
                else if([spellCard.spellType isEqualToString:SPELLTYPE_INCREMENT_DEF])
                {
                    
                    [self animatePlayerSpellWithCard:spellCard toCard:self.playerField3 andCompletition:^(BOOL finished)
                     {
                         int spellValue = self.playerField3.def / 100 * spellCard.spellValue;
                         [self.playerField3 incrementDEF:spellValue];
                         
                         
                         [self animateCard:spellCard toGrave:self.playerGrave andCompletition:^(BOOL finished)
                          {
                             // [self.gameManager buffWithCard:spellCard];
                              [spellCard releaseCard];
                              completion(YES);
                          }];
                     }];
                    //[self.gameManager buffCard:card withCard:spellCard];
                }
                else
                {
                    completion(YES);
                }
         
            }
            else
            {
                completion(YES);
            }
        }
        else
        {
            completion(YES);
        }
    
    }
    else
    {
        completion(YES);
    }*/
   
    

}

-(void)opponentSpellCard:(TCardField*)spellCard andCompletition:(void (^)(BOOL finished))completion
{
    
    if(spellCard == self.opponentField4)
    {
        //opponent hat eine Spellkarte auf gegenüberliegender seite, checke ob diese des Spielers Karte debuffen kann
        [self debuffPlayersCard:self.opponentField1 withSpellCard:self.playerField6 andCompletition:^(BOOL finished)
         {
             //Buffe Karte
             [self buffPlayersCard:self.opponentField1 withSpellCard:self.opponentField4 andCompletition:^(BOOL finished)
              {
                  completion(YES);
              }];
             
         }];
    }
    else if(spellCard == self.opponentField5)
    {
        
        //opponent hat eine Spellkarte auf gegenüberliegender seite, checke ob diese des Spielers Karte debuffen kann
        [self debuffPlayersCard:self.opponentField2 withSpellCard:self.playerField5 andCompletition:^(BOOL finished)
         {
             //Buffe Karte
             [self buffPlayersCard:self.opponentField2 withSpellCard:self.opponentField5 andCompletition:^(BOOL finished)
              {
                  completion(YES);
              }];
             
         }];
    }
    else if(spellCard == self.opponentField6)
    {
        
        //opponent hat eine Spellkarte auf gegenüberliegender seite, checke ob diese des Spielers Karte debuffen kann
        [self debuffPlayersCard:self.opponentField3 withSpellCard:self.playerField4 andCompletition:^(BOOL finished)
         {
             //Buffe Karte
             [self buffPlayersCard:self.opponentField3 withSpellCard:self.opponentField6 andCompletition:^(BOOL finished)
              {
                  completion(YES);
              }];
             
         }];
        
        
    }
}

/*-(void)opponentSpellCard:(TCardField*)spellCard wthCompletition: (void (^) (BOOL success))completion
{
    //Spellcard ist auf opponentField4, also kann entweder eine Karte auf opponentfield1 oder eine Karte auf playerfield3 gebuffed werden
    if(spellCard == self.opponentField4)
    {
        
        if(self.opponentField1.isTaken)
        {
            //opponent hat eine Spellkarte auf gegenüberliegender seite, checke ob diese des Spielers Karte debuffen kann
            if(self.playerField6.isTaken)
            {
                if([self.playerField6.spellType isEqualToString:SPELLTYPE_DECREMENT_ATK])
                {
                    
                    [self animatePlayerSpellWithCard:self.playerField6 toCard:self.opponentField1 andCompletition:^(BOOL finished)
                     {
                      
                         int spellValue = self.opponentField1.atk / 100 * self.playerField6.spellValue;
                         [self.opponentField1 decrementATK:spellValue];
                         //Karte wird zerstört sobald sie gewirkt hat
                         [self animateCard:self.playerField6 toGrave:self.playerGrave andCompletition:^(BOOL finished)
                         {
                         
                             [self.playerField6 releaseCard];
                   
              
                             
                         }];
                         

                     }];
                    
                }
                else if([self.playerField6.spellType isEqualToString:SPELLTYPE_DECREMENT_HP])
                {
                    
                    [self animatePlayerSpellWithCard:self.playerField6 toCard:self.opponentField1 andCompletition:^(BOOL finished)
                     {
                    
                         int spellValue = self.opponentField1.hp / 100 * self.playerField6.spellValue;
                         [self.opponentField1 decrementHP:spellValue];
                         
                         //Karte wird zerstört sobald sie gewirkt hat
                         [self animateCard:self.playerField6 toGrave:self.playerGrave andCompletition:^(BOOL finished)
                          {
                              
                              [self.playerField6 releaseCard];
 
                     
                          }];
                     }];
                    
                }
                else if([self.playerField6.spellType isEqualToString:SPELLTYPE_DECREMENT_DEF])
                {
                   
                    [self animatePlayerSpellWithCard:self.playerField6 toCard:self.opponentField1 andCompletition:^(BOOL finished)
                     {
                  
        
                         int spellValue = self.opponentField1.def / 100 * self.playerField6.spellValue;
                         [self.opponentField1 decrementDEF:spellValue];
                         //Karte wird zerstört sobald sie gewirkt hat
                         [self animateCard:self.playerField6 toGrave:self.playerGrave andCompletition:^(BOOL finished)
                          {
                              
                              [self.playerField6 releaseCard];
                      
                          }];
                     }];
                    
                }
                
                
               // [self.gameManager buffWithCard:spellCard];
            }
            
            if(spellCard.isTaken)
            {
                if([spellCard.spellType isEqualToString:SPELLTYPE_INCREMENT_ATK])
                {
                    
                   
                    [self animatePlayerSpellWithCard:spellCard toCard:self.opponentField1 andCompletition:^(BOOL finished)
                     {
                         int spellValue = self.opponentField1.atk / 100 * spellCard.spellValue;
                         [self.opponentField1 incrementATK:spellValue];
                         //Karte wird zerstört sobald sie gewirkt hat
                         [self animateCard:spellCard toGrave:self.opponentGrave andCompletition:^(BOOL finished)
                          {
                              
                              [spellCard releaseCard];
                              completion(YES);

                          }];
                     }];
              
                }
                else if([spellCard.spellType isEqualToString:SPELLTYPE_INCREMENT_HP])
                {
                    
                    [self animatePlayerSpellWithCard:spellCard toCard:self.opponentField1 andCompletition:^(BOOL finished)
                     {
                      
                         int spellValue = self.opponentField1.hp / 100 * spellCard.spellValue;
                         [self.opponentField1 incrementHP:spellValue];
                         //Karte wird zerstört sobald sie gewirkt hat
                         [self animateCard:spellCard toGrave:self.opponentGrave andCompletition:^(BOOL finished)
                          {
                              
                              [spellCard releaseCard];
                              completion(YES);
                       
                          }];
                     }];
             
                }
                else if([spellCard.spellType isEqualToString:SPELLTYPE_INCREMENT_DEF])
                {
                 
                    [self animatePlayerSpellWithCard:spellCard toCard:self.opponentField1 andCompletition:^(BOOL finished)
                     {
                        
                         int spellValue = self.opponentField1.def / 100 * spellCard.spellValue;
                         [self.opponentField1 incrementDEF:spellValue];
                         //Karte wird zerstört sobald sie gewirkt hat
                         [self animateCard:spellCard toGrave:self.opponentGrave andCompletition:^(BOOL finished)
                          {
                              
                              [spellCard releaseCard];
                              completion(YES);
             
                          }];
                     }];
                
                }

            }
            else
            {
                completion(YES);
            }
  
            
        }
        else
        {
            completion(YES);
        }
    }
    
    
    //Spellcard ist auf opponentField5, also kann entweder eine Karte auf opponentfield2 oder eine Karte auf playerField2 gebuffed werden
    else if(spellCard == self.opponentField5)
    {
        
        if(self.opponentField2.isTaken)
        {
            //opponent hat eine Spellkarte auf gegenüberliegender seite, checke ob diese des Spielers Karte debuffen kann
            if(self.playerField5.isTaken)
            {
                if([self.playerField5.spellType isEqualToString:SPELLTYPE_DECREMENT_ATK])
                {
                    [self animatePlayerSpellWithCard:self.playerField5 toCard:self.opponentField2 andCompletition:^(BOOL finished)
                     {
                      
                       
                         int spellValue = self.opponentField2.atk / 100 * self.playerField5.spellValue;
                         [self.opponentField2 decrementATK:spellValue];

                         //Karte wird zerstört sobald sie gewirkt hat
                         [self animateCard:self.playerField5 toGrave:self.playerGrave andCompletition:^(BOOL finished)
                          {
                                [self.playerField5 releaseCard];
                             
        
                          }];
                     }];
                    //[self.gameManager buffCard:card withCard:spellCard];
                }
                else if([self.playerField5.spellType isEqualToString:SPELLTYPE_DECREMENT_HP])
                {
                   
                    [self animatePlayerSpellWithCard:self.playerField5 toCard:self.opponentField2 andCompletition:^(BOOL finished)
                     {
                         
        
                         int spellValue = self.opponentField2.hp / 100 * self.playerField5.spellValue;
                         [self.opponentField2 decrementHP:spellValue];
                         //Karte wird zerstört sobald sie gewirkt hat
                         [self animateCard:self.playerField5 toGrave:self.playerGrave andCompletition:^(BOOL finished)
                          {
                              [self.playerField5 releaseCard];
               
                   
                          }];
                     }];
                    //[self.gameManager buffCard:card withCard:spellCard];
                }
                else if([self.playerField5.spellType isEqualToString:SPELLTYPE_DECREMENT_DEF])
                {
                   
                    [self animatePlayerSpellWithCard:self.playerField5 toCard:self.opponentField2 andCompletition:^(BOOL finished)
                     {
                      
                         int spellValue = self.opponentField2.def / 100 * self.playerField5.spellValue;
                         [self.opponentField2 decrementDEF:spellValue];
                         
                         //Karte wird zerstört sobald sie gewirkt hat
                         [self animateCard:self.playerField5 toGrave:self.playerGrave andCompletition:^(BOOL finished)
                          {
                              [self.playerField5 releaseCard];
       
                             
                          }];
                     }];
                    //[self.gameManager buffCard:card withCard:spellCard];
                }
                
                //[self.gameManager buffWithCard:spellCard];
                
            }
            
            if(spellCard.isTaken)
            {
            
                if([spellCard.spellType isEqualToString:SPELLTYPE_INCREMENT_ATK])
                {
                   
                    [self animatePlayerSpellWithCard:spellCard toCard:self.opponentField2 andCompletition:^(BOOL finished)
                     {
                        
                         int spellValue = self.opponentField2.atk / 100 * spellCard.spellValue;
                         [self.opponentField2 incrementATK:spellValue];
                         //Karte wird zerstört sobald sie gewirkt hat
                         [self animateCard:spellCard toGrave:self.opponentGrave andCompletition:^(BOOL finished)
                          {
                              //Karte wird zerstört sobald sie gewirkt hat
                              [spellCard releaseCard];
                              completion(YES);
                    
                          }];
                     }];
                    //[self.gameManager buffCard:card withCard:spellCard];
                }
                else if([spellCard.spellType isEqualToString:SPELLTYPE_INCREMENT_HP])
                {
                    
                    [self animatePlayerSpellWithCard:spellCard toCard:self.opponentField2 andCompletition:^(BOOL finished)
                     {
                       
                         int spellValue = self.opponentField2.hp / 100 * spellCard.spellValue;
                         [self.opponentField2 incrementHP:spellValue];
                         //Karte wird zerstört sobald sie gewirkt hat
                         [self animateCard:spellCard toGrave:self.opponentGrave andCompletition:^(BOOL finished)
                          {
                              //Karte wird zerstört sobald sie gewirkt hat
                              [spellCard releaseCard];
                              completion(YES);
                 
                          }];
                     }];
                    //[self.gameManager buffCard:card withCard:spellCard];
                }
                else if([spellCard.spellType isEqualToString:SPELLTYPE_INCREMENT_DEF])
                {
                    
                    [self animatePlayerSpellWithCard:spellCard toCard:self.opponentField2 andCompletition:^(BOOL finished)
                     {
                      
                         int spellValue = self.opponentField2.def / 100 * spellCard.spellValue;
                         [self.opponentField2 incrementDEF:spellValue];

                         //Karte wird zerstört sobald sie gewirkt hat
                         [self animateCard:spellCard toGrave:self.opponentGrave andCompletition:^(BOOL finished)
                          {
                              //Karte wird zerstört sobald sie gewirkt hat
                              [spellCard releaseCard];
                              completion(YES);

                          }];
                     }];
                    //[self.gameManager buffCard:card withCard:spellCard];
                }
                //[self.gameManager buffWithCard:spellCard];
            }
            else
            {
                completion(YES);
            }
            
        }
        else
        {
            completion(YES);
        }
    }
    
    //Spellcard ist auf opponentField6, also kann entweder eine Karte auf opponentfield3 oder eine Karte auf playerField1 gebuffed werden
    else if(spellCard == self.opponentField6)
    {
        
        if(self.opponentField3.isTaken)
        {
            //opponent hat eine Spellkarte auf gegenüberliegender seite, checke ob diese des Spielers Karte debuffen kann
            if(self.playerField4.isTaken)
            {
                if([self.playerField4.spellType isEqualToString:SPELLTYPE_DECREMENT_ATK])
                {
                   
                    [self animatePlayerSpellWithCard:self.playerField4 toCard:self.opponentField3 andCompletition:^(BOOL finished)
                     {

                         int spellValue = self.opponentField3.atk / 100 * self.playerField4.spellValue;
                         [self.opponentField3 decrementATK:spellValue];

                         
                         //Karte wird zerstört sobald sie gewirkt hat
                         [self animateCard:self.playerField4 toGrave:self.playerGrave andCompletition:^(BOOL finished)
                          {
                              //Karte wird zerstört sobald sie gewirkt hat
                              [self.playerField4 releaseCard];
             
               
                          }];
                     }];
                    //[self.gameManager buffCard:card withCard:spellCard];
                }
                else if([self.playerField4.spellType isEqualToString:SPELLTYPE_DECREMENT_HP])
                {
                    
                    [self animatePlayerSpellWithCard:self.playerField4 toCard:self.opponentField3 andCompletition:^(BOOL finished)
                     {
                   
                         int spellValue = self.opponentField3.hp / 100 * self.playerField4.spellValue;
                         [self.opponentField3 decrementHP:spellValue];
                         //Karte wird zerstört sobald sie gewirkt hat
                         [self animateCard:self.playerField4 toGrave:self.playerGrave andCompletition:^(BOOL finished)
                          {
                              //Karte wird zerstört sobald sie gewirkt hat
                              [self.playerField4 releaseCard];
             
                              
   
                          }];

                     }];
                    //[self.gameManager buffCard:card withCard:spellCard];
                }
                else if([self.playerField4.spellType isEqualToString:SPELLTYPE_DECREMENT_DEF])
                {
                    [self animatePlayerSpellWithCard:self.playerField4 toCard:self.opponentField3 andCompletition:^(BOOL finished)
                     {
                      
                         int spellValue = self.opponentField3.def / 100 * self.playerField4.spellValue;
                         [self.opponentField3 decrementDEF:spellValue];

                         //Karte wird zerstört sobald sie gewirkt hat
                         [self animateCard:self.playerField4 toGrave:self.playerGrave andCompletition:^(BOOL finished)
                          {
                              //Karte wird zerstört sobald sie gewirkt hat
                              [self.playerField4 releaseCard];
              
          
                          }];

                     }];
                    //[self.gameManager buffCard:card withCard:spellCard];
                }
                
                //[self.gameManager buffWithCard:spellCard];
                
            }
            
            if(spellCard.isTaken)
            {
                
                if([spellCard.spellType isEqualToString:SPELLTYPE_INCREMENT_ATK])
                {
                    

                    [self animatePlayerSpellWithCard:spellCard toCard:self.opponentField3 andCompletition:^(BOOL finished)
                     {
                         int spellValue = self.opponentField3.atk / 100 * spellCard.spellValue;
                         [self.opponentField3 incrementATK:spellValue];
                         //Karte wird zerstört sobald sie gewirkt hat
                         [self animateCard:spellCard toGrave:self.opponentGrave andCompletition:^(BOOL finished)
                          {
                              //Karte wird zerstört sobald sie gewirkt hat
                              [spellCard releaseCard];
                              completion(YES);
                             
                          }];

                     }];
                    //[self.gameManager buffCard:card withCard:spellCard];
                }
                else if([spellCard.spellType isEqualToString:SPELLTYPE_INCREMENT_HP])
                {
                    [self animatePlayerSpellWithCard:spellCard toCard:self.opponentField3 andCompletition:^(BOOL finished)
                     {
                    
                         int spellValue = self.opponentField3.hp / 100 * spellCard.spellValue;
                         [self.opponentField3 incrementHP:spellValue];

                         
                         //Karte wird zerstört sobald sie gewirkt hat
                         [self animateCard:spellCard toGrave:self.opponentGrave andCompletition:^(BOOL finished)
                          {
                              //Karte wird zerstört sobald sie gewirkt hat
                              [spellCard releaseCard];
                              completion(YES);

                          }];
                     }];
                    //[self.gameManager buffCard:card withCard:spellCard];
                }
                else if([spellCard.spellType isEqualToString:SPELLTYPE_INCREMENT_DEF])
                {
                   
                    [self animatePlayerSpellWithCard:spellCard toCard:self.opponentField3 andCompletition:^(BOOL finished)
                     {
                        
                         int spellValue = self.opponentField3.def / 100 * spellCard.spellValue;
                         [self.opponentField3 incrementDEF:spellValue];
                         
                         //Karte wird zerstört sobald sie gewirkt hat
                         [self animateCard:spellCard toGrave:self.opponentGrave andCompletition:^(BOOL finished)
                          {
                              //Karte wird zerstört sobald sie gewirkt hat
                              [spellCard releaseCard];
                
                              completion(YES);
                          }];
                     }];
                    //[self.gameManager buffCard:card withCard:spellCard];
                }
                //[self.gameManager buffWithCard:spellCard];
                //Karte wird zerstört sobald sie gewirkt hat
            }
            else
            {
                completion(YES);
            }

            
        }
        else
        {
            completion(YES);
        }
        
        
    }
    else
    {
        completion(YES);
    }
    
}*/


-(void)turnCard:(TCardField*)card
{
    if([card.product.isInDefensePosition boolValue] == YES)
    {
        [card setDefensePosition];
    }
    else
    {
        [card setAttackPosition];
    }
}

-(void)playerAttackWithCard:(TCardField*)card
{
    
        
    if(card == self.playerField1 && !card.isInDefensePosition)
    {
        
        self.attackLabel.text = [NSString stringWithFormat:@"%d", card.atk];
        
        if(self.opponentField3.isTaken)
        {
            
            //Ist Kartenfeld belegt und Karte ist nicht in Verteidigungsposition
            if(self.opponentField3.isInDefensePosition)
            {
                int value =  abs(self.opponentField3.def - card.atk);
                [self.opponentField3 decrementDEF: card.atk];
                
                //ist def <= 0. wird Karte zerstört
                if(self.opponentField3.def <= 0)
                {
                     //ziehe Lifepoints ab

                    int newOpponentLifePoints = [self.gameData.opponent.lifePoints intValue] - value;
                    self.gameData.opponent.lifePoints = [NSNumber numberWithInt:newOpponentLifePoints];
                    
                    [self.gameManager attackOpponentWithValue:abs(value)];
    
                    //Animiere Karte
                    [self animateCard:self.opponentField3 toGrave:self.opponentGrave andCompletition:^(BOOL finished)
                     {
        
                        [self.opponentGrave storeCardWithCardController:self.opponentField3.ov];
                         [self.opponentField3 releaseCard];
                     }];
                }
                
            }
            else   //karte ist in angriffsposition: ziehe von hp ab
            {
                int value =  abs(self.opponentField3.hp - card.atk);
                [self.opponentField3 decrementHP:card.atk];
                
                //ist hp <= 0. wird Karte zerstört
                if(self.opponentField3.hp <= 0)
                {
                
                     //ziehe Lifepoints ab

                    int newOpponentLifePoints = [self.gameData.opponent.lifePoints intValue] - value;
                    self.gameData.opponent.lifePoints = [NSNumber numberWithInt:newOpponentLifePoints];
                    
                    [self.gameManager attackOpponentWithValue:abs(value)];

                    //Animiere Karte
                    [self animateCard:self.opponentField3 toGrave:self.opponentGrave andCompletition:^(BOOL finished)
                     {
                         
                         [self.opponentGrave storeCardWithCardController:self.opponentField3.ov];

                         [self.opponentField3 releaseCard];

                     }];
                }
            }
        }
        else
        {
            //ziehe Lifepoints ab
            int value = card.atk;
            int newOpponentLifePoints = [self.gameData.opponent.lifePoints intValue] - value;
            self.gameData.opponent.lifePoints = [NSNumber numberWithInt:newOpponentLifePoints];
            
            [self.gameManager attackOpponentWithValue:value];


        }
       // [self.gameManager attackWithCard:card];
        
    }
    else if(card == self.playerField2  && !card.isInDefensePosition)
    {
        self.attackLabel.text = [NSString stringWithFormat:@"%d", card.atk];
        
        if(self.opponentField2.isTaken)
        {
            //Ist Kartenfeld belegt und Karte ist nicht in Verteidigungsposition
            if(self.opponentField2.isInDefensePosition)
            {
                int value =  abs(self.opponentField2.def - card.atk);
                [self.opponentField2 decrementDEF: card.atk];
                
                //ist def <= 0. wird Karte zerstört
                if(self.opponentField2.def <= 0)
                {
                     //ziehe Lifepoints ab
                    int newOpponentLifePoints = [self.gameData.opponent.lifePoints intValue] - value;
                    self.gameData.opponent.lifePoints = [NSNumber numberWithInt:newOpponentLifePoints];
                    
                    [self.gameManager attackOpponentWithValue:abs(value)];

                    
                    //Animiere Karte
                    [self animateCard:self.opponentField2 toGrave:self.opponentGrave andCompletition:^(BOOL finished)
                     {
                         
                         [self.opponentGrave storeCardWithCardController:self.opponentField2.ov];

                         [self.opponentField2 releaseCard];

                     }];
                }
                
            }
            else   //karte ist in angriffsposition: ziehe von hp ab
            {
                int value =  abs(self.opponentField2.hp - card.atk);
                [self.opponentField2 decrementHP:card.atk];
             
                //ist hp <= 0. wird Karte zerstört
                if(self.opponentField2.hp <= 0)
                {
                  
                    int newOpponentLifePoints = [self.gameData.opponent.lifePoints intValue] - value;
                    self.gameData.opponent.lifePoints = [NSNumber numberWithInt:newOpponentLifePoints];
                    
                    [self.gameManager attackOpponentWithValue:abs(value)];

                    
                    //Animiere Karte
                    [self animateCard:self.opponentField2 toGrave:self.opponentGrave andCompletition:^(BOOL finished)
                     {
                         
                         [self.opponentGrave storeCardWithCardController:self.opponentField2.ov];
                         [self.opponentField2 releaseCard];
                     }];
                }
            }
        }
        else
        {
            //ziehe Lifepoints ab
            int value = card.atk;
            int newOpponentLifePoints = [self.gameData.opponent.lifePoints intValue] - value;
            self.gameData.opponent.lifePoints = [NSNumber numberWithInt:newOpponentLifePoints];
            
            [self.gameManager attackOpponentWithValue:value];

            
        }
        
       // [self.gameManager attackWithCard:card];
        
    }
    else if(card == self.playerField3  && !card.isInDefensePosition)
    {
        self.attackLabel.text = [NSString stringWithFormat:@"%d", card.atk];
        
        if(self.opponentField1.isTaken)
        {
            //Ist Kartenfeld belegt und Karte ist in Verteidigungsposition
            if(self.opponentField1.isInDefensePosition)
            {
                 int value =  abs(self.opponentField1.def - card.atk);
                [self.opponentField1 decrementDEF: card.atk];
               
                //ist def <= 0. wird Karte zerstört
                if(self.opponentField1.def <= 0)
                {
                     //ziehe Lifepoints ab
                 
                    int newOpponentLifePoints = [self.gameData.opponent.lifePoints intValue] - value;
                    self.gameData.opponent.lifePoints = [NSNumber numberWithInt:newOpponentLifePoints];
                    
                    [self.gameManager attackOpponentWithValue: abs(value)];


                    //Animiere Karte
                    [self animateCard:self.opponentField1 toGrave:self.opponentGrave andCompletition:^(BOOL finished)
                     {
                         
                         [self.opponentGrave storeCardWithCardController:self.opponentField1.ov];
                         [self.opponentField1 releaseCard];
                     }];
                }
                
            }
            else   //karte ist in angriffsposition: ziehe von hp ab
            {
                int value = abs(self.opponentField1.hp - card.atk);

                [self.opponentField1 decrementHP:card.atk];
                
                //ist hp <= 0. wird Karte zerstört
                if(self.opponentField1.hp <= 0)
                {
                    //ziehe Lifepoints ab
              
                    int newOpponentLifePoints = [self.gameData.opponent.lifePoints intValue] - value;
                    self.gameData.opponent.lifePoints = [NSNumber numberWithInt:newOpponentLifePoints];
                    
                    [self.gameManager attackOpponentWithValue:abs(value)];


                    //Animiere Karte
                    [self animateCard:self.opponentField1 toGrave:self.opponentGrave andCompletition:^(BOOL finished)
                     {
                         
                         
                         [self.opponentGrave storeCardWithCardController:self.opponentField1.ov];
                         [self.opponentField1 releaseCard];
                     }];
                }
            }
        }
        else
        {
          //ziehe Lifepoints ab
          int value = card.atk;
          int newOpponentLifePoints = [self.gameData.opponent.lifePoints intValue] - value;
          self.gameData.opponent.lifePoints = [NSNumber numberWithInt:newOpponentLifePoints];
         [self.gameManager attackOpponentWithValue:value];

            
        }
             // [self.gameManager attackWithCard:card];
    }
    
    self.opponentLifepointsLabel.text = [NSString stringWithFormat:@"%@", self.gameData.opponent.lifePoints];

}
-(void)opponentAttackWithCard:(TCardField*)card
{
    if(card == self.opponentField1 && !card.isInDefensePosition)
    {
        
        self.attackLabel.text = [NSString stringWithFormat:@"%d", card.atk];
        
        if(self.playerField3.isTaken)
        {
            //Ist Kartenfeld belegt und Karte ist nicht in Verteidigungsposition
            if(self.playerField3.isInDefensePosition)
            {
                int value = abs(self.playerField3.def - card.atk);
                [self.playerField3 decrementDEF: card.atk];
                
                //ist def <= 0. wird Karte zerstört
                if(self.playerField3.def <= 0)
                {
                    //ziehe Lebenspunkte ab
               
                    int newPlayerLifePoints = [self.dataManger.player.lifePoints intValue] - value;
                    self.dataManger.player.lifePoints = [NSNumber numberWithInt:newPlayerLifePoints];

                    //Animiere Karte
                    [self animateCard:self.playerField3 toGrave:self.playerGrave andCompletition:^(BOOL finished)
                    {
                        [self.playerGrave storeCardWithCardController:self.playerField3.ov];
                        [self.playerField3 releaseCard];
                    }];
                }
                
            }
            else   //karte ist in angriffsposition: ziehe von hp ab
            {
                int value = abs(self.playerField3.hp - card.atk);
                [self.playerField3 decrementHP:card.atk];
                
                //ist hp <= 0. wird Karte zerstört
                if(self.playerField3.hp <= 0)
                {
                    //ziehe Lebenspunkte ab

                    int newPlayerLifePoints = [self.dataManger.player.lifePoints intValue] - value;
                    self.dataManger.player.lifePoints = [NSNumber numberWithInt:newPlayerLifePoints];
                    
                    [self animateCard:self.playerField3 toGrave:self.playerGrave andCompletition:^(BOOL finished)
                     {
                         [self.playerGrave storeCardWithCardController:self.playerField3.ov];

                         [self.playerField3 releaseCard];
                    }];
                }
            }
            
        }
        else
        {
            //ziehe Lebenspunkte ab
            int value = card.atk;
            int newPlayerLifePoints = [self.dataManger.player.lifePoints intValue] - value;
            self.dataManger.player.lifePoints = [NSNumber numberWithInt:newPlayerLifePoints];

        }
        


    }
    else if(card == self.opponentField2 && !card.isInDefensePosition)
    {
        self.attackLabel.text = [NSString stringWithFormat:@"%d", card.atk];
        
        if(self.playerField2.isTaken)
        {
            //Ist Kartenfeld belegt und Karte ist nicht in Verteidigungsposition
            if(self.playerField2.isInDefensePosition)
            {
                int value = abs(self.playerField2.def - card.atk);
                [self.playerField2 decrementDEF: card.atk];
                
                //ist def <= 0. wird Karte zerstört
                if(self.playerField2.def <= 0)
                {
                   

                    int newPlayerLifePoints = [self.dataManger.player.lifePoints intValue] - value;
                    self.dataManger.player.lifePoints = [NSNumber numberWithInt:newPlayerLifePoints];
                    
                    //Animiere Karte
                    [self animateCard:self.playerField2 toGrave:self.playerGrave andCompletition:^(BOOL finished)
                     {
                         [self.playerGrave storeCardWithCardController:self.playerField2.ov];
                         [self.playerField2 releaseCard];
                     }];
                }
                
            }
            else   //karte ist in angriffsposition: ziehe von hp ab
            {
                int value = abs(self.playerField2.hp - card.atk);
                [self.playerField2 decrementHP:card.atk];
                
                //ist hp <= 0. wird Karte zerstört
                if(self.playerField2.hp <= 0)
                {
                    //ziehe Lebenspunkte ab

                    int newPlayerLifePoints = [self.dataManger.player.lifePoints intValue] - value;
                    self.dataManger.player.lifePoints = [NSNumber numberWithInt:newPlayerLifePoints];
                    
                    //Animiere Karte
                    [self animateCard:self.playerField2 toGrave:self.playerGrave andCompletition:^(BOOL finished)
                     {
                         [self.playerGrave storeCardWithCardController:self.playerField2.ov];
                         [self.playerField2 releaseCard];
                     }];
                }
            }
        }
        else
        {
            //ziehe Lebenspunkte ab
              int value = card.atk;
            int newPlayerLifePoints = [self.dataManger.player.lifePoints intValue] - value;
            self.dataManger.player.lifePoints = [NSNumber numberWithInt:newPlayerLifePoints];

        }
        


    }
    else if(card == self.opponentField3 && !card.isInDefensePosition)
    {
        self.attackLabel.text = [NSString stringWithFormat:@"%d", card.atk];
        
        if(self.playerField1.isTaken)
        {
            //Ist Kartenfeld belegt und Karte ist in Verteidigungsposition
            if(self.playerField1.isInDefensePosition)
            {
                int value = abs(self.playerField1.def - card.atk);
                [self.playerField1 decrementDEF: card.atk];
                
                //ist def <= 0. wird Karte zerstört
                if(self.playerField1.def <= 0)
                {
                    //ziehe Lebenspunkte ab

                    int newPlayerLifePoints = [self.dataManger.player.lifePoints intValue] - value;
                    self.dataManger.player.lifePoints = [NSNumber numberWithInt:newPlayerLifePoints];
                    
                    //Animiere Karte
                    [self animateCard:self.playerField1 toGrave:self.playerGrave andCompletition:^(BOOL finished)
                     {
                        [self.playerGrave storeCardWithCardController:self.playerField1.ov];
                        [self.playerField1 releaseCard];
                     }];
                }
                
            }
            else   //karte ist in angriffsposition: ziehe von hp ab
            {
                int value = abs(self.playerField1.hp - card.atk);
                [self.playerField1 decrementHP:card.atk];
                
                //ist hp <= 0. wird Karte zerstört
                if(self.playerField1.hp <= 0)
                {
                    //ziehe Lebenspunkte ab
             
                    int newPlayerLifePoints = [self.dataManger.player.lifePoints intValue] - value;
                    self.dataManger.player.lifePoints = [NSNumber numberWithInt:newPlayerLifePoints];
                    
                    //Animiere Karte
                    [self animateCard:self.playerField1 toGrave:self.playerGrave andCompletition:^(BOOL finished)
                     {
                         [self.playerGrave storeCardWithCardController:self.playerField1.ov];
                         [self.playerField1 releaseCard];
                     }];
                }
            }
        }
        else
        {
            //ziehe Lebenspunkte ab
            int value = card.atk;
            int newPlayerLifePoints = [self.dataManger.player.lifePoints intValue] - value;
            self.dataManger.player.lifePoints = [NSNumber numberWithInt:newPlayerLifePoints];
            
        }
        
   


    }
    self.playerLifepointsLabel.text = [NSString stringWithFormat:@"%@",  self.dataManger.player.lifePoints];

    if([self.gameData.gameState isEqualToString:GAMESTATE_FINISHED])
    {
               //Opponent wins
        if([self.dataManger.player.lifePoints intValue] <= 0)
        {
            
                [[NSNotificationCenter defaultCenter]
                 removeObserver:self];
                
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You lose" message:@"don`t be disappointed ;( " delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            alert.tag = 1;
            [alert show];
            return;
        }
        
    }
    
}

-(void)opponentAttackCards

{

    [self opponentSpellCard:self.opponentField4 andCompletition:^(BOOL finished)
    {
        [self animateOpponentAttackWithCard:self.opponentField1 andCompletition:^(BOOL finished)
         {
             if(self.opponentField1.isTaken)
             {
                 [self opponentAttackWithCard:self.opponentField1];
                 NSLog(@"opponent1");
             }
         
             [self opponentSpellCard:self.opponentField5 andCompletition:^(BOOL finished)
             {
                  [self animateOpponentAttackWithCard:self.opponentField2 andCompletition:^(BOOL finished)
                   {
                       if(self.opponentField2.isTaken)
                       {
                           [self opponentAttackWithCard:self.opponentField2];
                            NSLog(@"opponent2");
                       }
                       
                      [self opponentSpellCard:self.opponentField6 andCompletition:^(BOOL finished)
                        {
                            [self animateOpponentAttackWithCard:self.opponentField3 andCompletition:^(BOOL finished)
                             {
                                 if(self.opponentField3.isTaken)
                                 {
                                     [self opponentAttackWithCard:self.opponentField3];
                                      NSLog(@"opponent3");
                                 }
                                 
                     
                                 
                             }];
                        }];
                       
                   }];
              }];
             
         }];
    }];
}

-(void)attackCards
{
    [self playerSpellCard:self.playerField4 andCompletition:^(BOOL finished)
     {
         [self animatePlayerAttackWithCard:self.playerField1 andCompletition:^(BOOL finished)
          {
              if(self.playerField1.isTaken)
              {
                  [self playerAttackWithCard:self.playerField1];
                  NSLog(@"player1");
              }
              
              [self playerSpellCard:self.playerField5 andCompletition:^(BOOL finished)
               {
                   [self animatePlayerAttackWithCard:self.playerField2 andCompletition:^(BOOL finished)
                    {
                        if(self.playerField2.isTaken)
                        {
                       
                            [self playerAttackWithCard:self.playerField2];
                            NSLog(@"player2");
                        }
                   
                        [self playerSpellCard:self.playerField6 andCompletition:^(BOOL finished)
                         {
                             [self animatePlayerAttackWithCard:self.playerField3 andCompletition:^(BOOL finished)
                              {
                                  if(self.playerField3.isTaken)
                                  {
                            
                                      [self playerAttackWithCard:self.playerField3];
                                      NSLog(@"player3");
                                  }
                                   [self.gameManager attackWithCard:self.playerField1];
                                 [self.dataManger sendReadyViaSocket];
                     
                         
                              }];
                   
                   
                         }];
              
                    }];
               }];
         }];
    }];
    
   
}

////////////////////////////////
/////ANIMATIONS////////////////
///////////////////////////////
#pragma mark ANIMATIONS

-(void)animatePlayerAttackWithCard:(TCardField*)card andCompletition:(void (^)(BOOL finished))completion
{
    int moveDistance = 20;
    CGPoint oldPos = card.center;
   
   
    if(card.isTaken && !card.isInDefensePosition)
    {
        //dubliziere aktuelle Karte
        TCardField *cardDublicate = [[TCardField alloc] initWithFrame:card.frame];
        cardDublicate.position = card.position;
        [cardDublicate storeCardWithCardController:card.ov];
        
        [self.view addSubview:cardDublicate];
        [card showEmptyField:YES];
        [UIView animateWithDuration:0.3f animations:^{cardDublicate.center = CGPointMake(cardDublicate.center.x, cardDublicate.center.y - moveDistance);}
                         completion:^(BOOL finished)
         {
             completion(YES);
             
             [UIView animateWithDuration:0.3f animations:^{cardDublicate.center = CGPointMake(oldPos.x, oldPos.y);}
                              completion:^(BOOL finished)
              {
                  [card showEmptyField:NO];
                  [cardDublicate removeFromSuperview];
                  [cardDublicate releaseCard];
              }];
         }];
    }
    else
    {
        completion(YES);
    }
        
    
}


-(void)animateOpponentAttackWithCard:(TCardField*)card andCompletition:(void (^)(BOOL finished))completion
{
    int moveDistance = 20;
    CGPoint oldPos = card.center;
    
    if(card.isTaken && !card.isInDefensePosition)
    {
        //dubliziere aktuelle Karte
        TCardField *cardDublicate = [[TCardField alloc] initWithFrame:card.frame];
        cardDublicate.position = card.position;
        [cardDublicate storeCardWithCardController:card.ov];

        
        [self.view addSubview:cardDublicate];
        [card showEmptyField:YES];
        [UIView animateWithDuration:0.3f animations:^{cardDublicate.center = CGPointMake(cardDublicate.center.x, cardDublicate.center.y + moveDistance);}
                         completion:^(BOOL finished)
         {
           
             completion(YES);
             [UIView animateWithDuration:0.3f animations:^{cardDublicate.center = CGPointMake(oldPos.x, oldPos.y);}
                              completion:^(BOOL finished)
              {
             
                  [card showEmptyField:NO];
                  [cardDublicate removeFromSuperview];
                  [cardDublicate releaseCard];

              }];
         }];
    }
    else
    {
        completion(YES);
    }
    
    
}

-(void)animatePlayerSpellWithCard:(TCardField*)card toCard:(TCardField*)toCard andCompletition:(void (^)(BOOL finished))completion
{
    if(card.isTaken && toCard.isTaken)
    {
        //dubliziere aktuelle Karte
        TCardField *cardDublicate = [[TCardField alloc] initWithFrame:card.frame];
        cardDublicate.position = card.position;
        [cardDublicate storeCardWithCardController:card.ov];
        
        
        [self.view addSubview:cardDublicate];
        [card showEmptyField:YES];
        
        [UIView animateWithDuration:0.3f animations:^
        {
            cardDublicate.center = toCard.center;
            
        }
                         completion:^(BOOL finished)
         {
             
             [UIView animateWithDuration:0.3f animations:^{cardDublicate.alpha = 0.0f;}
                              completion:^(BOOL finished)
              {
                  cardDublicate.alpha = 1.0f;
                  [card showEmptyField:NO];
                  [cardDublicate removeFromSuperview];
                  [cardDublicate releaseCard];
                  completion(YES);
                  
              }];
             
            
         }];
    }
    else
    {
        completion(YES);
    }


}

-(void)animateCard:(TCardField*)card toGrave:(TCardField*)grave andCompletition:(void (^)(BOOL finished))completion
{
    //dubliziere aktuelle Karte
    TCardField *cardDublicate = [[TCardField alloc] initWithFrame:card.frame];
    cardDublicate.position = card.position;
    [cardDublicate storeCardWithCardController:card.ov];
    [self.view addSubview:cardDublicate];
    [card showEmptyField:YES];

    
 
    [UIView animateWithDuration:0.3f animations:^{
        cardDublicate.center = CGPointMake(grave.center.x, grave.center.y);
        cardDublicate.frame = grave.frame;
        
        if(card.isInDefensePosition)
        {
            cardDublicate.transform = CGAffineTransformMakeRotation(0);
        }
    }
                     completion:^(BOOL finished)
     {
        // card.frame = originalFrame;
         
         completion(YES);
     }];
}

////////////////////////////
///////alertview delegate///
////////////////////////////
#pragma mark ALERTVIEWDELEGATE

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(alertView.tag == 1) //Quit running game
    {
        if(buttonIndex == 0)
        {
            
            [self.dataManger quitRunningGame];
            
            [self popToRootView];
        }
        
    }
    else if(alertView.tag == 2) //oppenent aborted game
    {
        [self.dataManger quitRunningGame];
        
        [self popToRootView];
        
    }
    
}

-(void)popToRootView
{
    [[[self presentingViewController] presentingViewController]  dismissViewControllerAnimated:NO completion:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    /*if(self.gameManager == nil)
     self.gameManager = [[TGameManager alloc] initGameManagerWithViewController:self];
     
     
     if([segue.identifier isEqualToString:SEGUE_PLAYER_FIELD])
     {
     TPlayerViewController *vc =(TPlayerViewController*) segue.destinationViewController;
     vc = [vc initWithNibName:@"TPlayingFieldViewController" bundle:nil];
     vc.gameManager = self.gameManager;
     
     }
     else if([segue.identifier isEqualToString:SEGUE_OPPONENT_FIELD])
     {
     TOpponentViewController *vc =(TOpponentViewController*) segue.destinationViewController;
     
     vc = [vc initWithNibName:@"TPlayingFieldViewController" bundle:nil];
     vc.gameManager = self.gameManager;
     }*/
    
    
}


////////////////////////////////////////////////////
////////////PAN_ACTIONS////////////////////////////
//////////////////////////////////////////////////
#pragma mark PAN_ACTIONS

-(void)handlePanAction:(TCardField*)card recognizer:(UIPanGestureRecognizer*)pan
{
    
    if(card.isTaken)
    {
        //Touch starts
        if(pan.state == UIGestureRecognizerStateBegan)
        {
            
            //dubliziere aktuelle Karte und mache altes Feld frei
            self.cardDublicate = [[TCardField alloc] initWithFrame:card.frame];
             self.cardDublicate.position = card.position;
            [self.cardDublicate storeCardWithCardController:card.ov];
           
            [self.view addSubview:self.cardDublicate];
            [card showEmptyField:YES];
            
            //markiere nur die Felder die gültig sind und die, welche frei sind
            
            //Karte kommt von playersHand: markiere nur die freien und gültigen Felder
            if(card == self.playerHand1 || card == self.playerHand2 || card == self.playerHand3)
            {
                if(!card.isSpellCard)
                {
                    if(!self.playerField1.isTaken)
                        [self.playerField1 markField];
                    if(!self.playerField2.isTaken)
                        [self.playerField2 markField];
                    if(!self.playerField3.isTaken)
                        [self.playerField3 markField];
                }
                else
                {
                    if(!self.playerField4.isTaken)
                        [self.playerField4 markField];
                    if(!self.playerField5.isTaken)
                        [self.playerField5 markField];
                    if(!self.playerField6.isTaken)
                        [self.playerField6 markField];
                }
                
            }
            else
            {
                if(!card.isSpellCard)
                {
                    if(card == self.playerField1)
                    {
                        if(self.playerField2.isAssigned == NO)
                            [self.playerField2 markField];
                        
                        if(self.playerField3.isAssigned  == NO)
                            [self.playerField3 markField];
                    }
                    if(card == self.playerField2)
                    {
                        if(self.playerField1.isAssigned  == NO)
                            [self.playerField1 markField];
                        
                        if(self.playerField3.isAssigned  == NO)
                            [self.playerField3 markField];
                    }
                    if(card == self.playerField3)
                    {
                        if(self.playerField1.isAssigned  == NO)
                            [self.playerField1 markField];
                        
                        if(self.playerField2.isAssigned  == NO)
                            [self.playerField2 markField];
                    }
                    
                }
                else
                {
                    if(card == self.playerField4)
                    {
                        if(self.playerField5.isAssigned  == NO)
                            [self.playerField5 markField];
                        
                        if(self.playerField6.isAssigned  == NO)
                            [self.playerField6 markField];
                    }
                    if(card == self.playerField5)
                    {
                        if(self.playerField5.isAssigned  == NO)
                            [self.playerField4 markField];
                        
                        if(self.playerField6.isAssigned  == NO)
                            [self.playerField6 markField];
                    }
                    if(card == self.playerField6)
                    {
                        if(self.playerField4.isAssigned  == NO)
                            [self.playerField4 markField];
                        
                        if(self.playerField5.isAssigned  == NO)
                            [self.playerField5 markField];
                    }
                    
                }
            }
            
        }
        //Dragging
        if(pan.state == UIGestureRecognizerStateChanged)
        {
            
            CGPoint delta = [pan translationInView: self.cardDublicate.superview];
            CGPoint c = self.cardDublicate.center;
            c.x += delta.x; c.y += delta.y;
            self.cardDublicate.center = c;
            [pan setTranslation: CGPointZero inView: self.cardDublicate.superview];
        }
        //Touch ended or cancelled
        if(pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled)
        {
            //demarkiere alle Felder
            [self.playerField1 demarkField];
            [self.playerField2 demarkField];
            [self.playerField3 demarkField];
            [self.playerField4 demarkField];
            [self.playerField5 demarkField];
            [self.playerField6 demarkField];
            
            CGPoint endedTouch = [pan locationInView:self.view];
            UIView *targetView = [self.view hitTest:endedTouch withEvent:nil];
            
            //ist target view ein Kartenfeld
            if([targetView isKindOfClass:[TCardField class]] && (targetView != self.playerHand1 && targetView != self.playerHand2 && targetView != self.playerHand3))
            {
                TCardField *targetField = (TCardField*) targetView;
                
                
                
                //Wenn Karte KEINE Spellkarte ist, kann sie nur auf den Feldern 1,2,3 abgelegt werden
                if(card.isSpellCard == NO && targetField.isAssigned == NO &&(targetField == self.playerField1 || targetField == self.playerField2 || targetField == self.playerField3))
                {
                    //ist kartenFeld bereits besetzt. Tausche!!!
                    if(targetField.isTaken)
                    {
                        //Tauschen mit Karten von playersHand nicht möglich. Karten die liegen, liegen eben ;)
                        if(card == self.playerHand1 || card == self.playerHand2 || card == self.playerHand3)
                           
                        {
                            //Bewege Karte wieder zurück
                            [UIView animateWithDuration:0.2f animations:^{self.cardDublicate.center = card.center;}
                                             completion:^(BOOL finished)
                             {
                                 [card showEmptyField:NO];
                                 
                                 [self.cardDublicate removeFromSuperview];
                                 self.cardDublicate = nil;
                                 return;
                             }];
                            
                        }
                        else
                        {
                            
                            //bewege Karte in die Mitte der targetKarte und tausche dann
                            [UIView animateWithDuration:0.2f animations:^{self.cardDublicate.center = targetField.center;}
                                             completion:^(BOOL finished)
                             {
                                 
                                 TCardField *tempCard = [[TCardField alloc] initWithFrame:targetField.frame];
                                 tempCard.position = targetField.position;
                                 [tempCard storeCardWithCardController:targetField.ov];
                                 
                                 [card storeCardWithCardController:tempCard.ov];
                                 
                                 [targetField storeCardWithCardController:self.cardDublicate.ov];
                                 [self.cardDublicate removeFromSuperview];
                                 self.cardDublicate = nil;
                                 
                                [self.gameManager moveCard:card];
                                 return;
                             }];
                        }
                    }
                    else  //Feld ist noch leer
                    {
                        
                        //bewege Karte in die Mitte der targetKarte
                        [UIView animateWithDuration:0.2f animations:^{self.cardDublicate.center = targetField.center;}
                                         completion:^(BOOL finished)
                         {
                             
                             [targetField storeCardWithCardController:self.cardDublicate.ov];
                             [self.gameManager moveCard:card];
                             [card releaseCard];
                             [self.cardDublicate removeFromSuperview];
                             self.cardDublicate = nil;
                           
                             
                             return;
                         }];
                    }
                }
                //Wenn Karte eine Spellkarte ist, kann sie nur auf den Feldern 1,2,3 abgelegt werden
                else if(card.isSpellCard == YES  && targetField.isAssigned == NO && (targetField == self.playerField4 || targetField == self.playerField5 || targetField == self.playerField6) )
                {
                    //ist kartenFeld bereits besetzt. Tausche!!!
                    if(targetField.isTaken)
                    {
                        //Tauschen mit Karten von playersHand nicht möglich. Karten die liegen, liegen eben ;)
                        if(card == self.playerHand1 || card == self.playerHand2 || card == self.playerHand3)
                        {
                            //Bewege Karte wieder zurück
                            [UIView animateWithDuration:0.2f animations:^{self.cardDublicate.center = card.center;}
                                             completion:^(BOOL finished)
                             {
                                 [card showEmptyField:NO];
                                 
                                 [self.cardDublicate removeFromSuperview];
                                 self.cardDublicate = nil;
                                 return;
                             }];
                            
                        }
                        else 
                        {
                            //bewege Karte in die Mitte der targetKarte und tausche dann
                            [UIView animateWithDuration:0.2f animations:^{self.cardDublicate.center = targetField.center;}
                                             completion:^(BOOL finished)
                             {
                                 
                                 TCardField *tempCard = [[TCardField alloc] initWithFrame:targetField.frame];
                                tempCard.position = targetField.position;
                                 [tempCard storeCardWithCardController:targetField.ov];
                                 [card storeCardWithCardController:tempCard.ov];
                                 
                                 [targetField storeCardWithCardController:self.cardDublicate.ov];
                                 [self.cardDublicate removeFromSuperview];
                                 self.cardDublicate = nil;
                                [self.gameManager moveCard:card];
                                 return;
                             }];
                        }
                    }
                    else //Feld ist noch leer   //Feld ist noch leer
                    {
                        
                        //bewege Karte in die Mitte der targetKarte
                        [UIView animateWithDuration:0.2f animations:^{self.cardDublicate.center = targetField.center;}
                                         completion:^(BOOL finished)
                         {
                             
                             [targetField storeCardWithCardController:self.cardDublicate.ov];
                              [self.gameManager moveCard:card];
                             [card releaseCard];
                             [self.cardDublicate removeFromSuperview];
                             self.cardDublicate = nil;
                           
                             return;
                         }];
                    }

                }

                else    //Karte ist KEINE Spellkarte und wurde versucht auf feld 4,5 oder 6 zu legen, was aber nicht geht
                {
                    //Bewege Karte wieder zurück
                    [UIView animateWithDuration:0.2f animations:^{self.cardDublicate.center = card.center;}
                                     completion:^(BOOL finished)
                     {
                         [card storeCardWithCardController:self.cardDublicate.ov];
                         [card showEmptyField:NO];
                        
                         [self.cardDublicate removeFromSuperview];
                          self.cardDublicate = nil;
                         return;
                     }];
                    
                }
                
                             
                
            }
            else    //kein Kartenfeld getroffen oder kein gültiges Kartenfeld
            {
                
                //Bewege Karte wieder zurück
                [UIView animateWithDuration:0.2f animations:^{self.cardDublicate.center = card.center;}
                                 completion:^(BOOL finished)
                 {
                     [card storeCardWithCardController:self.cardDublicate.ov];
                     [card showEmptyField:NO];
                     [self.cardDublicate removeFromSuperview];
                      self.cardDublicate = nil;
                     return;
                 }];
                
            }
            
            
        }
    }
    
}

- (IBAction)handlePanHandField1:(UIPanGestureRecognizer *)recognizer
{
    if(self.playerHand1.isTouchable)
        [self handlePanAction:self.playerHand1 recognizer:recognizer];
}
- (IBAction)handlePanHandField2:(UIPanGestureRecognizer *)recognizer
{
     if(self.playerHand2.isTouchable)
         [self handlePanAction:self.playerHand2 recognizer:recognizer];

}
- (IBAction)handlePanHandField3:(UIPanGestureRecognizer *)recognizer
{
     if(self.playerHand3.isTouchable)
         [self handlePanAction:self.playerHand3 recognizer:recognizer];
}

- (IBAction)handlePanField1:(UIPanGestureRecognizer *)recognizer
{
     if(self.playerField1.isTouchable && !self.playerField1.isAssigned)
         [self handlePanAction:self.playerField1 recognizer:recognizer];
}
- (IBAction)handlePanField2:(UIPanGestureRecognizer *)recognizer
{
    if(self.playerField2.isTouchable && !self.playerField2.isAssigned)
        [self handlePanAction:self.playerField2 recognizer:recognizer];
}
- (IBAction)handlePanField3:(UIPanGestureRecognizer *)recognizer
{
    if(self.playerField3.isTouchable && !self.playerField3.isAssigned)
        [self handlePanAction:self.playerField3 recognizer:recognizer];
}
- (IBAction)handlePanField4:(UIPanGestureRecognizer *)recognizer
{
    if(self.playerField4.isTouchable && !self.playerField4.isAssigned)
        [self handlePanAction:self.playerField4 recognizer:recognizer];
}
- (IBAction)handlePanField5:(UIPanGestureRecognizer *)recognizer
{
    if(self.playerField5.isTouchable && !self.playerField5.isAssigned)
        [self handlePanAction:self.playerField5 recognizer:recognizer];
    
}
- (IBAction)handlePanField6:(UIPanGestureRecognizer *)recognizer
{
    if(self.playerField6.isTouchable && !self.playerField6.isAssigned)
        [self handlePanAction:self.playerField6 recognizer:recognizer];
}


////////////////////////////////////////////////////
////////////TAP_ACTIONS////////////////////////////
//////////////////////////////////////////////////
#pragma mark TAP_ACTIONS

-(IBAction)handleSingleTap:(UITapGestureRecognizer*)recognizer
{
    
    CGPoint touch = [recognizer locationInView:self.view];
    UIView *touchedView = [self.view hitTest:touch withEvent:nil];
    //CGRect frame =  [self.cardDetailView convertRect:self.cardDetailView.bounds toView:self.view];
    
    if([touchedView isKindOfClass:[TCardField class]])
    {
        TCardField *cardField = (TCardField*) touchedView;
        
        if (cardField.isTaken && cardField.isHidden == NO)
        {
            [self.cardDetailView removeFromSuperview];
            NSLog(@"card touched");
            Product *productTouched = cardField.product;
            
            TDetailCardViewController *detailVc = [CardGenerator generateDetailCard:productTouched];
            UIImage *snapshot = [detailVc snapshotView];
            
            CGPoint center = CGPointMake(self.view.bounds.size.width * 0.5f, self.view.bounds.size.height * 0.5f);
            self.cardDetailView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 250)];
            self.cardDetailView.image = snapshot;
            self.cardDetailView.center = center;
            self.cardDetailView.userInteractionEnabled = YES;
            [self.view addSubview:self.cardDetailView];
            
            return;
            
        }
        else
        {
            
            [self.cardDetailView removeFromSuperview];
            self.cardDetailView = nil;
        }
        
    }
    else
    {
        [self.cardDetailView removeFromSuperview];
        self.cardDetailView = nil;
        
    }
    
    
    
}

-(IBAction)handleDoubleTap:(UITapGestureRecognizer*)recognizer
{
    
    
    CGPoint touch = [recognizer locationInView:self.view];
    
    UIView *touchedView = [self.view hitTest:touch withEvent:nil];
    
    if([touchedView isKindOfClass:[TCardField class]])
    {
        
        TCardField *cardField = (TCardField*) touchedView;
        
        if(cardField.isTouchable && cardField.isAssigned == NO &&
           (cardField != self.opponentField1 &&
            cardField != self.opponentField2 &&
            cardField != self.opponentField3 &&
            cardField != self.opponentField4 &&
            cardField != self.opponentField5 &&
            cardField != self.opponentField6 &&
            cardField != self.opponentHand1 &&
            cardField != self.opponentHand2 &&
            cardField != self.opponentHand3))
        {
            //Karte muss belegt sein und darf nicht von palyersHand sein (In der Hand soll nicht gedreht werden) und keine Spellcard
            if(cardField.isTaken && !cardField.isSpellCard && (cardField != self.playerHand1 && cardField != self.playerHand2 && cardField != self.playerHand3))
            {
                if(cardField.isInDefensePosition == YES)
                {
                    //Kein Feld getroffen. Verschiebe wieder auf Anfangsfeld
                    [UIView animateWithDuration:0.2f animations:^{
                        //Move the image view
                        [cardField setAttackPosition];
                        
                        
                        
                    }
                                     completion:^(BOOL finished)
                     {
                         [self.gameManager turnCard:cardField];
                         return;
                     }];
                    
                    
                }
                else
                {
                    //Kein Feld getroffen. Verschiebe wieder auf Anfangsfeld
                    [UIView animateWithDuration:0.2f animations:^{
                        //Move the image view
                        //   cardField.transform = CGAffineTransformMakeRotation(90 * M_PI/180);
                        [cardField setDefensePosition];
                        
                    }
                                     completion:^(BOOL finished)
                     {
                         
                         [self.gameManager turnCard:cardField];


                         return;
                     }];
                    
                }
                
                
            }
        }
    }
    
    
}

////////////////////////////////////////////////////
////////////PLAYER_ACTIONS////////////////////////////
//////////////////////////////////////////////////
#pragma mark PLAYER_ACTIONS
-(void)fillPlayersHand
{
    if(self.dataManger.player.cardsInGame.count > 0)
    {
        for(TCardField *c in self.view.subviews)
        {
            if(c == self.playerHand1 || c == self.playerHand2 || c == self.playerHand3)
            {
                if(c.isTaken == NO)
                {
                    [c storeCardWithCardController:[self.gameManager takeNextCard:self.dataManger.player]];
                    [self.gameManager nextCard:c];
                    
                }
            }
        }
        self.isInOperation = NO;
    }
    self.isInOperation = NO;
    self.playerDeckCounterLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.dataManger.player.cardsInGame.count];
    
}




///////////////////////////////////////////////
///BUTTON_ACTIONS//////////////////////////////
//////////////////////////////////////////////
#pragma mark BUTTON_ACTIONS

- (IBAction)readyBtnTouched:(UIButton *)sender
{

      // [self attackCards];
    [self assignTakenCards];
    if([self.gameData.gameState isEqualToString:GAMESTATE_FIRST_ROUND])
    {
        
        [self.dataManger sendReadyViaSocket];


        [self activateUserActions:NO];

    }
    
 
    if([self.gameData.gameState isEqualToString:GAMESTATE_PHASE_TWO])
    {
        [self attackCards];
        
     

        [self activateUserActions:NO];
    }

}

///////////////////////////////////////////////////
///BACKGROUND_ACTIONS//////////////////////////////
///////////////////////////////////////////////////
#pragma mark BACKGROUND_ACTIONS

-(void)activateUserActions:(BOOL)active
{
    [self.playerHand1 enableInteraction:active];
    [self.playerHand2 enableInteraction:active];
    [self.playerHand3 enableInteraction:active];
    [self.playerField1 enableInteraction:active];
    [self.playerField2 enableInteraction:active];
    [self.playerField3 enableInteraction:active];
    [self.playerField4 enableInteraction:active];
    [self.playerField5 enableInteraction:active];
    [self.playerField6 enableInteraction:active];
   
    self.readyBtn.enabled = active;
    
    

    
}

-(void)assignTakenCards
{
    if(self.playerField1.isTaken)
    {
        [self.playerField1 assignCard];
    }
    if(self.playerField2.isTaken)
    {
        [self.playerField2 assignCard];
    }
    if(self.playerField3.isTaken)
    {
        [self.playerField3 assignCard];
    }
    if(self.playerField4.isTaken)
    {
        [self.playerField4 assignCard];
    }
    if(self.playerField5.isTaken)
    {
        [self.playerField5 assignCard];
    }
    if(self.playerField6.isTaken)
    {
        [self.playerField6 assignCard];
    }
}
@end
