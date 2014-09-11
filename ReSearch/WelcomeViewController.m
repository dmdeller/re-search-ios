//
//  FirstViewController.m
//  Re-Search
//
//  Created by David on 7/19/14.
//  Copyright (c) 2014 David Deller. All rights reserved.
//

#import "WelcomeViewController.h"

@interface WelcomeViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *howToContainerView;
@property (strong, nonatomic) IBOutlet UIView *howToView;

@end

@implementation WelcomeViewController
            
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [NSBundle.mainBundle loadNibNamed:@"HowTo" owner:self options:nil];
    
    // https://developer.apple.com/library/ios/technotes/tn2154/_index.html
    [self.scrollView addSubview:self.howToContainerView];
    
    // Set the translatesAutoresizingMaskIntoConstraints to NO so that the views autoresizing mask is not translated into auto layout constraints.
    self.scrollView.translatesAutoresizingMaskIntoConstraints  = NO;
    self.howToContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Set the constraints for the scroll view and the image view.
    NSDictionary *viewsDictionary = @{@"scrollView": self.scrollView, @"howToContainerView": self.howToContainerView};
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[howToContainerView]|" options:0 metrics: 0 views:viewsDictionary]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[howToContainerView]|" options:0 metrics: 0 views:viewsDictionary]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.howToContainerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.howToView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
