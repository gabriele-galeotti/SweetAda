
#
# CPU sub-Makefile
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

LIBRARY_NAME := cpu

OBJECTS :=
# force inclusion of not-explicit-referenced subprograms
#OBJECTS += $(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/arm.o
OBJECTS += $(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/unwind.o

ifneq ($(USE_LIBGCC),Y)
LIB1ASMSRC       := lib1funcs.S
LIBGCC_FUNCTIONS := divsi3 dvmd_tls udivsi3 muldi3
LIBGCC_SOURCES   := $(foreach f,$(LIBGCC_FUNCTIONS),L_$(f).S)
OBJECTS          += $(foreach f,$(LIBGCC_FUNCTIONS),$(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/L_$(f).o)
$(LIBGCC_SOURCES) : %.S : $(LIB1ASMSRC)
	$(call brief-command, \
        $(CPP) -o $@ -x assembler-with-cpp -P -CC -D$* $(LIB1ASMSRC) \
        ,[CPP],$@)
endif

.PHONY : all
all : $(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/lib$(LIBRARY_NAME).a

.PHONY : configure
configure : $(LIBGCC_SOURCES)
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
ifneq ($(USE_LIBGCC),Y)
	$(RM) $(LIBGCC_SOURCES)
endif

include $(KERNEL_PARENT_PATH)/Makefile.lb.in

