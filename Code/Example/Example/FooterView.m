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
@property (weak, nonatomic) UIView *containerView;
@end

@implementation FooterView

-(instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor blackColor];
        
        UIView *container = [[UIView alloc] initWithFrame:self.bounds];
        container.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self addSubview:container];
        
        self.containerView = container;
        
        CGFloat yValue = (frame.size.height / 2.0f)-(45/2.0f);
        
        UIImageView *imageView;
        
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1"]];
        imageView.frame = CGRectMake(20, yValue, 45, 44);
        imageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        
        [container addSubview:imageView];
        
        self.bug1 = imageView;
        
        CGFloat width = frame.size.width;
        
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2"]];
        imageView.frame = CGRectMake((width / 2.0f) - (45/2.0f), yValue, 45, 44);
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [container addSubview:imageView];
        
        self.bug2 = imageView;
        
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"3"]];
        imageView.frame = CGRectMake((width - 45.0f) - 20.0f, yValue, 45, 44);
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        
        [container addSubview:imageView];
        
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
    
    [self.delegate footerView:self
              visibleFraction:progress];
    
    CGFloat p = MIN(MAX(progress, 0), 1);
    
    self.containerView.alpha = p;
    self.containerView.layer.transform = [self transformWithBounds:self.bounds
                                                      withProgress:progress];
    
    if (p >= 1) {
        [UIView animateWithDuration:.3 animations:^{
//            self.containerView.backgroundColor = COLOUR_1;
        }];
    } else {
        [UIView animateWithDuration:.1 animations:^{
//            self.containerView.backgroundColor = COLOUR_2;
        }];
    }
}

-(CATransform3D)transformWithBounds:(CGRect)bounds withProgress:(CGFloat)progress {
    
    CGFloat p = MIN(MAX(progress, 0), 1);
    CGFloat f = (1 - p);
    
    CATransform3D identity = CATransform3DIdentity;
    CGFloat angle = f * M_PI_2;
    CGFloat yOffset = CGRectGetHeight(bounds) * (f * -0.5);
    CATransform3D rotateTransform = CATransform3DRotate(identity, angle, 1, 0, 0);
    CATransform3D translateTransform = CATransform3DMakeTranslation(0, yOffset, 0);
    return CATransform3DConcat(rotateTransform, translateTransform);
    
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
    
    self.containerView.layer.transform = CATransform3DIdentity;
}

-(void)reset {
    
    [self stop];
    
    self.bug1.transform = CGAffineTransformIdentity;
    self.bug2.transform = CGAffineTransformIdentity;
    self.bug3.transform = CGAffineTransformIdentity;
    
    self.containerView.layer.transform = CATransform3DIdentity;
    
}

@end
