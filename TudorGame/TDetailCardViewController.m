//
//  TCardViewController.m
//  TudorGame
//
//  Created by David Joerg on 28.01.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import "TDetailCardViewController.h"
#import "Nutritive.h"
#import "TNutritiveCell.h"
#import "AppSpecificValues.h"

@interface TDetailCardViewController ()
@property(nonatomic, retain) NSArray *dataArray;
@property(nonatomic, retain) UIColor *cellColor1;
@property(nonatomic, retain) UIColor *cellColor2;
@end

@implementation TDetailCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
          }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];

    static NSString *CellIdentifier = @"NutritiveCell";
    UINib *cellNib = [UINib nibWithNibName:@"TNutritiveCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:CellIdentifier];
   
    [self fillValues];
}

-(void)fillValues
{
    
   
    
    self.nameLabel.text = self.product.name;
    self.EANLabel.text =[NSString stringWithFormat:@"%@", self.product.EANCode];
    

    
    
    
    
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
        
        self.cellColor1 = [UIColor colorWithRed:0 green:0.7f blue:0 alpha:1];
        self.cellColor2 = [UIColor colorWithRed:0 green:0.5f blue:0 alpha: 1];
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
        self.cellColor1 = [UIColor colorWithRed:0 green:0 blue:0 alpha: 0.5f];
        self.cellColor2 = [UIColor colorWithRed:0 green:0 blue:0 alpha: 0.3f];
        
    }
    


    
}

-(void)generateCardWithProduct:(Product*)product
{
 
   
    
    self.product = product;
    [self fillValues];
    self.dataArray = self.product.sortedNutritives;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///////////////////////////////////////////
//////TableViewdelegate and datasource/////
///////////////////////////////////////////

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NutritiveCell";
    TNutritiveCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(cell == nil)
    {
        cell = [[TNutritiveCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
   
    int row = indexPath.row;
   // Nutritive *currentNutritive = [self.dataArray objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = [self getNutritiveTextForRow:row];
    cell.valueLabel.text = [self getNutritiveValueForRow:row];
    
    if(row % 2 == 0)
    {

        cell.backgroundColor = self.cellColor1;
    }
    else
    {
        cell.backgroundColor = self.cellColor2;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}




-(NSString*)getNutritiveTextForRow:(int)row
{
    NSString *text;
    switch (row)
    {
        case 0:
            text = @"Energy kj/kcal";
            break;
        case 1:
            text = @"Protein";
            break;
        case 2:
            text = @"Carbohydrate";
            break;
        case 3:
            text = @"Sugar";
            break;
        case 4:
            text = @"Fat";
            break;
        case 5:
            text = @"Saturates";
            break;
        case 6:
            text = @"Fibre";
            break;
        default:
            text = @"Sodium";
            break;
    }
    
    return text;
}


//Liefert den Wert des Nährwertes an richtiger Stelle des Arrays

-(NSString*)getNutritiveValueForRow:(int)row
{
    NSString *value;
    
    //Falls row +1 > arraylänge gebe einfach 0 als String aus.
    
    if(self.dataArray.count > row + 1) //+1 da durch kj und kcal, die in einer Reihe stehen, einer übersprunbgen werden muss
    {
        Nutritive *currentNutritive;
    
        switch (row)
        {
            case 0:
            {
                currentNutritive = [self.dataArray objectAtIndex:row];
                Nutritive *nextNutritive =[self.dataArray objectAtIndex:row + 1];
                value = [NSString stringWithFormat:@"%@/%@", currentNutritive.value, nextNutritive.value];
            }
                break;
            
            default:
            {
                 currentNutritive = [self.dataArray objectAtIndex:row + 1];
                 value = [NSString stringWithFormat:@"%@ %@", currentNutritive.value, currentNutritive.unit];
            }
                break;
        }
    }
    else
    {
        value = [NSString stringWithFormat:@"%i", 0];

    }
    
    
    
    return value;
}



@end
