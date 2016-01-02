//
//  FooterView.h
//  Example
//
//  Created by Robert Nash on 31/12/2015.
//  Copyright © 2015 Robert Nash. All rights reserved.
//

#import <InfiniteScroll/RRNInfiniteScrollFooterViewProtocol.h>

@interface FooterView : UIView <RRNInfiniteScrollFooterViewProtocol>

@property (weak, nonatomic) UIImageView *bug1;
@property (weak, nonatomic) UIImageView *bug2;
@property (weak, nonatomic) UIImageView *bug3;

+(FooterView *)buildInstanceWithWidth:(CGFloat)width;

@end
