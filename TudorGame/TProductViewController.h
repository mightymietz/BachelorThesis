//
//  TProductViewController.h
//  TudorGame
//
//  Created by David Joerg on 09.01.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"

@interface TProductViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productCountryLabel;
@property (weak, nonatomic) IBOutlet UILabel *productEANCodeLabel;
@property (nonatomic, retain) Product *scannedProduct;
- (IBAction)backBtnTouched:(UIBarButtonItem *)sender;

@end
