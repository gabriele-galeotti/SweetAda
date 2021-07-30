
#
# C library sub-Makefile
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
INCLUDES := $(foreach d,$(INCLUDE_DIRECTORIES),-I$(KERNEL_PARENT_PATH)/$(d))

.PHONY : all
all : $(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/lib$(LIBRARY_NAME).a

# dependencies of .c

$(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/assert.o  : stdio.h stdlib.h
$(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/ctype.o   : ctype.h
$(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/errno.o   :
$(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/stdio.o   : ada_interface.h clibrary.h ctype.h stdio.h stdlib.h string.h
$(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/stdlib.o  : ada_interface.h clibrary.h ctype.h errno.h stdlib.h string.h
$(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/string.o  : ada_interface.h clibrary.h ctype.h string.h
$(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/strings.o : ada_interface.h clibrary.h strings.h

# manually-inferred dependency logic

$(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/c_wrappers.o :    \
        $(KERNEL_PARENT_PATH)/$(CORE_DIRECTORY)/bits.ads    \
        $(KERNEL_PARENT_PATH)/$(CORE_DIRECTORY)/console.ads

.PHONY : configure
configure :

.PHONY : clean
clean :
	$(RM) $(CLEAN_OBJECTS_COMMON)

.PHONY : distclean
distclean : clean

.PHONY : dep
dep :

include $(KERNEL_PARENT_PATH)/Makefile.lb.in

