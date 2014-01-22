//
//  SHACode.m
//  TudorGame
//
//  Created by David Joerg on 21.01.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import "SHACode.h"
#import <CommonCrypto/CommonDigest.h>
@implementation SHACode

+(NSString*)getHash:(NSString*)text
{
    NSData *data = [self createHash:text];
    
    return [self asHex:data];
}

+(NSData*)createHash:(NSString*) text
{
    unsigned char hashedChars[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1([text UTF8String], (int)[text lengthOfBytesUsingEncoding:NSUTF8StringEncoding], hashedChars);

    NSData * hashedData = [NSData dataWithBytes:hashedChars length:  CC_SHA1_DIGEST_LENGTH];
    
    return hashedData;

}

+(NSString*)asHex:(NSData*)data
{
    /* Returns hexadecimal string of NSData. Empty string if data is empty.   */
    
    const unsigned char *dataBuffer = (const unsigned char *)[data bytes];
    
    if (!dataBuffer)
        return [NSString string];
    
    NSUInteger          dataLength  = [data length];
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; ++i)
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    
    return [NSString stringWithString:hexString];
}

@end
