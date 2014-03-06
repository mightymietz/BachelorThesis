//
//  TGameViewController.h
//  TudorGame
//
//  Created by David Joerg on 09.01.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"
#import "Player.h"
#import "TCardField.h"
@interface TGameViewController : UIViewController

//Player
@property (weak, nonatomic) IBOutlet TCardField *playerField1;
@property (weak, nonatomic) IBOutlet TCardField *playerField2;
@property (weak, nonatomic) IBOutlet TCardField *playerField3;
@property (weak, nonatomic) IBOutlet TCardField *playerField4;
@property (weak, nonatomic) IBOutlet TCardField *playerField5;
@property (weak, nonatomic) IBOutlet TCardField *playerField6;
@property (weak, nonatomic) IBOutlet TCardField *playerHand1;
@property (weak, nonatomic) IBOutlet TCardField *playerHand2;
@property (weak, nonatomic) IBOutlet TCardField *playerHand3;
@property (weak, nonatomic) IBOutlet UIImageView *playerDeck;
@property (weak, nonatomic) IBOutlet UIImageView *playerImage;
@property (weak, nonatomic) IBOutlet UILabel *playerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerDeckCounterLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerLifepointsLabel;
@property (weak, nonatomic) IBOutlet TCardField *playerGrave;


//Opponent
@property (weak, nonatomic) IBOutlet TCardField *opponentField1;
@property (weak, nonatomic) IBOutlet TCardField *opponentField2;
@property (weak, nonatomic) IBOutlet TCardField *opponentField3;
@property (weak, nonatomic) IBOutlet TCardField *opponentField4;
@property (weak, nonatomic) IBOutlet TCardField *opponentField5;
@property (weak, nonatomic) IBOutlet TCardField *opponentField6;
@property (weak, nonatomic) IBOutlet TCardField *opponentHand1;
@property (weak, nonatomic) IBOutlet TCardField *opponentHand2;
@property (weak, nonatomic) IBOutlet TCardField *opponentHand3;
@property (weak, nonatomic) IBOutlet UIImageView *opponentDeck;
@property (weak, nonatomic) IBOutlet UIImageView *opponentImage;
@property (weak, nonatomic) IBOutlet UILabel *opponentNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *opponentDeckCounterLabel;
@property (weak, nonatomic) IBOutlet UILabel *opponentLifepointsLabel;
@property (weak, nonatomic) IBOutlet TCardField *opponentGrave;

//Tap recognizer
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *singleTapRecognizer;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *doubleTapRecognizer;

//Buttons
@property (weak, nonatomic) IBOutlet UIButton *readyBtn;

//Handle Pan with HandCards
- (IBAction)handlePanHandField1:(UIPanGestureRecognizer *)recognizer;
- (IBAction)handlePanHandField2:(UIPanGestureRecognizer *)recognizer;
- (IBAction)handlePanHandField3:(UIPanGestureRecognizer *)recognizer;

//Handle Pan with FieldsCards

- (IBAction)handlePanField1:(UIPanGestureRecognizer *)recognizer;
- (IBAction)handlePanField2:(UIPanGestureRecognizer *)recognizer;
- (IBAction)handlePanField3:(UIPanGestureRecognizer *)recognizer;
- (IBAction)handlePanField4:(UIPanGestureRecognizer *)recognizer;
- (IBAction)handlePanField5:(UIPanGestureRecognizer *)recognizer;
- (IBAction)handlePanField6:(UIPanGestureRecognizer *)recognizer;

//Handle Tap
-(IBAction)handleSingleTap:(UITapGestureRecognizer*)recognizer;
-(IBAction)handleDoubleTap:(UITapGestureRecognizer*)recognizer;



-(void)updateGame:(Game*)gameData;
-(void)nextCard;
-(void)flipCard;
-(void)attackCards;
-(void)playCard;
-(void)fillPlayersHand;


//Buttonactions
- (IBAction)backBtnTouched:(UIBarButtonItem *)sender;
- (IBAction)readyBtnTouched:(UIButton *)sender;



@end
