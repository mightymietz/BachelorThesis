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
        
        //Generiere Farbe für tableViewCells aus der Hintergrundfarbe der view
        UIColor *backgroundColor = self.view.backgroundColor;
        const CGFloat* components = CGColorGetComponents(backgroundColor.CGColor);
        CGFloat red = components[0];
        CGFloat green = components[1];
        CGFloat blue = components[2];
        CGFloat alpha = CGColorGetAlpha([[UIColor greenColor] CGColor]);
        
        self.cellColor1 = [UIColor colorWithRed:red green:green blue:blue alpha:alpha - 0.9f];
        self.cellColor2 = [UIColor colorWithRed:red green:green blue:blue alpha:alpha - 0.4f];
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];

    static NSString *CellIdentifier = @"NutritiveCell";
    UINib *cellNib = [UINib nibWithNibName:@"TNutritiveCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:CellIdentifier];
    // Do any additional setup after loading the view from its nib.
    self.nameLabel.text = self.product.name;
    self.EANLabel.text =[NSString stringWithFormat:@"%@", self.product.EANCode];
    
}

-(void)generateCardWithProduct:(Product*)product
{
 
   
    
    self.product = product;
    self.nameLabel.text = self.product.name;
    self.EANLabel.text =[NSString stringWithFormat:@"%@", self.product.EANCode];
    
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
    
    if(indexPath.row % 2 == 0)
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
                 value = [NSString stringWithFormat:@"%@", currentNutritive.value];
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
