//
//  AppDelegate.m
//  CGIKit
//
//  Created by Maxthon Chan on 8/2/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import "AppDelegate.h"
#import <unistd.h>

@interface AppDelegate ()

@property NSUInteger counter;

@end

@implementation AppDelegate

- (void)application:(CGIApplication *)application handleHTTPContext:(CGIHTTPContext *)context
{
    NSUInteger i = self.counter++;
    sleep(5);
    NSUInteger j = self.counter++;
    NSString *string = MSSTR(@"%@ %@: %lu %lu\n", self, [NSThread currentThread], i, j);
    [context.response.data setData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    context.response.contentType = @"text/plain";
}

@end
