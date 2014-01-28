//
//  TCardViewController.m
//  TudorGame
//
//  Created by David Joerg on 28.01.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import "TCardViewController.h"
#import "Nutritive.h"

@interface TCardViewController ()

@end

@implementation TCardViewController

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
    [self setUp];
    // Do any additional setup after loading the view from its nib.
    
    
}

-(void)setUp
{
    
    self.labelName.text = self.product.name;
    self.labelEAN.text =[NSString stringWithFormat:@"%@", self.product.EANCode];
    
    NSArray *ingredientsArray = [self.product.ingredients allObjects];
    NSArray *nutritivesArray = [self.product.nutritives allObjects];
    
    NSString *ingredientsStr = [ingredientsArray componentsJoinedByString:@","];
    
    
    NSMutableString *nutritivesStr = [[NSMutableString alloc] init];
    
    for(Nutritive *nutritive in nutritivesArray)
    {
        [nutritivesStr appendString:nutritive.name];
    }
  
    
    
    self.ingredientsTextView.text = ingredientsStr;
    self.nutritivesTextView.text = nutritivesStr;
    
    

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UIImage*)snapshotViewController
{
    
    UIView *view = self.view;
    CGRect rect = [view bounds];
    UIGraphicsBeginImageContextWithOptions(rect.size,YES,0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *capturedScreen = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return capturedScreen;

}

@end
