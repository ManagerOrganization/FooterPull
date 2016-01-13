//
//  FakeDataFetcherManager.h
//  Example
//
//  Created by Robert Nash on 31/12/2015.
//  Copyright © 2015 Robert Nash. All rights reserved.
//

#import "ValuesFactory.h"

@interface FakeDataFetcherManager : NSObject

@property (nonatomic, strong, readonly) ValuesFactory * _Nonnull valuesFactory;

-(instancetype _Nonnull)initWithRowCount:(NSUInteger)rowCount withMaxFetchCount:(NSUInteger)maxFetchCount;

-(void)fetchFreshDataWithCompletion:(void (^ _Nonnull)(BOOL dataFound))completion;

-(void)fetchMoreDataWithCompletion:(void (^ _Nonnull)(BOOL moreDataFound))completion;

@end
