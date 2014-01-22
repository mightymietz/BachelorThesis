//
//  Item.h
//  TudorGame
//
//  Created by David Joerg on 16.01.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
@interface Item : NSObject


@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *value;
@property(nonatomic, copy) NSNumber *number;
@property(nonatomic, copy) NSArray *array;
@property(nonatomic) BOOL isFinished;


-(void)load;

@end
