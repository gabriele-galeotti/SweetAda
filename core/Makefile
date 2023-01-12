
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

LIBRARY_NAME := core

OBJECTS :=
OBJECTS += $(patsubst %,$(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/%.o,$(IMPLICIT_CORE_UNITS))

.PHONY : all
all : $(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/lib$(LIBRARY_NAME).a

# manually-inferred dependency logic

$(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/abort_library.o : \
        $(KERNEL_PARENT_PATH)/$(SPEC_CONSOLE)

$(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/console.o : \
        $(KERNEL_PARENT_PATH)/$(SPEC_BITS)            \
        $(KERNEL_PARENT_PATH)/$(SPEC_LLUTILS)

$(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/core.o : \
        $(KERNEL_PARENT_PATH)/$(SPEC_BITS)         \
        $(KERNEL_PARENT_PATH)/$(SPEC_CONSOLE)

$(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/gnat_exceptions.o : \
        $(KERNEL_PARENT_PATH)/$(SPEC_ABORT_LIBRARY)

$(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/last_chance_handler.o : \
        $(KERNEL_PARENT_PATH)/$(SPEC_ABORT_LIBRARY)

$(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/malloc.o :   \
        $(KERNEL_PARENT_PATH)/$(SPEC_BITS)             \
        $(KERNEL_PARENT_PATH)/$(SPEC_CONSOLE)          \
        $(KERNEL_PARENT_PATH)/$(SPEC_INTEGER_MATH)     \
        $(KERNEL_PARENT_PATH)/$(SPEC_MEMORY_FUNCTIONS)

$(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/memory_functions.o : \
        $(KERNEL_PARENT_PATH)/$(SPEC_BITS)

.PHONY : configure
configure :
	@$(CREATESYMLINK) $(KERNEL_PARENT_PATH)/$(GNATADC_FILENAME) $(GNATADC_FILENAME)

.PHONY : clean
clean :
	$(RM) $(CLEAN_OBJECTS_COMMON)

.PHONY : distclean
distclean : clean

.PHONY : dep
dep :

include $(KERNEL_PARENT_PATH)/Makefile.lb.in

