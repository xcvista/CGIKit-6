//
//  CGINSObjectClassSensing.m
//  CGIJSONObject
//
//  Created by Maxthon Chan on 8/15/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <CGIJSONObject/CGIJSONObject.h>
#import "CGITestClass.h"

@interface CGINSObjectClassSensing : SenTestCase

@property CGITestClass *test;

@end

@implementation CGINSObjectClassSensing

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class. 
    [super tearDown];
}

- (void)testClassSensing
{
    NSArray *targetArray = @[@1, @2, @3];
    NSDictionary *targetDictionary = @{@"one": @1, @"two": @2};
    NSDictionary *target = @{
                             @"test": @{
                                        @"array": [targetArray copy],
                                        @"dictionary": [targetDictionary copy],
                                        @"null": [NSNull null],
                                        @"date": @5000,
                                        }
                             };
    
    CGINSObjectClassSensing *decoded = [[CGINSObjectClassSensing alloc] initWithSerializedObject:target];
    STAssertNotNil(decoded, nil);
    STAssertEqualObjects(NSStringFromClass([decoded.test class]), NSStringFromClass([CGITestClass class]), nil);
    STAssertEqualObjects(decoded.test.array, targetArray, nil);
    STAssertEqualObjects(decoded.test.dictionary, targetDictionary, nil);
    STAssertNil(decoded.test.null, nil);
    STAssertEqualObjects(decoded.test.date, [NSDate dateWithTimeIntervalSince1970:5], nil);
}

- (void)testNullEncoding
{
    self.test = nil;
    NSDictionary *target = @{@"test": [NSNull null]};
    
    id encoded = [self serializedObject];
    STAssertNotNil(encoded, nil);
    STAssertEqualObjects(encoded, target, nil);
}

@end
