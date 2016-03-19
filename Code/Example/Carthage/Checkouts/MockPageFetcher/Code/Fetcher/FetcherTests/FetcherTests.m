//
//  FetcherTests.m
//  FetcherTests
//
//  Created by Robert Nash on 07/03/2016.
//  Copyright © 2016 Robert Nash. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Fetcher/Fetcher.h>

@interface FetcherTests : XCTestCase
@property (nonatomic) RRNFetchManager *fetcher;
@end

@implementation FetcherTests

- (void)testFreshData {
    
    NSUInteger batchCount = 4;
    NSUInteger currentPage = 0;
    NSUInteger totalPages = 1;
    NSUInteger duration = 0;
    
    self.fetcher = [[RRNFetchManager alloc] initWithBatchCount:batchCount
                                               withCurrentPage:currentPage
                                                withTotalPages:totalPages];
    
    XCTestExpectation *expectationA = [self expectationWithDescription:@"data found flag correct"];
    XCTestExpectation *expectationB = [self expectationWithDescription:@"data found"];
    
    [self.fetcher fetchFreshDataWithFetchDuration:duration
                                   withCompletion:^(BOOL dataFound) {
                                       
                                       if (dataFound) {
                                           [expectationA fulfill];
                                       }
                                       
                                       if (self.fetcher.values.count == batchCount) {
                                           [expectationB fulfill];
                                       }
                                       
                                   }];
    
    [self waitForExpectationsWithTimeout:duration + 0.0001
                                 handler:nil];
}

-(void)testFetchMoreData {
    
    NSUInteger batchCount = 4;
    NSUInteger currentPage = 0;
    NSUInteger totalPages = 2;
    NSUInteger duration = 0;
    
    self.fetcher = [[RRNFetchManager alloc] initWithBatchCount:batchCount
                                               withCurrentPage:currentPage
                                                withTotalPages:totalPages];
    
    XCTestExpectation *expectationA = [self expectationWithDescription:@"more data found flag correct"];
    XCTestExpectation *expectationB = [self expectationWithDescription:@"data found"];
    
    [self.fetcher fetchFreshDataWithFetchDuration:duration
                                   withCompletion:^(BOOL dataFound) {
                                       
                                       [self.fetcher fetchMoreDataWithFetchDuration:duration
                                                                     withCompletion:^(BOOL moreDataFound) {
                                                                         
                                                                         if (moreDataFound) {
                                                                             [expectationA fulfill];
                                                                         }
                                                                         
                                                                         if (self.fetcher.values.count == batchCount * 2) {
                                                                             [expectationB fulfill];
                                                                         }
                                                                         
                                                                     }];
                                       
                                   }];
    
    [self waitForExpectationsWithTimeout:duration + 0.001
                                 handler:nil];
}

@end
