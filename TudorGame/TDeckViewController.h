//
//  TDeckViewController.h
//  TudorGame
//
//  Created by David Joerg on 09.01.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AppSpecificValues.h"

@interface TDeckViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate>

- (IBAction)showDeckBtnTouched:(id)sender;
- (IBAction)backBtnTouched:(UIBarButtonItem *)sender;
- (IBAction)addNewCardBtnTouched:(id)sender;
@end
