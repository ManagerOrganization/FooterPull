[![GitHub License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/rob-nash/InfiniteScroll/master/Licence.md)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

![](http://i.imgur.com/iHGMhrk.gif?1)
![](http://i.imgur.com/19aTCJy.gif?1)

##Description

The creative design of your UI, remains yours. All I offer here, is a protocol.

Extend your table view to handle a loading event for fetching more data that appends to the bottom of your table view. Optionally animate the footer view easily, in just a few simple steps.

## Requirements
XCode 6.4+, iOS 8.1+

## Manual Installation
In XCode, select 'Add Files To Project', and select the following

* RRNInfiniteScrollManager.h
* RRNInfiniteScrollManager.m
* UITableView+RRNInfiniteScroll.h
* UITableView+RRNInfiniteScroll.m
* RRNInfiniteScrollFooterViewProtocol.h

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
    
        [self.tableView rrn_infinitScrollWithFooter:[FooterView buildInstanceWithWidth:self.tableView.frame.size.width]
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