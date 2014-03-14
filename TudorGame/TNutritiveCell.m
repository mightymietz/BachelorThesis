//
//  TNutritiveCell.m
//  TudorGame
//
//  Created by David Joerg on 30.01.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import "TNutritiveCell.h"

@implementation TNutritiveCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame
{
    float cellWidth = self.superview.frame.size.width;
    float cellHeight = frame.size.height;
    float labelWidth = cellWidth * 0.5f;
    float labelHeight = cellHeight * 0.8f;
    frame.size.width = cellWidth;
    float fontSize = cellWidth / 20;
    float padding = 10;
    self.nameLabel.frame = CGRectMake(padding, cellHeight * 0.5f - labelHeight * 0.5f, cellWidth * 0.5f, labelHeight);
    self.valueLabel.frame = CGRectMake(cellWidth - labelWidth - padding  , cellHeight * 0.5f  - labelHeight * 0.5f, cellWidth * 0.5f, labelHeight);
    self.nameLabel.font = [UIFont systemFontOfSize:fontSize];
    self.valueLabel.font = [UIFont systemFontOfSize:fontSize];
    [super setFrame:frame];
}
@end
