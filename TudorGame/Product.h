//
//  Product.h
//  TudorGame
//
//  Created by David Joerg on 09.01.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject
@property(nonatomic, copy) NSNumber *EANCode;
@property(nonatomic,copy) NSString *EANType;
@property(nonatomic, copy) NSNumber *wikiFoodID;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSNumber *atk;
@property(nonatomic,copy) NSNumber *hp;
@property(nonatomic,copy) NSNumber *def;
@property(nonatomic,copy) NSNumber *spellValue;
@property(nonatomic,copy) NSString *spelltype;
@property(nonatomic, copy) NSNumber *isSpellCard;
@property(nonatomic, copy) NSNumber *position;
@property(nonatomic, copy) NSNumber *oldPosition;
@property(nonatomic, copy) NSNumber *isInDefensePosition;
@property(nonatomic, copy) NSString *country;
@property(nonatomic, copy) NSSet *ingredients;
@property(nonatomic, copy) NSSet *nutritives;
@property(nonatomic, retain) NSArray *sortedNutritives;


@end
