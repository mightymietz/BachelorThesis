//
//  TCardField.m
//  TudorGame
//
//  Created by David Joerg on 12.02.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import "TCardField.h"

@interface TCardField()
@property (nonatomic,retain)UIImage *snapshot;
@property (nonatomic,retain)CALayer *borderLayer;

@end
@implementation TCardField

-(void)storeCardWithCardController:(TOverviewCardViewController*)ov
{
    
    
    self.ov = ov;
    self.product = ov.product;

    
    if(self.product.oldPosition == nil)
    {
        self.product.oldPosition = [NSNumber numberWithInt: self.position];

    }
    else
    {
        self.product.oldPosition = self.product.position;
    }

    self.product.position = [NSNumber numberWithInt: self.position];
    self.isTaken = YES;
    self.isAssigned = NO;
    self.isHidden = NO;
    self.isSpellCard = [self.product.isSpellCard boolValue];
 
   
    self.atk = [self.product.atk intValue];
    self.hp = [self.product.hp intValue];
    self.def = [self.product.def intValue];
    self.spellValue = [self.product.spellValue intValue];
    self.spellType = self.product.spelltype;
   
    if([self.product.isInDefensePosition boolValue])
    {
        [self setDefensePosition];
    }
    else
    {
        [self setAttackPosition];
    }
    
}
-(void)releaseCard
{
    self.ov = nil;
    self.isTaken = NO;
    self.isAssigned = NO;
    self.isSpellCard = NO;
    self.product = nil;
    self.isHidden = NO;
    
    self.image = [UIImage imageNamed:@"emptyField"];

}

-(void)showCardBack:(BOOL)show
{
    if(show == YES)
    {
        self.isHidden = YES;
        self.image = [UIImage imageNamed:@"cardback.jpg"];
    }
    else
    {
        self.isHidden = NO;
        self.image = self.snapshot;
    }
}
-(void)showEmptyField:(BOOL)show
{
    if(show == YES)
    {
        self.isHidden = YES;
        self.image = [UIImage imageNamed:@"emptyField"];
    }
    else
    {
        self.isHidden = NO;
        self.image = self.snapshot;
    }
}

-(void)storeCardWithImage:(UIImage*)image
{
    self.image = image;
    self.isTaken = YES;
}


-(void)markField
{
    self.layer.borderColor = [UIColor yellowColor].CGColor;
    self.layer.borderWidth = 2.0f;
    
    /*if(self.borderLayer == nil)
    {
        self.borderLayer = [CALayer layer];
        CGRect borderFrame = CGRectMake(0, 0, (self.frame.size.width), (self.frame.size.height));
        [self.borderLayer setBackgroundColor:[[UIColor clearColor] CGColor]];
        [self.borderLayer setFrame:borderFrame];
        [self.borderLayer setCornerRadius:2];
        [self.borderLayer setBorderWidth:2];
        [self.borderLayer setBorderColor:[[UIColor yellowColor] CGColor]];
        [self.layer addSublayer:self.borderLayer];
    }*/
    
    
}

-(void)demarkField
{
    self.layer.borderColor = [UIColor clearColor].CGColor;
    self.layer.borderWidth = 0.0f;
    
}

-(void)setDefensePosition
{
    self.isInDefensePosition = YES;
    [self.ov defenseMode];
    self.snapshot = [self.ov snapshotView];
    self.transform = CGAffineTransformMakeRotation(90 * M_PI/180);
    self.image = self.snapshot;

    
    
}
-(void)setAttackPosition
{
    self.isInDefensePosition = NO;
    [self.ov attackMode];
    self.snapshot = [self.ov snapshotView];
    self.transform = CGAffineTransformMakeRotation(0);
    self.image = self.snapshot;

}


-(void)incrementATK:(int)value
{
    [self.ov incrementATK:value];
    self.product = self.ov.product;
    self.atk = [self.product.atk intValue];
    self.snapshot = [self.ov snapshotView];
    self.image = self.snapshot;
}
-(void)incrementHP:(int)value
{
    [self.ov incrementHP:value];
    self.product = self.ov.product;
    self.hp = [self.product.hp intValue];
    self.snapshot = [self.ov snapshotView];
    self.image = self.snapshot;

}
-(void)incrementDEF:(int)value
{
    [self.ov incrementDEF:value];
    self.product = self.ov.product;
    self.def = [self.product.def intValue];
    self.snapshot = [self.ov snapshotView];
    self.image = self.snapshot;

}
-(void)decrementATK:(int)value
{
    [self.ov decrementATK:value];
    self.product = self.ov.product;
    self.atk = [self.product.atk intValue];
    self.snapshot = [self.ov snapshotView];
    self.image = self.snapshot;
}
-(void)decrementHP:(int)value
{
    [self.ov decrementHP:value];
    self.product = self.ov.product;
    self.hp = [self.product.hp intValue];
    self.snapshot = [self.ov snapshotView];
    self.image = self.snapshot;
}
-(void)decrementDEF:(int)value
{
    [self.ov decrementDEF:value];
    self.product = self.ov.product;
    self.def = [self.product.def intValue];
    self.snapshot = [self.ov snapshotView];
    self.image = self.snapshot;
}

-(void)enableInteraction:(BOOL)touchable
{
    self.isTouchable = touchable;
}

-(void)assignCard
{
    self.isAssigned = YES;
}
@end
