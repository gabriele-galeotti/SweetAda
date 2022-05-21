
#
# Platform sub-Makefile
#
# Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

ifeq ($(KERNEL_PARENT_PATH),)
$(error Error: invalid KERNEL_PARENT_PATH)
endif
ifeq ($(OBJECT_DIRECTORY),)
$(error Error: invalid OBJECT_DIRECTORY)
endif

include $(KERNEL_PARENT_PATH)/Makefile.fn.in
include $(KERNEL_PARENT_PATH)/Makefile.ut.in

LIBRARY_NAME := platform

OBJECTS :=
OBJECTS += $(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/startup.o
OBJECTS += $(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/llkernel.o

INCLUDES := $(foreach d,$(INCLUDE_DIRECTORIES),-I$(KERNEL_PARENT_PATH)/$(d))

-include Makefile.in

.PHONY : all
all : $(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/lib$(LIBRARY_NAME).a

# startup.S processing
ifeq ($(MODE32),Y)
$(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/startup.o : mode32.S
endif
ifeq ($(USE_STARTUP_MEMORY),Y)
$(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/startup.o : startup-memory.S
endif
$(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/startup.o : startup.S
	$(call brief-command, \
        $(CC) -o $@ -c $(INCLUDES) $(STARTUP_DEFINES) $< \
        ,[CC/AS],$<)
ifeq ($(MODE32),Y)
	@$(OBJDUMP) -M i8086 -d -j .init16 $@ > init16.lst
endif

.PHONY : installfiles
installfiles :
	@$(call echo-print,"Installing files for subplatform $(SUBPLATFORM):")
	@$(CREATESYMLINK) platform-$(SUBPLATFORM)
	@$(call echo-print,"")

.PHONY : configure
configure : configure-subplatform

.PHONY : postbuild
postbuild : postbuild-subplatform

.PHONY : clean
clean :
	$(RM) $(CLEAN_OBJECTS_COMMON) $(CLEAN_OBJECTS_EXTRA)

.PHONY : distclean
distclean : clean
	$(RM) configure.h configure.ads $(DISTCLEAN_OBJECTS_EXTRA)

.PHONY : dep
dep :

include $(KERNEL_PARENT_PATH)/Makefile.lb.in

