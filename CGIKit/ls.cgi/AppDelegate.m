//
//  AppDelegate.m
//  CGIKit
//
//  Created by Maxthon Chan on 8/2/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property NSUInteger number;

@end

@implementation AppDelegate

- (void)application:(CGIApplication *)application handleHTTPContext:(CGIHTTPContext *)context
{
    NSUInteger num1 = self.number++;
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        NSUInteger num2 = self.number++;
        [context.response.data setData:[MSSTR(@"%lu %lu\n", num1, num2) dataUsingEncoding:NSUTF8StringEncoding]];
        context.response.contentType = @"text/plain";
        dispatch_group_leave(group);
    });
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
}

@end
