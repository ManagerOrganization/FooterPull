//
//  ExampleTests.m
//  ExampleTests
//
//  Created by Robert Nash on 31/12/2015.
//  Copyright © 2015 Robert Nash. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FakeDataFetcherManager.h"

@interface ExampleTests : XCTestCase

@end

@implementation ExampleTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - FakeDataFetcherManager

-(void)testFetchFreshDataWithNoFetchCount {
    
    FakeDataFetcherManager *manager = [[FakeDataFetcherManager alloc] initWithRowCount:10 withMaxFetchCount:0];
    
    [manager fetchFreshDataWithFetchDuration:0
                              withCompletion:^(BOOL dataFound) {
                                  
                                  XCTAssertFalse(dataFound);
                                  
                              }];
}

-(void)testFetchFreshDataWithFetchCount {
    
    FakeDataFetcherManager *manager = [[FakeDataFetcherManager alloc] initWithRowCount:10 withMaxFetchCount:1];
    
    [manager fetchFreshDataWithFetchDuration:0
                             withCompletion:^(BOOL dataFound) {
                                 
                                 XCTAssertTrue(dataFound);
                                 
                             }];
}

-(void)testFetchFreshDataWithNoRowCount {
    
    FakeDataFetcherManager *manager = [[FakeDataFetcherManager alloc] initWithRowCount:0 withMaxFetchCount:1];
    
    [manager fetchFreshDataWithFetchDuration:0
                              withCompletion:^(BOOL dataFound) {
                                  
                                  XCTAssertFalse(dataFound);
                                  
                              }];
}

-(void)testFetchFreshDataWithRowCount {
    
    FakeDataFetcherManager *manager = [[FakeDataFetcherManager alloc] initWithRowCount:10 withMaxFetchCount:1];
    
    [manager fetchFreshDataWithFetchDuration:0
                              withCompletion:^(BOOL dataFound) {
                                  
                                  XCTAssertTrue(dataFound);
                                  
                              }];
}

-(void)testFetchMoreDataWithNoFetchCount {
    
    FakeDataFetcherManager *manager = [[FakeDataFetcherManager alloc] initWithRowCount:10 withMaxFetchCount:0];
    
    [manager fetchMoreDataWithFetchDuration:0
                             withCompletion:^(BOOL moreDataFound) {
                                 
                                 XCTAssertFalse(moreDataFound);
                                 
                             }];
}

-(void)testFetchMoreDataWithFetchCount {
    
    FakeDataFetcherManager *manager = [[FakeDataFetcherManager alloc] initWithRowCount:10 withMaxFetchCount:1];
    
    [manager fetchMoreDataWithFetchDuration:0
                             withCompletion:^(BOOL moreDataFound) {
                                 
                                 XCTAssertTrue(moreDataFound);
                                 
                             }];
}

-(void)testFetchMoreDataWithNoRowCount {
    
    FakeDataFetcherManager *manager = [[FakeDataFetcherManager alloc] initWithRowCount:0 withMaxFetchCount:1];
    
    [manager fetchMoreDataWithFetchDuration:0
                             withCompletion:^(BOOL moreDataFound) {
                                 
                                 XCTAssertFalse(moreDataFound);
                                 
                             }];
}

-(void)testFetchMoreDataWithRowCount {
    
    FakeDataFetcherManager *manager = [[FakeDataFetcherManager alloc] initWithRowCount:10 withMaxFetchCount:1];
    
    [manager fetchMoreDataWithFetchDuration:0
                             withCompletion:^(BOOL moreDataFound) {
                                
                                 XCTAssertTrue(moreDataFound);
                                
                             }];
}

@end
