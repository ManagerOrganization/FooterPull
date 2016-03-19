//
//  RRNValuesFactory.h
//  Fetcher
//
//  Created by Robert Nash on 07/03/2016.
//  Copyright © 2016 Robert Nash. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRNValuesFactory : NSObject

@property (nonatomic, strong, readonly) NSArray <NSNull *> * _Nullable values;

-(instancetype _Nonnull)initWithBatchCount:(NSUInteger)batchCount
                            withTotalPages:(NSUInteger)totalPages; //0 total pages is ULONG_MAX

-(BOOL)fetchValuesForNextPage;

-(void)reset;

@end
