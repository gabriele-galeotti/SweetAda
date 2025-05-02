
#
# CPU sub-Makefile
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
include $(KERNEL_PARENT_PATH)/Makefile.fn.in
include $(KERNEL_PARENT_PATH)/Makefile.ut.in

# shorthands
LIB_DIRECTORY     := $(KERNEL_PARENT_PATH)/$(LIBRARY_DIRECTORY)
OBJ_DIRECTORY     := $(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)
DEP_DIRECTORY     := $(OBJ_DIRECTORY)
ifeq ($(OSTYPE),cmd)
LIB_DIRECTORY_CMD := $(subst /,\,$(LIB_DIRECTORY))
OBJ_DIRECTORY_CMD := $(subst /,\,$(OBJ_DIRECTORY))
DEP_DIRECTORY_CMD := $(OBJ_DIRECTORY_CMD)
endif

LIBRARY_NAME := cpu

OBJECTS :=

ifneq ($(USE_LIBGCC),Y)
LIBGCC_SOURCES := div.S
OBJECTS        += $(LIBGCC_SOURCES:%.S=$(OBJ_DIRECTORY)/%.o)
ifeq ($(RISCV),RV32)
OBJECTS        += $(OBJ_DIRECTORY)/libgcc.o
endif
endif

-include Makefile.if.in

.PHONY: all
all: $(OBJ_DIRECTORY)/lib$(LIBRARY_NAME).a

.PHONY: configure
configure: clean-installed-files
	@$(CREATESYMLINK) $(KERNEL_PARENT_PATH)/$(GNATADC_FILENAME) $(GNATADC_FILENAME)
ifneq ($(MMIO_FUNCTIONS),)
	@$(CREATESYMLINK) -v -c -m Makefile.if.in $(foreach f,$(MMIO_FUNCTIONS),./mmio/$(f) $(f))
endif

.PHONY: clean-installed-files
clean-installed-files:
ifneq ($(filter cmd msys,$(OSTYPE)),)
	$(RMSYMLINK) $(INSTALLED_FILENAMES) -o $(ORIGIN_FILENAMES)
else
	$(RM) $(INSTALLED_FILENAMES)
endif
	$(RM) Makefile.if.in

.PHONY: clean
clean:
	$(RM) $(CLEAN_OBJECTS_COMMON)

.PHONY: distclean
distclean: clean-installed-files clean
	$(RM) $(DISTCLEAN_OBJECTS_COMMON)

include $(KERNEL_PARENT_PATH)/Makefile.lb.in

