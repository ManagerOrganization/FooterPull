//
//  ValuesFactory.m
//  Example
//
//  Created by Rob Nash on 2016-01-07.
//  Copyright © 2016 Robert Nash. All rights reserved.
//

#import "ValuesFactory.h"

@interface ValuesFactory ()
@property (nonatomic, strong, readwrite) NSArray * _Nullable values;
@end

@implementation ValuesFactory {
    NSUInteger currentFetchCount;
    NSUInteger maxFetchCount;
    NSUInteger rowCount;
}

-(NSArray * _Nullable)values {
    
    if (_values == nil) {
        _values = @[];
    }
    
    return _values;
}

-(instancetype _Nonnull)initWithRowCount:(NSUInteger)rCount withMaxFetchCount:(NSUInteger)count {
    
    self = [super init];
    
    if (self) {
        rowCount = rCount;
        maxFetchCount = count;
    }
    
    return self;
}

-(BOOL)fetchMoreValues {
    
    if (currentFetchCount == maxFetchCount) {
        return NO;
    }
    
    NSMutableArray *collector = [@[] mutableCopy];
    
    for (NSInteger i = 0; i < rowCount; i++) {
        [collector addObject:[NSNull null]];
    }
    
    currentFetchCount += 1;
    
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
    
    currentFetchCount = 0;
}

@end
