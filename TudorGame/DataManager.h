//
//  DataManager.h
//  TudorGame
//
//  Created by David Joerg on 14.02.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Game.h"
#import "UserData.h"
#import "Player.h"
#import "TOverviewCardViewController.h"
@interface DataManager : NSObject
@property(nonatomic, retain) Game *game;
@property(nonatomic, retain) Player *player;
@property(strong) UserData *coreData;
@property(nonatomic, retain) Product *receivedProduct;
@property(nonatomic, retain) NSString *receivedQuestion;

+ (id)sharedManager;

-(void)connectUser;
-(BOOL)hasLoginNameAndPassword;
-(BOOL)saveUsername: (NSString*)name andPassword:(NSString*)password;
-(void)sendUserDataViaWebSocket;
-(void)getProductsViaWebsocket;
-(void)getProductViaWebsocket:(NSString*)eanCode;
-(void)getNewProductViaWebsocket;
-(void)getQuestionViaWebsocket:(NSString*)eanCode;
-(void)searchGameViaWebsocket;
-(void)startGameViaWebsocket;
-(void)sendReadyViaSocket;
-(void)sendCardDictionary:(NSDictionary*)dict;
-(void)sendAttackOpponentWithValue:(int)value;
-(void)sendActionViaSocket:(NSString*)actionType andCard: (TOverviewCardViewController*)card;
-(void)quitRunningGame;
-(void)resetPlayer;
/////////MAPPING//////////////////////////
-(void)mapProductsFromDictionary:(NSDictionary*)productsDict;
-(void)mapGameFromDictionary:(NSDictionary*)gameDict;
-(void)mapReceivedProductFromDictionary:(NSDictionary*)productsDict;
-(NSDictionary*)mapGameDataToDictionary:(Game*)gameData;
@end
