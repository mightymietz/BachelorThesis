//
//  SpinnerView.m
//  DentaApp
//
//  Created by David Joerg on 28.10.13.
//  Copyright (c) 2013 David Joerg. All rights reserved.
//

#import "SpinnerView.h"
#import <QuartzCore/QuartzCore.h> 
@interface SpinnerView()
@end

@implementation SpinnerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(SpinnerView *)loadSpinnerIntoViewController:(UIViewController *)vc withText:(NSString*)text andBtnTouched:(SEL)function
{
    
    // Create a new view with the same frame size as the superView
    SpinnerView *spinnerView = [[SpinnerView alloc] initWithFrame:vc.view.bounds];
    spinnerView.tag = 110;
    // If something's gone wrong, abort!
    if(!spinnerView){ return nil; }
  
    // Create a new image view, from the image made by our gradient method
    UIImageView *background = [[UIImageView alloc] initWithImage:[spinnerView addBackground]];
    
    // Make a little bit of the superView show through
    background.alpha = 0.7;
    
    [spinnerView addSubview:background];
    
    ////////////////////
    //setup abortButton
    ///////////////////
    UIButton *abortButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [abortButton addTarget:vc
            action:function
     forControlEvents:UIControlEventTouchDown];
    
    [abortButton setTitle:@"abort" forState:UIControlStateNormal];
    abortButton.tintColor = [UIColor whiteColor];
    abortButton.layer.borderColor = [UIColor whiteColor].CGColor;
    abortButton.layer.borderWidth = 1.0f;
    abortButton.layer.cornerRadius = 20.0f;
    abortButton.frame = CGRectMake(spinnerView.center.x, spinnerView.center.y, 160.0f, 40.0f);
    abortButton.center = CGPointMake(spinnerView.center.x, spinnerView.center.y + 100.0f);
    [spinnerView addSubview:abortButton];
    
    ///////////////////
    //setup statusLabel
    //////////////////
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, spinnerView.center.y - 100.0f, spinnerView.frame.size.width, 40.0f)];
    statusLabel.tag = 111;
    statusLabel.textAlignment = NSTextAlignmentCenter;
    statusLabel.textColor = [UIColor whiteColor];
    statusLabel.text = text;
    [spinnerView addSubview:statusLabel];
    // Add the spinner view to the superView. Boom.
    [vc.view addSubview:spinnerView];
    
    if(!spinnerView){ return nil; }
    
    // This is the new stuff here ;)
    UIActivityIndicatorView *indicator =
    [[UIActivityIndicatorView alloc]
          initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
    
    // Set the resizing mask so it's not stretched
    indicator.autoresizingMask =
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleLeftMargin;
    
    // Place it in the middle of the view
    indicator.center = vc.view.center;
    
    // Add it into the spinnerView
    [spinnerView addSubview:indicator];
    
    // Start it spinning! Don't miss this step
    [indicator startAnimating];
    
    // Create a new animation
    CATransition *animation = [CATransition animation];
    
    // Set the type to a nice wee fade
    [animation setType:kCATransitionFade];
    
    // Add it to the superView
    [[vc.view layer] addAnimation:animation forKey:@"layerAnimation"];
    return spinnerView;
}

+(void)removeSpinnerFromViewController:(UIViewController *)vc
{
    // Add this in at the top of the method. If you place it after you've remove the view from the superView it won't work!
    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionFade];
    [[vc.view layer] addAnimation:animation forKey:@"layerAnimation"];
    // Take me the hells out of the superView!

    [[vc.view viewWithTag:110] removeFromSuperview];
}

+(void)updateLoadingStatus:(UIViewController*)vc withText: (NSString*)text
{
    if([[vc.view viewWithTag:111] isKindOfClass:[UILabel class]] )
    {
        UILabel *statusLabel = (UILabel*) [vc.view viewWithTag:111];
        statusLabel.text = text;
    }
}
-(UIImage *)addBackground
{
    // Create an image context (think of this as a canvas for our masterpiece) the same size as the view
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 1);
    
    // Our gradient only has two locations - start and finish. More complex gradients might have more colours
    size_t num_locations = 2;
    
    // The location of the colors is at the start and end
    CGFloat locations[2] = { 0.0, 1.0 };
    
    // These are the colors! That's two RBGA values
    CGFloat components[8] = {
        0.4,0.4,0.4, 0.8,
        0.1,0.1,0.1, 0.5 };
    
    // Create a color space
    CGColorSpaceRef myColorspace = CGColorSpaceCreateDeviceRGB();
    
    // Create a gradient with the values we've set up
    CGGradientRef myGradient = CGGradientCreateWithColorComponents (myColorspace, components, locations, num_locations);
    
    // Set the radius to a nice size, 80% of the width. You can adjust this
    float myRadius = (self.bounds.size.width*.8)/2;
    
    // Now we draw the gradient into the context. Think painting onto the canvas
    CGContextDrawRadialGradient (UIGraphicsGetCurrentContext(), myGradient, self.center, 0, self.center, myRadius, kCGGradientDrawsAfterEndLocation);
    
    // Rip the 'canvas' into a UIImage object
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // And release memory
    CGColorSpaceRelease(myColorspace);
    CGGradientRelease(myGradient);
    UIGraphicsEndImageContext();
    
    // … obvious.
    return image;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
