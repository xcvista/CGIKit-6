//
//  CGIRemoteObjectTest.m
//  CGIJSONObject
//
//  Created by Maxthon Chan on 8/15/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "CGITestRemoteObject.h"

@interface CGIRemoteObjectTest : SenTestCase <CGIRemoteConnectionDelegate>

@property NSURL *requestURL;
@property CGITestRemoteObject *testObject;

@end

@implementation CGIRemoteObjectTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    CGIRemoteConnection *connection = [CGIRemoteConnection defaultRemoteConnection];
    connection.delegate = self;
    connection.serverRoot = @"http://www.example.org/%@";
    
    self.testObject = [[CGITestRemoteObject alloc] init];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class. 
    [super tearDown];
}

- (BOOL)connection:(CGIRemoteConnection *)connection shouldSendURLRequset:(NSURLRequest *)request
{
    self.requestURL = request.URL;
    return NO;
}

- (void)testRemoteClassSensing
{
    STAssertEqualObjects(NSStringFromClass([self.testObject classForSelector:@selector(remoteMethod)]), NSStringFromClass([NSArray class]), nil);
}

- (void)testRemoteSending
{
    id remote = [self.testObject remoteMethod];
    STAssertEqualObjects(NSStringFromClass([remote class]), NSStringFromClass([NSError class]), nil);
    STAssertEqualObjects([self.requestURL lastPathComponent], NSStringFromSelector(@selector(remoteMethod)), nil);
}

@end
