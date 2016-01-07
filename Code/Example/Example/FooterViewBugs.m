//
//  FooterViewBugs.m
//  Example
//
//  Created by Robert Nash on 31/12/2015.
//  Copyright © 2015 Robert Nash. All rights reserved.
//

#import "FooterViewBugs.h"

typedef enum : NSUInteger {
    IMAGE_STATE_DARK,
    IMAGE_STATE_LIGHT
} IMAGE_STATE;

@interface FooterViewBugs ()
@property (weak, nonatomic) UIImageView *bug1;
@property (weak, nonatomic) UIImageView *bug2;
@property (weak, nonatomic) UIImageView *bug3;
@property (weak, nonatomic) UIView *containerView;
@property (nonatomic) IMAGE_STATE state;
@end

@implementation FooterViewBugs

#define IMAGE_1_DARK [UIImage imageNamed:@"11"]
#define IMAGE_1_LIGHT [UIImage imageNamed:@"1"]
#define IMAGE_2_DARK [UIImage imageNamed:@"22"]
#define IMAGE_2_LIGHT [UIImage imageNamed:@"2"]
#define IMAGE_3_DARK [UIImage imageNamed:@"33"]
#define IMAGE_3_LIGHT [UIImage imageNamed:@"3"]

-(instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        UIView *container = [[UIView alloc] initWithFrame:self.bounds];
        container.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self addSubview:container];
        
        self.containerView = container;
        
        CGSize imageSize = CGSizeMake(90/1.5f, 88/1.5f);
        
        CGFloat yValue = (frame.size.height / 2.0f)-(imageSize.height/2.0f);
        
        UIImageView *imageView;
        
        imageView = [[UIImageView alloc] initWithImage:IMAGE_1_DARK];
        imageView.frame = (CGRect) { CGPointMake(20, yValue), imageSize };
        imageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        
        [container addSubview:imageView];
        
        self.bug1 = imageView;
        
        CGFloat width = frame.size.width;
        
        imageView = [[UIImageView alloc] initWithImage:IMAGE_2_DARK];
        imageView.frame = (CGRect) { CGPointMake((width / 2.0f) - (imageSize.width/2.0f), yValue), imageSize };
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [container addSubview:imageView];
        
        self.bug2 = imageView;
        
        imageView = [[UIImageView alloc] initWithImage:IMAGE_3_DARK];
        imageView.frame = (CGRect) { CGPointMake((width - imageSize.height) - 20.0f, yValue), imageSize };
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
    
    CGFloat p = MIN(MAX(progress, 0), 1);
    
    self.containerView.alpha = p;
    self.containerView.layer.transform = [self transformWithBounds:self.bounds
                                                      withProgress:progress];
    
    if (p >= 1 && self.state == IMAGE_STATE_DARK) {
        self.state = IMAGE_STATE_LIGHT;
        [UIView animateWithDuration:.3 animations:^{
            self.bug1.image = IMAGE_1_LIGHT;
            self.bug2.image = IMAGE_2_LIGHT;
            self.bug3.image = IMAGE_3_LIGHT;
        }];
    } else if (p < 1 && self.state == IMAGE_STATE_LIGHT) {
        self.state = IMAGE_STATE_DARK;
        [UIView animateWithDuration:.1 animations:^{
            self.bug1.image = IMAGE_1_DARK;
            self.bug2.image = IMAGE_2_DARK;
            self.bug3.image = IMAGE_3_DARK;
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
