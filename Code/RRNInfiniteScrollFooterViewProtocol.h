//
//  RRNInfiniteScrollFooterViewProtocol.h
//  Example
//
//  Created by Robert Nash on 31/12/2015.
//  Copyright © 2015 Robert Nash. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RRNInfiniteScrollFooterViewProtocol <NSObject>

-(void)prepare:(CGFloat)progress;
-(void)trigger;
-(void)stop;
-(void)reset;

@end
