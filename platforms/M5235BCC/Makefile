
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

.PHONY : all
all : $(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/lib$(LIBRARY_NAME).a

.PHONY : installfiles
installfiles :
	@$(call echo-print,"Installing files for subplatform $(SUBPLATFORM):")
	@"$(CREATESYMLINK)" platform-$(SUBPLATFORM)
	@$(call echo-print,"")

.PHONY : configure
configure : configure-subplatform

.PHONY : postbuild
postbuild :
	@# dBUG S-record download
	$(call brief-command, \
        $(OBJCOPY) -O srec $(SWEETADA_PATH)/$(KERNEL_OUTFILE) $(SWEETADA_PATH)/$(KERNEL_BASENAME).srec \
        ,[OBJCOPY],$(KERNEL_BASENAME).srec)
ifneq ($(OSTYPE),cmd)
	@chmod a-x $(SWEETADA_PATH)/$(KERNEL_BASENAME).srec
endif

.PHONY : clean
clean :
	$(RM) $(CLEAN_OBJECTS_COMMON)

.PHONY : distclean
distclean : clean
	$(RM) configure.h configure.ads $(DISTCLEAN_OBJECTS_EXTRA)

.PHONY : dep
dep :

-include Makefile.in

include $(KERNEL_PARENT_PATH)/Makefile.lb.in

