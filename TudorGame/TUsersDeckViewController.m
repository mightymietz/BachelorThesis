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
@property(nonatomic, retain) NSMutableArray *dataArrayAllCards;
@property(nonatomic, retain) NSMutableArray *dataArrayCurrentCardDeck;
@property(nonatomic, retain) UIImageView *cardDublicate;
@property(nonatomic, retain)  Product *productTouched;

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
    self.dataArrayCurrentCardDeck = [[NSMutableArray alloc]init];
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
        
    
    
        /*dispatch_queue_t myNewQueue = dispatch_queue_create("loadingCards", NULL);
        
        // Dispatch work to your queue
        dispatch_async(myNewQueue, ^
                       {
                           
                           
                           
                           // Dispatch work back to the main queue for your UIKit changes
                           dispatch_async(dispatch_get_main_queue(), ^{
                               
                                 [self.dataManager getProductsViaWebsocket];
             
                
                           });
                           
                           
                       });*/
    
    
    self.dataArrayAllCards = [NSMutableArray arrayWithArray: self.player.products];
    self.dataArrayCurrentCardDeck = [NSMutableArray arrayWithArray:self.player.cardsInDeck];
    //self.dataArrayCurrentCardDeck = self.user.productsChoosenForDeck;
    
    //self.dataArrayCurrentCardDeck = self.player.products;
    
    [self.collectionView reloadData];
    [self.collectionViewCurrentDeck reloadData];
    
    [SpinnerView removeSpinnerFromViewController:self];
    
    
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
    self.dataArrayAllCards = [NSMutableArray arrayWithArray: self.player.products];
    //self.dataArrayCurrentCardDeck = self.user.productsChoosenForDeck;
    
    //self.dataArrayCurrentCardDeck = self.player.products;
    
    [self.collectionView reloadData];
    [self.collectionViewCurrentDeck reloadData];
    
    [SpinnerView removeSpinnerFromViewController:self];
}

- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer
{
    //CGPoint touch = [recognizer locationInView:self.collectionView];

     CGPoint point = [recognizer locationInView:self.collectionView];
    //CGRect frame =  [self.cardDetailView convertRect:self.cardDetailView.bounds toView:self.view];
    NSIndexPath *path =  [self.collectionView indexPathForItemAtPoint:point];
    if(path)
    {
        //Touch starts
        if(recognizer.state == UIGestureRecognizerStateBegan)
        {
         
            
            TCardCollectionViewCell *cardField =(TCardCollectionViewCell*) [self.collectionView cellForItemAtIndexPath:path];

            self.productTouched = [self.dataArrayAllCards objectAtIndex:path.row];
            
            
            TOverviewCardViewController *detailVc = [CardGenerator generateOverviewCard:self.productTouched];
            UIImage *snapshot = [detailVc snapshotView];

            
            //dubliziere aktuelle Karte und mache altes Feld frei
            self.cardDublicate = [[UIImageView alloc] initWithFrame:cardField.frame];
            self.cardDublicate.image = snapshot;
            self.cardDublicate.center = [self.collectionView convertPoint:point toView:self.view];
            [self.view addSubview:self.cardDublicate];
            [self.view bringSubviewToFront:self.cardDublicate];
        }
    }
    //Dragging
    if(recognizer.state == UIGestureRecognizerStateChanged)
    {
        
        CGPoint delta = [recognizer translationInView: self.cardDublicate.superview];
        CGPoint c = self.cardDublicate.center;
        c.x += delta.x; c.y += delta.y;
        self.cardDublicate.center = c;
        [recognizer setTranslation: CGPointZero inView: self.cardDublicate.superview];
    }
    //Touch ended
    if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        UIView *touchedView = [self.view hitTest:self.cardDublicate.center withEvent:nil];

        if([touchedView isKindOfClass:[UICollectionView class]])
        {
            UICollectionView *collectionView = (UICollectionView*) touchedView;
            
            if(collectionView == self.collectionViewCurrentDeck)
            {
                [self.dataArrayCurrentCardDeck addObject:self.productTouched];
                [self.collectionViewCurrentDeck reloadData];
                
                [self.dataArrayAllCards removeObject:self.productTouched];
                [self.collectionView reloadData];
                
                [self.cardDublicate removeFromSuperview];
                self.productTouched = nil;
                
               // [self.dataManager saveProducts:self.dataArrayAllCards andProductsInDeck:self.dataArrayCurrentCardDeck];
            }
        }
    }

}

-(IBAction)handleSingleTap:(UITapGestureRecognizer*)recognizer
{
    
    CGPoint touch = [recognizer locationInView:self.view];
    UIView *touchedView = [self.view hitTest:touch withEvent:nil];
    //CGRect frame =  [self.cardDetailView convertRect:self.cardDetailView.bounds toView:self.view];
    
    if([touchedView isKindOfClass:[TCardCollectionViewCell class]])
    {
        TCardCollectionViewCell *cardField = (TCardCollectionViewCell*) touchedView;
        NSIndexPath *path = [self.collectionView indexPathForCell:cardField];
        Product *productTouched = [self.dataArrayAllCards objectAtIndex:path.row];

        
        TDetailCardViewController *detailVc = [CardGenerator generateDetailCard:productTouched];
        UIImage *snapshot = [detailVc snapshotView];
       
        
        UIImageView *view = [[UIImageView alloc] initWithFrame:cardField.frame];
        view.image = snapshot;
        
            NSLog(@"card touched");
        
    }
    
}


@end
