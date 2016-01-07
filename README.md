[![GitHub License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/rob-nash/InfiniteScroll/master/Licence.md)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

![](http://i.imgur.com/iHGMhrk.gif?1)
![](http://i.imgur.com/OBRO1Kl.gif?1)

##Description

Extend your table view to handle a loading event for fetching more data that appends to the bottom of your table view. Optionally animate the footer view easily, in just a few simple steps.

This library offers the creative responsibility to the implementing developer for how the footer view looks and animates. Distinct indications for when a data fetch should be triggered and when each loading phases will begin and end, are provided.

Checkout the wiki for more details.

## Requirements
XCode 6.4+, iOS 8.1+

## Manual Installation
In XCode, select 'Add Files To Project', and select the following

* UITableView+RRNInfiniteScroll.h
* UITableView+RRNInfiniteScroll.m

## Usage
1 - Build a UITableView, either in code or from interface builder.

2 - Prevent iOS from automatically adjusting your content insets (flip checkmark in storyboard or set the 'automaticallyAdjustsScrollViewInsets' boolean in code)

3 - Manually adjust your table view content insets as you like. So for instance, if you have a navigation controller, you may want to adjust your top inset to accomodate a navigation bar and/or the status bar.

4 - Import UITableView+RRNInfiniteScroll.h

5 - Build a footer view for your table view using code.

>Important: You have to build your footer view the old school way, using auto-resizing masks. Do not use auto-layout to constrain your footer view or any of its subviews. Do not build your footer view using a storyboard or a xib.

6 - Make your footer view conform to RRNInfiniteScrollFooterViewProtocol

```objective-c
-(void)viewDidLoad {

    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat top = statusBarHeight + navHeight;

    self.tableView.contentInset = UIEdgeInsetsMake(top, 0, 0, 0);

    CGRect frame = CGRectMake(0, 0, self.tableView.frame.size.width, 60.0f);

    FooterView <RRNInfiniteScrollFooterViewProtocol> *view = [[FooterView alloc] initWithFrame:frame];

    [self.tableView rrn_infinitScrollWithFooter:view
                               withTriggerBlock:^{
                               //Fetch your data
                           }];
}

-(void)fetchYourDataCompletionHandler {

    [self.tableView rrn_completeAnimationForNewContent:YES
                                  performPeakAnimation:YES];

}
```

7 - Handle the scroll view delegate like so

```objective-c
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

##Demo
Try the Demo App by running the **Example** scheme in the **Development** workspace.

## Contributions
Please use the 'Development' workspace.