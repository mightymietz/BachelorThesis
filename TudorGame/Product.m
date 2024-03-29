//
//  Product.m
//  TudorGame
//
//  Created by David Joerg on 09.01.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#import "Product.h"
#import "AppSpecificValues.h"
#import "Nutritive.h"
@implementation Product


/*-(NSString *)country
{
    
    
    return [self encodeEANToCountry:self.EANCode];
}*/



-(NSArray *)sortedNutritives
{
    NSSet *nut = self.nutritives;
    NSArray *tempArray = [nut allObjects];
    for(int i = 0; i < tempArray.count; i++)
    {
        Nutritive *n = [tempArray objectAtIndex:i];
        NSLog(@"%@", n.nutritiveID);
    }
    NSArray *stringOrder = [NSArray arrayWithObjects:K_JOULE, KCAL, PROTEIN, CARBOHYDRATE, SUGAR, FAT, SATURATES, FIBRE, SODIUM, nil];
    tempArray = [tempArray sortedArrayUsingComparator:^NSComparisonResult(Nutritive *obj1, Nutritive *obj2)
     {
         return [@([stringOrder indexOfObject:obj1.nutritiveID]) compare:@([stringOrder indexOfObject:obj2.nutritiveID])];
     }];
    
    
    for(int i = 0; i < tempArray.count; i++)
    {
        Nutritive *n = [tempArray objectAtIndex:i];
        NSLog(@"%@", n.nutritiveID);
    }
    return tempArray;
}



-(NSString*) encodeEANToCountry:(NSInteger*)code
{
    NSString *country = nil;
    /*NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *finalPath = [path stringByAppendingPathComponent:@"EANCodes.plist"];
    NSDictionary *plistDict = [[NSDictionary alloc] initWithContentsOfFile:finalPath];
    
    NSMutableDictionary *tempDict = (NSMutableDictionary*) plistDict;
    NSMutableString *str = nil;
    int strLength = NSString;
    

        
        NSString *tempStr = nil;
        
        for(NSString *key in tempDict)
        {
            tempStr = [self getNumbersOfEAN:key];
            if(tempStr == nil)
            {
               NSArray *tempArray = [key componentsSeparatedByString:@"-"];
                
                tempStr = [self getNumbersOfEAN: [tempArray objectAtIndex:0]];
                
                int max = [[tempArray objectAtIndex:1] integerValue];
                int min = [[tempArray objectAtIndex:0] integerValue];
                int ean = [tempStr intValue];
                
                if(ean >= min && ean <= max)
                {
                    country = [tempDict valueForKey:key];
                    break;
                }
                
                
            }
            else
            {
                country = [tempDict valueForKey:key];
                break;
            }
            
            
            
                
                
            
        
        
    }*/
    
    return country;

}

-(NSString*) getNumbersOfEAN:(NSString*)key
{
    
    NSString *tempStr = nil;
    /*if(key.length == 2)
    {
        tempStr = [self.EANCode substringToIndex:2];
        
    }
    else if(key.length == 3)
    {
        tempStr = [self.EANCode substringToIndex:3];
        
    }*/
    
    return tempStr;

}
@end
