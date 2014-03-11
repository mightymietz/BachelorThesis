//
//  UserData.h
//  TudorGame
//
//  Created by David Joerg on 11.03.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ProductData;

@interface UserData : NSManagedObject

@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * name;

@end


