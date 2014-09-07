//
//  Record.m
//  Re-Search
//
//  Created by David on 7/19/14.
//  Copyright (c) 2014 David Deller. All rights reserved.
//

#import "Record.h"

@implementation Record

- (NSDictionary *)serializedData
{
    NSMutableDictionary *data = NSMutableDictionary.new;
    NSArray *attributeNames = self.entity.attributesByName.allKeys;
    
    for (NSString *attributeName in attributeNames)
    {
        id value = [self valueForKey:attributeName];
        
        if (![value conformsToProtocol:@protocol(NSCoding)] && value != nil)
        {
            NSLog(@"%@: Cannot serialize attribute: %@ value: %@", self.class, attributeName, value);
            continue;
        }
        
        if (value == nil)
        {
//            value = NSNull.null;
            continue;
        }
        
        data[attributeName] = value;
    }
    
    return [NSDictionary dictionaryWithDictionary:data];
}

@end
