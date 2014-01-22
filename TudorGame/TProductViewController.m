//
//  TProductViewController.m
//  TudorGame
//
//  Created by David Joerg on 09.01.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import "TProductViewController.h"

@interface TProductViewController ()

@end

@implementation TProductViewController

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
    
    self.productEANCodeLabel.text = [NSString stringWithFormat:@"%@ %@", @"EAN: ", self.scannedProduct.EANCode];
    self.productCountryLabel.text = [NSString stringWithFormat:@"%@ %@", @"COUNTRY: ",self.scannedProduct.country];
    
    //Aufgabe an den Spieler wird gestellt
    [self showTask];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-----------------------------------------------------------------------------------------------------
#pragma Server
//-----------------------------------------------------------------------------------------------------

//stellt einen taskRequest  an den Server und bekommt diesen zurück und wird dann dem Spieler angezeigt
-(void) showTask
{
    NSString *task = [self requestTaskFromServer];
    UIAlertView *serverTaskAlert = nil;
    if([task isEqualToString:@"Take a Photo from the ingredients"])
    {
        serverTaskAlert = [[UIAlertView alloc] initWithTitle:@"Task" message:task delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
      

    }
    else
    {
        serverTaskAlert = [[UIAlertView alloc] initWithTitle:@"Task" message:task delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];

    }
    
    [serverTaskAlert show];
}

//Stellt request an den Server und erhält den task
-(NSString*) requestTaskFromServer
{
    NSString *task= @"test";
    
    return task;
   
}

//Task ist fertig beantwortet, Ergebnis wird an Server übertragen
-(void)taskIsCompletedWithResult:(NSString*)result
{
   // if(result isEqualToString:<#(NSString *)#>)
}


//-----------------------------------------------------------------------------------------------------
#pragma Alertview
//-----------------------------------------------------------------------------------------------------

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex == 0)    //Frage ist mit Nein beantwortet
    {
        
    }
    else
    {
        
    }
}

//-----------------------------------------------------------------------------------------------------
#pragma TableView
//-----------------------------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }
    
       
    
    return cell;
}



//-----------------------------------------------------------------------------------------------------
#pragma BtnActions
//-----------------------------------------------------------------------------------------------------

- (IBAction)backBtnTouched:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
