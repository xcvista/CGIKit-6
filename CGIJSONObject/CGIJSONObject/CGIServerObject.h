//
//  CGIServerObject.h
//  CGIJSONObject
//
//  Created by Maxthon Chan on 8/16/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import <CGIKit/CGIKit.h>

@interface CGIServerObject : NSObject <CGIHTTPContextDelegate>

- (id)objectFromProcessingContext:(CGIHTTPContext *)context;

@end
