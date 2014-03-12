//
//  TNewProductViewController.m
//  TudorGame
//
//  Created by David Joerg on 12.03.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import "TNewProductViewController.h"

@interface TNewProductViewController ()
@property (strong) AVCaptureSession *captureSession;
@property (nonatomic, retain) AVCaptureVideoPreviewLayer *previewLayer;
@end

@implementation TNewProductViewController

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
    NSLog(@"%d", self.interfaceOrientation);
     NSLog(@"%f", self.view.bounds.size.width);
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
    
    if(IS_IPHONE)
    {
        self.previewLayer.frame = CGRectMake(0, 0, 480, 320);
    }
    else
    {
         self.previewLayer.frame = CGRectMake(0, 0, 568, 320);
    }
  
    
    if(self.previewLayer.connection.supportsVideoOrientation)
    {
        self.previewLayer.connection.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
    }
    
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];

    [self.view.layer addSublayer:self.previewLayer];
    
    [self.view bringSubviewToFront:self.cancelBtn];
    [self.view bringSubviewToFront:self.scanImage];
    [self.view bringSubviewToFront:self.scanLabel];

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
    
    
    
    
    //self.scannedProduct.EANCode = [EANCode integerValue];
    [self.cancelBtn removeFromSuperview];
    [self.scanLabel removeFromSuperview];
    [self.scanImage removeFromSuperview];
    [self.captureSession stopRunning];
    [self.previewLayer removeFromSuperlayer];
    
    //[self performSegueWithIdentifier:SEGUE_PRODUCT sender:self];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancelBtnTouched:(id)sender
{
    [self.cancelBtn removeFromSuperview];
    [self.scanLabel removeFromSuperview];
    [self.scanImage removeFromSuperview];
    [self.captureSession stopRunning];
    [self.previewLayer removeFromSuperlayer];
    [self dismissViewControllerAnimated:NO completion:nil];
    
}
@end
