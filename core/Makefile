
#
# Core sub-Makefile
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

LIBRARY_NAME := core

OBJECTS := $(patsubst %,$(OBJ_DIRECTORY)/%.o,$(IMPLICIT_CORE_UNITS))

.PHONY: all
all: $(OBJ_DIRECTORY)/lib$(LIBRARY_NAME).a

.PHONY: configure
configure:
	@$(CREATESYMLINK) $(KERNEL_PARENT_PATH)/$(GNATADC_FILENAME) $(GNATADC_FILENAME)
	@$(GCCDEFINES)                        \
          GCC.Defines gcc-defines.ads         \
          __VERSION__:VERSION:String:S        \
          __ELF__:ELF:Boolean:H               \
          __ATOMIC_RELAXED:ATOMIC_RELAXED::N  \
          __ATOMIC_CONSUME:ATOMIC_CONSUME::N  \
          __ATOMIC_ACQUIRE:ATOMIC_ACQUIRE::N  \
          __ATOMIC_RELEASE:ATOMIC_RELEASE::N  \
          __ATOMIC_ACQ_REL:ATOMIC_ACQ_REL::N  \
          __ATOMIC_SEQ_CST:ATOMIC_SEQ_CST::N  \
          __aarch64__:AARCH64:Boolean:H       \
          __arm__:ARM:Boolean:H               \
          __AVR__:AVR:Boolean:H               \
          __m68k__:M68k:Boolean:H             \
          __mips__:MIPS:Boolean:H             \
          __microblaze__:MICROBLAZE:Boolean:H \
          __nios2__:NIOS2:Boolean:H           \
          __or1k__:OR1k:Boolean:H             \
          __PPC__:PPC:Boolean:H               \
          __riscv:RISCV:Boolean:H             \
          __s390__:S390:Boolean:H             \
          __sh__:SH:Boolean:H                 \
          __sparc__:SPARC:Boolean:H           \
          __i386__:x86:Boolean:H              \
          __x86_64__:x86_64:Boolean:H         \
          $(GCCDEFINES_CPU)

.PHONY: clean
clean:
	$(RM) $(CLEAN_OBJECTS_COMMON)

.PHONY: distclean
distclean: clean
	$(RM) $(DISTCLEAN_OBJECTS_COMMON) \
              gcc_defines.ads

include $(KERNEL_PARENT_PATH)/Makefile.lb.in

