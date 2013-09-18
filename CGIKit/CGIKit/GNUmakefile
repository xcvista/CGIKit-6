
include ../../GNUstep.make

FRAMEWORK_NAME := CGIKit

$(FRAMEWORK_NAME)_NEEDS_GUI := no
$(FRAMEWORK_NAME)_HEADER_FILES := $(wildcard *.h)
$(FRAMEWORK_NAME)_OBJC_FILES := $(wildcard *.m)
$(FRAMEWORK_NAME)_RESOURCE_FILES := error.html
$(FRAMEWORK_NAME)_LDFLAGS := -lMSBooster -lfcgi
$(FRAMEWORK_NAME)_CURRENT_VERSION_NAME := F
$(FRAMEWORK_NAME)_VERSION := 6.0

include ../../framework.make
