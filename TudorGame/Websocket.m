//
//  Websocket.m
//  TudorGame
//
//  Created by David Joerg on 06.02.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import "Websocket.h"
#import "AppSpecificValues.h"
#import "AppDelegate.h"

@implementation Websocket
SRWebSocket *_webSocket;

+ (id)sharedManager
{
    static Websocket *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (void)reconnect;
{
    _webSocket.delegate = nil;
    [_webSocket close];
    
    _webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:WEBSOCKET_ADDRESS]]];
    _webSocket.delegate = self;
    
    NSLog(@"Opening Connection...");
    [_webSocket open];
    
}

-(void)close
{
    _webSocket.delegate = nil;
    [_webSocket close];
}

#pragma mark - SRWebSocketDelegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
{
    NSLog(@"Websocket Connected");
    
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    
    [app websocketDidOpen];
    
    
 
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
{
    NSLog(@":( Websocket Failed With Error %@", error);

    
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    
    [app websocketDidFail];
    
    _webSocket = nil;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;
{
  
    
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    
    [app websocketDidReceiveMessage:message];
    //[_messages addObject:[[TCMessage alloc] initWithMessage:message fromMe:NO]];
    //[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:_messages.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    //[self.tableView scrollRectToVisible:self.tableView.tableFooterView.frame animated:YES];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    NSLog(@"WebSocket closed");
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    [app websocketDidClose];

    _webSocket = nil;
}

-(void)sendMessage:(NSString*)message
{
    [_webSocket send:message];
}



@end
