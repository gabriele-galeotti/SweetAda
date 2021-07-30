
#
# Platform sub-Makefile
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

LIBRARY_NAME := platform

OBJECTS :=
OBJECTS += $(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/startup.o
OBJECTS += $(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/llkernel.o

INCLUDES := $(foreach d,$(INCLUDE_DIRECTORIES),-I$(KERNEL_PARENT_PATH)/$(d))

.PHONY : all
all : $(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/lib$(LIBRARY_NAME).a

.PHONY : configure
configure :
	@"$(PROCESSCFG)" s390.cnf.in s390.cnf
	@"$(PROCESSCFG)" hercules.rc.in hercules.rc
	@"$(PROCESSCFG)" configure.h.in configure.h
	@"$(PROCESSCFG)" configure.ads.in configure.ads

.PHONY : postbuild
postbuild :
ifeq ($(IPL_MODE),CARD_READER)
	@"$(TCLSH)" S360obj.tcl -a 0x800 -l loader.rdr $(KERNEL_PARENT_PATH)/$(KERNEL_ROMFILE) $(KERNEL_IPLFILE)
else ifeq ($(IPL_MODE),DASD)
	@$(RM) SYSRES.DSD
	@"$(TCLSH)" S360obj.tcl -a 0x800 $(KERNEL_PARENT_PATH)/$(KERNEL_ROMFILE) $(KERNEL_IPLFILE)
	@$(call echo-print,"SYSRES 3390-1 * $(KERNEL_IPLFILE)")> dasd_ctlfile.txt
	@"$(HERCULES_PREFIX)"/bin/dasdload -0 dasd_ctlfile.txt SYSRES.DSD 5
endif

.PHONY : clean
clean :
	$(RM) $(CLEAN_OBJECTS_COMMON) $(KERNEL_RDR)

.PHONY : distclean
distclean : clean
	$(RM) s390.cnf hercules.rc configure.h configure.ads $(KERNEL_IPLFILE) dasd_ctlfile.txt SYSRES.DSD

.PHONY : dep
dep :

include $(KERNEL_PARENT_PATH)/Makefile.lb.in

