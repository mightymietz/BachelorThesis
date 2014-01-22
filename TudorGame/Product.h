//
//  Product.h
//  TudorGame
//
//  Created by David Joerg on 09.01.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject
@property(nonatomic,copy) NSString *EANCode;
@property(nonatomic,copy) NSString *EANType;
@property(nonatomic,copy) NSString *name;
@property(nonatomic, copy) NSString *country;
@property(nonatomic, retain) NSArray *ingredients;
@property(nonatomic, retain) NSArray *nutritives;

@end
