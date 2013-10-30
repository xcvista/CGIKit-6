//
//  CGIRemoteObject.h
//  CGIJSONObject
//
//  Created by Maxthon Chan on 8/15/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

/**
 @def       CGIClassForKey
 
 This macro defines a method that tags the class of the key.
 
 @param     __key    Name of method that requires its class identified.
 @param     __class  Type of the return value of the method.
 @note      A nonexist class will cause the key being ignored.
 */
#define CGIRemoteMethodClass(__method, __class) \
- (Class)classForMethod ##__method { return objc_lookUpClass(#__class); }

#define CGINotRemoteMethod(__method) \
- (Class)classForMethod ##__method { return Nil; }

@class CGIRemoteConnection;

@interface CGIRemoteObject : NSObject

- (BOOL)remoteRespondsToSelector:(SEL)selector;
- (Class)classForSelector:(SEL)selector;

@end
