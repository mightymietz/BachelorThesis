//
//  Nutritive.h
//  TudorGame
//
//  Created by David Joerg on 24.01.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Nutritive : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, copy) NSString *nutritiveID;
@property (nonatomic, copy) NSNumber *value;

@end
