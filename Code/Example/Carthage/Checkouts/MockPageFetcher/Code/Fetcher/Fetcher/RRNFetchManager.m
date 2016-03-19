//
//  RRNFetchManager.m
//  Fetcher
//
//  Created by Robert Nash on 07/03/2016.
//  Copyright © 2016 Robert Nash. All rights reserved.
//

#import "RRNFetchManager.h"
#import "RRNValuesFactory.h"

@interface RRNFetchManager ()
@property (strong, nonatomic, readwrite) RRNValuesFactory * _Nonnull valuesFactory;
@property (strong, nonatomic) dispatch_queue_t queue;
@property (strong, nonatomic, readwrite) NSArray * _Nonnull values;
@end

@implementation RRNFetchManager

-(instancetype _Nonnull)initWithBatchCount:(NSUInteger)batchCount
                            withTotalPages:(NSUInteger)totalPages {
    
    self = [super init];
    if (self) {
        _valuesFactory = [[RRNValuesFactory alloc] initWithBatchCount:batchCount
                                                       withTotalPages:totalPages];
        
        _queue = dispatch_queue_create("rrn_fetch_queue", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

-(NSArray *)values {
    _values = self.valuesFactory.values;
    return _values;
}

#pragma mark - Fetch

-(void)fetchFreshDataWithFetchDuration:(unsigned int)seconds
                        withCompletion:(void (^ _Nonnull)(BOOL dataFound))completion {
    
    [self fetchDataWithDuration:seconds
                   forceRefresh:YES
                 withCompletion:completion];
}

-(void)fetchNextPageWithFetchDuration:(unsigned int)seconds
                       withCompletion:(void (^ _Nonnull)(BOOL moreDataFound))completion {
    
    [self fetchDataWithDuration:seconds
                   forceRefresh:NO
                 withCompletion:completion];
}

-(void)fetchDataWithDuration:(unsigned int)seconds
                forceRefresh:(BOOL)forceRefresh
              withCompletion:(void(^ _Nonnull)(BOOL newContent))completion {
    
    dispatch_async(self.queue, ^{
        
        sleep(seconds);
        
        if (forceRefresh) {
            [self.valuesFactory reset];
        }
        
        BOOL newContent = [self.valuesFactory fetchValuesForNextPage];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            completion(newContent);
            
        });
        
    });
    
}

@end
