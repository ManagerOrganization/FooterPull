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
 * @discussion used to initialise the infinite scroll mechanism. The code you pass into the trigger block will be executed when the footer view is scrolled beyond the trigger point and the user releases their touch.
 * @param footerView a UIView that has a non-zero frame and auto-resizing masks. Do not use a xib or auto-layout to build the footer view as you may experience failure. The frame should be the same width as the table view.
 */
-(void)rrn_infinitScrollWithFooter:(UIView  <RRNInfiniteScrollFooterViewProtocol> * _Nonnull)footerView
                  withTriggerBlock:(RRNInfiniteScrollTriggerBlock _Nonnull)triggerBlock;

/*!
 * @discussion finishes the animation and optionally reload the tableview and/or perform a peak animation. The peak animation is a scroll animation in the opposite direction, which exposes new cells that you have appended to your table view. The distance scrolled will be the the height of the footer view.
 * @param newContent by passing in 'YES', the table view will reload, once the footer view scrolls offscreen.
 * @param shoudlPeak by passing in 'YES', the table view will scroll upwards, by a distance equal to that of the height of the footer view. It is necessary to have newContent i.e. new cells, at the bottom of your existing content, for the peak animation to make sense.
 */
-(void)rrn_completeAnimationForNewContent:(BOOL)newContent performPeakAnimation:(BOOL)shouldPeak;

/*!
 * @discussion it is mandatory to call each of these scroll view specific methods in your scroll view delegate, for normal function.
 */
-(void)rrn_scrollViewDidScroll;

/*!
 * @discussion it is mandatory to call each of these scroll view specific methods in your scroll view delegate, for normal function.
 */
-(void)rrn_scrollViewWillBeginDecelerating;

/*!
 * @discussion it is mandatory to call each of these scroll view specific methods in your scroll view delegate, for normal function.
 */
-(void)rrn_scrollViewDidEndDecelerating;

@end
