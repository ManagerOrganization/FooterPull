//
//  FooterView.m
//  Example
//
//  Created by Robert Nash on 31/12/2015.
//  Copyright © 2015 Robert Nash. All rights reserved.
//

#import "FooterView.h"

@interface FooterView ()
@property (weak, nonatomic) UIImageView *bug1;
@property (weak, nonatomic) UIImageView *bug2;
@property (weak, nonatomic) UIImageView *bug3;
@end

@implementation FooterView

-(instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        UIImageView *imageView;
        
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1"]];
        imageView.frame = CGRectMake(20, 0, 45, 44);
        imageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:imageView];
        
        self.bug1 = imageView;
        
        CGFloat width = frame.size.width;
        
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2"]];
        imageView.frame = CGRectMake((width / 2.0f) - (45/2.0f), 0, 45, 44);
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:imageView];
        
        self.bug2 = imageView;
        
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"3"]];
        imageView.frame = CGRectMake((width - 45.0f) - 20.0f, 0, 45, 44);
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self addSubview:imageView];
        
        self.bug3 = imageView;
    }
    
    return self;
}

#pragma mark - Animations 

#define ANIMATION_KEY @"wiggleAnimtion"

-(void)addAnimation:(UIImageView *)imageView {
    
    CGFloat randomWiggle = (arc4random() / MAXFLOAT) + 0.1;
    CGFloat randomDuration = (arc4random() / MAXFLOAT) + 0.1;
    
    CATransform3D transform = CATransform3DMakeRotation(randomWiggle, 0, 0, 1.0);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.toValue = [NSValue valueWithCATransform3D:transform];
    animation.autoreverses = YES;
    animation.duration = randomDuration;
    animation.repeatCount = 999999;
    animation.delegate = self;
    
    [imageView.layer addAnimation:animation forKey:ANIMATION_KEY];
    
}

#pragma mark - RRNInfiniteScrollFooterViewProtocol

-(void)prepare:(CGFloat)progress {
    
    CGFloat value = 1.2 * progress - .2;
    self.bug1.transform = CGAffineTransformMakeScale(value, value);
    self.bug2.transform = CGAffineTransformMakeScale(value, value);
    self.bug3.transform = CGAffineTransformMakeScale(value, value);
    
}

-(void)trigger {
    
    [self addAnimation:self.bug1];
    [self addAnimation:self.bug2];
    [self addAnimation:self.bug3];
    
}

-(void)stop {
    
    [self.bug1.layer removeAnimationForKey:ANIMATION_KEY];
    [self.bug2.layer removeAnimationForKey:ANIMATION_KEY];
    [self.bug3.layer removeAnimationForKey:ANIMATION_KEY];
    
}

-(void)reset {
    
    [self stop];
    
    self.bug1.transform = CGAffineTransformIdentity;
    self.bug2.transform = CGAffineTransformIdentity;
    self.bug3.transform = CGAffineTransformIdentity;
    
}

@end
