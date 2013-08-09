//
//  CGIHTTPResponse.m
//  CGIKit
//
//  Created by Maxthon Chan on 8/2/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import "CGIHTTPResponse.h"

@implementation CGIHTTPResponse

#pragma mark - Property rewritings

- (CGIHTTPResponseCode)statusCode
{
    return [self.headers[CGIHTTPResponseStatusKey] unsignedIntegerValue];
}

- (void)setStatusCode:(CGIHTTPResponseCode)statusCode
{
    self.headers[CGIHTTPResponseStatusKey] = @(statusCode);
}

@end

#import <MSBooster/MSBooster_Private.h>
#include "CGIHTTPResponseStrings.h"
