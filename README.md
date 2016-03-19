Footer Pull
===========
[![GitHub license](https://img.shields.io/github/license/mashape/apistatus.svg?style=plastic&label=Legal)](https://raw.githubusercontent.com/rob-nash/InfiniteScroll/master/Licence.md)
[![Carthage compatible](https://img.shields.io/badge/Carthage-Compatible-Greene.svg?style=plastic)](https://github.com/Carthage/Carthage)

##Description

<sup>XCode 6.4+ iOS 8.0+</sup>

Several pull-like loading events for table views that have scrollable content.

![](http://i.imgur.com/9XxVQ31.gif?1)
![](http://i.imgur.com/zfHf9vI.gif?1)

##Demo
Try the Demo App by running the **Example** scheme in the **OpenMe** workspace.

## Dependencies

* [InfiniteScrollKit](https://github.com/rob-nash/InfiniteScrollKit.git)

## Installation with Carthage
Add the following to your Cartfile.

* github "https://github.com/rob-nash/FooterPull" >= 1.0.0

After running Carthage, add each of the following frameworks to your project, as embedded frameworks. See [Carthage](https://github.com/Carthage/Carthage) for details.

* FooterPull.framework
* InfiniteScrollKit.framework

## Implementation
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

## Contributions
Please use the 'OpenMe' workspace.
