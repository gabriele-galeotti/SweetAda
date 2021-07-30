
#
# CPU sub-Makefile
#
# Copyright (C) 2020, 2021 Gabriele Galeotti
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

LIBRARY_NAME := cpu

OBJECTS :=

ifneq ($(USE_LIBGCC),Y)
LIB1ASMSRC       := lb1spc.S
LIBGCC_FUNCTIONS := mulsi3 divsi3 modsi3
LIBGCC_SOURCES   := $(foreach f,$(LIBGCC_FUNCTIONS),L_$(f).S)
OBJECTS          += $(foreach f,$(LIBGCC_FUNCTIONS),$(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/L_$(f).o)
$(LIBGCC_SOURCES) : %.S : $(LIB1ASMSRC)
	$(call brief-command, \
        $(CPP) -o $@ -x assembler-with-cpp -P -CC -D$* $(LIB1ASMSRC) \
        ,[CPP],$@)
endif

INCLUDES := $(foreach d,$(INCLUDE_DIRECTORIES),-I$(KERNEL_PARENT_PATH)/$(d))

.PHONY : all
all : $(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/lib$(LIBRARY_NAME).a

.PHONY : configure
configure :

.PHONY : clean
clean :
	$(RM) $(CLEAN_OBJECTS_COMMON)

.PHONY : distclean
distclean : clean
ifneq ($(USE_LIBGCC),Y)
	$(RM) $(LIBGCC_SOURCES)
endif

.PHONY : dep
dep :

include $(KERNEL_PARENT_PATH)/Makefile.lb.in

