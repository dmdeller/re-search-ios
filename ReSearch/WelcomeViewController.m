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
@property (strong, nonatomic) IBOutlet UIView *howToView;

@end

@implementation WelcomeViewController
            
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [NSBundle.mainBundle loadNibNamed:@"HowTo" owner:self options:nil];
    
    [self.scrollView addSubview:self.howToView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    NSLayoutConstraint *widthConstraint1 = [NSLayoutConstraint constraintWithItem:self.howToView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
    widthConstraint1.priority = UILayoutPriorityDefaultHigh;
    
    NSLayoutConstraint *widthConstraint2 = [NSLayoutConstraint constraintWithItem:self.howToView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:450.0];
    
    [self.view addConstraint:widthConstraint1];
    [self.howToView addConstraint:widthConstraint2];
    
    self.scrollView.contentSize = self.howToView.bounds.size;
}

@end
