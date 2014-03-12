//
//  User.m
//  TudorGame
//
//  Created by David Joerg on 16.01.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import "Player.h"
#import "Product.h"
#import "AppSpecificValues.h"
#import "Nutritive.h"
#import "Player.h"
#import "SHACode.h"
#import "Websocket.h"
#import <RestKit/RestKit.h>
#import <RestKit/RKObjectMappingOperationDataSource.h>
@implementation Player 



/*-(void)connectUser
{
    self.status = nil;
    
    Websocket *socket = [Websocket sharedManager];
 
    [socket reconnect];
    

    
}

//Function: sendet username, password, appleID als USerdata zum Server
-(void)sendUserDataViaWebSocket
{
    Websocket *socket = [Websocket sharedManager];
    
    
    
    NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                         self.name, @"username",
                         [SHACode getHash: self.password], @"password",
                         self.currentID, @"id",
                         USERDATA,MESSAGE_TYPE,
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
                         self.name, @"username",
                         [SHACode getHash: self.password], @"password",
                         self.currentID, @"id",  self.game.gameID, @"gameID",
                         START_GAME,MESSAGE_TYPE,
                         nil];
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
    
    NSString *message = [[NSString alloc] initWithData:postdata encoding:NSUTF8StringEncoding];
    [socket sendMessage:message];
    
    self.game = nil;
}

-(void)sendGameData:(Game*)gameData
{
    
   

    Websocket *socket = [Websocket sharedManager];

    NSDictionary *jsonDict = [self mapGameDataToDictionary:gameData];
    
    
    
    NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                         self.name, @"username",
                         [SHACode getHash: self.password], @"password",
                         self.currentID, @"id",
                         jsonDict, @"gameData",
                         GAMEDATA,MESSAGE_TYPE,
                         nil];
    
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];

 
    NSString *message = [[NSString alloc] initWithData:postdata encoding:NSUTF8StringEncoding];
    NSLog(@"%@",message);
    [socket sendMessage:message];

}
-(void)getProductsViaWebsocket
{
    Websocket *socket = [Websocket sharedManager];
    
    
    
    NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                         self.name, @"username",
                         [SHACode getHash: self.password], @"password",
                         self.currentID, @"id",
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
                         self.name, @"username",
                         [SHACode getHash: self.password], @"password",
                         self.currentID, @"id",
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
    
    
    
    NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                         self.name, @"username",
                         [SHACode getHash: self.password], @"password",
                         self.currentID, @"id",
                         GET_GAME,MESSAGE_TYPE,
                         nil];
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
    
    NSString *message = [[NSString alloc] initWithData:postdata encoding:NSUTF8StringEncoding];
    [socket sendMessage:message];
    
}


/*-(void)getProductsFromServerWithCompletion:(void (^)(BOOL finished))completion
{
    
    
    
    // Now configure the Nutritive mapping
    RKObjectMapping *nutritiveMapping = [RKObjectMapping mappingForClass:[Nutritive class] ];
    [nutritiveMapping addAttributeMappingsFromDictionary:@{
                                                         @"id": @"nutritiveID",
                                                         @"value": @"value",
                                                         @"name": @"name",
                                                         @"unit" : @"unit"
                                                         }];

  
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[Product class]];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"nutritives"
                                                                                   toKeyPath:@"nutritives"
                                                                                 withMapping:nutritiveMapping]];
    [ mapping addAttributeMappingsFromDictionary:@{@"eancode" : @"EANCode",
                                                   @"eantype" : @"EANType",
                                                   @"wikiFoodID" : @"wikiFoodID",
                                                   @"name" : @"name",
                                                   @"ingredients" : @"ingredients",
                                              
                                                  }];
    
    // Define the relationship mapping
   // [articleMapping mapKeyPath:@"author" toRelationship:@"authors" withMapping:authorMapping];
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:statusCodes];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@",SERVERADDRESS,REQUEST_PRODUCTS,self.currentID];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    
    
    
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result)
     {
       
         
         NSArray *resultArray = result.array;
         self.products = resultArray;
         
         
         //Muss später ersetzt werden!!!!!!!
         self.cardsInDeck = resultArray;
        
         completion(YES);
 
         
         
     }
                                     failure:^(RKObjectRequestOperation *operation, NSError *error)
                                     {
                                      
                                         RKLogError(@"Operation failed with error: %@", error);
    
                                     }];
    
    
    [operation start];
    

   

}

-(void)requestForQuickGameWithCompletion:(void (^)(BOOL))completion
{
   
  
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    

    
    NSArray *params = [NSArray arrayWithObjects:self.currentID, nil];
    NSData *responseData = [self sendRequestWithParams:params requestType:REQUEST_QUICKGAME httpMethod: @"GET"  returningResponse:&responseCode error:&error];
    
    if([responseCode statusCode] != 200)
    {
        NSLog(@"error");
      
        
    }
    else
    {
        
        
   
        completion(YES);
    }
    


}



-(NSData*)sendRequestWithParams:(NSArray*)params requestType:(NSString*) type httpMethod:(NSString*) httpMethod returningResponse:(NSURLResponse **)response error:(NSError **)error

{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod: httpMethod];
    NSMutableString *urlString = [NSMutableString stringWithString:SERVERADDRESS];
    [urlString appendString:[NSString stringWithFormat:@"/%@", type]];

    for(NSString* subStr in params)
    {
        [urlString appendString:[NSString stringWithFormat:@"/%@", subStr]];
    }
    
    [request setURL:[NSURL URLWithString: urlString]];
    
    

    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:response error:error];
    
   
    
    return responseData;
    
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
                                                          @"ingredients" : @"ingredients",
                                                          
                                                          }];

    
    RKObjectMapping *playerMapping = [RKObjectMapping mappingForClass:[Player class]];
    [playerMapping addAttributeMappingsFromDictionary:@{
                                                        @"name":                      @"name",
                                                        @"lifepoints":                @"lifePoints",
                                                        @"isInTurn":                  @"isInTurn"
                                                        }];
    
    [playerMapping addPropertyMapping:[RKRelationshipMapping  relationshipMappingFromKeyPath:@"cardsInDeck" toKeyPath:@"cardsInDeck" withMapping:productMapping]];
    [playerMapping addPropertyMapping:[RKRelationshipMapping  relationshipMappingFromKeyPath:@"cardsOnField" toKeyPath:@"cardsOnField" withMapping:productMapping]];
    [playerMapping addPropertyMapping:[RKRelationshipMapping  relationshipMappingFromKeyPath:@"cardsOnHand" toKeyPath:@"cardsOnHand" withMapping:productMapping]];
    
    // Setting up objectmapping for issue
    RKObjectMapping *gameMapping = [RKObjectMapping mappingForClass:[Game class]];
    
    [gameMapping addPropertyMapping:[RKRelationshipMapping  relationshipMappingFromKeyPath:@"opponent" toKeyPath:@"opponent" withMapping:playerMapping]];
    
    [gameMapping addAttributeMappingsFromDictionary:@{
                                                      @"gameState":                      @"gameState",
                                                      @"gameStatus":                     @"gameStatus",
                                                      @"gameID":                         @"gameID",
                                                      
                                                      
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


//////////////////////////////
/////////MAPPING//////////////
//////////////////////////////

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
                                                   @"ingredients" : @"ingredients",
                                                   
                                                   }];
    

    RKObjectMapping *productsMapping = [RKObjectMapping mappingForClass:[self class]];
    [productsMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"products"
                                                                                   toKeyPath:@"products"
                                                                                 withMapping:productMapping]];
    


    

  
    
    NSDictionary *mappingsDictionary = @{ @"": productsMapping };
    RKMapperOperation *mapper = [[RKMapperOperation alloc] initWithRepresentation:productsDict mappingsDictionary:mappingsDictionary];
    mapper.targetObject = self;
    NSError *mappingError = nil;
    BOOL isMapped = [mapper execute:&mappingError];
    if (isMapped && !mappingError)
    {
        // Yay! Mapping finished successfully
        NSLog(@"mapper: %@", [mapper representation]);
        
       // self.products= game;
     
    }

    
    
    
    
}

-(void)mapOpponentFromDictionary:(NSDictionary*)opponentDict
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
                                                          @"ingredients" : @"ingredients",
                                                          
                                                          }];
    
    
    // Now configure the Opponent mapping
    RKObjectMapping *opponentMapping = [RKObjectMapping mappingForClass:[Opponent class] ];
    [opponentMapping addAttributeMappingsFromDictionary:@{
                                                           @"name": @"name",
                                                           @"lifepoints": @"lifepoints",
                                                           @"isInTurn": @"isInTurn",
                                                           @"id" : @"currentID"
                                                           }];
    
    [opponentMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"cardsInDeck"
                                                                                toKeyPath:@"cardsInDeck"
                                                                              withMapping:productMapping]];
    
    [opponentMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"cardsOnHand"
                                                                                    toKeyPath:@"cardsOnHand"
                                                                                  withMapping:productMapping]];
    
    [opponentMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"cardsOnField"
                                                                                    toKeyPath:@"cardsOnField"
                                                                                  withMapping:productMapping]];
    
    
 
    if(self.game == nil)
    {
        self.game = [[Game alloc] init];
        self.game.opponent = [[Opponent alloc]init];
    }
    
    
    
    NSDictionary *mappingsDictionary = @{ @"": opponentMapping };
    RKMapperOperation *mapper = [[RKMapperOperation alloc] initWithRepresentation:opponentDict mappingsDictionary:mappingsDictionary];
    mapper.targetObject = self.game.opponent;
    NSError *mappingError = nil;
    BOOL isMapped = [mapper execute:&mappingError];
    if (isMapped && !mappingError)
    {
        // Yay! Mapping finished successfully
        NSLog(@"mapper: %@", [mapper representation]);
        
        
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
                                                          @"ingredients" : @"ingredients",
                                                          
                                                          }];
    



    //Setting up objectmapping for article
    RKObjectMapping *teamMapping = [RKObjectMapping mappingForClass:[Player class]];
    [teamMapping addAttributeMappingsFromDictionary:@{
                                                      @"name":                      @"name",
                                                      @"lifePoints":          @"lifePoints",
                                                      }];
    [teamMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"cardsInDeck"
                                                                                    toKeyPath:@"cardsInDeck"
                                                                                  withMapping:productMapping]];
    
    // Setting up objectmapping for issue
    RKObjectMapping *gameMapping = [RKObjectMapping mappingForClass:[Game class]];
    
    [gameMapping addPropertyMapping:[RKRelationshipMapping  relationshipMappingFromKeyPath:@"player" toKeyPath:@"player" withMapping:teamMapping]];
    
    
    [gameMapping addPropertyMapping:[RKRelationshipMapping  relationshipMappingFromKeyPath:@"opponent" toKeyPath:@"opponent" withMapping:teamMapping]];
    

 
    
    [gameMapping addAttributeMappingsFromDictionary:@{
                                                      @"gameStatus":                      @"gameStatus",
                                                      @"gameID":                         @"gameID",
                                                      
                                                      
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
        NSLog(@"mapper: %@", [mapper representation]);
        
  
        // self.products= game;
        
    }
    
    
    
    
    
}

//Function: prüft ob Login und passsword bereits eingegeben wurden
-(BOOL)hasLoginNameAndPassword
{
    if(self.coreData.name != nil && self.coreData.password !=nil)
        return YES;
    
    return NO;
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
        
        self.name = self.coreData.name;
        self.password = self.coreData.password;
        
        return YES;
    }
    
    return  NO;
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



////////////////////////////
////////Core Data//////////
///////////////////////////

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
*/

@end
