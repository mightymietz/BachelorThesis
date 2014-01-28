 //
//  TUsersDeckViewController.m
//  TudorGame
//
//  Created by David Joerg on 17.01.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import "TUsersDeckViewController.h"
#import "User.h"
#import "Product.h"
#import "TCardCollectionViewCell.h"
#import "TCardViewController.h"
@interface TUsersDeckViewController ()
@property(nonatomic, retain) User *user;
@property(nonatomic, retain) NSArray *dataArray;
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
	// Do any additional setup after loading the view.
    self.user = [User sharedManager];
    [self.user getProductsFromServerWithCompletion:^(BOOL finished)
     {
         NSLog(@"finished loading products");
         
         self.dataArray = self.user.products;
         
         [self.collectionView reloadData];
         
        // NSLog(@"%@",[[p.ingredients objectAtIndex:0] stringValue]);
         
         
     }];
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
    
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TCardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CardCell" forIndexPath:indexPath];
    
    
   
    
    Product *currentProduct = [self.dataArray objectAtIndex:indexPath.row];
    cell.vc.product = currentProduct;
    
    [cell updateCell];
  
   
    
    
    return cell;
}


- (IBAction)backBtnTouched:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
