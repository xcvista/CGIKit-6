//
//  MSStringManipulation.h
//  MSBooster
//
//  Created by Maxthon Chan on 7/31/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#ifndef MSBooster_MSStringManiplation_h
#define MSBooster_MSStringManiplation_h

#include <MSBooster/MSCommon.h>
#include <MSBooster/MSOCCompatibility.h>

#if !GNUSTEP && __has_include(<CoreFoundation/CoreFoundation.h>)
#include <CoreFoundation/CoreFoundation.h>
#else
#ifndef CFSTR
#define CFSTR(cStr) _MS_CFSTR("" cStr "")
#endif
typedef NSString *CFStringRef;
extern MSFormat(printf, 1, 0) CFStringRef _MS_CFSTR(const char *string);
#endif

#if __OBJC__

__BEGIN_DECLS

/**
 Convenient function to create an NSString object from a format string.
 
 @param     format  The format string.
 @param     args    The argument list.
 @return    An NSString object containing the arguments, formatted as the format
            string.
 
 @see       vsnprintf(3)
 @see       -[NSString initWithFormat:arguments:]
 */
extern MSFormat(NSString, 1, 0) NSString *MSSTRv(NSString *format,
                                                 va_list args);

/**
 Convenient function to create an NSString object from a format string.
 
 @param     format  The format string.
 @param     ...     The argument list.
 @return    An NSString object containing the arguments, formatted as the format
            string.
 
 @see       snprintf(3)
 @see       -[NSString initWithFormat:]
 @see       +[NSString stringWithFormat:]
 */
extern MSFormat(NSString, 1, 2) NSString *MSSTR(NSString *format,
                                                ...);

/**
 Convenient function to create a C string from an NSString object.
 
 @param     string  The source NSString object.
 @return    A C string containing the exact contents of the source string, using
            UTF-8 encoding.
 
 @see       -[NSString cStringUsingEncoding:]
 */
extern const char *MSCSTR(NSString *string);

__END_DECLS

#endif

#endif
