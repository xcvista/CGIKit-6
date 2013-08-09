//
//  CGICoder.m
//  CGIJSONObject
//
//  Created by Maxthon Chan on 8/1/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import "CGICoder.h"

@implementation CGICoder

- (void)codingParadigmMixed
{
    [NSException raise:NSInvalidArchiveOperationException
                format:@"You cannot mix keyed and non-keyed coding in one object."];
}

- (void)encodeValueOfObjCType:(const char *)type at:(const void *)addr
{
    if (!_encodedObject)
    {
        _encodedObject = [NSMutableArray array];
    }
    
    if (![_encodedObject isKindOfClass:[NSArray class]])
    {
        [self codingParadigmMixed];
    }
    else if (!strcmp(type, "@"))
    {
        // Objects
        id __weak object = (__bridge id)(addr);
        id encoded = [[self class] encodedObjectWithRootObject:object];
        [_encodedObject addObject:encoded];
    }
}

@end
