//
//  UITableView+RRNInfiniteScroll.m
//  Dancer
//
//  Created by Robert Nash on 31/12/2015.
//  Copyright © 2015 Robert Nash. All rights reserved.
//

#import "UITableView+RRNInfiniteScroll.h"
#import <objc/runtime.h>

typedef enum : NSUInteger {
    PULL_UP_TO_GET_MORE_STATE_IDLE,
    PULL_UP_TO_GET_MORE_STATE_READY,
    PULL_UP_TO_GET_MORE_STATE_TRIGGERED,
    PULL_UP_TO_GET_MORE_STATE_LOADING,
    PULL_UP_TO_GET_MORE_STATE_FETCHING
} PULL_UP_TO_GET_MORE_STATE;

@implementation UIScrollView (RRNScrollViewExtensions)

-(CGRect)contentRect {
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.contentSize.height;
    return CGRectMake(x, y, width, height);
}

-(CGRect)visibleContentRect {
    CGFloat x = 0;
    CGFloat y = self.contentOffset.y;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height - self.contentInset.top - self.contentInset.bottom;
    return CGRectMake(x, y, width, height);
}

@end

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
    
    CGRect contentRect = [self contentRect];
    
    CGRect visibleContentRect = [self visibleContentRect];
    
    CGFloat contentEndExceeded = (self.contentOffset.y + visibleContentRect.size.height) - contentRect.size.height;
    
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
    
    [self prepareFooterWithThreshold:contentRect.size.height >= visibleContentRect.size.height];
    
    if (contentEndExceeded >= triggerHeight && [self getCurrentState] == PULL_UP_TO_GET_MORE_STATE_READY) {
        [self setCurrentState:PULL_UP_TO_GET_MORE_STATE_TRIGGERED];
    }
}

-(void)prepareFooterWithThreshold:(BOOL)threshold {
    
    if (threshold) {
        
        if (!self.tableFooterView) {
            self.tableFooterView = objc_getAssociatedObject(self, &kRRNFooter);
            self.contentInset = UIEdgeInsetsMake(0, 0, -self.tableFooterView.frame.size.height, 0);
        }
        
        [self setCurrentState:PULL_UP_TO_GET_MORE_STATE_READY];
        
    } else {
        
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
    CGRect contentRect = [self contentRect];
    CGRect visibleContentRect = [self visibleContentRect];
    CGFloat bloat = self.contentInset.top - self.contentInset.bottom - self.tableFooterView.frame.size.height;
    CGFloat showFooter = bloat + self.tableFooterView.frame.size.height;
    CGFloat yValue = contentRect.size.height - visibleContentRect.size.height + showFooter;
    CGPoint point = CGPointMake(0, yValue);
    return point;
}

@end