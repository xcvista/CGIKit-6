//
//  NSSet+MSUniqueCollection.h
//  MSBooster
//
//  Created by Maxthon Chan on 10/21/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MSUniqueCollection

- (NSUInteger)count;
- (id)member:(id)object;
- (NSEnumerator *)objectEnumerator;

@end

@protocol MSMutableUniqueCollection <MSUniqueCollection>

- (void)addObject:(id)object;
- (void)removeObject:(id)object;

@end

@interface NSSet (MSUniqueCollection) <MSUniqueCollection>

@end

@interface NSMutableSet (MSMutableUniqueCollection) <MSMutableUniqueCollection>

@end
