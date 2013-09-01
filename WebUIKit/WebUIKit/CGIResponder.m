//
//  CGIResponder.m
//  WebUIKit
//
//  Created by Maxthon Chan on 9/1/13.
//
//

#import "CGIResponder.h"

@implementation CGIResponder

- (id)nextResponder
{
    return nil;
}

- (void)handleEvent:(CGIEvent *)event
{
    [[self nextResponder] handleEvent:event];
}

@end
