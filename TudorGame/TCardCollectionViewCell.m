//
//  TCardCeollectionViewCell.m
//  TudorGame
//
//  Created by David Joerg on 17.01.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import "TCardCollectionViewCell.h"

@interface TCardCollectionViewCell()
@property (nonatomic, retain) Product *product;
@property (nonatomic, retain) NSArray *nutritivesArray;
@end

@implementation TCardCollectionViewCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        // Initialization code
        //TCardViewController *controller = [[TCardViewController alloc] initWithNibName:@"TCardViewController" bundle:nil];
        //self.vc = controller;
        

    }
    return self;
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
