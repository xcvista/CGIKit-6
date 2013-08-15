//
//  TimeServerObject.m
//  Demo
//
//  Created by Maxthon Chan on 8/16/13.
//
//

#import "TimeServerObject.h"
#import "TimeDateWrapper.h"

@implementation TimeServerObject

- (id)objectFromProcessingContext:(CGIHTTPContext *)context
{
    return [[TimeDateWrapper alloc] init];
}

@end
