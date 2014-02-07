//
//  User.m
//  TudorGame
//
//  Created by David Joerg on 16.01.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import "User.h"
#import "Product.h"
#import "AppSpecificValues.h"
#import "Nutritive.h"
#import "TeamMember.h"
#import "SHACode.h"
#import "Websocket.h"
#import <RestKit/RestKit.h>
#import <RestKit/RKObjectMappingOperationDataSource.h>
@implementation User 


+ (id)sharedManager
{
    static User *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
     
    });
    return sharedMyManager;
}

- (id)init
{
    if (self = [super init])
    {
        self.currentGame = nil;
        
        [self loadCoreData];
       
    }
    return self;
}



-(void)connectUserWith:(NSString*)name andPassword:(NSString*)password completion:(void (^)(BOOL finished))completion

{
  
    self.abortAllOperations = NO;

    self.status = nil;

    [self saveUsername:name andPassword:password];
    while (self.status == nil && self.abortAllOperations == NO)
    {
        NSError *error = [[NSError alloc] init];
        NSHTTPURLResponse *responseCode = nil;
        
        NSArray *params = [NSArray arrayWithObjects:name,[SHACode getHash:password], self.currentID, nil];
        NSData *responseData = [self sendRequestWithParams:params requestType:REQUEST_CONNECT httpMethod: @"GET"  returningResponse:&responseCode error:&error];
        
       self.loadingStatus = @"connecting to server...";
            
        if([responseCode statusCode] != 200)
        {
            NSLog(@"%ld", (long)[responseCode statusCode]);
            
        }
        else
        {
            //œself.currentID =  [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            
           // self.isConnected = YES;
            NSString *response = [[NSString alloc] initWithData:responseData encoding: NSUTF8StringEncoding];
            
            self.status = response;
            
            
            completion(YES);
            
        }
    }
    
    // self.isFinished = NO;
    


}

-(void)connectUser

{
    //self.cancelledLogIn = NO;
    //self.abortAllOperations = NO;
    
    self.status = nil;

    /* NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
     [request setHTTPMethod:@"GET"];
     NSString *urlString = [NSString stringWithFormat:@"%@%@%@/%@", SERVERADDRESS,REQUEST_CONNECT,self.username,self.password];
     [request setURL:[NSURL URLWithString: urlString]];*/
   
   /* while (self.status == nil && self.abortAllOperations == NO)
    {
        NSError *error = [[NSError alloc] init];
        NSHTTPURLResponse *responseCode = nil;
        
        NSArray *params = [NSArray arrayWithObjects:name,password, self.currentID, nil];
        NSData *responseData = [self sendRequestWithParams:params requestType:REQUEST_CONNECT httpMethod: @"GET"  returningResponse:&responseCode error:&error];
        
        self.loadingStatus = @"connecting to server...";
        
        if([responseCode statusCode] != 200)
        {
            NSLog(@"%ld", (long)[responseCode statusCode]);
            
        }
        else
        {
            //œself.currentID =  [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            
            NSString *response = [[NSString alloc] initWithData:responseData encoding: NSUTF8StringEncoding];
            
            
            self.status = response;

            self.isConnected = YES;
            completion(YES);
        }
    }*/
    
    Websocket *socket = [Websocket sharedManager];
 
    [socket reconnect];
    
  
    
    
   /* NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                         self.username, @"username",
                         [SHACode getHash: self.password], @"password",
                         self.currentID, @"id",
                         USERDATA,MESSAGE_TYPE,
                         nil];
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
    
    NSString *message = [[NSString alloc] initWithData:postdata encoding:NSUTF8StringEncoding];
    [socket sendMessage:message];
    
    completion(YES);*/
    
    
    

    
}

-(void)getProductsViaWebsocket
{
    Websocket *socket = [Websocket sharedManager];
    
    
    
    NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                         self.username, @"username",
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
                         self.username, @"username",
                         [SHACode getHash: self.password], @"password",
                         self.currentID, @"id",
                         QUIT_GAME,MESSAGE_TYPE,
                         nil];
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
    
    NSString *message = [[NSString alloc] initWithData:postdata encoding:NSUTF8StringEncoding];
    [socket sendMessage:message];
    
    self.currentGame = nil;

}

-(void)searchGameViaWebsocket
{
    Websocket *socket = [Websocket sharedManager];
    
    
    
    NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                         self.username, @"username",
                         [SHACode getHash: self.password], @"password",
                         self.currentID, @"id",
                         GET_GAME,MESSAGE_TYPE,
                         nil];
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
    
    NSString *message = [[NSString alloc] initWithData:postdata encoding:NSUTF8StringEncoding];
    [socket sendMessage:message];
    
}


-(void)getProductsFromServerWithCompletion:(void (^)(BOOL finished))completion
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
         self.productsChoosenForDeck = resultArray;
        
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

-(void)updateGameData:(NSString *)newData completion:(void (^)(BOOL))completion
{
    // Get json from destination
    // NSString *myJSON = [[NSString alloc] initWithContentsOfFile:newData encoding:NSUTF8StringEncoding error:NULL];
    
    NSString* MIMEType = @"application/json";
    NSError* parseError;
    
    NSData *data = [newData dataUsingEncoding:NSUTF8StringEncoding];
    id parsedData = [RKMIMETypeSerialization objectFromData:data MIMEType:MIMEType error:&parseError];
    if (parsedData == nil && parseError) {
        NSLog(@"Cannot parse data: %@", parseError);
    }
    
    

    
    
    
    //Setting up objectmapping for article
    RKObjectMapping *teamMapping = [RKObjectMapping mappingForClass:[TeamMember class]];
    [teamMapping addAttributeMappingsFromDictionary:@{
                                                      @"name":                      @"name",
                                                      
                                                      }];
    
    // Setting up objectmapping for issue
    RKObjectMapping *gameMapping = [RKObjectMapping mappingForClass:[Game class]];
    
     [gameMapping addPropertyMapping:[RKRelationshipMapping  relationshipMappingFromKeyPath:@"team1" toKeyPath:@"team1" withMapping:teamMapping]];
    
    [gameMapping addPropertyMapping:[RKRelationshipMapping  relationshipMappingFromKeyPath:@"team2" toKeyPath:@"team2" withMapping:teamMapping]];
    
    [gameMapping addAttributeMappingsFromDictionary:@{
                                                      @"gameState":                      @"gameState",
                                                      @"gameID":                         @"gameID",
                                                 
                                          
                                                      }];
    
   
    Game *game = [[Game alloc] init];
    
    NSDictionary *mappingsDictionary = @{ @"": gameMapping };
    RKMapperOperation *mapper = [[RKMapperOperation alloc] initWithRepresentation:parsedData mappingsDictionary:mappingsDictionary];
    mapper.targetObject = game;
    NSError *mappingError = nil;
    BOOL isMapped = [mapper execute:&mappingError];
    if (isMapped && !mappingError)
    {
        // Yay! Mapping finished successfully
        NSLog(@"mapper: %@", [mapper representation]);
       
        self.currentGame = game;
        completion(YES);
    }

    
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

-(void)mapGameFromDictionary:(NSDictionary*)gameDict
{
    //Setting up objectmapping for article
    RKObjectMapping *teamMapping = [RKObjectMapping mappingForClass:[TeamMember class]];
    [teamMapping addAttributeMappingsFromDictionary:@{
                                                      @"name":                      @"name",
                                                      
                                                      }];
    
    // Setting up objectmapping for issue
    RKObjectMapping *gameMapping = [RKObjectMapping mappingForClass:[Game class]];
    
    [gameMapping addPropertyMapping:[RKRelationshipMapping  relationshipMappingFromKeyPath:@"team1" toKeyPath:@"team1" withMapping:teamMapping]];
    
    [gameMapping addPropertyMapping:[RKRelationshipMapping  relationshipMappingFromKeyPath:@"team2" toKeyPath:@"team2" withMapping:teamMapping]];
    
    [gameMapping addAttributeMappingsFromDictionary:@{
                                                      @"gameState":                      @"gameState",
                                                      @"gameID":                         @"gameID",
                                                      
                                                      
                                                      }];

    
    
    
    
    
    if(self.currentGame == nil)
    {
        self.currentGame = [[Game alloc] init];
    }
    
    
    NSDictionary *mappingsDictionary = @{ @"": gameMapping };
    RKMapperOperation *mapper = [[RKMapperOperation alloc] initWithRepresentation:gameDict mappingsDictionary:mappingsDictionary];
    mapper.targetObject = self.currentGame;
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
        
        self.username = self.coreData.name;
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

//Function: sendet username, password, appleID als USerdata zum Server
-(void)sendUserDataViaWebSocket
{
    Websocket *socket = [Websocket sharedManager];
    
    
    
    NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                         self.username, @"username",
                        [SHACode getHash: self.password], @"password",
                         self.currentID, @"id",
                          USERDATA,MESSAGE_TYPE,
                         nil];
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
    
    NSString *message = [[NSString alloc] initWithData:postdata encoding:NSUTF8StringEncoding];
    [socket sendMessage:message];
    
    
    
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


@end
