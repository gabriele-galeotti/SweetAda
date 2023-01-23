
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

ifeq ($(OSTYPE),cmd)
KERNEL_PARENT_PATH_CMD := $(shell $(ECHO) $(KERNEL_PARENT_PATH)| $(SED) -e "s|/|\\|g")
endif

LIBRARY_NAME := platform

OBJECTS :=
OBJECTS += $(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/startup.o
OBJECTS += $(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/llkernel.o

-include Makefile.in
-include Makefile.if.in

.PHONY : all
all : $(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/lib$(LIBRARY_NAME).a

.PHONY : installfiles
installfiles :
	@$(call echo-print,"Installing files for subplatform $(SUBPLATFORM):")
	@$(CREATESYMLINK) platform-$(SUBPLATFORM) Makefile.if.in
	@$(call echo-print,"installfiles: done")
	@$(call echo-print,"")

.PHONY : configure
configure : configure-subplatform
ifeq ($(OSTYPE),cmd)
	@$(CP) $(KERNEL_PARENT_PATH_CMD)\$(GNATADC_FILENAME) $(GNATADC_FILENAME)
else
	@$(CREATESYMLINK) $(KERNEL_PARENT_PATH)/$(GNATADC_FILENAME) $(GNATADC_FILENAME)
endif

.PHONY : postbuild
postbuild :

.PHONY : clean
clean :
	$(RM) $(CLEAN_OBJECTS_COMMON)

.PHONY : distclean
distclean : clean
	$(RM) $(DISTCLEAN_OBJECTS_COMMON)           \
              configure.h configure.ads             \
              $(INSTALLED_FILENAMES) Makefile.if.in

include $(KERNEL_PARENT_PATH)/Makefile.lb.in

