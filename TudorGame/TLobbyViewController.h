//
//  TLobbyViewController.h
//  TudorGame
//
//  Created by David Joerg on 09.01.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"
@interface TLobbyViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *startBtn;

@property (weak, nonatomic) IBOutlet UIImageView *playerImage;
@property (weak, nonatomic) IBOutlet UILabel *playerNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *opponentImage;
@property (weak, nonatomic) IBOutlet UILabel *opponentNameLabel;

- (IBAction)backBtnTouched:(UIBarButtonItem *)sender;
@end
