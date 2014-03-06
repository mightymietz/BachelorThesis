//
//  Game.h
//  TudorGame
//
//  Created by David Joerg on 30.01.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Opponent.h"
#import <RestKit/RestKit.h>
#import "TOverviewCardViewController.h"
#import "Player.h"
@interface Game : NSObject 


@property(nonatomic, copy) NSString *gameID;
@property(nonatomic, copy) NSString *gameStatus;
@property(nonatomic, copy) NSString *gameState;
@property(nonatomic, copy) NSString *actionType;
@property(nonatomic, retain) Opponent *opponent;
@property(nonatomic, retain) Player *player;
@property(nonatomic, retain) TOverviewCardViewController *playedCard;



@end
