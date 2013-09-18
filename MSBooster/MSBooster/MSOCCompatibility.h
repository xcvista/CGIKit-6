//
//  MSOCCompatibility.h
//  MSBooster
//
//  Created by Maxthon Chan on 7/31/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#ifndef MSBooster_MSOCCompatibility_h
#define MSBooster_MSOCCompatibility_h

#include <objc/runtime.h>
#include <objc/message.h>

#if __has_include(<objc/arc.h>)
#   include <objc/arc.h>
#else // !__has_include(<objc/arc.h>)
/**
 Retains an object.
 */
extern id objc_retain(id);

/**
 Releases an object.
 */
extern void objc_release(id);

/**
 Add the object into the current autorelease pool.
 */
extern id objc_autorelease(id);
#endif // __has_include(<objc/arc.h>)

#if __has_include(<CoreFoundation/CoreFoundaton.h>)
#include <CoreFoundation/CoreFoundation.h>
#endif // __has_include(<CoreFoundation/CoreFoundaton.h>)

#if __has_include(<dispatch/dispatch.h>)
#include <dispatch/dispatch.h>
#endif

#if __OBJC__
#import <Foundation/Foundation.h>
#define __class @class
#else // !__OBJC__
#define __class typedef struct objc_object
#endif // __OBJC__

// Commonly-used Foundation classes, redeclared for C.

__class NSObject;
__class NSString;
__class NSArray;
__class NSDictionary;
__class NSData;
__class NSDate;
__class NSNull;
__class NSNumber;

// instancetype

#if !__has_feature(objc_instancetype)
typedef id instancetype;
#endif // !__has_feature(objc_instancetype)

#endif
