//
//  NSOrderedSet+MSCollectionProtocols.m
//  MSBooster
//
//  Created by Maxthon Chan on 10/21/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import "NSOrderedSet+MSCollectionProtocols.h"

@implementation NSOrderedSet (MSCollectionProtocols)

- (id)member:(id)object
{
    NSUInteger idx = [self indexOfObject:object];
    if (idx != NSNotFound)
        return [self objectAtIndex:idx];
    else
        return nil;
}

@end

@implementation NSMutableOrderedSet (MSCollectionProtocols)

- (void)removeLastObject
{
    [self removeObjectAtIndex:[self count] - 1];
}

@end
