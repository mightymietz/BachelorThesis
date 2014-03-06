 //
//  TUsersDeckViewController.m
//  TudorGame
//
//  Created by David Joerg on 17.01.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import "TUsersDeckViewController.h"
#import "Player.h"
#import "Product.h"
#import "TCardCollectionViewCell.h"
#import "TDetailCardViewController.h"
#import "SpinnerView.h"
#import "CardGenerator.h"
#import "DataManager.h"
#import "AppSpecificValues.h"

@interface TUsersDeckViewController ()
@property(nonatomic, retain) Player *player;
@property(nonatomic, retain) DataManager *dataManager;
@property(nonatomic, retain) NSArray *dataArrayAllCards;
@property(nonatomic, retain) NSArray *dataArrayCurrentCardDeck;

@end

@implementation TUsersDeckViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataManager = [DataManager sharedManager];
    self.player = self.dataManager.player;
    
    if([self.player.status isEqualToString:USER_LOGGED_IN])
    {
        [self loadProducts];
    }
   
         
       
}

-(void)viewDidAppear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(productsUpdated:)
     name: PRODUCTS_UPDATED
     object:nil];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:PRODUCTS_UPDATED
     object:nil];
}

-(void)loadProducts
{
    
    [SpinnerView loadSpinnerIntoViewController:self withText:@"loading cards..." andBtnTouched:@selector(backBtnTouched:)];
        
        
        dispatch_queue_t myNewQueue = dispatch_queue_create("loadingCards", NULL);
        
        // Dispatch work to your queue
        dispatch_async(myNewQueue, ^
                       {
                           
                           
                           
                           // Dispatch work back to the main queue for your UIKit changes
                           dispatch_async(dispatch_get_main_queue(), ^{
                               
                                 [self.dataManager getProductsViaWebsocket];
             
                
                           });
                           
                           
                       });
        
        
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
 
    if(collectionView == self.collectionView)
    {
         return self.dataArrayAllCards.count;
    }
    else
    {
        return  self.dataArrayCurrentCardDeck.count;
    }
   
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    
    TCardCollectionViewCell *cell = [collectionView  dequeueReusableCellWithReuseIdentifier:@"CardCell" forIndexPath:indexPath];
    

    Product *currentProduct;
   
    
    if(collectionView == self.collectionView)
    {
         currentProduct = [self.dataArrayAllCards objectAtIndex:indexPath.row];
    }
    else
    {
        currentProduct = [self.dataArrayCurrentCardDeck objectAtIndex:indexPath.row];

    }
    TOverviewCardViewController *ov = [CardGenerator generateOverviewCard:currentProduct];
    UIImage *snapshot = [ov snapshotView];
    cell.cardView.image = snapshot;
    
    [cell setNeedsDisplay];

   
  
    
    
    return cell;
}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Product *currentProduct;

   
    if(collectionView == self.collectionView)
    {
         currentProduct = [self.dataArrayAllCards objectAtIndex:indexPath.row];
        
      
    }
    else
    {
        currentProduct = [self.dataArrayCurrentCardDeck objectAtIndex:indexPath.row];

       

    }
    

    
    TDetailCardViewController *dv = [CardGenerator generateDetailCard:currentProduct];

    UIImage *cardImage = [dv snapshotView];

    self.selectedCardImageView.image = cardImage;
    
    
}




-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

- (IBAction)backBtnTouched:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)productsUpdated:(NSDictionary *)updatedProducts
{
    self.dataArrayAllCards = self.player.products;
    //self.dataArrayCurrentCardDeck = self.user.productsChoosenForDeck;
    
    self.dataArrayCurrentCardDeck = self.player.products;
    
    [self.collectionView reloadData];
    [self.collectionViewCurrentDeck reloadData];
    
    [SpinnerView removeSpinnerFromViewController:self];
}
@end
