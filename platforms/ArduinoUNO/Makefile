
#
# Platform sub-Makefile
#
# Copyright (C) 2020-2023 Gabriele Galeotti
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
# override standard core unit, see configuration.in
# 1) add the unit to the library
OBJECTS += $(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/core.o
# 2) state the dependencies, that could be in turn overriden
$(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/core.o : $(KERNEL_PARENT_PATH)/$(SPEC_BITS)

.PHONY : all
all : $(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/lib$(LIBRARY_NAME).a

.PHONY : installfiles
installfiles :

.PHONY : configure
configure :
	@$(PROCESSCFG) configure.h.in configure.h
	@$(PROCESSCFG) configure.ads.in configure.ads

.PHONY : postbuild
postbuild :

.PHONY : clean
clean :
	$(RM) $(CLEAN_OBJECTS_COMMON) *.vcd

.PHONY : distclean
distclean : clean
	$(RM) configure.h configure.ads

.PHONY : dep
dep :

include $(KERNEL_PARENT_PATH)/Makefile.lb.in

