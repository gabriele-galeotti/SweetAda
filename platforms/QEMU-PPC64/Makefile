
#
# Platform sub-Makefile
#
# Copyright (C) 2020-2025 Gabriele Galeotti
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

include $(KERNEL_PARENT_PATH)/Makefile.os.in
include $(KERNEL_PARENT_PATH)/Makefile.ut.in
include $(KERNEL_PARENT_PATH)/Makefile.fn.in

# shorthands
LIB_DIRECTORY     := $(KERNEL_PARENT_PATH)/$(LIBRARY_DIRECTORY)
OBJ_DIRECTORY     := $(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)
DEP_DIRECTORY     := $(OBJ_DIRECTORY)
ifeq ($(OSTYPE),cmd)
LIB_DIRECTORY_CMD := $(subst /,\,$(LIB_DIRECTORY))
OBJ_DIRECTORY_CMD := $(subst /,\,$(OBJ_DIRECTORY))
DEP_DIRECTORY_CMD := $(OBJ_DIRECTORY_CMD)
endif

LIBRARY_NAME := platform

OBJECTS_XFORM_1 := $(filter %.S %.c,$(LOWLEVEL_FILES_PLATFORM))
OBJECTS_XFORM_2 := $(OBJECTS_XFORM_1:.S=.o)
OBJECTS_XFORM_3 := $(OBJECTS_XFORM_2:.c=.o)
OBJECTS := $(foreach f,$(OBJECTS_XFORM_3),$(OBJ_DIRECTORY)/$(f))

.PHONY: all
all: $(CONFIGURE_FILES_PLATFORM) $(OBJ_DIRECTORY)/lib$(LIBRARY_NAME).a

.PHONY: configure
configure: clean-configure-files $(CONFIGURE_FILES_PLATFORM) $(LD_SCRIPT)
	@$(CREATESYMLINK) $(KERNEL_PARENT_PATH)/$(GNATADC_FILENAME) $(GNATADC_FILENAME)
	@$(CREATELINKERADSB) $(LD_SCRIPT)

ifneq ($(CONFIGURE_FILES_PLATFORM),)
$(CONFIGURE_FILES_PLATFORM): % : %.in
	$(PROCESSCFG) $< $@
endif

ifneq ($(wildcard $(LD_SCRIPT).S),)
$(LD_SCRIPT): $(LD_SCRIPT).S
	$(CPP) -o $@ -C -E -P $<
else
$(LD_SCRIPT):
endif

.PHONY: postbuild
postbuild:
ifneq ($(POSTBUILD_COMMAND),)
	$(POSTBUILD_COMMAND)
endif

.PHONY: clean-configure-files
clean-configure-files:
ifneq ($(CONFIGURE_FILES_PLATFORM),)
	$(RM) $(CONFIGURE_FILES_PLATFORM)
endif
ifneq ($(wildcard $(LD_SCRIPT).S),)
	$(RM) $(LD_SCRIPT)
endif
ifeq ($(OSTYPE),cmd)
	-$(RM) $(KERNEL_PARENT_PATH)\$(CORE_DIRECTORY)\linker.ad*
else
	-$(RM) $(KERNEL_PARENT_PATH)/$(CORE_DIRECTORY)/linker.ad*
endif

.PHONY: clean
clean:
	$(RM) $(CLEAN_OBJECTS_COMMON)

.PHONY: distclean
distclean: clean-configure-files clean
	$(RM) $(DISTCLEAN_OBJECTS_COMMON)

include $(KERNEL_PARENT_PATH)/Makefile.lb.in

