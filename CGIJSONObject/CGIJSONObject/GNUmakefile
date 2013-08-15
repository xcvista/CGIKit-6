
include ../../GNUstep.make

FRAMEWORK_NAME := CGIJSONObject

$(FRAMEWORK_NAME)_NEEDS_GUI := no
$(FRAMEWORK_NAME)_HEADER_FILES := CGIJSONObject.h NSArray+CGIJSONSerializable.h NSData+CGIJSONSerializable.h NSObject+CGIJSONSerializable.h CGIRemoteObject.h CGIRemoteConnection.h
$(FRAMEWORK_NAME)_OBJC_FILES := NSArray+CGIJSONSerializable.m NSData+CGIJSONSerializable.m NSDate+CGIJSONSerializable.m NSDictionary+CGIJSONSerializable.m NSNull+CGIJSONSerializable.m NSNumber+CGIJSONSerializable.m NSObject+CGIJSONSerializable.m NSString+CGIJSONSerializable.m CGIRemoteObject.m CGIRemoteConnection.m
$(FRAMEWORK_NAME)_LDFLAGS := -lMSBooster -lCGIKit -lfcgi
$(FRAMEWORK_NAME)_CURRENT_VERSION_NAME := F
$(FRAMEWORK_NAME)_VERSION := 6.0

include ../../framework.make
