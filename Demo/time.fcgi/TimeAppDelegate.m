//
//  TimeAppDelegate.m
//  Demo
//
//  Created by Maxthon Chan on 8/16/13.
//
//

#import "TimeAppDelegate.h"
#import "TimeServerObject.h"

@implementation TimeAppDelegate

- (id<CGIHTTPContextDelegate>)createDelegateForContext:(CGIApplication *)application
{
    return [[TimeServerObject alloc] init];
}

@end
