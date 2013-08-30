//
//  CGINSMutableArraySerializing.m
//  CGIJSONObject
//
//  Created by Maxthon Chan on 8/30/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <CGIJSONObject/CGIJSONObject.h>

@interface CGINSMutableArraySerializing : SenTestCase

@property NSMutableArray *mutableArray;
@property NSMutableDictionary *mutableDictionary;

@end

@implementation CGINSMutableArraySerializing

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testMutableDeserialization
{
    id dict = @{@"one": @1, @"two": @2};
    id arr = @[@1, @2, @3];
    id object = @{
                  @"mutableArray": arr,
                  @"mutableDictionary": dict,
                  };
    
    CGINSMutableArraySerializing *target = [[CGINSMutableArraySerializing alloc] initWithSerializedObject:object];
    
    STAssertNotNil(target, nil);
    STAssertTrue([target.mutableArray isKindOfClass:[NSMutableArray class]], nil);
    STAssertTrue([target.mutableDictionary isKindOfClass:[NSMutableDictionary class]], nil);
    STAssertEqualObjects(target.mutableDictionary, dict, nil);
    STAssertEqualObjects(target.mutableArray, arr, nil);
}

@end
