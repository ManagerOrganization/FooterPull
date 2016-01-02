//
//  RRNInfiniteScrollManager.h
//  Dancer
//
//  Created by Robert Nash on 31/12/2015.
//  Copyright © 2015 Robert Nash. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    PULL_UP_TO_GET_MORE_STATE_IDLE,
    PULL_UP_TO_GET_MORE_STATE_READY,
    PULL_UP_TO_GET_MORE_STATE_TRIGGERED,
    PULL_UP_TO_GET_MORE_STATE_LOADING,
    PULL_UP_TO_GET_MORE_STATE_FETCHING
} PULL_UP_TO_GET_MORE_STATE;

@interface RRNInfiniteScrollManager : NSObject

+(instancetype)sharedManager;

@property (nonatomic) PULL_UP_TO_GET_MORE_STATE state;

@end
