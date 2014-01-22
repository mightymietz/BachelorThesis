//
//  TDeckViewController.m
//  TudorGame
//
//  Created by David Joerg on 09.01.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import "TDeckViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "TProductViewController.h"
#import "Product.h"
#import "User.h"
@interface TDeckViewController ()
@property (strong) AVCaptureSession *captureSession;
@property (nonatomic, retain) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic,retain) Product *scannedProduct;
@end

@implementation TDeckViewController

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
    self.scannedProduct =[[Product alloc] init];
   	// Do any additional setup after loading the view.
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}
-(BOOL)shouldAutorotate
{
    return NO;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-----------------------------------------------------------------------------------------------------
#pragma Camera
//-----------------------------------------------------------------------------------------------------


//-----------------------------------------------------------------------------------------------------
#pragma Seque
//-----------------------------------------------------------------------------------------------------

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *destinationVC = segue.destinationViewController;
    
    if([destinationVC isKindOfClass:[TProductViewController class]])
    {
        TProductViewController *productVC = (TProductViewController*) destinationVC;
        
        productVC.scannedProduct = self.scannedProduct;
    }
    else
    {
        NSLog(@"Wrong UIViewController Class was sent to Segue");
    }
}

//-----------------------------------------------------------------------------------------------------
#pragma BtnActions
//-----------------------------------------------------------------------------------------------------

- (IBAction)showDeckBtnTouched:(id)sender
{
     // User *sharedManager = [User sharedManager];
    
    //[sharedManager addObserver:self forKeyPath:NSStringFromSelector(@selector(products)) options:NSKeyValueObservingOptionNew context:nil];
    /*[sharedManager getProductsFromServerWithCompletion:^(BOOL finished)
     {
         NSLog(@"finished");
         
     }];*/
}

- (IBAction)backBtnTouched:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)addNewCardBtnTouched:(id)sender
{
    self.captureSession = [[AVCaptureSession alloc] init];
    AVCaptureDevice *videoCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoCaptureDevice error:&error];
    if(videoInput)
        [self.captureSession addInput:videoInput];
    else
        NSLog(@"Error: %@", error);
    
    AVCaptureMetadataOutput *metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [self.captureSession addOutput:metadataOutput];
    [metadataOutput setMetadataObjectsDelegate:(id) self queue:dispatch_get_main_queue()];
    [metadataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code]];
    
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    self.previewLayer.frame = self.view.layer.bounds;
    [self.view.layer addSublayer:self.previewLayer];
    
    [self.captureSession startRunning];

}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputMetadataObjects:(NSArray *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection
{
    NSString *EANCode = nil;
    NSString *EANType = nil;
    AVMetadataObject *metadata =[metadataObjects objectAtIndex:0];
    
   
    if ([metadata.type isEqualToString:AVMetadataObjectTypeEAN8Code] ||
        [metadata.type isEqualToString:AVMetadataObjectTypeEAN13Code])
    {
            
        EANCode = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
        EANType = metadata.type;
    }
    
    
    
    
    self.scannedProduct.EANCode = EANCode;
    
    [self.captureSession stopRunning];
    [self.previewLayer removeFromSuperlayer];
    
    [self performSegueWithIdentifier:SEGUE_PRODUCT sender:self];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
   
     User *sharedManager = [User sharedManager];
   // NSDictionary *products = sharedManager.products;
    
   /* for( NSString *aKey in products )
    {
        NSLog(@"%@", aKey);
    }*/
    

      NSLog(@"%@",@"pdojfopijefpepfmfem");
}

@end
