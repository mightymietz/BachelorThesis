//
//  TCardField.h
//  TudorGame
//
//  Created by David Joerg on 12.02.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TOverviewCardViewController.h"
@interface TCardField : UIImageView
@property(nonatomic) BOOL isTaken;
@property(nonatomic, retain)TOverviewCardViewController *ov;
@property(nonatomic) BOOL isSpellCard;
@property(nonatomic) BOOL isTouchable;
@property(nonatomic) BOOL isHidden;
@property(nonatomic) BOOL isAssigned;
@property(nonatomic) BOOL isInDefensePosition;
@property(nonatomic, retain) Product *product;
@property(nonatomic) int atk;
@property(nonatomic) int hp;
@property(nonatomic) int def;
@property(nonatomic) int position;
@property(nonatomic) int spellValue;
@property(nonatomic) NSString *spellType;

-(void)storeCardWithCardController:(TOverviewCardViewController*)ov;
-(void)storeCardWithImage:(UIImage*)image;
-(void)releaseCard;
-(void)showEmptyField:(BOOL)show;
-(void)showCardBack:(BOOL)show;
-(void)enableInteraction:(BOOL)touchable;
-(void)assignCard;
-(void)markField;
-(void)demarkField;
-(void)setDefensePosition;
-(void)setAttackPosition;


-(void)incrementATK:(int)value;
-(void)incrementHP:(int)value;
-(void)incrementDEF:(int)value;
-(void)decrementATK:(int)value;
-(void)decrementHP:(int)value;
-(void)decrementDEF:(int)value;
@end
