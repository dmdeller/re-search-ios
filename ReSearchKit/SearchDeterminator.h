//
//  SearchDeterminator.h
//  Re-Search
//
//  Created by David on 9/7/14.
//  Copyright (c) 2014 David Deller. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const kSearchQueryToken = @"🔤";

@interface SearchDeterminator : NSObject

+ (NSUserDefaults *)sharedDefaults;
+ (NSURL *)sharedCoreDataStoreURL;
+ (NSURL *)redirectURLForCurrentSearchPageURL:(NSURL *)currentURL;

@end
