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
1. Build a UITableView, either in code or from interface builder.
2. Build a footer view for your table view using code. 
3. Make your footer view conform to RRNInfiniteScrollFooterViewProtocol
4. Import UITableView+RRNInfiniteScroll.h in the view controller that handles your table view
5. Copy and paste the following code into your project

>Important: You have to build your footer view the old school way, using auto-resizing masks. Do not use auto-layout to constrain your footer view or any of its subviews. Do not build your footer view using a storyboard or a xib.

    -(void)scrollViewDidScroll:(UIScrollView *)scrollView {
        [self.tableView rrn_scrollViewDidScroll];
    }

    -(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
        [self.tableView rrn_scrollViewWillBeginDecelerating];
    }

    -(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
        [self.tableView rrn_scrollViewDidEndDecelerating];
    }

    -(void)viewDidLoad {
    
        [super viewDidLoad];
    
        CGRect frame = CGRectMake(0, 0, self.tableView.frame.size.width, 44.0f);
    
        UIView *footerView = [[UIView alloc] initWithFrame:frame];

        [self.tableView rrn_infinitScrollWithFooter:footerView
                                   withTriggerBlock:^{
                                   //Fetch your data
                               }];
    }

    -(void)fetchYourDataCompletionHandler {
    
        [self.tableView rrn_completeAnimationForNewContent:YES
                                      performPeakAnimation:YES];
    
    }

##Demo
Try the Demo App by running the **Example** scheme in the **Development** workspace.

## Contributions
Please use the 'Development' workspace.