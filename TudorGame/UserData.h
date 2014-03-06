//
//  UserData.h
//  TudorGame
//
//  Created by David Joerg on 05.02.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserData : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * password;

@end
