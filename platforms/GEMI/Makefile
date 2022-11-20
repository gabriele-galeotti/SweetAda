
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

# overriding standard last_chance_handler unit requires a little bit of care,
# see configuration.in
# 1) add the unit to the library
OBJECTS += $(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/last_chance_handler.o
# 2) state the dependencies in terms of standard core units, that could be in
# turn overriden
# NOTE: in this case the prerequisite is empty because there is no dependency
# on $(KERNEL_PARENT_PATH)/$(SPEC_ABORT_LIBRARY), so it is just a placeholder
$(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/last_chance_handler.o :
# 3) states all other explicit dependencies
$(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/last_chance_handler.o : $(KERNEL_PARENT_PATH)/$(CPU_DIRECTORY)/sh.ads \
                                                                  $(KERNEL_PARENT_PATH)/$(CPU_DIRECTORY)/sh.adb \
                                                                  gemi.ads

INCLUDES := $(foreach d,$(INCLUDE_DIRECTORIES),-I$(KERNEL_PARENT_PATH)/$(d))

.PHONY : all
all : $(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/lib$(LIBRARY_NAME).a

.PHONY : configure
configure :
	@$(PROCESSCFG) configure.h.in configure.h
	@$(PROCESSCFG) configure.ads.in configure.ads

.PHONY : postbuild
postbuild :

.PHONY : clean
clean :
	$(RM) $(CLEAN_OBJECTS_COMMON)

.PHONY : distclean
distclean : clean
	$(RM) configure.h configure.ads

.PHONY : dep
dep :

include $(KERNEL_PARENT_PATH)/Makefile.lb.in

