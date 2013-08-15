
include $(GNUSTEP_MAKEFILES)/framework.make

after-all::
	-cp module.map $(FRAMEWORK_NAME).framework
	-cp module.map $(FRAMEWORK_NAME).framework/Headers
	cp -r $(FRAMEWORK_NAME).framework $(PROJECT_ROOT)/build
	ln -sf $(FRAMEWORK_NAME).framework/Headers $(PROJECT_ROOT)/build/$(FRAMEWORK_NAME)
	ln -sf $(FRAMEWORK_NAME).framework/lib$(FRAMEWORK_NAME).so $(PROJECT_ROOT)/build/lib$(FRAMEWORK_NAME).so
