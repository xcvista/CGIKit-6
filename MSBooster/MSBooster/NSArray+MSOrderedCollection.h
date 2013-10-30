//
//  NSArray+MSOrderedCollection.h
//  MSBooster
//
//  Created by Maxthon Chan on 10/21/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MSOrderedCollection

- (NSUInteger)count;
- (id)objectAtIndex:(NSUInteger)index;

@end

@protocol MSMutableOrderedCollection <MSOrderedCollection>

- (void)addObject:(id)anObject;
- (void)insertObject:(id)anObject atIndex:(NSUInteger)index;
- (void)removeLastObject;
- (void)removeObjectAtIndex:(NSUInteger)index;
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;

@end

@interface NSArray (MSOrderedCollection) <MSOrderedCollection>

@end

@interface NSMutableArray (MSMutableOrderedCollection) <MSMutableOrderedCollection>

@end
