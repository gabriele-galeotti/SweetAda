
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
OBJECTS += $(patsubst %,$(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/%.o,$(EXTERNAL_OBJECTS))

.PHONY : all
all : $(KERNEL_PARENT_PATH)/$(OBJECT_DIRECTORY)/lib$(LIBRARY_NAME).a

.PHONY : configure
configure :
ifeq ($(OSTYPE),cmd)
	@$(CP) $(KERNEL_PARENT_PATH_CMD)\$(GNATADC_FILENAME) $(GNATADC_FILENAME)
else
	@$(CREATESYMLINK) $(KERNEL_PARENT_PATH)/$(GNATADC_FILENAME) $(GNATADC_FILENAME)
endif
	@$(PROCESSCFG) configure.h.in configure.h
	@$(PROCESSCFG) configure.ads.in configure.ads

.PHONY : postbuild
postbuild :
ifeq ($(BOOTTYPE),CDROM)
ifeq ($(USE_PYTHON),Y)
	"$(PYTHON)" makecdrom.py IP_TMPL IP_TXT "$(SWEETADA_PATH)"/kernel.rom
else
	"$(TCLSH)" makecdrom.tcl IP_TMPL IP_TXT "$(SWEETADA_PATH)"/kernel.rom
endif
ifneq ($(OSTYPE),cmd)
	@$(REM)mkisofs -r 1ST_READ.BIN | (cat IP.BIN ; dd bs=2048 skip=16) > sweetada.iso
	mkisofs -G IP.BIN -J -V SweetAda -l -r -o sweetada.iso 1ST_READ.BIN
	@$(REM) transform .iso into a .cdi
	@$(REM)mkisofs -C 0,11702 -G IP.BIN -J -V SweetAda -l -r -o sweetada.iso 1ST_READ.BIN
	@$(REM)cdi4dc sweetada.iso sweetada.cdi
else
	@$(call echo-print,"Please build a CD image with an mkisofs-style application.")
endif
endif

.PHONY : clean
clean :
	$(RM) $(CLEAN_OBJECTS_COMMON) gxemullog.txt IP.BIN 1ST_READ.BIN sweetada.iso

.PHONY : distclean
distclean : clean
	$(RM) $(DISTCLEAN_OBJECTS_COMMON) configure.h configure.ads

include $(KERNEL_PARENT_PATH)/Makefile.lb.in

