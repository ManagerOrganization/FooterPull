/**
 *  Infinite Scroll - Add paging to your table views with a cool animation.
 *
 *  UITableView+RRNInfiniteScroll.h
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

#import <UIKit/UIKit.h>

@protocol RRNInfiniteScrollFooterViewProtocol <NSObject>

/*!
 * @discussion use the progress value to configure your UI as the user pulls the table view towards the trigger point.
 * @param progress a value between 0 and 1 which represents the movement between an idle state and the trigger state.
 */
-(void)prepare:(CGFloat)progress;

/*!
 * @discussion the trigger point is the point at which the user should be notified that the 'trigger block' will be executued.
 */
-(void)trigger;

/*!
 * @discussion the finish point where the footer view is dismissed offscreen.
 */
-(void)stop;

/*!
 * @discussion use for clean up.
 */
-(void)reset;

@end

typedef void(^RRNInfiniteScrollTriggerBlock)(void);

@interface UITableView (RRNInfiniteScroll)

/*
 * @discussion used to insert a footer view which 
 */
-(void)rrn_infinitScrollWithFooter:(UIView  * _Nonnull)footerView
                  withTriggerBlock:(RRNInfiniteScrollTriggerBlock _Nonnull)triggerBlock;

-(void)rrn_completeAnimationForNewContent:(BOOL)newContent performPeakAnimation:(BOOL)shouldPeak;
-(void)rrn_scrollViewDidScroll;
-(void)rrn_scrollViewWillBeginDecelerating;
-(void)rrn_scrollViewDidEndDecelerating;

@end
