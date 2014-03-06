//
//  SpinnerView.h
//  DentaApp
//
//  Created by David Joerg on 28.10.13.
//  Copyright (c) 2013 David Joerg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpinnerView : UIView
+(SpinnerView *)loadSpinnerIntoViewController:(UIViewController *)vc withText:(NSString*)text andBtnTouched:(SEL)function;
+(void)removeSpinnerFromViewController:(UIViewController *)vc;
+(void)updateLoadingStatus:(UIViewController*)vc withText: (NSString*)text;
@end
