//
//  FetchMoreFakeDataTableViewController.m
//  Example
//
//  Created by Robert Nash on 31/12/2015.
//  Copyright © 2015 Robert Nash. All rights reserved.
//

#import "FetchMoreFakeDataTableViewController.h"
#import "FooterView.h"
#import <InfiniteScroll/UITableView+RRNInfiniteScroll.h>

@implementation FetchMoreFakeDataTableViewController

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    __weak typeof (self) weakSelf = self;
    
    [self.tableView rrn_infinitScrollWithFooter:[FooterView buildInstanceWithWidth:self.tableView.frame.size.width]
                               withTriggerBlock:^{
                                   
                                   __strong typeof (weakSelf) strongSelf = weakSelf;
                                   
                                   [strongSelf.fetcher fetchMoreDataWithCompletion:[strongSelf fetchMoreDataCompletionHandler]];
                                   
                               }];
    
}

-(void(^)(BOOL moreDataFound))fetchMoreDataCompletionHandler {
    
    __weak typeof (self) weakSelf = self;
    
    return ^ (BOOL moreDataFound) {
        
        [weakSelf.tableView rrn_completeAnimationForNewContent:moreDataFound
                                          performPeakAnimation:moreDataFound];
    };
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.tableView rrn_scrollViewDidScroll];
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [self.tableView rrn_scrollViewWillBeginDecelerating];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.tableView rrn_scrollViewDidEndDecelerating];
}

@end
