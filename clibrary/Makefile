
#
# C library sub-Makefile
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

LIBRARY_NAME := clibrary

OBJECTS :=
OBJECTS += $(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/assert.o
OBJECTS += $(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/ctype.o
OBJECTS += $(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/errno.o
OBJECTS += $(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/stdio.o
OBJECTS += $(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/stdlib.o
OBJECTS += $(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/string.o
OBJECTS += $(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/strings.o
OBJECTS += $(patsubst %,$(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/%.o,$(IMPLICIT_CLIBRARY_UNITS))

.PHONY : all
all : $(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/lib$(LIBRARY_NAME).a

ifeq ($(BUILD_MODE),MAKEFILE)

# manually-inferred dependency logic

$(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/assert.o : \
        stdio.h  \
        stdlib.h

$(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/ctype.o : \
        ctype.h

$(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/errno.o :

$(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/stdio.o : \
        ada_interface.h \
        clibrary.h      \
        ctype.h         \
        stdio.h         \
        stdlib.h        \
        string.h

$(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/stdlib.o : \
        ada_interface.h \
        clibrary.h      \
        ctype.h         \
        errno.h         \
        stdlib.h        \
        string.h

$(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/string.o : \
        clibrary.h \
        ctype.h    \
        string.h

$(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/strings.o : \
        clibrary.h \
        strings.h

$(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/c_wrappers.o : \
        $(KERNEL_PARENT_PATH)/$(SPEC_ABORT_LIBRARY) \
        $(KERNEL_PARENT_PATH)/$(SPEC_BITS)          \
        $(KERNEL_PARENT_PATH)/$(SPEC_CONSOLE)       \
        $(KERNEL_PARENT_PATH)/$(SPEC_MALLOC)

endif

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

$(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/%.o : %.c
	$(call brief-command, \
        $(CC) -o $@ -c $(INCLUDES) $< \
        ,[CC],$<)

include $(KERNEL_PARENT_PATH)/Makefile.lb.in

