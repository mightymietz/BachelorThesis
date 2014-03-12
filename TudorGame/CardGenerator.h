//
//  CardGenerator.h
//  TudorGame
//
//  Created by David Joerg on 11.02.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"
#import "TDetailCardViewController.h"
#import "TOverviewCardViewController.h"
@interface CardGenerator : NSObject

+(TDetailCardViewController*)generateDetailCard:(Product*) product;
+(TOverviewCardViewController*)generateOverviewCard:(Product*) product;
@end
