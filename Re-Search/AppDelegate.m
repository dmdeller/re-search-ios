//
//  AppDelegate.m
//  Re-Search
//
//  Created by David on 7/19/14.
//  Copyright (c) 2014 David Deller. All rights reserved.
//

#import "AppDelegate.h"

#import "SearchEngine.h"

#import <ReSearchKit/ReSearchKit.h>
#import <MagicalRecord/CoreData+MagicalRecord.h>

@interface AppDelegate ()

@end

@implementation AppDelegate
            

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [self setupCoreData];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Core Data

- (void)setupCoreData
{
    [MagicalRecord setupAutoMigratingCoreDataStack];
    
    [self importSeeds];
    [self setupDefaults];
    [self exportDataToDefaults];
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

- (void)setupDefaults
{
    if ([SearchDeterminator.sharedDefaults stringForKey:kDefaultsFavouriteEngineID] == nil)
    {
        // Need a default engine.
        // Don't want to use Google because that's already the iOS/Safari default.
        // Don't want to use DuckDuckGo because privacy-conscious users (primary target of this app) will have already set that in Safari.
        // Pick one that's unlikely to be set in Safari, but still familiar. Bing(-o)!
        [SearchDeterminator.sharedDefaults setObject:kEngineIDBing forKey:kDefaultsFavouriteEngineID];
        [SearchDeterminator.sharedDefaults synchronize];
    }
}

// Yuck. This is due to not being able to get MagicalRecord (or indeed, ANY cocoapods) working with ReSearchKit.
- (void)exportDataToDefaults
{
    NSArray *engines = [SearchEngine MR_findAllSortedBy:@"order" ascending:YES];
    NSMutableArray *serializedData = [NSMutableArray arrayWithCapacity:engines.count];
    
    for (SearchEngine *engine in engines)
    {
        [serializedData addObject:engine.serializedData];
    }
    
    [SearchDeterminator.sharedDefaults setObject:@"hello" forKey:@"test"];
    [SearchDeterminator.sharedDefaults setObject:[NSArray arrayWithArray:serializedData] forKey:kDefaultsAllEngines];
    [SearchDeterminator.sharedDefaults synchronize];
    
}

@end
