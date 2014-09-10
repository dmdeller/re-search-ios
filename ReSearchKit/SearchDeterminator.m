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
    if ([currentID isEqualToString:favouriteID])
    {
        if ([currentID isEqualToString:kEngineIDDuckDuckGo])
        {
            NSLog(@"%@: Current search page and favourite are both DuckDuckGo; redirecting to Google instead", self.class);
            
            return [self engineForID:kEngineIDGoogle inEngines:engines];
        }
        else
        {
            NSLog(@"%@: Current search page and favourite are the same; redirecting to DuckDuckGo instead", self.class);
            
            return [self engineForID:kEngineIDDuckDuckGo inEngines:engines];
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
    
    [self.sharedDefaults synchronize];
    
    NSArray *engines = [self.sharedDefaults objectForKey:kDefaultsAllEngines];
    NSString *currentURLHostPart = currentURL.host;
    NSString *currentURLPathPart = [NSString stringWithFormat:@"%@?%@", currentURL.path, currentURL.query];
    
//    NSLog(@"%@: Engines: %@", self.class, engines);
    
    if (engines.count == 0)
    {
        NSLog(@"%@: Couldn't find defaults!!! %@", self.class, self.sharedDefaults.dictionaryRepresentation);
        
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
        NSLog(@"%@: domain matched, but current URL: %@ doesn't contain first part of queryPart: %@", self.class, pagePathPart, engineQueryFirstPart);
        return nil;
    }
    else if (engineQueryLastPart.length > 0 && ![pagePathPart containsString:engineQueryLastPart])
    {
        NSLog(@"%@: domain matched, but current URL: %@ doesn't contain last part of queryPart: %@", self.class, pagePathPart, engineQueryLastPart);
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
