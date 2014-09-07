//
//  SearchDeterminator.m
//  Re-Search
//
//  Created by David on 9/7/14.
//  Copyright (c) 2014 David Deller. All rights reserved.
//

#import "SearchDeterminator.h"

static NSString *const kAppGroupID = @"group.Re-Search";

static NSString *const kDefaultsEngineID = @"id";
static NSString *const kDefaultsEngineDomainPart = @"domainPart";
static NSString *const kDefaultsEngineQueryPart = @"queryPart";
static NSString *const kDefaultsEngineRedirectURL = @"redirectURL";

@implementation SearchDeterminator

+ (NSUserDefaults *)sharedDefaults
{
    return [NSUserDefaults.alloc initWithSuiteName:kAppGroupID];
}

+ (NSURL *)sharedCoreDataStoreURL
{
    static NSString *databaseName = @"Re-Search.sqlite";
    NSURL *URL = [[NSFileManager.defaultManager containerURLForSecurityApplicationGroupIdentifier:kAppGroupID] URLByAppendingPathComponent:databaseName];
    
    return URL;
}

+ (NSURL *)redirectURLForCurrentSearchPageURL:(NSURL *)currentURL
{
    return [NSURL URLWithString:@"https://duckduckgo.com"];
}

@end
