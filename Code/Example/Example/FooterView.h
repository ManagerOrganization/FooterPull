//
//  FooterView.h
//  Example
//
//  Created by Robert Nash on 31/12/2015.
//  Copyright © 2015 Robert Nash. All rights reserved.
//

#import <InfiniteScroll/InfiniteScroll.h>

//#define COLOUR_1 [UIColor colorWithRed:41/255.0f green:174/255.0f blue:107/255.0f alpha:1.0f];
//#define COLOUR_2 [UIColor colorWithRed:41/255.0f green:174/255.0f blue:174/255.0f alpha:1.0f];

@class FooterView;

@protocol FooterViewDelegate <NSObject>

-(void)footerView:(FooterView *)view visibleFraction:(CGFloat)progress;

@end

@interface FooterView : UIView <RRNInfiniteScrollFooterViewProtocol>

@property (nonatomic, weak) id <FooterViewDelegate> delegate;

-(instancetype)initWithFrame:(CGRect)frame;

@end
