//
//  User.h
//  TudorGame
//
//  Created by David Joerg on 16.01.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject



@property(nonatomic, copy) NSString *username;
@property(nonatomic, copy) NSString *password;
@property(nonatomic, copy) NSString *currentID;
@property(nonatomic, copy) NSArray *products;
@property(nonatomic) BOOL isFinished;
@property(nonatomic) BOOL isConnected;
@property(nonatomic) BOOL cancelledLogIn;

+ (id)sharedManager;

-(void)getProductsFromServerWithCompletion:(void (^)(BOOL finished))completion;

-(void)connectUserWith:(NSString*)name andPassword:(NSString*)password completion:(void (^)(BOOL finished))completion;
@end
