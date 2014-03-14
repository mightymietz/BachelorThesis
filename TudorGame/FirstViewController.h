//
//  FirstViewController.h
//  TudorGame
//
//  Created by David Joerg on 09.01.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRWebSocket.h"
#import "CustomIOS7AlertView.h"
@interface FirstViewController : UIViewController <UIAlertViewDelegate, CustomIOS7AlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;

- (IBAction)buyNewCardBtnTouched:(id)sender;
@end
