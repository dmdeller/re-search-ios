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

static NSString *const kEngineIDGoogle      = @"7A8141DE-CC69-46F0-B913-2719102ED88B";
static NSString *const kEngineIDBing        = @"6F87078F-1B51-4038-9305-4D8674713A5F";
static NSString *const kEngineIDDuckDuckGo  = @"11A7CF8D-9908-4D9E-B38C-68DD7E118958";

@interface SearchDeterminator : NSObject

+ (NSUserDefaults *)sharedDefaults;
+ (NSURL *)redirectURLForCurrentSearchPageURL:(NSURL *)currentURL error:(NSError **)error;

@end
