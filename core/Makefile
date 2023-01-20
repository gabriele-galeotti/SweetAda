
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
ifeq ($(OBJECT_DIRECTORY),)
$(error Error: invalid OBJECT_DIRECTORY)
endif

include $(KERNEL_PARENT_PATH)/Makefile.fn.in
include $(KERNEL_PARENT_PATH)/Makefile.ut.in

ifeq ($(OSTYPE),cmd)
KERNEL_PARENT_PATH_CMD := $(shell $(ECHO) $(KERNEL_PARENT_PATH)| $(SED) -e "s|/|\\|g")
endif

LIBRARY_NAME := core

OBJECTS :=
OBJECTS += $(patsubst %,$(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/%.o,$(IMPLICIT_CORE_UNITS))

.PHONY : all
all : $(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/lib$(LIBRARY_NAME).a

.PHONY : configure
configure :
ifeq ($(OSTYPE),cmd)
	@$(CP) $(KERNEL_PARENT_PATH_CMD)\$(GNATADC_FILENAME) $(GNATADC_FILENAME)
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

