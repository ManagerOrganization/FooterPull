/**
 *  Infinite Scroll - Add paging to your table views with a cool animation.
 *
 *  UITableView+RRNInfiniteScroll.m
 *
 *  For usage, see documentation of the classes/symbols listed in this file.
 *
 *  Copyright (c) 2016 Rob Nash. Licensed under the MIT license, as follows:
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in all
 *  copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 *  SOFTWARE.
 */

#import "UITableView+RRNInfiniteScroll.h"
#import <objc/runtime.h>

typedef enum : NSUInteger {
    PULL_UP_TO_GET_MORE_STATE_IDLE,
    PULL_UP_TO_GET_MORE_STATE_READY,
    PULL_UP_TO_GET_MORE_STATE_TRIGGERED,
    PULL_UP_TO_GET_MORE_STATE_LOADING,
    PULL_UP_TO_GET_MORE_STATE_FETCHING
} PULL_UP_TO_GET_MORE_STATE;

@implementation UITableView (RRNInfiniteScroll)

static const char kRRNTrigger;
static const char kRRNRefresh;
static const char kRRNFooter;
static const char kRRNState;

typedef void(^RRNInfiniteScrollRefreshBlock)(void);

-(PULL_UP_TO_GET_MORE_STATE)getCurrentState {
    NSNumber *state = objc_getAssociatedObject(self, &kRRNState);
    return state.integerValue;
}

-(void)setCurrentState:(PULL_UP_TO_GET_MORE_STATE)state {
    objc_setAssociatedObject(self, &kRRNState, @(state), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(void)rrn_infinitScrollWithFooter:(UIView * _Nonnull)footerView withTriggerBlock:(RRNInfiniteScrollTriggerBlock _Nonnull)triggerBlock {
    [self setCurrentState:PULL_UP_TO_GET_MORE_STATE_IDLE];
    objc_setAssociatedObject(self, &kRRNTrigger, triggerBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &kRRNFooter, footerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)rrn_completeAnimationForNewContent:(BOOL)newContent performPeakAnimation:(BOOL)shouldPeak {
    
    UIView *view = self.tableFooterView;
    
    UIView <RRNInfiniteScrollFooterViewProtocol> *footerView;
    
    if ([view conformsToProtocol:@protocol(RRNInfiniteScrollFooterViewProtocol)]) {
        footerView = (UIView <RRNInfiniteScrollFooterViewProtocol> *)view;
    }
    
    [footerView stop];
    
    __weak typeof (self) weakSelf = self;
    
    RRNInfiniteScrollRefreshBlock block = ^ {
        if (newContent) {
            [weakSelf reloadData];
        }
    };
    
    objc_setAssociatedObject(self, &kRRNRefresh, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    CGFloat yValue = self.contentOffset.y - self.tableFooterView.frame.size.height;
    
    [self setContentOffset:CGPointMake(0, yValue)
                  animated:YES];
    
    [self performSelector:@selector(executeRefreshBlock:)
               withObject:@(shouldPeak)
               afterDelay:.3];
    
}

-(void)executeRefreshBlock:(NSNumber * _Nullable)shouldPeakValue {
    
    RRNInfiniteScrollRefreshBlock block = objc_getAssociatedObject(self, &kRRNRefresh);
    block();
    
    if (shouldPeakValue.boolValue) {
        CGFloat yValue = self.contentOffset.y + self.tableFooterView.frame.size.height;
        
        [self setContentOffset:CGPointMake(0, yValue)
                      animated:YES];
    }
    
    UIView *view = self.tableFooterView;
    
    UIView <RRNInfiniteScrollFooterViewProtocol> *footerView;
    
    if ([view conformsToProtocol:@protocol(RRNInfiniteScrollFooterViewProtocol)]) {
        footerView = (UIView <RRNInfiniteScrollFooterViewProtocol> *)view;
    }
    
    [footerView reset];
    
    self.userInteractionEnabled = YES;
}

-(void)rrn_scrollViewDidScroll {
    
    CGSize contentSize = [self contentSize];
    
    CGFloat height = self.frame.size.height - self.contentInset.top - self.contentInset.bottom;
    
    CGFloat contentEndExceeded = ((self.contentOffset.y + self.contentInset.top) + height) - contentSize.height;
    
    CGFloat triggerHeight = self.tableFooterView.frame.size.height;
    
    if (contentEndExceeded > 0) {

        UIView <RRNInfiniteScrollFooterViewProtocol> *footerView;
        
        if ([self.tableFooterView conformsToProtocol:@protocol(RRNInfiniteScrollFooterViewProtocol) ]) {
            footerView = (UIView <RRNInfiniteScrollFooterViewProtocol> *)self.tableFooterView;
        }
        
        CGFloat percentage = contentEndExceeded / triggerHeight;
        
        if (footerView) {
            [footerView prepare:percentage];
        }
    }
    
    [self prepareFooterWithThreshold:contentSize.height >= height];
    
    if (contentEndExceeded >= triggerHeight && [self getCurrentState] == PULL_UP_TO_GET_MORE_STATE_READY) {
        [self setCurrentState:PULL_UP_TO_GET_MORE_STATE_TRIGGERED];
    }
}

-(void)prepareFooterWithThreshold:(BOOL)threshold {
    
    if (threshold) {
        
        if (!self.tableFooterView) {
            self.tableFooterView = objc_getAssociatedObject(self, &kRRNFooter);
            UIEdgeInsets insets = self.contentInset;
            insets.bottom = -self.tableFooterView.frame.size.height;
            self.contentInset = insets;
        }
        
        [self setCurrentState:PULL_UP_TO_GET_MORE_STATE_READY];
        
    } else {
        
        if (self.tableFooterView) {
            
            UIEdgeInsets insets = self.contentInset;
            
            UIView *view = self.tableFooterView;
            
            UIView <RRNInfiniteScrollFooterViewProtocol> *footerView;
            
            if ([view conformsToProtocol:@protocol(RRNInfiniteScrollFooterViewProtocol)]) {
                footerView = (UIView <RRNInfiniteScrollFooterViewProtocol> *)view;
            }
            
            [footerView reset];
            
            self.tableFooterView = nil;
            insets.bottom = 0;
            self.contentInset = insets;
        }
        
        [self setCurrentState:PULL_UP_TO_GET_MORE_STATE_IDLE];
        
    }
    
}

-(void)rrn_scrollViewWillBeginDecelerating {
    if ([self getCurrentState] == PULL_UP_TO_GET_MORE_STATE_TRIGGERED) {
        [self setCurrentState:PULL_UP_TO_GET_MORE_STATE_LOADING];
        [self setContentOffset:self.contentOffset
                      animated:YES];
        self.userInteractionEnabled = NO;
    }
}

-(void)rrn_scrollViewDidEndDecelerating {
    if ([self getCurrentState] == PULL_UP_TO_GET_MORE_STATE_LOADING) {
        [self setCurrentState:PULL_UP_TO_GET_MORE_STATE_FETCHING];
        [self performSelector:@selector(scrollToPointShowingFooterViewAndExecuteTriggerBlock)
                   withObject:nil
                   afterDelay:.1];
    }
}

-(void)scrollToPointShowingFooterViewAndExecuteTriggerBlock {
    
    [self setContentOffset:[self footerViewShowingOffset]
                  animated:YES];
    
    UIView *view = self.tableFooterView;
    
    UIView <RRNInfiniteScrollFooterViewProtocol> *footerView;
    
    if ([view conformsToProtocol:@protocol(RRNInfiniteScrollFooterViewProtocol)]) {
        footerView = (UIView <RRNInfiniteScrollFooterViewProtocol> *)view;
    }
    
    [footerView trigger];
    
    RRNInfiniteScrollTriggerBlock block = objc_getAssociatedObject(self, &kRRNTrigger);
    
    block();
    
}

-(CGPoint)footerViewShowingOffset {
    CGSize contentSize = [self contentSize];
    CGFloat height = self.frame.size.height;
    CGFloat yValue = contentSize.height - height;
    CGPoint point = CGPointMake(0, yValue);
    return point;
}

@end