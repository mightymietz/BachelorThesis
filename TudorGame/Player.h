//
//  User.h
//  TudorGame
//
//  Created by David Joerg on 16.01.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Player : NSObject



@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *password;
@property(nonatomic, copy) NSString *currentID;
@property(nonatomic, retain) NSMutableArray *products;
@property(nonatomic, retain) NSMutableArray *cardsInDeck;
@property(nonatomic, copy) NSMutableArray *cardsOnHand;
@property(nonatomic, copy) NSMutableArray *cardsOnField;
@property(nonatomic, retain) NSMutableArray *cardsInGame;
@property(nonatomic, copy) NSNumber *lifePoints;
@property(nonatomic) int points;
@property(nonatomic, copy) NSNumber *isInTurn;
@property(nonatomic, retain) NSString* status;


@end
