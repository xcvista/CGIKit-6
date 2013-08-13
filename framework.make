
include $(GNUSTEP_MAKEFILES)/framework.make

after-all::
	cp -r $(FRAMEWORK_NAME).framework $(PROJECT_ROOT)/build
	ln -s $(FRAMEWORK_NAME).framework/Headers $(PROJECT_ROOT)/build/$(FRAMEWORK_NAME)
