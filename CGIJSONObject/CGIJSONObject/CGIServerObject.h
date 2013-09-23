//
//  CGIServerObject.h
//  CGIJSONObject
//
//  Created by Maxthon Chan on 8/16/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import <CGIKit/CGIKit.h>

/**
 Represents a remote method that can be called when needed.
 */
@interface CGIServerObject : NSObject <CGIHTTPContextDelegate>

/**
 Indicate that if this method handles GET requests.
 */
- (BOOL)shouldHandleEmptyRequests;

/**
 Process the HTTP request and return an object that is treated as the output.
 */
- (id)objectFromProcessingContext:(CGIHTTPContext *)context;

@end
