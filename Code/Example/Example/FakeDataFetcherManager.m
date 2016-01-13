//
//  FakeDataFetcherManager.m
//  Example
//
//  Created by Robert Nash on 31/12/2015.
//  Copyright © 2015 Robert Nash. All rights reserved.
//

#import "FakeDataFetcherManager.h"

@interface FakeDataFetcherManager ()
@property (nonatomic, strong, readwrite) ValuesFactory *valuesFactory;
@property (nonatomic, strong) dispatch_queue_t queue;
@end

@implementation FakeDataFetcherManager

-(dispatch_queue_t)queue {
    
    if (_queue == nil) {
        _queue = dispatch_queue_create("example_queue", DISPATCH_QUEUE_CONCURRENT);
    }
    return _queue;
}

-(ValuesFactory *)valuesFactory {
    
    if (_valuesFactory == nil) {
        _valuesFactory = [[ValuesFactory alloc] initWithRowCount:22 withMaxFetchCount:3];
    }
    
    return _valuesFactory;
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
        
        if (forceRefresh) {
            [self.valuesFactory reset];
        }
        
        BOOL newContent = [self.valuesFactory fetchMoreValues];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            completion(newContent);
            
        });
        
    });
    
}

@end
