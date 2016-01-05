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

@interface FetchMoreFakeDataTableViewController () <FooterViewDelegate>
@end

@implementation FetchMoreFakeDataTableViewController

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat top = statusBarHeight + navHeight;
    self.tableView.contentInset = UIEdgeInsetsMake(top, 0, 0, 0);
    
    __weak typeof (self) weakSelf = self;
    
    CGRect frame = CGRectMake(0, 0, self.tableView.frame.size.width, 60.0f);
    
    FooterView *footer = [[FooterView alloc] initWithFrame:frame];
    footer.delegate = self;
    
    [self.tableView rrn_infinitScrollWithFooter:footer
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

-(void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
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

#pragma mark - FooterViewDelegate

-(void)footerView:(FooterView *)view visibleFraction:(CGFloat)progress {
    
//    if (progress >= 1) {
//        self.tableView.backgroundColor = COLOUR_1;
//    } else {
//        self.tableView.backgroundColor = [UIColor whiteColor];
//    }
    
}

@end
