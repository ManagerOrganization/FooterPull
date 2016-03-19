//
//  FooterViewSpinner.m
//  Example
//
//  Created by Rob Nash on 2016-01-06.
//  Copyright © 2016 Robert Nash. All rights reserved.
//

#import "FooterViewSpinner.h"

@interface FooterViewSpinner ()
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) UILabel *label;
@end

@implementation FooterViewSpinner

#define SPINNER_SIZE CGSizeMake(44, 44)

-(UIActivityIndicatorView *)spinner {
    if (_spinner == nil) {
        _spinner = [[UIActivityIndicatorView alloc] initWithFrame:(CGRect){CGPointZero, SPINNER_SIZE}];
        _spinner.hidden = YES;
        _spinner.hidesWhenStopped = YES;
    }
    return _spinner;
}

-(UILabel *)label {
    if (_label == nil) {
        _label = [[UILabel alloc] init];
        _label.text = @"Keep Pulling...";
        _label.textColor = [UIColor whiteColor];
        [_label sizeToFit];
    }
    return _label;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat midX = 0.0f;
    CGFloat midY = 0.0f;
    
    midX = CGRectGetMidX(self.bounds) - self.spinner.frame.size.width / 2.0f;
    midY = CGRectGetMidY(self.bounds) - self.spinner.frame.size.height / 2.0f;
    
    if (!self.spinner.superview) {
        [self addSubview:self.spinner];
    }
    
    self.spinner.frame = (CGRect){CGPointMake(midX, midY), SPINNER_SIZE};
    
    if (!self.label.superview) {
        [self addSubview:self.label];
    }
    
    midX = CGRectGetMidX(self.bounds) - self.label.frame.size.width / 2.0f;
    midY = CGRectGetMidY(self.bounds) - self.label.frame.size.height / 2.0f;
    
    CGSize labelSize = self.label.frame.size;
    self.label.frame = (CGRect){CGPointMake(midX, midY), labelSize};
}

-(void)prepare:(CGFloat)progress {
    if (progress >= 1) {
        self.label.text = @"Release to load";
        [self.label sizeToFit];
    } else if (progress < 1) {
        self.label.text = @"Keep Pulling...";
        [self.label sizeToFit];
    }
}

-(void)trigger {
    self.label.hidden = YES;
    [self.spinner startAnimating];
}

-(void)stop {
}

-(void)reset {
    [self.spinner stopAnimating];
    self.label.hidden = NO;
    self.label.text = @"Keep Pulling...";
    [self.label sizeToFit];
}

@end
