//
//  FirstViewController.m
//  TudorGame
//
//  Created by David Joerg on 09.01.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import "FirstViewController.h"
#import "Item.h"
#import "User.h"
#import "TLogInViewController.h"
#import "AppSpecificValues.h"
@interface FirstViewController ()
@property(nonatomic,retain) Item *item;
@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
   self.item = [[Item alloc]init];
    
    [self.item addObserver:self forKeyPath:NSStringFromSelector(@selector(isFinished)) options:NSKeyValueObservingOptionNew context:nil];

    
   
  //  [self.item load];

   
}


-(void)viewDidAppear:(BOOL)animated
{
    User *sharedManager = [User sharedManager];
    
    if(sharedManager.isConnected == NO && sharedManager.cancelledLogIn == NO)
    {
        TLogInViewController *logInViewController =
        [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil]
         instantiateViewControllerWithIdentifier:LOGINVIEWCONTROLLER_ID];
        
        [self presentViewController:logInViewController animated:YES completion:nil ];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"%@",@"pdojfopijefpepfmfem");
    NSLog(@"%@", [self.item.array objectAtIndex:0]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
