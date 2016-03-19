//
//  RRNFooterViewBugs.m
//  InfiniteScrollFooter
//
//  Created by Robert Nash on 07/03/2016.
//  Copyright © 2016 Robert Nash. All rights reserved.
//

#import "RRNFooterViewBugs.h"

typedef enum : NSUInteger {
    IMAGE_STATE_DARK,
    IMAGE_STATE_LIGHT
} IMAGE_STATE;

@interface RRNFooterViewBugs ()
@property (strong, nonatomic) UIImageView *bug1;
@property (strong, nonatomic) UIImageView *bug2;
@property (strong, nonatomic) UIImageView *bug3;
@property (strong, nonatomic) UIView *containerView;
@property (nonatomic) IMAGE_STATE state;
@end

@implementation RRNFooterViewBugs

-(UIView *)containerView {
    if (_containerView == nil) {
        _containerView = [[UIView alloc] initWithFrame:self.bounds];
        _containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _containerView;
}

#define IMAGE_1_DARK [UIImage imageNamed:@"11"]
#define IMAGE_1_LIGHT [UIImage imageNamed:@"1"]
#define IMAGE_2_DARK [UIImage imageNamed:@"22"]
#define IMAGE_2_LIGHT [UIImage imageNamed:@"2"]
#define IMAGE_3_DARK [UIImage imageNamed:@"33"]
#define IMAGE_3_LIGHT [UIImage imageNamed:@"3"]

-(UIImageView *)bug1 {
    if (_bug1 == nil) {
        _bug1 = [[UIImageView alloc] initWithImage:IMAGE_1_DARK];
        _bug1.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    }
    return _bug1;
}

-(UIImageView *)bug2 {
    if (_bug2 == nil) {
        _bug2 = [[UIImageView alloc] initWithImage:IMAGE_2_DARK];
        _bug2.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    }
    return _bug2;
}

-(UIImageView *)bug3 {
    if (_bug3 == nil) {
        _bug3 = [[UIImageView alloc] initWithImage:IMAGE_3_DARK];
        _bug3.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    }
    return _bug3;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.containerView];
        [self.containerView addSubview:self.bug1];
        [self.containerView addSubview:self.bug2];
        [self.containerView addSubview:self.bug3];
    }
    return self;
}

#define IMAGE_SIZE CGSizeMake(90/1.5f, 88/1.5f)

-(void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = self.bounds;
    CGFloat width = frame.size.width;
    CGFloat yValue = (frame.size.height / 2.0f)-(IMAGE_SIZE.height/2.0f);
    self.bug1.frame = (CGRect) { CGPointMake(20, yValue), IMAGE_SIZE };
    self.bug2.frame = (CGRect) { CGPointMake((width / 2.0f) - (IMAGE_SIZE.width/2.0f), yValue), IMAGE_SIZE };
    self.bug3.frame = (CGRect) { CGPointMake((width - IMAGE_SIZE.height) - 20.0f, yValue), IMAGE_SIZE };
}

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
    
    CGFloat p = MIN(MAX(progress, 0), 1);
    
    self.containerView.alpha = p;
    self.containerView.layer.transform = [self transformWithBounds:self.bounds withProgress:progress];
    
    if (p >= 1 && self.state == IMAGE_STATE_DARK) {
        self.state = IMAGE_STATE_LIGHT;
        self.bug1.image = IMAGE_1_LIGHT;
        self.bug2.image = IMAGE_2_LIGHT;
        self.bug3.image = IMAGE_3_LIGHT;
    } else if (p < 1 && self.state == IMAGE_STATE_LIGHT) {
        self.state = IMAGE_STATE_DARK;
        self.bug1.image = IMAGE_1_DARK;
        self.bug2.image = IMAGE_2_DARK;
        self.bug3.image = IMAGE_3_DARK;
    }
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

@end
