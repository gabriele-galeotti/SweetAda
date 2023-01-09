
#
# Ada GNAT RTS Makefile
#
# Copyright (C) 2020-2023 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# make arguments
#
# Environment variables:
# NULL
# OSTYPE
# CAT
# CP
# ECHO
# MKDIR
# RM
# RMDIR
# SED
# CPU
# CPUS
# TOOLCHAIN_NAME
# TOOLCHAIN_ADAC
# TOOLCHAIN_CC
# TOOLCHAIN_AR
# TOOLCHAIN_RANLIB
# RTS
# RTSES
# RTS_PATH
# MULTILIB
# MLL
# DISABLE_STACK_USAGE
#

################################################################################
#                                                                              #
# Parameter checks.                                                            #
#                                                                              #
################################################################################

ifeq ($(findstring $(RTS),$(RTSES)),)
$(error Error: no valid RTS)
endif
ifeq ($(findstring $(CPU),$(CPUS)),)
$(error Error: no valid CPU)
endif
ifeq ($(TOOLCHAIN_NAME),)
$(error Error: no valid TOOLCHAIN_NAME)
endif
ifeq ($(MULTILIB),)
$(error Error: no valid MULTILIB)
endif

################################################################################
#                                                                              #
# Initialize basic variables and paths.                                        #
#                                                                              #
################################################################################

TARGET := $(CPU)

ifeq ($(OSTYPE),cmd)
MULTILIB_DIRECTORY := $(shell $(ECHO) $(MULTILIB)| $(SED) -e "s|;.*$$||")
MULTILIB_SWITCHES  := $(shell $(ECHO) $(MULTILIB)| $(SED) -e "s|^[^;]*;||" -e "s|@| -|g" -e "s|^ ||")
else
MULTILIB_DIRECTORY := $(shell $(ECHO) "$(MULTILIB)" | $(SED) -e "s|;.*$$||")
MULTILIB_SWITCHES  := $(shell $(ECHO) "$(MULTILIB)" | $(SED) -e "s|^[^;]*;||" -e "s|@| -|g" -e "s|^ ||")
endif

# assemble RTS paths
RTS_SOURCE_PATH            := ./src/$(RTS)
RTS_SOURCE_PATH_TARGET     := ./src/targets/$(TARGET)
ADAINCLUDE_PATH            := ./$(RTS)/$(TOOLCHAIN_NAME)/$(MULTILIB_DIRECTORY)/adainclude
ADALIB_PATH                := ./$(RTS)/$(TOOLCHAIN_NAME)/$(MULTILIB_DIRECTORY)/adalib
ifeq ($(OSTYPE),cmd)
RTS_SOURCE_PATH_CMD        := $(shell $(ECHO) $(RTS_SOURCE_PATH)| $(SED) -e "s|/|\\|g" -e "s|\.\\||g")
RTS_SOURCE_PATH_TARGET_CMD := $(shell $(ECHO) $(RTS_SOURCE_PATH_TARGET)| $(SED) -e "s|/|\\|g" -e "s|\.\\||g")
ADAINCLUDE_PATH_CMD        := $(shell $(ECHO) $(ADAINCLUDE_PATH)| $(SED) -e "s|/|\\|g" -e "s|\.\\||g")
ADALIB_PATH_CMD            := $(shell $(ECHO) $(ADALIB_PATH)| $(SED) -e "s|/|\\|g" -e "s|\.\\||g")
endif
ifeq ($(OSTYPE),msys)
ADAINCLUDE_PATH_CMD        := $(shell $(ECHO) $(ADAINCLUDE_PATH)| $(SED) -e "s|/|\\\\|g" -e "s|\\.\\\\||g")
endif

ADAC   := $(TOOLCHAIN_ADAC)
CC     := $(TOOLCHAIN_CC)
AR     := $(TOOLCHAIN_AR)
RANLIB := $(TOOLCHAIN_RANLIB)

ADAC_SWITCHES :=
ADAC_SWITCHES += --RTS="$(SWEETADA_PATH)"/rts/$(RTS)/$(TOOLCHAIN_NAME)/$(MULTILIB_DIRECTORY)
ADAC_SWITCHES += $(MULTILIB_SWITCHES)
# we are building a static library, so no PIC
#ADAC_SWITCHES += -fPIC
ADAC_SWITCHES += -nostdinc
ADAC_SWITCHES += -gnatwa
#ADAC_SWITCHES += -gnata       # Assertions enabled.
# -gnatg implies -gnatwae and -gnatyg
ADAC_SWITCHES += -gnatg       # Internal GNAT implementation mode.
#ADAC_SWITCHES += -gnatn       # Activate inlining for subprograms for which pragma inline is specified.
ADAC_SWITCHES += -gnatp       # Suppress all checks.
# turn off some style checks (which are turned on by -gnatg)
#ADAC_SWITCHES += -gnatyC      # Check comments, single space.
#ADAC_SWITCHES += -gnaty$(MLL) # Set maximum line length.
ADAC_SWITCHES += -gnatyN      # Turn off all style checks.
ADAC_SWITCHES += -Wextra
ADAC_SWITCHES += -Wall

CC_SWITCHES :=
CC_SWITCHES += $(MULTILIB_SWITCHES)
CC_SWITCHES += -ffreestanding
CC_SWITCHES += -Wall

################################################################################
#                                                                              #
# Specific setup.                                                              #
#                                                                              #
################################################################################

LIBGNAT_SRCS  :=
LIBGNARL_SRCS :=

# RTS target-independent part
include $(RTS_SOURCE_PATH)/Makefile.in
# RTS target-dependent part
-include $(RTS_SOURCE_PATH_TARGET)/Makefile.in

LIBGNAT       := $(ADALIB_PATH)/libgnat.a
LIBGNAT_ADS   := $(filter-out %.adb,$(LIBGNAT_SRCS))
LIBGNAT_OBJS  := $(addprefix $(ADALIB_PATH)/,$(LIBGNAT_ADS:.ads=.o))
LIBGNAT_ALIS  := $(addprefix $(ADALIB_PATH)/,$(LIBGNAT_ADS:.ads=.ali))

LIBGNARL      := $(ADALIB_PATH)/libgnarl.a
LIBGNARL_ADS  := $(filter-out %.adb,$(LIBGNARL_SRCS))
LIBGNARL_OBJS := $(addprefix $(ADALIB_PATH)/,$(LIBGNARL_ADS:.ads=.o))
LIBGNARL_ALIS := $(addprefix $(ADALIB_PATH)/,$(LIBGNARL_ADS:.ads=.ali))

# this include file defines additional target-dependent switches
-include $(RTS_SOURCE_PATH_TARGET)/Makefile.rts.in
ADAC_SWITCHES += $(ADAC_SWITCHES_RTS)
CC_SWITCHES   += $(CC_SWITCHES_RTS)

# process per-target compiler switches
ifneq ($(DISABLE_STACK_USAGE),Y)
ADAC_SWITCHES += -fstack-usage
endif

################################################################################
#                                                                              #
# Build targets.                                                               #
#                                                                              #
################################################################################

.PHONY : all
ifneq ($(findstring "$(MULTILIB_DIRECTORY)",$(MULTILIB_DIRECTORIES_SKIP)),)
all :
	$(info *** Skipping target "all" for multilib directory "$(MULTILIB_DIRECTORY)".)
else
all : configure-rts configure-rts-target multilib
endif

.PHONY : configure
ifneq ($(findstring "$(MULTILIB_DIRECTORY)",$(MULTILIB_DIRECTORIES_SKIP)),)
configure :
	$(info *** Skipping target "configure" for multilib directory "$(MULTILIB_DIRECTORY)".)
else
configure : createdirectories configure-rts configure-rts-target
endif

# configure-rts is in src/$(RTS)/Makefile.in
.PHONY : configure-rts
configure-rts :

# configure-rts-target is in src/targets/$(TARGET)/Makefile.in
.PHONY : configure-rts-target
configure-rts-target :

.PHONY : createdirectories
createdirectories :
ifeq ($(OSTYPE),cmd)
	IF EXIST $(ADAINCLUDE_PATH_CMD)\ $(RMDIR) $(ADAINCLUDE_PATH_CMD)\ $(NULL)
	$(MKDIR) $(ADAINCLUDE_PATH_CMD)
	IF EXIST $(ADALIB_PATH_CMD)\ $(RMDIR) $(ADALIB_PATH_CMD)\ $(NULL)
	$(MKDIR) $(ADALIB_PATH_CMD)
else
	$(RMDIR) $(ADAINCLUDE_PATH)
	$(MKDIR) $(ADAINCLUDE_PATH)
	$(RMDIR) $(ADALIB_PATH)
	$(MKDIR) $(ADALIB_PATH)
endif

.PHONY : multilib
ifneq ($(findstring "$(MULTILIB_DIRECTORY)",$(MULTILIB_DIRECTORIES_SKIP)),)
multilib :
	$(info *** Skipping target "multilib" for multilib directory "$(MULTILIB_DIRECTORY)".)
else
multilib : $(LIBGNAT) $(LIBGNARL) clean-objs
endif

$(LIBGNAT) : $(LIBGNAT_OBJS)
	$(AR) cr $@ $(LIBGNAT_OBJS)
	$(RANLIB) $@

$(LIBGNARL) : $(LIBGNARL_OBJS)
	$(AR) cr $@ $(LIBGNARL_OBJS)
	$(RANLIB) $@

.PHONY : clean-objs
clean-objs :
ifeq ($(OSTYPE),cmd)
	@$(RM) $(ADALIB_PATH_CMD)\*.o
else
	@$(RM) $(ADALIB_PATH)/*.o
endif

#
# From .../gcc/ada/Makefile.rtl:
#
# Force no function reordering on a-except.o because of the exclusion bounds
# mechanism (see the source file for more detailed information).
# force debugging information on a-except.o so that it is always
# possible to set conditional breakpoints on exceptions.
# use -O1 otherwise gdb isn't able to get a full backtrace on mips targets.
#
$(ADALIB_PATH)/a-except.o : $(ADAINCLUDE_PATH)/a-except.adb
	$(ADAC) -o $@ -c -g -O1 -fno-inline -fno-toplevel-reorder $(ADAC_SWITCHES) $<

# Ada sources generic rules
$(ADALIB_PATH)/%.o : $(ADAINCLUDE_PATH)/%.adb
	$(ADAC) -o $@ -c -g -O2 $(ADAC_SWITCHES) $<
$(ADALIB_PATH)/%.o : $(ADAINCLUDE_PATH)/%.ads
	$(ADAC) -o $@ -c -g -O2 $(ADAC_SWITCHES) $<

# C sources generic rules
$(ADALIB_PATH)/%.o : $(ADAINCLUDE_PATH)/%.c
	$(CC) -o $@ -c -g -O2 $(CC_SWITCHES) $<

