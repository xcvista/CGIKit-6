
include GNUstep.make

SUBPROJECTS := MSBooster CGIKit CGIJSONObject Demo

include $(GNUSTEP_MAKEFILES)/aggregate.make

before-all:: $(PROJECT_ROOT)/build

$(PROJECT_ROOT)/build::
	mkdir -p $(PROJECT_ROOT)/build

before-clean::
	-rm -r $(PROJECT_ROOT)/build
