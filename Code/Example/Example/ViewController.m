//
//  ViewController.m
//  Example
//
//  Created by Robert Nash on 07/03/2016.
//  Copyright © 2016 Robert Nash. All rights reserved.
//

#import "ViewController.h"
#import <FooterPull/FooterPull.h>
#import "FakeDataFetcherManager.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) FakeDataFetcherManager *fetcher;
@end

@implementation ViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.fetcher = [[FakeDataFetcherManager alloc] initWithRowCount:20 withMaxFetchCount:3];
    
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navHeight = self.navigationController.navigationBar.frame.size.height;
    
    self.tableView.contentInset = UIEdgeInsetsMake(statusBarHeight + navHeight, 0, 0, 0);
    
    [self styleTableView:self.tableView];
    [self.tableView addSubview:self.refreshControl];
    
    CGRect frame = CGRectMake(0, 0, self.tableView.frame.size.width, 60.0f);
    
    RRNFooterViewBugs <RRNInfiniteScrollFooterViewProtocol> *view = [[RRNFooterViewBugs alloc] initWithFrame:frame];
    
    __weak typeof(self) weakSelf = self;
    
    [self.tableView rrn_infinitScrollWithFooter:view
                               withTriggerBlock:^{
                                   
                                   __strong typeof (weakSelf) strongSelf = weakSelf;
                                   
                                   [strongSelf.fetcher fetchMoreDataWithFetchDuration:2
                                                                       withCompletion:[strongSelf fetchMoreDataCompletionHandler]];
                                   
                               }];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void(^)(BOOL moreDataFound))fetchMoreDataCompletionHandler {
    
    __weak typeof (self) weakSelf = self;
    
    return ^ (BOOL moreDataFound) {
        
        [weakSelf.tableView rrn_completeAnimationForNewContent:moreDataFound
                                          performPeakAnimation:moreDataFound];
    };
}

#pragma mark - UITableView Styling

-(void)styleTableView:(UITableView *)tableView {
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    CGRect frame = tableView.bounds;
    frame.origin = CGPointZero;
    
    UIView *backgroundView = [self buildBackgroundViewWithFrame:frame];
    [backgroundView addSubview:[self buildImageViewWithFrame:frame]];
    [backgroundView addSubview:[self buildBlurViewWithBlurEffect:blur withFrame:frame]];
    
    tableView.backgroundView = backgroundView;
    tableView.separatorEffect = [UIVibrancyEffect effectForBlurEffect:blur];
}

-(UIView *)buildBackgroundViewWithFrame:(CGRect)frame {
    UIView *backgroundView = [[UIView alloc] initWithFrame:frame];
    backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    return backgroundView;
}

-(UIImageView *)buildImageViewWithFrame:(CGRect)frame {
    UIImage *image = [UIImage imageNamed:@"uk-flag"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = frame;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    return imageView;
}

-(UIVisualEffectView *)buildBlurViewWithBlurEffect:(UIBlurEffect *)blur withFrame:(CGRect)frame {
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    visualEffectView.frame = frame;
    visualEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    return visualEffectView;
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

    [self.fetcher fetchFreshDataWithFetchDuration:2
                                   withCompletion:^(BOOL dataFound) {

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
    return self.fetcher.valuesFactory.values.count;
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

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
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
