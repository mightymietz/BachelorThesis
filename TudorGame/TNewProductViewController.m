//
//  TNewProductViewController.m
//  TudorGame
//
//  Created by David Joerg on 12.03.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import "TNewProductViewController.h"
#import "DataManager.h"
#import "TNutritiveCell.h"
#import "Nutritive.h"

@interface TNewProductViewController ()
@property (strong) AVCaptureSession *captureSession;
@property (nonatomic, retain) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, retain)Product *receivedProduct;
@property (nonatomic, retain)NSString *eanCode;
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
    
    static NSString *CellIdentifier = @"NutritiveCell";
    UINib *cellNib = [UINib nibWithNibName:@"TNutritiveCell" bundle:nil];
    [self.nutritivesTableView registerNib:cellNib forCellReuseIdentifier:CellIdentifier];
    
    [self startCapture];
}

-(void)viewDidAppear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(productReceived:)
     name: PRODUCT_RECEIVED
     object:nil];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:PRODUCT_RECEIVED
     object:nil];
}


#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputMetadataObjects:(NSArray *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection
{

    NSString *EANType = nil;
    AVMetadataObject *metadata =[metadataObjects objectAtIndex:0];
    
    
    if ([metadata.type isEqualToString:AVMetadataObjectTypeEAN8Code] ||
        [metadata.type isEqualToString:AVMetadataObjectTypeEAN13Code])
    {
        
        self.eanCode = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
        EANType = metadata.type;
    }
    
    DataManager *dataManager = [DataManager sharedManager];
    
    [dataManager getProductViaWebsocket:self.eanCode];
    
    
    
    //self.scannedProduct.EANCode = [EANCode integerValue];
    self.cancelBtn.hidden = YES;
    self.scanLabel.hidden = YES;
    self.scanImage.hidden = YES;
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

-(void)questionReceived:(NSDictionary*)userInfo
{
    DataManager *dataManager = [DataManager sharedManager];
    NSString *question = dataManager.receivedQuestion;
    NSString *message = [NSString stringWithFormat:@"You have %d points \nAnswer the question and gain 100 points! \n %@", dataManager.player.points, question];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Do you want to gain some Points?" message:message delegate:self cancelButtonTitle:@"NO, Thanks" otherButtonTitles:@"YES", @"NO", nil];
    alert.tag = 1;
    [alert show];

    
}
-(void)productReceived:(NSDictionary *)updatedProduct
{
    DataManager *dataManager = [DataManager sharedManager];
    
    self.receivedProduct = dataManager.receivedProduct;
    self.title = self.receivedProduct.name;
    
    [self fillValues];
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(questionReceived:)
     name: QUESTION_RECEIVED
     object:nil];
    
    DataManager *manager = [DataManager sharedManager];
    [manager getQuestionViaWebsocket:self.eanCode];
    
    //self.dataArrayAllCards = [NSMutableArray arrayWithArray: self.dataManager.player.products];
    //self.dataArrayCurrentCardDeck = self.user.productsChoosenForDeck;
    
    //self.dataArrayCurrentCardDeck = self.player.products;
    
    
    
    //[SpinnerView removeSpinnerFromViewController:self];
}

-(void)fillValues
{
    self.nameLabel.text = self.receivedProduct.name;
    self.eanCodeLabel.text =[NSString stringWithFormat:@"%@", self.receivedProduct.EANCode];
    
    NSArray *ingredients = self.receivedProduct.ingredients;
    NSString *result = [ingredients componentsJoinedByString:@","];
   
    self.ingredientsTextView.text = result;
    
    [self.nutritivesTableView reloadData];
    
}

///////////////////////////////////////////
//////TableViewdelegate and datasource/////
///////////////////////////////////////////

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.receivedProduct.nutritives.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NutritiveCell";
    TNutritiveCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(cell == nil)
    {
        cell = [[TNutritiveCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    
    long row = indexPath.row;
    
    NSArray *array = [self.receivedProduct.nutritives allObjects];
    Nutritive *currentNutritive = [array objectAtIndex:row];
    
    cell.nameLabel.text = currentNutritive.name;
    cell.valueLabel.text = [NSString stringWithFormat:@"%@%@",currentNutritive.value, currentNutritive.unit];
    
    if(row % 2 == 0)
    {
        
        cell.backgroundColor = [UIColor grayColor];
        cell.nameLabel.textColor = [UIColor whiteColor];
        cell.valueLabel.textColor = [UIColor whiteColor];

    }
    else
    {
        cell.backgroundColor = [UIColor whiteColor];
        cell.nameLabel.textColor = [UIColor grayColor];
        cell.valueLabel.textColor = [UIColor grayColor];
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

///////////////////////////////////////////
//////UIAlertView delegate/////
///////////////////////////////////////////
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //server should ask question
   
    if(alertView.tag == 1)
    {
        if(buttonIndex != 0)
        {
            DataManager *manager = [DataManager sharedManager];
            [manager getQuestionViaWebsocket:self.eanCode];
            
            manager.player.points += 100;
        }
        else
        {
            
            [[NSNotificationCenter defaultCenter]
             removeObserver:self
             name:QUESTION_RECEIVED
             object:nil];
        }

    }
   
}
///////////////////////////////////////////
//////Button Actions/////
///////////////////////////////////////////


- (IBAction)scanOtherProductBtnTouched:(id)sender
{

    self.cancelBtn.hidden = NO;
    self.scanLabel.hidden = NO;
    self.scanImage.hidden = NO;
    [self startCapture];
    

    
}
- (IBAction)cancelBtnTouched:(id)sender
{
    self.cancelBtn.hidden = YES;
    self.scanLabel.hidden = YES;
    self.scanImage.hidden = YES;
    [self.captureSession stopRunning];
    [self.previewLayer removeFromSuperlayer];
    [self dismissViewControllerAnimated:NO completion:nil];
    
}


///////////////////////////////////////////
//////Other functions/////
///////////////////////////////////////////

-(void)startCapture
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
    
    if(IS_IPHONE5)
    {
        self.previewLayer.frame = CGRectMake(0, 0, 568, 320);
        
    }
    else
    {
        self.previewLayer.frame = CGRectMake(0, 0, 480, 320);
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
@end
