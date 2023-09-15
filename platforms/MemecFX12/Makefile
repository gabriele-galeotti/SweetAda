
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
ifeq ($(LIBRARY_DIRECTORY),)
$(error Error: invalid LIBRARY_DIRECTORY)
endif
ifeq ($(OBJECT_DIRECTORY),)
$(error Error: invalid OBJECT_DIRECTORY)
endif

include $(KERNEL_PARENT_PATH)/Makefile.fn.in
include $(KERNEL_PARENT_PATH)/Makefile.ut.in

# shorthands
LIB_DIRECTORY           := $(KERNEL_PARENT_PATH)/$(LIBRARY_DIRECTORY)
OBJ_DIRECTORY           := $(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)
DEP_DIRECTORY           := $(OBJ_DIRECTORY)
GNATADC_FILENAME_TARGET := $(KERNEL_PARENT_PATH)/$(GNATADC_FILENAME)
ifeq ($(OSTYPE),cmd)
KERNEL_PARENT_PATH_CMD  := $(shell $(ECHO) $(KERNEL_PARENT_PATH)| $(SED) -e "s|/|\\|g")
LIB_DIRECTORY_CMD       := $(shell $(ECHO) $(LIB_DIRECTORY)| $(SED) -e "s|/|\\|g")
OBJ_DIRECTORY_CMD       := $(shell $(ECHO) $(OBJ_DIRECTORY)| $(SED) -e "s|/|\\|g")
DEP_DIRECTORY_CMD       := $(OBJ_DIRECTORY_CMD)
GNATADC_FILENAME_TARGET := $(shell $(ECHO) $(GNATADC_FILENAME_TARGET)| $(SED) -e "s|/|\\|g")
endif

LIBRARY_NAME := platform

OBJECTS :=
OBJECTS += $(OBJ_DIRECTORY)/startup.o
OBJECTS += $(OBJ_DIRECTORY)/llkernel.o

.PHONY : all
all : $(OBJ_DIRECTORY)/lib$(LIBRARY_NAME).a

.PHONY : configure
configure :
	@$(CREATESYMLINK) $(GNATADC_FILENAME_TARGET) $(GNATADC_FILENAME)
	@$(PROCESSCFG) configure.h.in configure.h
	@$(PROCESSCFG) configure.ads.in configure.ads

.PHONY : postbuild
postbuild :
	$(REM) bitstream file must have .elf extension
	$(CP) $(KERNEL_PARENT_PATH)/$(KERNEL_OUTFILE) $(KERNEL_PARENT_PATH)/$(KERNEL_BASENAME).elf

.PHONY : clean
clean :
	$(RM) $(CLEAN_OBJECTS_COMMON)

.PHONY : distclean
distclean : clean
	$(RM) $(DISTCLEAN_OBJECTS_COMMON) configure.h configure.ads impact.cmd xmd.ini download.bit*

include $(KERNEL_PARENT_PATH)/Makefile.lb.in

