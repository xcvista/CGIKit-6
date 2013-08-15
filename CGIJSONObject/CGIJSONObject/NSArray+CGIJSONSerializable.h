//
//  NSArray_CGIJSONSerializable.h
//  CGIJSONObject
//
//  Created by Maxthon Chan on 8/15/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (CGIJSONSerializableHelper)

- (id)initWithArray:(NSArray *)array classForMembers:(Class)class;

@end
