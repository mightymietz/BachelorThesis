//
//  TNewProductViewController.h
//  TudorGame
//
//  Created by David Joerg on 12.03.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AppSpecificValues.h"
@interface TNewProductViewController : UIViewController< AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIView *scanImage;
@property (weak, nonatomic) IBOutlet UILabel *scanLabel;
@property (weak, nonatomic) IBOutlet UITableView *nutritivesTableView;
@property (weak, nonatomic) IBOutlet UITextView *ingredientsTextView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *eanCodeLabel;

- (IBAction)cancelBtnTouched:(id)sender;
- (IBAction)scanOtherProductBtnTouched:(id)sender;

@end
