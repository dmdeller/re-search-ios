//
//  SearchDeterminator.h
//  Re-Search
//
//  Created by David on 9/7/14.
//  Copyright (c) 2014 David Deller. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchDeterminator : NSObject

+ (NSURL *)redirectURLForCurrentSearchPageURL:(NSURL *)currentURL;

@end
