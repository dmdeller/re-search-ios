//
//  SearchDeterminator.m
//  Re-Search
//
//  Created by David on 9/7/14.
//  Copyright (c) 2014 David Deller. All rights reserved.
//

#import "SearchDeterminator.h"

static NSString *const kAppGroupID = @"group.horizonnigh.research";

static NSString *const kEngineID = @"id";
static NSString *const kEngineDomainPart = @"domainPart";
static NSString *const kEngineQueryPart = @"queryPart";
static NSString *const kEngineRedirectURL = @"redirectURL";

@implementation SearchDeterminator

+ (NSUserDefaults *)sharedDefaults
{
    return [NSUserDefaults.alloc initWithSuiteName:kAppGroupID];
    
//    NSUserDefaults *defaults = NSUserDefaults.new;
//    [defaults addSuiteNamed:kAppGroupID];
//    
//    return defaults;
}

#pragma mark - Engines

+ (NSDictionary *)redirectEngineForID:(NSString *)favouriteID inEngines:(NSArray *)engines currentEngineID:(NSString *)currentID
{
    static NSString *googleID = @"7A8141DE-CC69-46F0-B913-2719102ED88B";
    static NSString *duckDuckGoID = @"11A7CF8D-9908-4D9E-B38C-68DD7E118958";
    
    if ([currentID isEqualToString:favouriteID])
    {
        if ([currentID isEqualToString:duckDuckGoID])
        {
            NSLog(@"%@: Current search page and favourite are both DuckDuckGo; redirecting to Google instead", self.class);
            
            return [self engineForID:googleID inEngines:engines];
        }
        else
        {
            NSLog(@"%@: Current search page and favourite are the same; redirecting to DuckDuckGo instead", self.class);
            
            return [self engineForID:duckDuckGoID inEngines:engines];
        }
    }
    else
    {
        return [self engineForID:favouriteID inEngines:engines];
    }
}

+ (NSDictionary *)engineForID:(NSString *)ID inEngines:(NSArray *)engines
{
    for (NSDictionary *engineData in engines)
    {
        if ([engineData[kEngineID] isEqualToString:ID])
        {
            return engineData;
        }
    }
    
    NSLog(@"%@: Could not find engine for ID: %@", self.class, ID);
    
    return nil;
}

#pragma mark - URLs

+ (NSURL *)redirectURLForCurrentSearchPageURL:(NSURL *)currentURL error:(NSError **)errorRef
{
    *errorRef = nil;
    
    NSLog(@"------------------------ %@", [self.sharedDefaults objectForKey:@"test"]);
    
    NSArray *engines = [self.sharedDefaults objectForKey:kDefaultsAllEngines];
    NSString *currentURLHostPart = currentURL.host;
    NSString *currentURLPathPart = currentURL.path;
    
    NSLog(@"%@: Engines: %@", self.class, engines);
    
    if (engines.count == 0)
    {
        NSError *error = [NSError errorWithDomain:SearchDeterminatorErrorDomain code:0 userInfo:@{
            NSLocalizedDescriptionKey: @"Please open the Re-Search app before using the extension.",
        }];
        
        *errorRef = error;
        
        return nil;
    }
    
    for (NSDictionary *engineData in engines)
    {
        if (engineData[kEngineQueryPart] == nil || [engineData[kEngineQueryPart] isKindOfClass:NSNull.class])
        {
            continue;
        }
        else if ([currentURLHostPart hasSuffix:engineData[kEngineDomainPart]])
        {
            NSString *engineQueryPart = engineData[kEngineQueryPart];
            
            NSString *pageQuery = [self queryStringForEngineQueryPart:engineQueryPart pagePathPart:currentURLPathPart];
            if (pageQuery.length > 0)
            {
                NSDictionary *redirectEngineData = [self redirectEngineForID:[self.sharedDefaults objectForKey:kDefaultsFavouriteEngineID] inEngines:engines currentEngineID:engineData[kEngineID]];
                if (redirectEngineData != nil)
                {
                    NSURL *redirectURL = [self redirectURLForEngineRedirectURL:redirectEngineData[kEngineRedirectURL] query:pageQuery];
                    if (redirectURL != nil)
                    {
                        return redirectURL;
                    }
                }
            }
        }
    }
    
    NSError *error = [NSError errorWithDomain:SearchDeterminatorErrorDomain code:0 userInfo:@{
        NSLocalizedDescriptionKey: @"Sorry, this page is not supported by Re-Search.",
    }];
    
    *errorRef = error;
    
    return nil;
}

+ (NSString *)queryStringForEngineQueryPart:(NSString *)engineQueryPart pagePathPart:(NSString *)pagePathPart
{
    if (![engineQueryPart containsString:kSearchQueryToken])
    {
        NSLog(@"%@: queryPart doesn't contain token: %@", self.class, engineQueryPart);
        return nil;
    }
    
    NSArray *engineQueryPartParts = [engineQueryPart componentsSeparatedByString:kSearchQueryToken];
    NSString *engineQueryFirstPart = engineQueryPartParts.firstObject;
    NSString *engineQueryLastPart = engineQueryPartParts.lastObject;
    
    if (![pagePathPart containsString:engineQueryFirstPart])
    {
        NSLog(@"%@: domain matched, but current URL doesn't contain first part of queryPart: %@", self.class, engineQueryFirstPart);
        return nil;
    }
    else if (engineQueryLastPart.length > 0 && ![pagePathPart containsString:engineQueryLastPart])
    {
        NSLog(@"%@: domain matched, but current URL doesn't contain last part of queryPart: %@", self.class, engineQueryLastPart);
        return nil;
    }
    
    NSScanner *scanner = [NSScanner scannerWithString:pagePathPart];
    NSString *encodedQuery = nil;
    
    [scanner scanUpToString:engineQueryFirstPart intoString:nil];
    [scanner scanString:engineQueryFirstPart intoString:nil];
    
    if (engineQueryLastPart.length > 0)
    {
        [scanner scanUpToString:engineQueryLastPart intoString:&encodedQuery];
    }
    else
    {
        [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"?&/"] intoString:&encodedQuery];
    }
    
    NSString *decodedQuery = [encodedQuery stringByReplacingOccurrencesOfString:@"+" withString:@" "].stringByRemovingPercentEncoding;
    
    return decodedQuery;
}

+ (NSURL *)redirectURLForEngineRedirectURL:(NSString *)engineRedirectURL query:(NSString *)query
{
    static NSString *allowedChars = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 ";
    NSCharacterSet *queryCharSet = [NSCharacterSet characterSetWithCharactersInString:allowedChars];
    
    NSString *encodedQuery = [[query stringByAddingPercentEncodingWithAllowedCharacters:queryCharSet] stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    if (![engineRedirectURL containsString:kSearchQueryToken])
    {
        NSLog(@"%@: redirectURL does not contain token: %@", self.class, kSearchQueryToken);
        return nil;
    }
    
    NSString *URLString = [engineRedirectURL stringByReplacingOccurrencesOfString:kSearchQueryToken withString:encodedQuery];
    NSURL *URL = [NSURL URLWithString:URLString];
    
    return URL;
}

@end
