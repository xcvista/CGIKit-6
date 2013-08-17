//
//  MSBooster.h
//  MSBooster
//
//  Created by Maxthon Chan on 7/31/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#ifndef MSBooster_h
#define MSBooster_h

#include <MSBooster/MSCommon.h>
#include <MSBooster/MSOCCompatibility.h>
#include <MSBooster/MSStringConstant.h>
#include <MSBooster/MSStringManipulation.h>

#if __OBJC__

#import <MSBooster/NSData+MSHashing.h>
#import <MSBooster/NSData+MSCompression.h>
#import <MSBooster/NSArray+LinqExtensions.h>
#import <MSBooster/NSDictionary+LinqExtensions.h>

#if !TARGET_OS_IPHONE

#import <MSBooster/NSData+MSArchiving.h>

#endif

#endif

#endif