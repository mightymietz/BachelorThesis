//
//  AppDelegate.m
//  TudorGame
//
//  Created by David Joerg on 09.01.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import "AppDelegate.h"
#import "DataManager.h"
#import "Websocket.h"
#import "AppSpecificValues.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    
    //[user addObserver:self forKeyPath:NSStringFromSelector(@selector(isConnected)) options:NSKeyValueObservingOptionNew context:nil];
   // [sharedManager connectUserWith:sharedManager.username andPassword:sharedManager.password];

    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
    //User *user = [User sharedManager];
   // [user removeObserver:self forKeyPath:NSStringFromSelector(@selector(isConnected))];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:DID_CONNECT_TO_WEBSOCKET
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:DID_RECEIVE_REMOTE_NOTIFICATION
     object:nil];

    [[UIApplication sharedApplication] unregisterForRemoteNotifications];

}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    DataManager *manager = [DataManager sharedManager];

    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    manager.player.currentID = token;
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
     DataManager *manager = [DataManager sharedManager];
     manager.player.currentID = @"0";
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    completionHandler(UIBackgroundFetchResultNewData);
    
    DataManager *manager = [DataManager sharedManager];

    if([userInfo  objectForKey: APN_DATA_TYPE_GAME_DATA] != nil)
    {
      /*  NSLog(@"%@", [userInfo objectForKey: APN_DATA_TYPE_GAME_DATA]);
        [user updateGameData:[userInfo objectForKey: APN_DATA_TYPE_GAME_DATA] completion:^(BOOL finished)
         {
           
             [[NSNotificationCenter defaultCenter]
              postNotificationName: DID_RECEIVE_REMOTE_NOTIFICATION
              object:self
              userInfo:userInfo];
         }];*/
       
    }
    
    
    
}


- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"UserCoreData" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"UserCoreData.sqlite"];

    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}



-(void)websocketDidReceiveMessage:(NSString*)message
{
    
    
    NSError* error = nil;
    NSDictionary *JSONdict =
    [NSJSONSerialization JSONObjectWithData: [message dataUsingEncoding:NSUTF8StringEncoding]
                                    options: NSJSONReadingMutableContainers | NSJSONReadingAllowFragments
                                      error: &error];
    DataManager *manager = [DataManager sharedManager];
    
    NSString *messageType = [JSONdict objectForKey:MESSAGE_TYPE];

    
    if([messageType isEqualToString:USER_LOGGED_IN])
    {
        NSLog(@"logged in");
      

        manager.player.status = messageType;
        [[NSNotificationCenter defaultCenter]
         postNotificationName: USER_STATUS_CHANGED
         object:self
         userInfo:nil];
        
        
    }
    
    if([messageType isEqualToString:USERNAME_OR_PASSWORD_WRONG])
    {
        NSLog(@"username or password wrong in");
        
        
        manager.player.status = messageType;
        [[NSNotificationCenter defaultCenter]
         postNotificationName: USER_STATUS_CHANGED
         object:self
         userInfo:nil];
        
        
    }
    
    if([messageType isEqualToString:USER_ALREADY_LOGGED_IN])
    {
        manager.player.status = messageType;
        Websocket *websocket = [Websocket sharedManager];
        [websocket close];
        [[NSNotificationCenter defaultCenter]
         postNotificationName: USER_STATUS_CHANGED
         object:self
         userInfo:nil];

    }
    
    if([messageType isEqualToString:PRODUCTS])
    {
        [manager mapProductsFromDictionary:JSONdict];
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName: PRODUCTS_UPDATED
         object:self
         userInfo:nil];
        
    }
    
    if([messageType isEqualToString:GAMEDATA])
    {
        [manager mapGameFromDictionary: JSONdict];
        [[NSNotificationCenter defaultCenter]
         postNotificationName: GAME_UPDATED
         object:self
         userInfo:nil];
    }
    
    if([messageType isEqualToString:GAME_STARTED])
    {
        manager.game.gameStatus = GAMESTATUS_RUNNING;
        [[NSNotificationCenter defaultCenter]
         postNotificationName: GAME_UPDATED
         object:self
         userInfo:nil];
    }
}

-(void)websocketDidOpen
{
    DataManager *dataManager = [DataManager sharedManager];
    dataManager.player.status = CONNECTION_ESTABLISHED;
    //user.status = CONNECTION_ESTABLISHED;
    [dataManager sendUserDataViaWebSocket];

}

-(void)websocketDidClose
{
    DataManager *dataManager = [DataManager sharedManager];

    dataManager.player.status = USER_LOGGED_OUT;
    [[NSNotificationCenter defaultCenter]
     postNotificationName: USER_STATUS_CHANGED
     object:self
     userInfo:nil];
    
}
-(void)websocketDidFail
{
     DataManager *dataManager = [DataManager sharedManager];
    dataManager.player.status = USER_CONNECTION_FAIL;
    [[NSNotificationCenter defaultCenter]
     postNotificationName: USER_STATUS_CHANGED
     object:self
     userInfo:nil];
    
}


@end
