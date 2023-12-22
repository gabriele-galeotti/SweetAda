
#
# Platform sub-Makefile
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
all: $(OBJ_DIRECTORY)/lib$(LIBRARY_NAME).a

.PHONY: configure
configure:
	@$(CREATESYMLINK) $(KERNEL_PARENT_PATH)/$(GNATADC_FILENAME) $(GNATADC_FILENAME)
ifeq ($(OSTYPE),cmd)
	@FOR %%F IN ($(CONFIGURE_FILES_PLATFORM)) DO \
          @ECHO OFF &&                               \
          IF EXIST %%F.in (                          \
            $(PROCESSCFG) %%F.in %%F || EXIT /B 1    \
          ) ELSE (                                   \
            EXIT /B 1                                \
          )
else
	@for f in $(CONFIGURE_FILES_PLATFORM) ; do \
          if [ -e $$f.in ] ; then                  \
            $(PROCESSCFG) $$f.in $$f || exit $$? ; \
          else                                     \
            exit 1 ;                               \
          fi ;                                     \
        done
endif

.PHONY: postbuild
postbuild:
	$(call brief-command, \
        $(OBJCOPY)                                               \
                   -j .romstartup -j .text -j .data              \
                   -O srec                                       \
                   $(KERNEL_PARENT_PATH)/$(KERNEL_OUTFILE)       \
                   $(KERNEL_PARENT_PATH)/$(KERNEL_BASENAME).srec \
        ,[OBJCOPY],$(KERNEL_BASENAME).srec)
ifneq ($(OSTYPE),cmd)
	@chmod a-x $(KERNEL_PARENT_PATH)/$(KERNEL_BASENAME).srec
endif

.PHONY: clean
clean:
	$(RM) $(CLEAN_OBJECTS_COMMON) config.txt

.PHONY: distclean
distclean: clean
	$(RM) $(DISTCLEAN_OBJECTS_COMMON) \
              $(CONFIGURE_FILES_PLATFORM)

include $(KERNEL_PARENT_PATH)/Makefile.lb.in

