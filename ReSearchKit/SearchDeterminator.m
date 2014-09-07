//
//  SearchDeterminator.m
//  Re-Search
//
//  Created by David on 9/7/14.
//  Copyright (c) 2014 David Deller. All rights reserved.
//

#import "SearchDeterminator.h"

@implementation SearchDeterminator

+ (NSURL *)redirectURLForCurrentSearchPageURL:(NSURL *)currentURL
{
    return @"https://duckduckgo.com";
}

@end
