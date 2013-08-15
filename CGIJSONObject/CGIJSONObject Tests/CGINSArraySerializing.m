//
//  CGINSArraySerializing.m
//  CGIJSONObject
//
//  Created by Maxthon Chan on 8/15/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <CGIJSONObject/CGIJSONObject.h>
#import "CGISingleElementClass.h"

@interface CGINSArraySerializing : SenTestCase

@property NSArray *objects;
@property id array;

@end

@implementation CGINSArraySerializing

CGIClassForKey(objects, CGISingleElementClass);
CGINoSerializeKey(array);

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:5];
    NSMutableArray *standard = [NSMutableArray arrayWithCapacity:5];
    for (NSUInteger i = 0; i < 5; i++)
    {
        CGISingleElementClass *object = [[CGISingleElementClass alloc] init];
        object.d = @(i);
        [objects addObject:object];
        [standard addObject:@{@"d": @(i)}];
    }
    
    self.objects = objects;
    self.array = standard;
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class. 
    [super tearDown];
}

- (void)testEncoding
{
    NSDictionary *encoded = [self serializedObject];
    
    STAssertNotNil(encoded, nil);
    STAssertEqualObjects(encoded[@"objects"], self.array, nil);
    STAssertNil(encoded[@"array"], nil);
}

- (void)testDecoding
{
    NSDictionary *target = @{
                             @"objects": self.array,
                             @"array": @"dead beef",
                             };
    
    CGINSArraySerializing *decoded = [[CGINSArraySerializing alloc] initWithSerializedObject:target];
    STAssertNotNil(decoded, nil);
    STAssertEqualObjects(decoded.objects, self.objects, nil);
    STAssertNil(decoded.array, nil);
}

@end
