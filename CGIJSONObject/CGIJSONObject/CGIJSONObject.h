//
//  CGIJSONObject.h
//  CGIJSONObject
//
//  Created by Maxthon Chan on 8/1/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#if __OBJC__

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
#import <MSBooster/MSBooster.h>
#else
#import <CGIKit/CGIKit.h>
#endif

#import <CGIJSONObject/NSObject+CGIJSONSerializable.h>
#import <CGIJSONObject/NSObject+CGIJSONSerializing.h>
#import <CGIJSONObject/NSArray+CGIJSONSerializable.h>
#import <CGIJSONObject/NSData+CGIJSONSerializable.h>
#import <CGIJSONObject/NSDate+CGIJSONSerializable.h>

#import <CGIJSONObject/CGIRemoteObject.h>
#import <CGIJSONObject/CGIRemoteConnection.h>

#if !TARGET_OS_IPHONE

#import <CGIJSONObject/CGIServerObject.h>

#endif

#endif
