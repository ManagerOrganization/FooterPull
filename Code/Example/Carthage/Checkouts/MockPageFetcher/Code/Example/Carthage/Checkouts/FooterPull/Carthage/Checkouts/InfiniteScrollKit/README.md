Infinite Scroll Kit
============
[![GitHub license](https://img.shields.io/github/license/mashape/apistatus.svg?style=plastic&label=Legal)](https://raw.githubusercontent.com/rob-nash/InfiniteScroll/master/Licence.md)
[![Carthage compatible](https://img.shields.io/badge/Carthage-Compatible-Greene.svg?style=plastic)](https://github.com/Carthage/Carthage)

##Description
<sup>XCode 6.4+ iOS 8.0+</sup>

A pull-like loading event for table views that have scrollable content. The creative design and style of the footer view is at the mercy of the implementing developer. Please contribute to pre-built footer view designs, [here](https://github.com/rob-nash/InfiniteScroll).

## Installation with Carthage
Add the following to your Cartfile. See [Carthage](https://github.com/Carthage/Carthage) for details.

* github "https://github.com/rob-nash/InfiniteScroll" >= 1.0.5

## Manual installation
In XCode, select 'Add Files To Project', and select the following files.

* UITableView+RRNInfiniteScroll.h
* UITableView+RRNInfiniteScroll.m

## Usage
1. Build a UITableView, either in code or from interface builder.

2. Manually adjust your table view content insets as you like. So for instance, if you have a navigation controller, you may want to adjust your top inset to accomodate a navigation bar and/or the status bar.

3. Build a footer view for your table view using code and have it conform to RRNInfiniteScrollFooterViewProtocol.

>Important: You have to build your footer view the old school way, using auto-resizing masks. Do not use auto-layout to constrain your footer view or any of its subviews. Do not build your footer view using a storyboard or a xib.

Your code should look something like this.

```objective-c
-(void)viewDidLoad {

    [super viewDidLoad];
    
    self.tableView.contentInset = UIEdgeInsetsMake(statusBarHeight + navHeight, 0, 0, 0);

    CustomFooterView <RRNInfiniteScrollFooterViewProtocol> *view = [[CustomFooterView alloc] initWithFrame:(CGRect){0, 0, tableViewWidth, 60.0}];

    [self.tableView rrn_infinitScrollWithFooter:view
                               withTriggerBlock:^{
                               //Fetch your data
                           }];
}

-(void)fetchYourDataCompletionHandler {

    [self.tableView rrn_completeAnimationForNewContent:YES
                                  performPeakAnimation:YES];

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.tableView rrn_scrollViewDidScroll];
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [self.tableView rrn_scrollViewWillBeginDecelerating];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.tableView rrn_scrollViewDidEndDecelerating];
}
```
