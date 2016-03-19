//
//  RRNValuesFactory.m
//  Fetcher
//
//  Created by Robert Nash on 07/03/2016.
//  Copyright © 2016 Robert Nash. All rights reserved.
//

#import "RRNValuesFactory.h"

@interface RRNValuesFactory ()
@property (nonatomic, strong, readwrite) NSArray * _Nullable values;
@property (nonatomic) NSUInteger batchCount;
@property (nonatomic) NSUInteger currentPage;
@property (nonatomic) NSUInteger totalPages;
@end

@implementation RRNValuesFactory

-(NSArray * _Nullable)values {
    
    if (_values == nil) {
        _values = @[];
    }
    
    return _values;
}

-(instancetype _Nonnull)initWithBatchCount:(NSUInteger)batchCount
                            withTotalPages:(NSUInteger)totalPages {
    
    self = [super init];
    
    if (self) {
        _batchCount = batchCount;
        _totalPages = totalPages;
        
        if (totalPages == 0) {
            _totalPages = ULONG_MAX;
        }
    }
    
    return self;
}

-(BOOL)fetchValuesForNextPage {
    
    if (self.currentPage == self.totalPages) {
        return NO;
    }
    
    NSMutableArray *collector = [@[] mutableCopy];
    
    for (NSInteger i = 0; i < self.batchCount; i++) {
        [collector addObject:[NSNull null]];
    }
    
    self.currentPage += 1;
    
    NSArray *values = [collector copy];
    
    [self appendValues:values];
    
    return values.count > 0;
}

-(void)appendValues:(NSArray <NSNull *> * _Nullable)values {
    
    if (!values || values.count == 0) {
        return;
    }
    
    NSMutableArray *collector = [self.values mutableCopy];
    
    [collector addObjectsFromArray:values];
    
    self.values = [collector copy];
}

-(void)reset {
    
    self.values = nil;
    
    self.currentPage = 0;
}

@end
