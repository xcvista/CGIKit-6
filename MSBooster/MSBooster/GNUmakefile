
include ../../GNUstep.make

FRAMEWORK_NAME := MSBooster

$(FRAMEWORK_NAME)_NEEDS_GUI := no
$(FRAMEWORK_NAME)_HEADER_FILES := MSBooster.h MSBooster_Private.h MSCommon.h MSOCCompatibility.h MSStringConstant.h MSStringManipulation.h NSData+MSHashing.h NSData+MSCompression.h NSArray+LinqExtension.h NSDictionary+LinqExtension.h
$(FRAMEWORK_NAME)_OBJC_FILES := MSStringManipulation.m NSData+MSHashing.m NSData+MSCompression.m NSArray+LinqExtension.m NSDictionary+LinqExtension.m
$(FRAMEWORK_NAME)_LDFLAGS := -lcrypto -lz -lbz2
$(FRAMEWORK_NAME)_CURRENT_VERSION_NAME := A
$(FRAMEWORK_NAME)_VERSION := 1.0

include ../../framework.make