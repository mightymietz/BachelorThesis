//
//  TCardViewController.h
//  TudorGame
//
//  Created by David Joerg on 28.01.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"
@interface TDetailCardViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *EANLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property(nonatomic) BOOL isSpellCard;
@property(nonatomic,retain) Product *product;

-(void)generateCardWithProduct:(Product*)product;
-(UIImage*)snapshotView;
@end
