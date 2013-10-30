//
//  NSDictionary+MSKeyValueCollection.h
//  MSBooster
//
//  Created by Maxthon Chan on 10/21/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MSKeyValueCollection

- (NSUInteger)count;
- (id)objectForKey:(id)aKey;
- (NSEnumerator *)keyEnumerator;

@end

@protocol MSMutableKeyValueCollection <MSKeyValueCollection>

- (void)removeObjectForKey:(id)aKey;
- (void)setObject:(id)anObject forKey:(id <NSCopying>)aKey;

@end

@interface NSDictionary (MSKeyValueCollection) <MSKeyValueCollection>

@end

@interface NSMutableDictionary (MSMutableKeyValueCollection) <MSMutableKeyValueCollection>

@end
