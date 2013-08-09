//
//  MSStringManipulation.m
//  MSBooster
//
//  Created by Maxthon Chan on 7/31/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import "MSStringManipulation.h"

NSString *MSSTRv(NSString *format, va_list args)
{
    return [[NSString alloc] initWithFormat:format arguments:args];
}

NSString *MSSTR(NSString *format, ...)
{
    va_list args;
    va_start(args, format);
    NSString *result = MSSTRv(format, args);
    va_end(args);
    return result;
}

const char *MSCSTR(NSString *string)
{
    return [string cStringUsingEncoding:NSUTF8StringEncoding];
}

NSString *_MS_CFSTR(const char *string)
{
    return @(string);
}
