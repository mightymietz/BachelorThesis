//
//  TGameManager.m
//  TudorGame
//
//  Created by David Joerg on 12.02.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import "TGameManager.h"
#import "DataManager.h"
#import "Product.h"
#import "AppSpecificValues.h"
@interface TGameManager()
@property (nonatomic, retain) TGameViewController *vc;
@property (nonatomic, retain) Player *player;
@property (nonatomic, retain) Opponent *opponent;
@property (nonatomic, retain) Game *game;
@property(nonatomic, retain) DataManager *dataManager;
@end
@implementation TGameManager

-(id)initGameManagerWithViewController:(TGameViewController*)vc
{
    self = [super init];
    
    if(self)
    {
        self.vc = vc;
    
    }
    
    return self;
}

-(void)setUp
{
    
    self.dataManager = [DataManager sharedManager];
    self.player = self.dataManager.player;
    self.game = self.dataManager.game;
    self.opponent = self.dataManager.game.opponent;
    if(self.dataManager.player.cardsInDeck.count <= 0)
    {
        self.player.cardsInDeck = [NSMutableArray arrayWithArray:self.player.products];
    }
    //self.player.cardsInDeck =[NSMutableArray arrayWithArray: self.player.products];
    NSMutableArray *array = [[NSMutableArray alloc ] init];
    for(int i = 0; i < self.player.cardsInDeck.count;i++)
    {
        Product *p = [self.player.cardsInDeck objectAtIndex:i];
        
        Product *copiedP = [[Product alloc] init];
        copiedP.EANCode = p.EANCode;
        copiedP.EANType = p.EANType;
        copiedP.wikiFoodID = p.wikiFoodID;
        copiedP.name = p.name;
        copiedP.atk = p.atk;
        copiedP.hp = p.hp;
        copiedP.def = p.def;
        copiedP.spellValue = p.spellValue;
        copiedP.spelltype = p.spelltype;
        copiedP.spellCard = p.spellCard;
        copiedP.position = p.position;
        copiedP.oldPosition = p.oldPosition;
        copiedP.isInDefensePosition = p.isInDefensePosition;
        copiedP.country = p.country;
        copiedP.ingredients = p.ingredients;
        copiedP.nutritives = p.nutritives;
        copiedP.sortedNutritives = p.sortedNutritives;
        
        [array addObject:p];
    }
    self.player.cardsInGame = [self shuffleProducts:array];



}

-(NSMutableArray*)shuffleProducts:(NSArray*)products
{
    NSMutableArray *temp = [NSMutableArray arrayWithArray:products];
    NSUInteger count = [temp count];
    for (NSUInteger i = 0; i < count; ++i)
    {
        // Select a random element between i and end of array to swap with.
        NSInteger nElements = count - i;
        NSInteger n = arc4random_uniform((int)nElements) + i;
        [temp exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    
    return temp;
}
-(void)updateGame:(Game*)game;
{
    
    self.game = game;
    
    [self notifyViewController];
}

-(void)notifyViewController
{
    
    [self.vc updateGame:self.game];
}

-(TOverviewCardViewController*)takeNextCard:(Player*)player
{
    
    TOverviewCardViewController *nextCard = nil;

    if(player.cardsInGame.count > 0)
    {
        nextCard = [CardGenerator generateOverviewCard: [player.cardsInGame firstObject]];
    
        [player.cardsInGame removeObject:[player.cardsInGame firstObject]];
    }

    return nextCard;
 
}

/////////////////////////////////////////////////////////////////
//////WEBSOCKET_ACTIONS/////////////////////////////////////////
////////////////////////////////////////////////////////////////
-(void)attackWithCard:(TCardField*)card
{
    [self.dataManager sendActionViaSocket:ATTACK_CARD andCard:card.ov];
}
-(void)buffWithCard:(TCardField*)card
{
     [self.dataManager sendActionViaSocket:SPELL_CARD andCard:card.ov];
}

-(void)sendCardDictionary:(NSDictionary*)dict
{
    [self.dataManager sendCardDictionary:dict];
}

-(void)attackOpponentWithValue:(int)value
{
    [self.dataManager sendAttackOpponentWithValue:value];
}
/*-(TOverviewCardViewController*)fillHand:(Player*)player
{
    
    if(player.cardsInGame.count >=1)
    {
        TOverviewCardViewController *nextCard = [CardGenerator generateOverviewCard: player.cardsInGame[0]];
        [player.cardsInGame removeObjectAtIndex:0];
        
        
        [self.dataManager sendActionViaSocket:FILLED_DECK];
        return nextCard;

    }
    
    return nil;
    
}*/

-(void)moveCard:(TCardField*)card
{
    
    [self.dataManager sendActionViaSocket:MOVE_CARD andCard:card.ov];

}

-(void)nextCard:(TCardField*)card
{
    
    [self.dataManager sendActionViaSocket:NEXT_CARD andCard:card.ov];
}

-(void)turnCard:(TCardField*)card
{
    [self.dataManager sendActionViaSocket:TURN_CARD andCard:card.ov];

}

@end
