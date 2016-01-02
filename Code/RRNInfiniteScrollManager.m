//
//  RRNInfiniteScrollManager.m
//  Dancer
//
//  Created by Robert Nash on 31/12/2015.
//  Copyright © 2015 Robert Nash. All rights reserved.
//

#import "RRNInfiniteScrollManager.h"

@implementation RRNInfiniteScrollManager

+(instancetype)sharedManager {
    static RRNInfiniteScrollManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [RRNInfiniteScrollManager new];
    });
    return manager;
}

@end
