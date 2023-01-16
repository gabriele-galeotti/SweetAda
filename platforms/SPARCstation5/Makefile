
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
ifeq ($(OBJECT_DIRECTORY),)
$(error Error: invalid OBJECT_DIRECTORY)
endif

include $(KERNEL_PARENT_PATH)/Makefile.fn.in
include $(KERNEL_PARENT_PATH)/Makefile.ut.in

LIBRARY_NAME := platform

OBJECTS := $(foreach f,$(STARTUP_OBJECTS:.S=.o),$(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/$(f))

.PHONY : all
all : $(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/lib$(LIBRARY_NAME).a

.PHONY : configure
configure :
	@$(CREATESYMLINK) $(KERNEL_PARENT_PATH)/$(GNATADC_FILENAME) $(GNATADC_FILENAME)
	@$(PROCESSCFG) configure.h.in configure.h
	@$(PROCESSCFG) configure.ads.in configure.ads

.PHONY : postbuild
postbuild :
ifeq ($(BOOT_FROM_NETWORK),True)
	$(REM) create an AMAGIC (OMAGIC) SPARC a.out executable
	$(ELFTOAOUT) -o $(KERNEL_PARENT_PATH)/kernel.aout $(KERNEL_PARENT_PATH)/kernel.o
ifneq ($(OSTYPE),cmd)
	@chmod a-x $(KERNEL_PARENT_PATH)/kernel.aout
endif
	$(CP) $(KERNEL_PARENT_PATH)/kernel.aout $(TFTP_DIRECTORY)/$(TFTP_FILENAME)
else
	$(FILEPAD) $(KERNEL_PARENT_PATH)/$(KERNEL_ROMFILE) 256K
endif
	$(REM) S-record download
	$(call brief-command, \
        $(OBJCOPY) -O srec $(SWEETADA_PATH)/$(KERNEL_OUTFILE) $(SWEETADA_PATH)/$(KERNEL_BASENAME).srec \
        ,[OBJCOPY],$(KERNEL_BASENAME).srec)
ifneq ($(OSTYPE),cmd)
	@chmod a-x $(SWEETADA_PATH)/$(KERNEL_BASENAME).srec
endif

.PHONY : clean
clean :
	$(RM) $(CLEAN_OBJECTS_COMMON)

.PHONY : distclean
distclean : clean
	$(RM) linker.lds configure.h configure.ads

.PHONY : dep
dep :

include $(KERNEL_PARENT_PATH)/Makefile.lb.in

