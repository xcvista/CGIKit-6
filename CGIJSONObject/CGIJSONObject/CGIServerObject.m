//
//  CGIServerObject.m
//  CGIJSONObject
//
//  Created by Maxthon Chan on 8/16/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import "CGIServerObject.h"
#import "NSObject+CGIJSONSerializable.h"

@implementation CGIServerObject

- (id)objectFromProcessingContext:(CGIHTTPContext *)context
{
    return nil;
}

- (BOOL)shouldHandleEmptyRequests
{
    return YES;
}

#pragma mark - HTTP Content Delegate

- (BOOL)context:(CGIHTTPContext *)context shouldHandleRequest:(CGIHTTPRequest *)request
{
    if ([request.data length] > 0)
    {
        id object = [NSJSONSerialization JSONObjectWithData:request.data
                                                    options:0
                                                      error:NULL];
        return [self setSerializedObject:object];
    }
    else
    {
        return [self shouldHandleEmptyRequests];
    }
}

- (void)handleHTTPContext:(CGIHTTPContext *)context
{
    id response = [self objectFromProcessingContext:context];
    
    if (response)
    {
        NSData *responseData = [NSJSONSerialization dataWithJSONObject:[response serializedObject]
                                                               options:0
                                                                 error:NULL];
        if (responseData)
            [context.response.data setData:responseData];
    }
    
    context.response.contentType = @"application/json";
}

@end
