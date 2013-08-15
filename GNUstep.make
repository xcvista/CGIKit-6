
ifeq ($(GNUSTEP_MAKEFILES),)
	GNUSTEP_MAKEFILES := $(shell gnustep-config --variable=GNUSTEP_MAKEFILES 2>/dev/null)
	ifeq ($(GNUSTEP_MAKEFILES),)
		$(warning )
		$(warning Unable to obtain GNUSTEP_MAKEFILES setting from gnustep-config!)
		$(warning Perhaps gnustep-make is not properly installed,)
		$(warning so gnustep-config is not in your PATH.)
		$(warning )
		$(warning Your PATH is currently $(PATH))
		$(warning )
	endif
endif

ifeq ($(GNUSTEP_MAKEFILES),)
	$(error You need to set GNUSTEP_MAKEFILES before compiling!)
endif

include $(GNUSTEP_MAKEFILES)/common.make

ifeq ($(PROJECT_ROOT),)
PROJECT_ROOT := $(shell git rev-parse --show-toplevel)
endif

ADDITIONAL_CFLAGS += -fblocks
ADDITIONAL_OBJCFLAGS += -fobjc-arc -fblocks -Xclang -fobjc-default-synthesize-properties -Wall
ADDITIONAL_CPPFLAGS += -I$(PROJECT_ROOT)/build
ADDITIONAL_LDFLAGS += -L$(PROJECT_ROOT)/build
CC := clang
CXX := clang++

ifneq ($(CC),clang)
	$(error You need clang 3.2+ to build this library.)
endif
