//
//  ActionViewController.m
//  Re-Search: Choose
//
//  Created by David on 7/19/14.
//  Copyright (c) 2014 David Deller. All rights reserved.
//

#import "ActionViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ActionViewController ()

@property(strong,nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ActionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Get the item[s] we're handling from the extension context.
    
    NSLog(@"context: %@", self.extensionContext);
    NSLog(@"context.inputItems: %@", self.extensionContext.inputItems);
    
    // For example, look for an image and place it into an image view.
    // Replace this with something appropriate for the type[s] your extension supports.
    BOOL imageFound = NO;
    for (NSExtensionItem *item in self.extensionContext.inputItems)
    {
        for (NSItemProvider *itemProvider in item.attachments)
        {
//            if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeImage])
//            {
//                // This is an image. We'll load it, then place it in our image view.
//                __weak UIImageView *imageView = self.imageView;
//                [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeImage options:nil completionHandler:^(UIImage *image, NSError *error)
//                {
//                    if(image)
//                    {
//                        [[NSOperationQueue mainQueue] addOperationWithBlock:^
//                         {
//                             [imageView setImage:image];
//                         }];
//                    }
//                }];
//                
//                imageFound = YES;
//                break;
//            }
            
            if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeURL])
            {
                [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeURL options:nil completionHandler:^(id item, NSError *error)
                 {
                     NSLog(@"hey look what I found! It's a %@: %@", [item class], item);
                 }];
            }
        }
        
//        if (imageFound)
//        {
//            // We only handle one image, so stop looking for more.
//            break;
//        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done
{
    // Return any edited content to the host app.
    // This template doesn't do anything, so we just echo the passed in items.
    
    NSItemProvider *provider = [NSItemProvider.alloc initWithItem:[NSURL URLWithString:@"https://duckduckgo.com"] typeIdentifier:(NSString *)kUTTypeURL];
    
    NSExtensionItem *item = NSExtensionItem.new;
    item.attachments = @[provider];
    
//    NSDictionary *resultsForJavaScriptFinalize = @{@"newURL": @"https://duckduckgo.com"};
//    NSDictionary *resultsDictionary = @{ NSExtensionJavaScriptFinalizeArgumentKey: resultsForJavaScriptFinalize };
//    
//    NSItemProvider *resultsProvider = [[NSItemProvider alloc] initWithItem:resultsDictionary typeIdentifier:(NSString *)kUTTypePropertyList];
//    
//    NSExtensionItem *resultsItem = [[NSExtensionItem alloc] init];
//    resultsItem.attachments = @[resultsProvider];
    
//    [self.extensionContext openURL:[NSURL URLWithString:@"https://duckduckgo.com"] completionHandler:nil];
    [self.extensionContext completeRequestReturningItems:@[item] completionHandler:nil];
}

@end
