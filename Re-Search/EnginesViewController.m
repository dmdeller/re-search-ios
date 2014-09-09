//
//  EnginesViewController.m
//  Re-Search
//
//  Created by David on 7/19/14.
//  Copyright (c) 2014 David Deller. All rights reserved.
//

#import "EnginesViewController.h"

#import "SearchEngine.h"

#import <ReSearchKit/ReSearchKit.h>
#import <MagicalRecord/CoreData+MagicalRecord.h>

@interface EnginesViewController ()

@property NSArray *searchEngines;

@end

@implementation EnginesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (void)loadData
{
    self.searchEngines = [SearchEngine MR_findAllSortedBy:@"order" ascending:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchEngines.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchEngine *searchEngine = self.searchEngines[indexPath.row];
    
    static NSString *kCellID = @"engineCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCellID forIndexPath:indexPath];
    
    cell.textLabel.text = searchEngine.name;
//    cell.detailTextLabel.text = searchEngine.redirectURL;
    
    if ([searchEngine.id isEqualToString:[SearchDeterminator.sharedDefaults stringForKey:kDefaultsFavouriteEngineID]])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"Choose a search engine to show results from when you use the Re-Search extension in Safari.";
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchEngine *searchEngine = self.searchEngines[indexPath.row];
    
    [SearchDeterminator.sharedDefaults setObject:searchEngine.id forKey:kDefaultsFavouriteEngineID];
    [SearchDeterminator.sharedDefaults synchronize];
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

@end
