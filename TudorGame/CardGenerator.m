//
//  CardGenerator.m
//  TudorGame
//
//  Created by David Joerg on 11.02.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import "CardGenerator.h"

@implementation CardGenerator


+(TDetailCardViewController*)generateDetailCard:(Product*) product
{
    TDetailCardViewController *controller = [[TDetailCardViewController alloc] initWithNibName:@"TDetailCardViewController" bundle:nil];
    
    [controller generateCardWithProduct:product];
    
  
    
    return controller;
    
    
    
}
+(TOverviewCardViewController*)generateOverviewCard:(Product*) product
{
    TOverviewCardViewController *controller = [[TOverviewCardViewController alloc] initWithNibName:@"TOverviewCardViewController" bundle:nil];
    
    [controller generateCardWithProduct:product];
    
    return controller;
}







@end
