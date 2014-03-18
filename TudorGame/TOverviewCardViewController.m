//
//  TOverviewCardViewController.m
//  TudorGame
//
//  Created by David Joerg on 11.02.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import "TOverviewCardViewController.h"
#import "Nutritive.h"
#import "AppSpecificValues.h"
@interface TOverviewCardViewController ()

@end

@implementation TOverviewCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self fillValues];
  

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fillValues
{
    self.nameLabel.text = self.product.name;
    self.EANLabel.text =[NSString stringWithFormat:@"%@", self.product.EANCode];
    
    NSArray *nutritives = [self.product.nutritives allObjects];
    
    for (Nutritive *n in nutritives)
    {
        if([n.nutritiveID isEqualToString: KCAL])
        {
            //self.atk = [n.value intValue];
            //self.hp = [n.value intValue];
            /* self.atk = 100;
             self.hp = 100;
             self.def = 90;
             self.attackAndDefenseLabel.text =[NSString stringWithFormat:@"%i", self.atk];
             self.lifepointsLabel.text =[NSString stringWithFormat:@"%i", self.hp];*/
        }
    }
    
    
    
    
    if([self.product.spellCard boolValue] == YES)
    {
       self.view.backgroundColor = [UIColor colorWithRed:0 green:0.8f blue:0 alpha:1];

        
        if([self.product.spelltype isEqualToString:SPELLTYPE_DECREMENT_ATK] || [self.product.spelltype isEqualToString:SPELLTYPE_INCREMENT_ATK])
        {
            //self.attackImageView.image = [UIImage imageNamed:@"sword.png"];
            self.attackLabel.text = @"-";
            self.defenseLabel.text = @"-";
            self.lifepointsLabel.text =[NSString stringWithFormat:@"ATK: %@%%",self.product.spellValue];
            
            //Ist es Buff oder Debuff? Ändere das Bild entsprechend
            if([self.product.spellValue intValue] > 0)
            {
                self.lifePointsImageView.image = [UIImage imageNamed:@"arrowup.png"];
            }
            else
            {
                self.lifePointsImageView.image = [UIImage imageNamed:@"arrowdown.png"];
                
            }
            
        }
        else if([self.product.spelltype isEqualToString:SPELLTYPE_DECREMENT_HP] || [self.product.spelltype isEqualToString:SPELLTYPE_INCREMENT_HP])
        {
            self.attackLabel.text = @"-";
            self.defenseLabel.text = @"-";
            self.lifepointsLabel.text =[NSString stringWithFormat:@"HP: %@%%",self.product.spellValue];

            
            //Ist es Buff oder Debuff? Ändere das Bild entsprechend
            if([self.product.spellValue intValue] > 0)
            {
                self.lifePointsImageView.image = [UIImage imageNamed:@"arrowup.png"];
            }
            else
            {
                self.lifePointsImageView.image = [UIImage imageNamed:@"arrowdown.png"];
                
            }
            
        }
        else if([self.product.spelltype isEqualToString:SPELLTYPE_DECREMENT_DEF] || [self.product.spelltype isEqualToString:SPELLTYPE_INCREMENT_DEF])
        {
            self.attackLabel.text = @"-";
            self.defenseLabel.text = @"-";
            self.lifepointsLabel.text =[NSString stringWithFormat:@"DEF: %@%%",self.product.spellValue];

            
            //Ist es Buff oder Debuff? Ändere das Bild entsprechend
            if([self.product.spellValue intValue] > 0)
            {
                self.lifePointsImageView.image = [UIImage imageNamed:@"arrowup.png"];
            }
            else
            {
                self.lifePointsImageView.image = [UIImage imageNamed:@"arrowdown.png"];
                
            }
            
        }
    }
    else
    {
        self.view.backgroundColor = [UIColor blackColor];
        
         self.defenseLabel.text =[NSString stringWithFormat:@"%@", self.product.def];
         self.attackLabel.text =[NSString stringWithFormat:@"%@", self.product.atk];
        self.lifepointsLabel.text =[NSString stringWithFormat:@"%@", self.product.hp];
        /*if([self.product.isInDefensePosition boolValue])
        {
            self.attackLabel.text =[NSString stringWithFormat:@"%@", self.product.def];

        }
        else
        {
            self.attackLabel.text =[NSString stringWithFormat:@"%@", self.product.atk];
        }
        self.lifepointsLabel.text =[NSString stringWithFormat:@"%@", self.product.hp];*/
        
        
    }

}

-(void)generateCardWithProduct:(Product*)product
{
    
    
    
    self.product = product;
    [self fillValues];
    //self.nameLabel.text = self.product.name;
    //self.EANLabel.text =[NSString stringWithFormat:@"%@", self.product.EANCode];
    
   
}



-(void)defenseMode
{
    //self.attackLabel.text = [NSString stringWithFormat:@"%@", self.product.def];
    //self.attackImageView.image = [UIImage imageNamed:@"shield.png"];
    self.product.isInDefensePosition = [NSNumber numberWithBool:YES];

    self.attackLabel.textColor = [UIColor grayColor];
    self.defenseLabel.textColor = [UIColor whiteColor];
    self.lifepointsLabel.textColor = [UIColor grayColor];

}
-(void)attackMode
{
    if([self.product.spellCard boolValue] == NO)
    {
       // self.attackLabel.text =[NSString stringWithFormat:@"%@", self.product.atk];
        //self.attackImageView.image = [UIImage imageNamed:@"sword.png"];
        self.product.isInDefensePosition = [NSNumber numberWithBool:NO];
        self.attackLabel.textColor = [UIColor whiteColor];
        self.defenseLabel.textColor = [UIColor grayColor];
        self.lifepointsLabel.textColor = [UIColor whiteColor];

    }

}


-(void)incrementATK:(int)value
{
    int atk = [self.product.atk intValue];
    atk+= value;
    self.product.atk = [NSNumber numberWithInt:atk];
    [self fillValues];
}
-(void)incrementHP:(int)value
{
    int hp = [self.product.hp intValue];
    hp+= value;
    self.product.hp = [NSNumber numberWithInt:hp];
    [self fillValues];
}
-(void)incrementDEF:(int)value
{
    int def = [self.product.def intValue];
    def += value;
    self.product.def = [NSNumber numberWithInt:def];
    [self fillValues];

}
-(void)decrementATK:(int)value
{
    int atk = [self.product.atk intValue];
    atk-= value;
    self.product.atk = [NSNumber numberWithInt:atk];
    [self fillValues];
}
-(void)decrementHP:(int)value
{
    int hp = [self.product.hp intValue];
    hp -= value;
    self.product.hp = [NSNumber numberWithInt:hp];
    [self fillValues];

}
-(void)decrementDEF:(int)value
{
    int def = [self.product.def intValue];
    def -= value;
    self.product.def = [NSNumber numberWithInt:def];
    [self fillValues];

}

-(UIImage*)snapshotView
{
    
    CGRect rect = [self.view bounds];
    UIGraphicsBeginImageContextWithOptions(rect.size,YES,0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:context];
    UIImage *capturedScreen = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
  
    return capturedScreen;
}

@end
