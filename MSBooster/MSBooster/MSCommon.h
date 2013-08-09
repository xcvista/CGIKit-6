//
//  MSCommon.h
//  MSBooster
//
//  Created by Maxthon Chan on 7/31/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#ifndef MSBooster_MSCommon_h
#define MSBooster_MSCommon_h

// Feature detection macros

#ifndef __has_feature
#define __has_feature(x) 0
#endif

#ifndef __has_extension
#define __has_extension(x) __has_feature(x)
#endif

#ifndef __has_attribute
#define __has_attribute(x) 0
#endif

#ifndef __has_builtin
#define __has_builtin(x) 0
#endif

// Commonly used C headers (standalone)

#include <iso646.h>
#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>
#include <sys/types.h>
#include <sys/cdefs.h>
#include <stdarg.h>

// Macros wrapping around some features

#if __has_attribute(format)
#define MSFormat(_type, _fmt_param, _vararg) __attribute__((format(_type, _fmt_param, _vararg)))
#else
#define MSFormat(_type, _fmt_param, _vararg)
#endif

#if __has_attribute(noreturn)
#define MSNoReturn __attribute__((noreturn))
#if __has_builtin(builtin_unreachable)
#define MSUnreachable() __builtin_unreachable()
#else
#define MSUnreachable() do; while (0)
#endif
#else
#define MSNoReturn
#define MSUnreachable() do; while (0)
#endif

#if __has_attribute(always_inline)
#define MSInline inline __attribute__((always_inline))
#else
#define MSInline inline
#endif

#if __has_attribute(deprecated)
#if __has_extension(attribute_deprecated_with_message)
#define MSDeprecated(_msg) __attribute__((deprecated(_msg)))
#else
#define MSDeprecated(_msg) __attribute__((deprecated))
#endif
#else
#define MSDeprecated(_msg)
#endif

#if __has_attribute(unavailable)
#if __has_extension(attribute_unavailable_with_message)
#define MSUnavailable(_msg) __attribute__((unavailable(_msg)))
#else
#define MSUnavailable(_msg) __attribute__((unavailable))
#endif
#else
#define MSUnavailable(_msg)
#endif

#if !__has_include(<Foundation/Foundation.h>)
#ifndef NS_ENUM
#define NS_ENUM(_type, _name) enum _name : _type; enum _name
#endif

#ifndef NS_OPTION
#define NS_OPTION(_type, _name) enum _name : _type; enum _name
#endif
#endif

#ifndef MSAssignPointer
#define MSAssignPointer(_ptr, _val) \
do { \
    typeof(_ptr) _p = (_ptr); \
    if (_p) \
        *_p = (_val); \
} while (0)
#endif

#endif
