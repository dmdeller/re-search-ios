//
//  Record.m
//  Re-Search
//
//  Created by David on 7/19/14.
//  Copyright (c) 2014 David Deller. All rights reserved.
//

#import "Record.h"

#import <MagicalRecord/CoreData+MagicalRecord.h>

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

#pragma mark -

+ (NSArray *)importFromArrayAndWait:(NSArray *)listOfObjectData inContext:(NSManagedObjectContext *)context
{
    NSMutableArray *objectIDs = [NSMutableArray array];
    
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext)
     {
         [listOfObjectData enumerateObjectsWithOptions:0 usingBlock:^(id obj, NSUInteger idx, BOOL *stop)
          {
              NSDictionary *objectData = (NSDictionary *)obj;
              
              NSManagedObject *dataObject = [self MR_importFromObject:objectData inContext:localContext];
              
              if ([context obtainPermanentIDsForObjects:[NSArray arrayWithObject:dataObject] error:nil])
              {
                  [objectIDs addObject:[dataObject objectID]];
              }
          }];
     }];
    
    return [self MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"self IN %@", objectIDs] inContext:context];
}

@end
