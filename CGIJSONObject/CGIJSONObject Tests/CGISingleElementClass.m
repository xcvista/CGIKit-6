//
//  CGISingleElementClass.m
//  CGIJSONObject
//
//  Created by Maxthon Chan on 8/15/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import "CGISingleElementClass.h"

@implementation CGISingleElementClass

- (BOOL)isEqual:(id)object
{
    return [self.d isEqual:[object d]];
}

@end
