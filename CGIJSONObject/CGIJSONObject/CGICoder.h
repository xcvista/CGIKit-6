//
//  CGICoder.h
//  CGIJSONObject
//
//  Created by Maxthon Chan on 8/1/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGICoder : NSCoder
{
    @private
    id _encodedObject;
    NSInteger _encodingState;
}

+ (id)encodedObjectWithRootObject:(id<NSCoding>)object;

- (void)codingParadigmMixed;

@end
