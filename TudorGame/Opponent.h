//
//  Opponent.h
//  TudorGame
//
//  Created by David Joerg on 13.02.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface Opponent : NSObject


@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *currentID;
@property(nonatomic, copy) NSNumber *lifePoints;
@property(nonatomic, copy) NSSet *cardsInGame;
@property(nonatomic, copy) NSNumber *isInTurn;
@end
