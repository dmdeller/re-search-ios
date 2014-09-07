//
//  SearchData.m
//  Re-Search
//
//  Created by David on 9/7/14.
//  Copyright (c) 2014 David Deller. All rights reserved.
//

#import "SearchData.h"

#import "SearchDeterminator.h"

@implementation SearchData

- (void)setupCoreData
{
    // BAD HACK: MagicalRecord's method signatures specify an NSString, but it actually knows what to do with an NSURL.
    // For proof, see the first line of NSPersistentStoreCoordinator+MagicalRecord -MR_addSqliteStoreNamed:withOptions:
    // The only way we can get it to accept an absolute URL is by passing it an NSURL instead of an NSString.
    id storeURL = SearchDeterminator.sharedCoreDataStoreURL;
    
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:storeURL];
    
    [self importSeeds];
}

- (void)importSeeds
{
    NSLog(@"Starting seed import");
    
    NSDictionary *entities = NSManagedObjectContext.MR_defaultContext.persistentStoreCoordinator.managedObjectModel.entitiesByName;
    
    for (NSString *entityName in entities.allKeys)
    {
        // Note: Add a 'Copy Files' build phase to the target in order to make sure this gets put in the right place
        NSURL *seedURL = [NSBundle.mainBundle URLForResource:entityName withExtension:@"json" subdirectory:@"Seed Data"];
        
        if ([NSFileManager.defaultManager fileExistsAtPath:seedURL.path])
        {
            NSInputStream *fileStream = [NSInputStream inputStreamWithURL:seedURL];
            [fileStream open];
            
            NSError *error = nil;
            NSArray *data = [NSJSONSerialization JSONObjectWithStream:fileStream options:0 error:&error];
            if (data != nil)
            {
                NSAssert([data isKindOfClass:NSArray.class], @"JSON must have array at root");
                
                NSEntityDescription *entity = entities[entityName];
                Class recordClass = NSClassFromString(entity.managedObjectClassName);
                
                // Each record must have a unique primary key, and the attribute must be specified using 'relatedByAttribute' in the xcdatamodel
                // https://github.com/magicalpanda/MagicalRecord/issues/180#issuecomment-6403926
                [recordClass MR_importFromArray:data];
                
                NSLog(@"Imported %@ seeds", entityName);
            }
            else
            {
                NSLog(@"Error parsing seed data for entity: %@, error: %@", entityName, error);
            }
        }
        else
        {
            NSLog(@"No seed data for entity: %@", entityName);
        }
    }
    
    NSLog(@"Finished seed import");
}

@end
