//
//  FakeDataTableViewController.h
//  Example
//
//  Created by Robert Nash on 31/12/2015.
//  Copyright © 2015 Robert Nash. All rights reserved.
//

#import "FakeDataFetcherManager.h"

@interface FakeDataTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (strong, nonatomic) FakeDataFetcherManager *fetcher;

@end
