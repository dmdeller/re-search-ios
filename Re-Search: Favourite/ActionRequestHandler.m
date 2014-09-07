//
//  ActionRequestHandler.m
//  Re-Search: Favourite
//
//  Created by David on 7/19/14.
//  Copyright (c) 2014 David Deller. All rights reserved.
//

#import "ActionRequestHandler.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ActionRequestHandler ()

@property (nonatomic, strong) NSExtensionContext *extensionContext;

@end

@implementation ActionRequestHandler

- (void)beginRequestWithExtensionContext:(NSExtensionContext *)context
{
    self.extensionContext = context;
    
    __block BOOL found = NO;
    
    NSLog(@"context: %@", context);
    NSLog(@"context.inputItems: %@", context.inputItems);
    
    // Find the item containing the results from the JavaScript preprocessing.
    for (NSExtensionItem* item in context.inputItems)
    {
        for (NSItemProvider* itemProvider in item.attachments)
        {
            if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypePropertyList])
            {
                [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypePropertyList options:nil completionHandler:^(NSDictionary *dictionary, NSError *error)
                {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^
                     {
                         [self itemLoadCompletedWithPreprocessingResults:dictionary[NSExtensionJavaScriptPreprocessingResultsKey]];
                     }];
                }];
                found = YES;
            }
            
            if (found) break;
        }
        
        if (found) break;
    }
    
    if (!found)
    {
        [self doneWithResults:nil];
    }
}

- (void)itemLoadCompletedWithPreprocessingResults:(NSDictionary *)javaScriptPreprocessingResults
{
    // Here, do something, potentially asynchronously, with the preprocessing
    // results.
    
//    // In this very simple example, the JavaScript will have passed us the
//    // current background color style, if there is one. We will construct a
//    // dictionary to send back with a desired new background color style.
//    if ([javaScriptPreprocessingResults[@"currentBackgroundColor"] length] == 0)
//    {
//        // No specific background color? Request setting the background to red.
//        [self doneWithResults:@{ @"newBackgroundColor": @"red" }];
//    }
//    else
//    {
//        // Specific background color is set? Request replacing it with green.
//        [self doneWithResults:@{ @"newBackgroundColor": @"green" }];
//    }
    
    NSLog(@"Look it's a URL! %@", javaScriptPreprocessingResults[@"url"]);
    
    NSURL *currentURL = [NSURL URLWithString:javaScriptPreprocessingResults[@"url"]];
    
    NSError *error = nil;
    NSURL *newURL = [SearchDeterminator redirectURLForCurrentSearchPageURL:currentURL error:&error];
    
    if (newURL != nil)
    {
        [self doneWithResults:@{@"newURL": newURL.absoluteString}];
    }
    else
    {
        [self doneWithResults:@{@"error": error.localizedDescription}];
    }
}

- (void)doneWithResults:(NSDictionary *)resultsForJavaScriptFinalize
{
    if (resultsForJavaScriptFinalize)
    {
        // Construct an NSExtensionItem of the appropriate type to return our
        // results dictionary in.
        
        // These will be used as the arguments to the JavaScript finalize()
        // method.
        
        NSDictionary *resultsDictionary = @{ NSExtensionJavaScriptFinalizeArgumentKey: resultsForJavaScriptFinalize };
        
        NSItemProvider *resultsProvider = [[NSItemProvider alloc] initWithItem:resultsDictionary typeIdentifier:(NSString *)kUTTypePropertyList];
        
        NSExtensionItem *resultsItem = [[NSExtensionItem alloc] init];
        resultsItem.attachments = @[resultsProvider];
        
        // Signal that we're complete, returning our results.
        [self.extensionContext completeRequestReturningItems:@[resultsItem] completionHandler:nil];
    }
    else
    {
        // We still need to signal that we're done even if we have nothing to
        // pass back.
        [self.extensionContext completeRequestReturningItems:nil completionHandler:nil];
    }
    
    // Don't hold on to this after we finished with it.
    self.extensionContext = nil;
}

@end
