
include ../../GNUstep.make

TOOL_NAME := time.fcgi

$(TOOL_NAME)_OBJC_FILES := TimeAppDelegate.m TimeDateWrapper.m TimeServerObject.m
$(TOOL_NAME)_C_FILES := main.c
$(TOOL_NAME)_LDFLAGS := -lCGIJSONObject -lCGIKit -lfcgi -lMSBooster

GNUSTEP_INSTALLATION_DOMAIN := NETWORK

include ../../tool.make
