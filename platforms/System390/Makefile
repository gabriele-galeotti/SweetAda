
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

ifeq ($(OSTYPE),cmd)
KERNEL_PARENT_PATH_CMD := $(shell $(ECHO) $(KERNEL_PARENT_PATH)| $(SED) -e "s|/|\\|g")
endif

LIBRARY_NAME := platform

OBJECTS :=
OBJECTS += $(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/startup.o
OBJECTS += $(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/llkernel.o

.PHONY : all
all : $(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/lib$(LIBRARY_NAME).a

.PHONY : configure
configure :
ifeq ($(OSTYPE),cmd)
	@$(CP) $(KERNEL_PARENT_PATH_CMD)\$(GNATADC_FILENAME) $(GNATADC_FILENAME)
else
	@$(CREATESYMLINK) $(KERNEL_PARENT_PATH)/$(GNATADC_FILENAME) $(GNATADC_FILENAME)
endif
	@$(PROCESSCFG) s390.cnf.in s390.cnf
	@$(PROCESSCFG) hercules.rc.in hercules.rc
	@$(PROCESSCFG) configure.h.in configure.h
	@$(PROCESSCFG) configure.ads.in configure.ads

.PHONY : postbuild
postbuild :
ifeq ($(IPL_MODE),CARD_READER)
	@$(TCLSH) S360obj.tcl -a 0x10000 -p -l loader.rdr $(KERNEL_PARENT_PATH)/$(KERNEL_ROMFILE) $(KERNEL_IPLFILE)
else ifeq ($(IPL_MODE),DASD)
	@$(RM) SYSRES.DSD
ifeq ($(USE_PYTHON),Y)
	@$(PYTHON) S360obj.py -a 0x10000 -p $(KERNEL_PARENT_PATH)/$(KERNEL_ROMFILE) $(KERNEL_IPLFILE)
else
	@$(TCLSH) S360obj.tcl -a 0x10000 -p $(KERNEL_PARENT_PATH)/$(KERNEL_ROMFILE) $(KERNEL_IPLFILE)
endif
	@$(HERCULES_PREFIX)/bin/dasdload -0 dasd_ctlfile.txt SYSRES.DSD 5
endif

.PHONY : clean
clean :
	$(RM) $(CLEAN_OBJECTS_COMMON) $(KERNEL_RDR)

.PHONY : distclean
distclean : clean
	$(RM) $(DISTCLEAN_OBJECTS_COMMON) configure.h configure.ads
	$(RM) s390.cnf hercules.rc $(KERNEL_IPLFILE) SYSRES.DSD

include $(KERNEL_PARENT_PATH)/Makefile.lb.in

