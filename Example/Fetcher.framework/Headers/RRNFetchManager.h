//
//  RRNFetchManager.h
//  Fetcher
//
//  Created by Robert Nash on 07/03/2016.
//  Copyright © 2016 Robert Nash. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRNFetchManager : NSObject

@property (strong, nonatomic, readonly) NSArray * _Nonnull values;

-(instancetype _Nonnull)initWithBatchCount:(NSUInteger)batchCount
                            withTotalPages:(NSUInteger)totalPages; //A value of zero is ULONG_MAX pages

-(void)fetchFreshDataWithFetchDuration:(unsigned int)seconds
                        withCompletion:(void (^ _Nonnull)(BOOL dataFound))completion;

-(void)fetchNextPageWithFetchDuration:(unsigned int)seconds
                       withCompletion:(void (^ _Nonnull)(BOOL moreDataFound))completion;

@end
