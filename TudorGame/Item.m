//
//  Item.m
//  TudorGame
//
//  Created by David Joerg on 16.01.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import "Item.h"



@implementation Item


- (void)load
{
   /* RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[Item class]];
    
    [ mapping addAttributeMappingsFromArray:@[@"name",@"value",@"number",@"array" ] ];
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:statusCodes];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://10.14.1.83:8080/TudorGameServer/usermanager/adduser/test/thtru"]];
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result)
     {
         
         Item *item = result.firstObject ;
         self.name = item.name;
         self.value  = item.value;
         self.array = item.array;
         self.number = item.number;
         self.isFinished = YES;
       
     }
                                     failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                         RKLogError(@"Operation failed with error: %@", error);
                                     }];
    
    [operation start];*/
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:@"http://10.14.1.83:8080/TudorGameServer/usermanager/adduser/test/thtru"]];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    bool connected = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] boolValue];
    if([responseCode statusCode] != 200)
    {
        NSLog(@"error");
        
    }
    
    

    /*[mapping addAttributeMappingsFromDictionary:@{@"name": @"name",
                                                  @"value": @"value",
                                                  @"number": @"number",
                                                  @"array": @"array"}];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    NSURL *url = [NSURL URLWithString:@"http://10.14.1.83:8080/TudorGameServer/tutorial/item"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result)
     {
         self.name = [result firstObject];
         NSLog(@"hallo %@",self.name);
     }
                                     failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                         RKLogError(@"Operation failed with error: %@", error);
                                     }];
    
    [operation start];*/
    
    

}


@end
