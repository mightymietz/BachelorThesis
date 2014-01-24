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
#import <RestKit/RestKit.h>
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

- (id)init {
    if (self = [super init])
    {
     
       
    }
    return self;
}

-(void)connectUserWith:(NSString*)name andPassword:(NSString*)password completion:(void (^)(BOOL finished))completion

{
    self.cancelledLogIn = NO;
   /* NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@/%@", SERVERADDRESS,REQUEST_CONNECT,self.username,self.password];
    [request setURL:[NSURL URLWithString: urlString]];*/
    self.username = name;
    self.password = password;
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSArray *params = [NSArray arrayWithObjects:name,password, nil];
    NSData *responseData = [self sendRequestWithParams:params requestType:REQUEST_CONNECT returningResponse:&responseCode error:&error];
    
    if([responseCode statusCode] != 200)
    {
        NSLog(@"error");
        self.isConnected = NO;

    }
    else
    {
        self.currentID =  [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];

        self.isConnected = YES;
        completion(YES);
    }
    
     self.isFinished = NO;

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
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@",SERVERADDRESS,REQUEST_PRODUCTS,self.currentID];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    
    
    
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result)
     {
       
         
         NSArray *resultArray = result.array;
         self.products = resultArray;
        
         completion(YES);
 
         
         
     }
                                     failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                         RKLogError(@"Operation failed with error: %@", error);
                                     }];
    
    
    [operation start];
    

   

}



-(NSData*)sendRequestWithParams:(NSArray*)params requestType:(NSString*) type returningResponse:(NSURLResponse **)response error:(NSError **)error

{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
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
@end
