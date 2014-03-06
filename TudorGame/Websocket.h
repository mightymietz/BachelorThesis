//
//  Websocket.h
//  TudorGame
//
//  Created by David Joerg on 06.02.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRWebSocket.h"
@interface Websocket : NSObject <SRWebSocketDelegate>

+ (id)sharedManager;
- (void)reconnect;
-(void)close;
-(void)sendMessage:(NSString*)message;
@end
