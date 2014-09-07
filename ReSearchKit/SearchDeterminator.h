//
//  SearchDeterminator.h
//  Re-Search
//
//  Created by David on 9/7/14.
//  Copyright (c) 2014 David Deller. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const kSearchQueryToken = @"🔤";

static NSString *const kDefaultsFavouriteEngineID = @"favouriteEngineID";
static NSString *const kDefaultsAllEngines = @"allEngines";

static NSString *const SearchDeterminatorErrorDomain = @"SearchDeterminatorErrorDomain";

@interface SearchDeterminator : NSObject

+ (NSUserDefaults *)sharedDefaults;
+ (NSURL *)redirectURLForCurrentSearchPageURL:(NSURL *)currentURL error:(NSError **)error;

@end
