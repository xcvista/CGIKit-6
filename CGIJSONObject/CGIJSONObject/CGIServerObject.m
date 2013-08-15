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

#pragma mark - HTTP Content Delegate

- (BOOL)context:(CGIHTTPContext *)context shouldHandleRequest:(CGIHTTPRequest *)request
{
    id object = [NSJSONSerialization JSONObjectWithData:request.data
                                                options:0
                                                  error:NULL];
    return [self setSerializedObject:object];
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
            [context.response.data setData:response];
    }
    
    context.response.contentType = @"application/json";
}

@end
