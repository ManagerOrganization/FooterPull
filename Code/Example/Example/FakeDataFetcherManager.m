//
//  FakeDataFetcherManager.m
//  Example
//
//  Created by Robert Nash on 31/12/2015.
//  Copyright © 2015 Robert Nash. All rights reserved.
//

#import "FakeDataFetcherManager.h"

@interface FakeDataFetcherManager ()
@property (nonatomic, strong, readwrite) ValuesFactory * _Nonnull valuesFactory;
@property (nonatomic, strong) dispatch_queue_t queue;
@end

@implementation FakeDataFetcherManager

-(dispatch_queue_t)queue {
    
    if (_queue == nil) {
        _queue = dispatch_queue_create("example_queue", DISPATCH_QUEUE_CONCURRENT);
    }
    return _queue;
}

-(instancetype)initWithRowCount:(NSUInteger)rowCount withMaxFetchCount:(NSUInteger)maxFetchCount {
    
    self = [super init];
    if (self) {
        _valuesFactory = [[ValuesFactory alloc] initWithRowCount:rowCount withMaxFetchCount:maxFetchCount];
    }
    return self;
}

#pragma mark - Fetch

-(void)fetchFreshDataWithFetchDuration:(unsigned int)seconds withCompletion:(void (^ _Nonnull)(BOOL dataFound))completion {
    
    [self fetchDataWithDuration:seconds
                   forceRefresh:YES
                 withCompletion:completion];
}

-(void)fetchMoreDataWithFetchDuration:(unsigned int)seconds withCompletion:(void (^ _Nonnull)(BOOL moreDataFound))completion {
    
    [self fetchDataWithDuration:seconds
                   forceRefresh:NO
                 withCompletion:completion];
}

-(void)fetchDataWithDuration:(unsigned int)seconds forceRefresh:(BOOL)forceRefresh withCompletion:(void(^ _Nonnull)(BOOL newContent))completion {
    
    dispatch_async(self.queue, ^{
        
        sleep(seconds);
        
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
