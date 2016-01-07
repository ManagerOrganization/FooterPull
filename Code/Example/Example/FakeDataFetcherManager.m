//
//  FakeDataFetcherManager.m
//  Example
//
//  Created by Robert Nash on 31/12/2015.
//  Copyright © 2015 Robert Nash. All rights reserved.
//

#import "FakeDataFetcherManager.h"

@interface FakeDataFetcherManager ()
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong, readwrite) NSArray *values;
@property (nonatomic, strong) NSNumber *buildValuesCount;
@end

@implementation FakeDataFetcherManager

-(dispatch_queue_t)queue {
    if (_queue == nil) {
        _queue = dispatch_queue_create("example_queue", DISPATCH_QUEUE_CONCURRENT);
    }
    return _queue;
}

#pragma mark - Fetch

-(void)fetchFreshDataWithCompletion:(void (^)(BOOL dataFound))completion {
    [self fetchDataForceRefresh:YES
                 withCompletion:completion];
}

-(void)fetchMoreDataWithCompletion:(void (^)(BOOL moreDataFound))completion {
    [self fetchDataForceRefresh:NO
                 withCompletion:completion];
}

-(void)fetchDataForceRefresh:(BOOL)forceRefresh withCompletion:(void(^)(BOOL newContent))completion {
    
    dispatch_async(self.queue, ^{
        
        sleep(2);
        
        NSArray *values = [self buildValues:forceRefresh];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (forceRefresh) {
                
                self.values = values;
                
            } else {
                
                NSMutableArray *collector = [self.values mutableCopy];
                [collector addObjectsFromArray:values];
                self.values = [collector copy];
                
            }
            
            completion(values.count > 0);
            
        });
        
    });
    
}

#pragma mark - Build Values

#define VALUES_COUNT 23

-(NSArray *)values {
    if (_values == nil) {
        NSMutableArray *collector = [@[] mutableCopy];
        for (NSInteger i = 0; i < VALUES_COUNT; i++) {
            [collector addObject:[NSNull null]];
        }
        
        _values = [collector copy];
    }
    return _values;
}

-(NSArray *)buildValues:(BOOL)forceRefresh {
    
    NSMutableArray *collector = [@[] mutableCopy];
    
    if (![self shouldBuildValues:forceRefresh]) {
        return [collector copy];
    }
    
    for (NSInteger i = 0; i < VALUES_COUNT; i++) {
        [collector addObject:[NSNull null]];
    }
    
    return [collector copy];
}

-(BOOL)shouldBuildValues:(BOOL)forceRefresh {
    
    if (forceRefresh || !self.buildValuesCount) {
        self.buildValuesCount = @(1);
    } else if (self.buildValuesCount.integerValue == 2) {
        return NO;
    } else {
        self.buildValuesCount = @(self.buildValuesCount.integerValue+1);
    }
    
    return YES;
}

@end
