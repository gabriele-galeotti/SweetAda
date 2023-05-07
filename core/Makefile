
#
# Core sub-Makefile
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
LIB_DIRECTORY := $(KERNEL_PARENT_PATH)/$(LIBRARY_DIRECTORY)
OBJ_DIRECTORY := $(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)
DEP_DIRECTORY := $(OBJ_DIRECTORY)
ifeq ($(OSTYPE),cmd)
KERNEL_PARENT_PATH_CMD := $(shell $(ECHO) $(KERNEL_PARENT_PATH)| $(SED) -e "s|/|\\|g")
LIB_DIRECTORY_CMD      := $(shell $(ECHO) $(LIB_DIRECTORY)| $(SED) -e "s|/|\\|g")
OBJ_DIRECTORY_CMD      := $(shell $(ECHO) $(OBJ_DIRECTORY)| $(SED) -e "s|/|\\|g")
DEP_DIRECTORY_CMD      := $(OBJ_DIRECTORY_CMD)
endif

LIBRARY_NAME := core

OBJECTS := $(patsubst %,$(OBJ_DIRECTORY)/%.o,$(IMPLICIT_CORE_UNITS))

.PHONY : all
all : $(OBJ_DIRECTORY)/lib$(LIBRARY_NAME).a

.PHONY : configure
configure :
ifeq      ($(OSTYPE),cmd)
	@$(RM) $(GNATADC_FILENAME)
	@$(CP) $(KERNEL_PARENT_PATH_CMD)\$(GNATADC_FILENAME) $(GNATADC_FILENAME)
else ifeq ($(OSTYPE),msys)
	@$(RM) $(GNATADC_FILENAME)
	@$(CP) $(KERNEL_PARENT_PATH)/$(GNATADC_FILENAME) $(GNATADC_FILENAME)
else
	@$(CREATESYMLINK) $(KERNEL_PARENT_PATH)/$(GNATADC_FILENAME) $(GNATADC_FILENAME)
endif

.PHONY : clean
clean :
	$(RM) $(CLEAN_OBJECTS_COMMON)

.PHONY : distclean
distclean : clean
	$(RM) $(DISTCLEAN_OBJECTS_COMMON)

include $(KERNEL_PARENT_PATH)/Makefile.lb.in

