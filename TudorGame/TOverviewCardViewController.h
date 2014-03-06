//
//  TOverviewCardViewController.h
//  TudorGame
//
//  Created by David Joerg on 11.02.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"

@interface TOverviewCardViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *EANLabel;
@property (weak, nonatomic) IBOutlet UILabel *attackAndDefenseLabel;
@property (weak, nonatomic) IBOutlet UILabel *lifepointsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *attackAndDefenseImageView;
@property (weak, nonatomic) IBOutlet UIImageView *lifePointsImageView;
@property(nonatomic,retain) Product *product;

-(void)generateCardWithProduct:(Product*)product;
-(void)defenseMode;
-(void)attackMode;


-(void)incrementATK:(int)value;
-(void)incrementHP:(int)value;
-(void)incrementDEF:(int)value;
-(void)decrementATK:(int)value;
-(void)decrementHP:(int)value;
-(void)decrementDEF:(int)value;

-(UIImage*)snapshotView;
@end
