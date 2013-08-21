//
//  CGINSDateDecodingTest.m
//  CGIJSONObject
//
//  Created by Maxthon Chan on 8/21/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <CGIJSONObject/CGIJSONObject.h>

@interface CGINSDateDecodingTest : SenTestCase

@property NSDate *test;

@end

@implementation CGINSDateDecodingTest

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

- (void)testDecodeDateFromString
{
    NSDictionary *target = @{@"test": @"5000"};
    
    CGINSDateDecodingTest *decoding = [[CGINSDateDecodingTest alloc] initWithSerializedObject:target];
    STAssertNotNil(decoding, nil);
    STAssertEqualObjects(decoding.test, [NSDate dateWithTimeIntervalSince1970:5], nil);
}

- (void)testDecodeDateFromNumber
{
    NSDictionary *target = @{@"test": @5000};
    
    CGINSDateDecodingTest *decoding = [[CGINSDateDecodingTest alloc] initWithSerializedObject:target];
    STAssertNotNil(decoding, nil);
    STAssertEqualObjects(decoding.test, [NSDate dateWithTimeIntervalSince1970:5], nil);
}

@end
