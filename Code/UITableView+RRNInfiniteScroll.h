//
//  UITableView+RRNInfiniteScroll.h
//  Dancer
//
//  Created by Robert Nash on 31/12/2015.
//  Copyright © 2015 Robert Nash. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RRNInfiniteScrollFooterViewProtocol <NSObject>

-(void)prepare:(CGFloat)progress;
-(void)trigger;
-(void)stop;
-(void)reset;

@end

typedef void(^RRNInfiniteScrollTriggerBlock)(void);

@interface UITableView (RRNInfiniteScroll)

-(void)rrn_infinitScrollWithFooter:(UIView  * _Nonnull)footerView withTriggerBlock:(RRNInfiniteScrollTriggerBlock _Nonnull)triggerBlock;
-(void)rrn_completeAnimationForNewContent:(BOOL)newContent performPeakAnimation:(BOOL)shouldPeak;
-(void)rrn_scrollViewDidScroll;
-(void)rrn_scrollViewWillBeginDecelerating;
-(void)rrn_scrollViewDidEndDecelerating;

@end
