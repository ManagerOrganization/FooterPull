//
//  ValuesFactory.h
//  Example
//
//  Created by Rob Nash on 2016-01-07.
//  Copyright © 2016 Robert Nash. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ValuesFactory : NSObject

@property (nonatomic, strong, readonly) NSArray * _Nullable values;

-(instancetype _Nonnull)initWithRowCount:(NSUInteger)rCount withMaxFetchCount:(NSUInteger)count;

-(BOOL)fetchMoreValues;

-(void)reset;

@end
