//
//  SHACode.h
//  TudorGame
//
//  Created by David Joerg on 21.01.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHACode : NSObject
+(NSString*)getHash:(NSString*)text;
@end
