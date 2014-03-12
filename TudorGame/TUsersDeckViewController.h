//
//  TUsersDeckViewController.h
//  TudorGame
//
//  Created by David Joerg on 17.01.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TUsersDeckViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewCurrentDeck;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *selectedCardImageView;
- (IBAction)backBtnTouched:(id)sender;

@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panRecognizer;

//Handle Tap
-(IBAction)handleSingleTap:(UITapGestureRecognizer*)recognizer;
//Handle Pan with HandCards
- (IBAction)handlePanAllCards:(UIPanGestureRecognizer *)recognizer;
- (IBAction)handlePanCurrentDeck:(UIPanGestureRecognizer *)recognizer;
@end
