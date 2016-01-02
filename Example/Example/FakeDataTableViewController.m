//
//  FakeDataTableViewController.m
//  Example
//
//  Created by Robert Nash on 31/12/2015.
//  Copyright © 2015 Robert Nash. All rights reserved.
//

#import "FakeDataTableViewController.h"

@implementation FakeDataTableViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView addSubview:self.refreshControl];
}

#pragma mark - FakeDataFetcher

-(FakeDataFetcherManager *)fetcher {
    if (_fetcher == nil) {
        _fetcher = [FakeDataFetcherManager new];
    }
    return _fetcher;
}

#pragma mark - UIRefreshControl

-(UIRefreshControl *)refreshControl {
    if (_refreshControl == nil) {
        UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
        [refreshControl addTarget:self action:@selector(refreshControlValueChanged:) forControlEvents:UIControlEventValueChanged];
        _refreshControl = refreshControl;
    }
    return _refreshControl;
}

-(void)refreshControlValueChanged:(UIRefreshControl *)refreshControl {
    
    __weak typeof(self) weakSelf = self;
    
    [self.fetcher fetchFreshDataWithCompletion:^(BOOL dataFound) {
        
        __strong typeof (weakSelf) strongSelf = weakSelf;
        
        if (dataFound) {
            [strongSelf.tableView reloadData];
        }
        
        [strongSelf.refreshControl endRefreshing];
        
    }];
    
}

#pragma mark - UITableViewDatasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fetcher.values.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"Value %lu", (unsigned long)indexPath.row+1];
    return cell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

@end
