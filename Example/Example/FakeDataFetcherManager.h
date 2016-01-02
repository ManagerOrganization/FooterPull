//
//  FakeDataFetcherManager.h
//  Example
//
//  Created by Robert Nash on 31/12/2015.
//  Copyright © 2015 Robert Nash. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FakeDataFetcherManager : NSObject

@property (nonatomic, strong, readonly) NSArray *values;

-(void)fetchFreshDataWithCompletion:(void (^)(BOOL dataFound))completion;

-(void)fetchMoreDataWithCompletion:(void (^)(BOOL moreDataFound))completion;

@end
