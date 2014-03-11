//
//  DataManager.m
//  TudorGame
//
//  Created by David Joerg on 14.02.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import "DataManager.h"
#import "Product.h"
#import "Nutritive.h"
#import "SHACode.h"
#import "Websocket.h"
#import "AppSpecificValues.h"

#import <RestKit/RestKit.h>
#import <RestKit/RKObjectMappingOperationDataSource.h>

@implementation DataManager


///////////////////////////////////////////////////////////////////////////////
//////// SINGLETON /////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
+ (id)sharedManager
{
    static DataManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
        
    });
    return sharedMyManager;
}

///////////////////////////////////////////////////////////////////////////////
//////// INIT /////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
- (id)init
{
    if (self = [super init])
    {
        self.player = [[Player alloc] init];
        [self loadCoreData];
        self.game = nil;
        [self resetPlayer];
        
    }
    return self;
}

-(void)resetPlayer
{
   
    self.player.lifePoints = [NSNumber numberWithInt:2000];
    
    //Nur zu testzwecken
   /* NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:20];
    
    for(int i = 0; i <= 20;i++)
    {
        Product *p = [[Product alloc] init];
        p.name = [NSString stringWithFormat:@"test %i", i ];
        
        
        int rand = arc4random() % 2;
        if(rand == 0)
        {
            int atk = arc4random_uniform(1000);
            int hp = arc4random_uniform(1000);
            int def = arc4random_uniform(2000);
            
            
            p.isSpellCard = [NSNumber numberWithBool:NO];
            p.atk = [NSNumber numberWithInt:atk];
            p.hp = [NSNumber numberWithInt:hp];
            p.def = [NSNumber numberWithInt:def];
        }
        else
        {
            p.isSpellCard = [NSNumber numberWithBool:YES];
            
            rand = arc4random() % 2;
            if(rand == 0)
            {
                p.spellValue = [NSNumber numberWithInt:-10];
                p.spelltype = SPELLTYPE_DECREMENT_ATK;
            }
            else
            {
                p.spellValue = [NSNumber numberWithInt:10];
                p.spelltype = SPELLTYPE_INCREMENT_ATK;
            }
        }
        
        [array addObject:p];
        
    }*/
    self.player.cardsInGame = [NSMutableArray arrayWithArray: self.player.products];
    self.game = nil;
 

}
///////////////////////////////////////////////////////////////////////////////
//////// WEBSOCKET /////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

-(void)connectUser
{
    self.player.status = nil;
    
    Websocket *socket = [Websocket sharedManager];
    
    [socket reconnect];
    
    
    
}

//Function: sendet username, password, appleID als USerdata zum Server
-(void)sendUserDataViaWebSocket
{
    Websocket *socket = [Websocket sharedManager];
    
    
    
    NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                         self.player.name, @"username",
                         [SHACode getHash: self.player.password], @"password",
                         self.player.currentID, @"id",
                         USERDATA, MESSAGE_TYPE,
                         nil];
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
    
    NSString *message = [[NSString alloc] initWithData:postdata encoding:NSUTF8StringEncoding];
    [socket sendMessage:message];
    
    
    
}

-(void)startGameViaWebsocket
{
    Websocket *socket = [Websocket sharedManager];
    
    
    
    NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                         self.player.name, @"username",
                         [SHACode getHash: self.player.password], @"password",
                         self.player.currentID, @"id",
                         self.game.gameID, @"gameID",
                         START_GAME, MESSAGE_TYPE,
                         nil];
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
    
    NSString *message = [[NSString alloc] initWithData:postdata encoding:NSUTF8StringEncoding];
    [socket sendMessage:message];
    

}

-(void)sendCardDictionary:(NSDictionary*)dict
{
    Websocket *socket = [Websocket sharedManager];
    

    
    NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                         self.player.name, @"username",
                         [SHACode getHash: self.player.password], @"password",
                         self.player.currentID, @"id",
                         self.game.gameID, @"gameID",
                         dict,@"cards",
                         GAMEDATA, MESSAGE_TYPE,
                         nil];
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
    
    NSString *message = [[NSString alloc] initWithData:postdata encoding:NSUTF8StringEncoding];
    [socket sendMessage:message];
    
    
}

-(void)sendReadyViaSocket
{
    Websocket *socket = [Websocket sharedManager];
    
     NSDictionary *playerJsonDict = [self mapPlayer:self.player];
    
    NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                         self.player.name, @"username",
                         [SHACode getHash: self.player.password], @"password",
                         self.player.currentID, @"id",
                         self.game.gameID, @"gameID",
                          playerJsonDict,@"player",
                         PLAYER_READY, MESSAGE_TYPE,
                         nil];
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
    
    NSString *message = [[NSString alloc] initWithData:postdata encoding:NSUTF8StringEncoding];
    [socket sendMessage:message];
    
    
}

-(void)sendAttackOpponentWithValue:(int)value
{
    Websocket *socket = [Websocket sharedManager];
    
    NSDictionary *playerJsonDict = [self mapPlayer:self.player];
    
    NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                         self.player.name, @"username",
                         [SHACode getHash: self.player.password], @"password",
                         self.player.currentID, @"id",
                         self.game.gameID, @"gameID",
                         GAMEDATA, MESSAGE_TYPE,
                         ATTACK_OPPONENT, ACTION_TYPE,
                         [NSNumber numberWithInt:value],@"value",
                         playerJsonDict,@"player",
                         nil];
    
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
    
    NSString *message = [[NSString alloc] initWithData:postdata encoding:NSUTF8StringEncoding];
    [socket sendMessage:message];

}
-(void)sendActionViaSocket:(NSString*)actionType andCard:(TOverviewCardViewController*)card;
{
    Websocket *socket = [Websocket sharedManager];
    NSDictionary *cardJsonDict;
    if(card != nil)
    {
        cardJsonDict = [self mapCard:card];
    }
    else
    {
        cardJsonDict = [[NSDictionary alloc] init];
    }
    NSDictionary *playerJsonDict = [self mapPlayer:self.player];
    
    NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                         self.player.name, @"username",
                         [SHACode getHash: self.player.password], @"password",
                         self.player.currentID, @"id",
                         self.game.gameID, @"gameID",
                         GAMEDATA, MESSAGE_TYPE,
                         actionType, ACTION_TYPE,
                         cardJsonDict,@"card",
                         playerJsonDict,@"player",
                         nil];

    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
    
    NSString *message = [[NSString alloc] initWithData:postdata encoding:NSUTF8StringEncoding];
    [socket sendMessage:message];
    
}



/*-(void)sendGameData:(Game*)gameData
{
    
    
    
    Websocket *socket = [Websocket sharedManager];
    
    NSDictionary *jsonDict = [self mapGameDataToDictionary:gameData];
    
    
    
    NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                         self.player.name, @"username",
                         [SHACode getHash: self.player.password], @"password",
                         self.player.currentID, @"id",
                         jsonDict, @"gameData",
                         GAMEDATA,MESSAGE_TYPE,
                         nil];
    
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
    
    
    NSString *message = [[NSString alloc] initWithData:postdata encoding:NSUTF8StringEncoding];
    NSLog(@"%@",message);
    [socket sendMessage:message];
    
}*/
-(void)getProductsViaWebsocket
{
    Websocket *socket = [Websocket sharedManager];
    
    
    
    NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                         self.player.name, @"username",
                         [SHACode getHash: self.player.password], @"password",
                         self.player.currentID, @"id",
                         GET_PRODUCTS,MESSAGE_TYPE,
                         nil];
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
    
    NSString *message = [[NSString alloc] initWithData:postdata encoding:NSUTF8StringEncoding];
    [socket sendMessage:message];
    
}

-(void)quitRunningGame
{
    Websocket *socket = [Websocket sharedManager];
    
    
    
    NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                         self.player.name, @"username",
                         [SHACode getHash: self.player.password], @"password",
                         self.player.currentID, @"id",
                         QUIT_GAME,MESSAGE_TYPE,
                         nil];
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
    
    NSString *message = [[NSString alloc] initWithData:postdata encoding:NSUTF8StringEncoding];
    [socket sendMessage:message];
    
    self.game = nil;
    
}

-(void)searchGameViaWebsocket
{
    Websocket *socket = [Websocket sharedManager];
    
    NSDictionary *playerJsonDict = [self mapPlayer:self.player];

    
    
    NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                         self.player.name, @"username",
                         [SHACode getHash: self.player.password], @"password",
                         self.player.currentID, @"id",
                         GET_GAME,MESSAGE_TYPE,
                         playerJsonDict,@"player",
                         nil];
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
    
    NSString *message = [[NSString alloc] initWithData:postdata encoding:NSUTF8StringEncoding];
    [socket sendMessage:message];
    
}


///////////////////////////////////////////////////////////////////////////////
//////// MAPPING /////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
#pragma mark MAPPING
-(NSDictionary*)mapPlayer:(Player*)player
{
    // Now configure the Nutritive mapping
    RKObjectMapping *nutritiveMapping = [RKObjectMapping mappingForClass:[Nutritive class] ];
    [nutritiveMapping addAttributeMappingsFromDictionary:@{
                                                           @"id": @"nutritiveID",
                                                           @"value": @"value",
                                                           @"name": @"name",
                                                           @"unit" : @"unit"
                                                           }];
    
    
    RKObjectMapping *productMapping = [RKObjectMapping mappingForClass:[Product class]];
    
    [productMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"nutritives"
                                                                                   toKeyPath:@"nutritives"
                                                                                 withMapping:nutritiveMapping]];
    [ productMapping addAttributeMappingsFromDictionary:@{@"eancode" : @"EANCode",
                                                          @"eantype" : @"EANType",
                                                          @"wikiFoodid" : @"wikiFoodID",
                                                          @"name" : @"name",
                                                          @"atk" :@"atk",
                                                          @"hp": @"hp",
                                                          @"def": @"def",
                                                          @"spellValue": @"spellValue",
                                                          @"spellType": @"spelltype",
                                                          @"spellCard": @"spellCard",
                                                          @"ingredients" : @"ingredients",
                                                          @"isInDefensePosition" : @"isInDefensePosition",
                                                          @"position" : @"position",
                                                          @"oldPosition" :@"oldPosition"
                                                          }];
    
    
    RKObjectMapping *playerMapping = [RKObjectMapping mappingForClass:[Player class]];
    [playerMapping addAttributeMappingsFromDictionary:@{
                                                        @"name":                      @"name",
                                                        @"lifePoints":          @"lifePoints",
                                                        @"isInTurn":              @"isInTurn",
                                                        @"id":                    @"currentID",
                                                        }];
    
    [playerMapping addPropertyMapping:[RKRelationshipMapping  relationshipMappingFromKeyPath:@"cardsInGame" toKeyPath:@"cardsInGame" withMapping:productMapping]];
    
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionary];
    RKObjectMappingOperationDataSource *dataSource = [RKObjectMappingOperationDataSource new];
    RKMappingOperation *operation = [[RKMappingOperation alloc] initWithSourceObject:player
                                                                   destinationObject:jsonDict
                                                                             mapping:[playerMapping inverseMapping]];
    operation.dataSource = dataSource;
    
    NSError *error = nil;
    [operation performMapping:&error];
    
    if(!error)
    {
        return (NSDictionary*)jsonDict;
    }
    
    return nil;
    

}

-(NSDictionary*)mapCard:(TOverviewCardViewController*)card
{
    // Now configure the Nutritive mapping
    RKObjectMapping *nutritiveMapping = [RKObjectMapping mappingForClass:[Nutritive class] ];
    [nutritiveMapping addAttributeMappingsFromDictionary:@{
                                                           @"id": @"nutritiveID",
                                                           @"value": @"value",
                                                           @"name": @"name",
                                                           @"unit" : @"unit"
                                                           }];
    
    
    RKObjectMapping *productMapping = [RKObjectMapping mappingForClass:[Product class]];
    
    [productMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"nutritives"
                                                                                   toKeyPath:@"nutritives"
                                                                                 withMapping:nutritiveMapping]];
    [ productMapping addAttributeMappingsFromDictionary:@{@"eancode" : @"EANCode",
                                                          @"eantype" : @"EANType",
                                                          @"wikiFoodid" : @"wikiFoodID",
                                                          @"name" : @"name",
                                                          @"atk" :@"atk",
                                                          @"hp": @"hp",
                                                          @"def": @"def",
                                                          @"spellValue": @"spellValue",
                                                          @"spellType": @"spelltype",
                                                         //@"ingredients" : @"ingredients",
                                                          @"isInDefensePosition" : @"isInDefensePosition",
                                                          @"spellCard" : @"spellCard",
                                                          @"position" :@"position",
                                                          @"oldPosition" :@"oldPosition"
                                                          }];
    
    

    

    RKObjectMapping *cardMapping = [RKObjectMapping mappingForClass:[TOverviewCardViewController class]];
    [cardMapping addAttributeMappingsFromDictionary:@{
                                                       
                                                        }];
    
   [cardMapping addPropertyMapping:[RKRelationshipMapping  relationshipMappingFromKeyPath:@"product" toKeyPath:@"product" withMapping:productMapping]];

    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionary];
    RKObjectMappingOperationDataSource *dataSource = [RKObjectMappingOperationDataSource new];
    RKMappingOperation *operation = [[RKMappingOperation alloc] initWithSourceObject:card
                                                                   destinationObject:jsonDict
                                                                             mapping:[cardMapping inverseMapping]];
    operation.dataSource = dataSource;
    
    NSError *error = nil;
    [operation performMapping:&error];
    
    if(!error)
    {
        return (NSDictionary*)jsonDict;
    }
    
    return nil;


}
-(NSDictionary*)mapGameDataToDictionary:(Game*)gameData
{
    // Now configure the Nutritive mapping
    RKObjectMapping *nutritiveMapping = [RKObjectMapping mappingForClass:[Nutritive class] ];
    [nutritiveMapping addAttributeMappingsFromDictionary:@{
                                                           @"id": @"nutritiveID",
                                                           @"value": @"value",
                                                           @"name": @"name",
                                                           @"unit" : @"unit"
                                                           }];
    
    
    RKObjectMapping *productMapping = [RKObjectMapping mappingForClass:[Product class]];
    
    [productMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"nutritives"
                                                                                   toKeyPath:@"nutritives"
                                                                                 withMapping:nutritiveMapping]];
    [ productMapping addAttributeMappingsFromDictionary:@{@"eancode" : @"EANCode",
                                                          @"eantype" : @"EANType",
                                                          @"wikiFoodid" : @"wikiFoodID",
                                                          @"name" : @"name",
                                                          @"atk" :@"atk",
                                                          @"hp": @"hp",
                                                          @"def": @"def",
                                                          @"spellValue": @"spellValue",
                                                          @"spellType": @"spelltype",
                                                          @"spellCard":@"spellCard",
                                                          @"ingredients" : @"ingredients",
                                                          @"position" : @"position",
                                                          @"oldPosition" :@"oldPosition"
                                                          }];
    

    RKObjectMapping *playerMapping = [RKObjectMapping mappingForClass:[Opponent class]];
    [playerMapping addAttributeMappingsFromDictionary:@{
                                                        @"name":                      @"name",
                                                        @"lifePoints":          @"lifePoints",
                                                        @"isInTurn":              @"isInTurn",
                                                        @"id":                    @"currentID",
                                                        @"cardsInGame":           @"cardsInGame",
                                                        }];
    
    /*[playerMapping addPropertyMapping:[RKRelationshipMapping  relationshipMappingFromKeyPath:@"cardsInDeck" toKeyPath:@"cardsInDeck" withMapping:productMapping]];
    [playerMapping addPropertyMapping:[RKRelationshipMapping  relationshipMappingFromKeyPath:@"cardsOnField" toKeyPath:@"cardsOnField" withMapping:productMapping]];
    [playerMapping addPropertyMapping:[RKRelationshipMapping  relationshipMappingFromKeyPath:@"cardsOnHand" toKeyPath:@"cardsOnHand" withMapping:productMapping]];*/
    
    // Setting up objectmapping for issue
    RKObjectMapping *gameMapping = [RKObjectMapping mappingForClass:[Game class]];
    
    [gameMapping addPropertyMapping:[RKRelationshipMapping  relationshipMappingFromKeyPath:@"opponent" toKeyPath:@"opponent" withMapping:playerMapping]];
    
    [gameMapping addAttributeMappingsFromDictionary:@{
                                                      @"gameState":                      @"gameState",
                                                      @"gameStatus":                     @"gameStatus",
                                                      @"id":                         @"gameID",
                                                      
                                                      
                                                      }];
    
    
    
    
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionary];
    RKObjectMappingOperationDataSource *dataSource = [RKObjectMappingOperationDataSource new];
    RKMappingOperation *operation = [[RKMappingOperation alloc] initWithSourceObject:gameData
                                                                   destinationObject:jsonDict
                                                                             mapping:[gameMapping inverseMapping]];
    operation.dataSource = dataSource;
    
    NSError *error = nil;
    [operation performMapping:&error];
    
    if(!error)
    {
        return (NSDictionary*)jsonDict;
    }
    
    return nil;
    
    
}




-(void)mapProductsFromDictionary:(NSDictionary*)productsDict
{
    // Now configure the Nutritive mapping
    RKObjectMapping *nutritiveMapping = [RKObjectMapping mappingForClass:[Nutritive class] ];
    [nutritiveMapping addAttributeMappingsFromDictionary:@{
                                                           @"id": @"nutritiveID",
                                                           @"value": @"value",
                                                           @"name": @"name",
                                                           @"unit" : @"unit"
                                                           }];
    
    
    RKObjectMapping *productMapping = [RKObjectMapping mappingForClass:[Product class]];
    
    [productMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"nutritives"
                                                                                   toKeyPath:@"nutritives"
                                                                                 withMapping:nutritiveMapping]];
    [ productMapping addAttributeMappingsFromDictionary:@{@"eancode" : @"EANCode",
                                                          @"eantype" : @"EANType",
                                                          @"wikiFoodid" : @"wikiFoodID",
                                                          @"name" : @"name",
                                                          @"atk" :@"atk",
                                                          @"hp": @"hp",
                                                          @"def": @"def",
                                                          @"spellValue": @"spellValue",
                                                          @"spellType": @"spelltype",
                                                          @"spellCard": @"spellCard",
                                                          @"ingredients" : @"ingredients",
                                                          @"position" : @"position",
                                                          @"oldPosition" :@"oldPosition"
                                                          }];
    
    
    RKObjectMapping *productsMapping = [RKObjectMapping mappingForClass:[Player class]];
    [productsMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"products"
                                                                                    toKeyPath:@"products"
                                                                                  withMapping:productMapping]];
    
   /* [productsMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"products"
                                                                                    toKeyPath:@"cardsInDeck"
                                                                                  withMapping:productMapping]];*/
    
    
    
    
    
    NSDictionary *mappingsDictionary = @{ @"": productsMapping };
    RKMapperOperation *mapper = [[RKMapperOperation alloc] initWithRepresentation:productsDict mappingsDictionary:mappingsDictionary];
    mapper.targetObject = self.player;
    NSError *mappingError = nil;
    BOOL isMapped = [mapper execute:&mappingError];
    if (isMapped && !mappingError)
    {
        // Yay! Mapping finished successfully
       // NSLog(@"mapper: %@", [mapper representation]);
     
        // self.products= game;
        
    }
    
    
    
    
    
}


-(void)mapGameFromDictionary:(NSDictionary*)gameDict
{
    
    // Now configure the Nutritive mapping
    RKObjectMapping *nutritiveMapping = [RKObjectMapping mappingForClass:[Nutritive class] ];
    [nutritiveMapping addAttributeMappingsFromDictionary:@{
                                                           @"id": @"nutritiveID",
                                                           @"value": @"value",
                                                           @"name": @"name",
                                                           @"unit" : @"unit"
                                                           }];
    
    
    RKObjectMapping *productMapping = [RKObjectMapping mappingForClass:[Product class]];
    
    [productMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"nutritives"
                                                                                   toKeyPath:@"nutritives"
                                                                                 withMapping:nutritiveMapping]];
    [ productMapping addAttributeMappingsFromDictionary:@{@"eancode" : @"EANCode",
                                                          @"eantype" : @"EANType",
                                                          @"wikiFoodid" : @"wikiFoodID",
                                                          @"name" : @"name",
                                                          @"atk" :@"atk",
                                                          @"hp": @"hp",
                                                          @"def": @"def",
                                                          @"spellValue": @"spellValue",
                                                          @"spellType": @"spelltype",
                                                          @"ingredients" : @"ingredients",
                                                          @"isInDefensePosition" : @"isInDefensePosition",
                                                          @"spellCard" : @"spellCard",
                                                          @"position" : @"position",
                                                          @"oldPosition" :@"oldPosition"
                                                          }];
    
    
    
    
    
    //Setting up objectmapping for article
    RKObjectMapping *playerMapping = [RKObjectMapping mappingForClass:[Opponent class]];
    [playerMapping addAttributeMappingsFromDictionary:@{
                                                      @"name":                      @"name",
                                                      @"lifePoints":          @"lifePoints",
                                                      @"isInTurn":              @"isInTurn",
                                                      @"id":                    @"currentID",
                                                      
                                                      }];
    [playerMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"cardsInGame"
                                                                                toKeyPath:@"cardsInGame"
                                                                              withMapping:productMapping]];
    
    RKObjectMapping *cardMapping = [RKObjectMapping mappingForClass:[TOverviewCardViewController class]];
    
    [cardMapping addPropertyMapping:[RKRelationshipMapping  relationshipMappingFromKeyPath:@"product" toKeyPath:@"product" withMapping:productMapping]];

    // Setting up objectmapping for issue
    RKObjectMapping *gameMapping = [RKObjectMapping mappingForClass:[Game class]];
       [gameMapping addPropertyMapping:[RKRelationshipMapping  relationshipMappingFromKeyPath:@"opponent" toKeyPath:@"opponent" withMapping:playerMapping]];
    
    [gameMapping addPropertyMapping:[RKRelationshipMapping  relationshipMappingFromKeyPath:@"card" toKeyPath:@"playedCard" withMapping:cardMapping]];
    

    
    
    
    [gameMapping addAttributeMappingsFromDictionary:@{
                                                      @"gameStatus":                      @"gameStatus",
                                                      @"id":                         @"gameID",
                                                      @"gameState":                   @"gameState",
                                                      @"actionType" : @"actionType",

                                                      }];
    

    if(self.game == nil)
    {
        self.game = [[Game alloc] init];
    }
    
    NSDictionary *mappingsDictionary = @{ @"": gameMapping };
    RKMapperOperation *mapper = [[RKMapperOperation alloc] initWithRepresentation:gameDict mappingsDictionary:mappingsDictionary];
    mapper.targetObject = self.game;
    NSError *mappingError = nil;
    BOOL isMapped = [mapper execute:&mappingError];
    if (isMapped && !mappingError)
    {
        // Yay! Mapping finished successfully
       // NSLog(@"mapper: %@", [mapper representation]);

        
    }
    
    
}


///////////////////////////////////////////////////////////////////////////////
//////// PLAYER /////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

//Function: prüft ob Login und passsword bereits eingegeben wurden
-(BOOL)hasLoginNameAndPassword
{
    if(self.coreData.name != nil && self.coreData.password !=nil)
        return YES;
    
    return NO;
}



//Function: speichert neuen usernamen und passwort
-(BOOL)saveUsername: (NSString*)name andPassword:(NSString*)password
{
    //Save username and Password to core Data
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *userData;
    NSError *error;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserData"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects =  [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];;
    
    if([fetchedObjects firstObject])
    {
        userData = [fetchedObjects firstObject];
        
    }
    else
    {
        userData = [NSEntityDescription  insertNewObjectForEntityForName: @"UserData"
                                                  inManagedObjectContext:context];
        
    }
    
    
    
    [userData setValue:name forKey:@"name"];
    
    [userData setValue:password forKey:@"password"];
    
    // Save the object to persistent store
    if (![context save:&error])
    {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        return NO;
    }
    
    [self loadCoreData];
    
    return YES;
    
}



///////////////////////////////////////////////////////////////////////////////
////////Core Data/////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)])
    {
        context = [delegate managedObjectContext];
    }
    return context;
}


//Function: lädt die persistent gespeicherten Daten des users
-(BOOL)loadCoreData
{
    NSError *error;
    //Save username and Password to core Data
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // Test listing all FailedBankInfos from the store
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserData"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    //Checke ob ein userData Objekt vorliegt
    if([fetchedObjects firstObject])
    {
        self.coreData = [fetchedObjects firstObject];
        
        self.player.name = self.coreData.name;
        self.player.password = self.coreData.password;
           
        return YES;
    }
    
    return  NO;
}


@end
