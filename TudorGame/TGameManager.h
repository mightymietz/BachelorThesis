//
//  TGameManager.h
//  TudorGame
//
//  Created by David Joerg on 12.02.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Game.h"
#import "TGameViewController.h"
#import "Player.h"
#import "Opponent.h"
#import "CardGenerator.h"

@interface TGameManager : NSObject


-(id)initGameManagerWithViewController:(TGameViewController*)vc;
-(void)updateGame:(Game*)game;
-(TOverviewCardViewController*)takeNextCard:(Player*)player;
-(void)nextCard:(TCardField*)card;
-(void)moveCard:(TCardField*)card;
-(void)turnCard:(TCardField*)card;
-(void)attackOpponentWithValue:(int)value;

-(void)sendCardDictionary:(NSDictionary*)dict;
-(UIImage*)flipCard:(Player*)player;
-(void)attackWithCard:(TCardField*)card;
-(void)buffWithCard:(TCardField*)card;
-(void)playCard;
-(NSMutableArray*)fillHand:(Player*)player;
-(void)setUp;
@end
