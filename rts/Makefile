
#
# Ada GNAT RTS Makefile
#
# Copyright (C) 2020-2026 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# make arguments
#
# Environment variables:
# KERNEL_PARENT_PATH
# TOOLCHAIN_NAME
# TOOLCHAIN_ADAC
# TOOLCHAIN_CC
# TOOLCHAIN_AR
# TOOLCHAIN_RANLIB
# CPU
# CPUS
# RTS
# MULTILIB
# PROBEVARIABLE
# PROBEVARIABLES
#

################################################################################
#                                                                              #
# Initialization.                                                              #
#                                                                              #
################################################################################

.POSIX:

MAKEFILE_RTS_INCLUDED := Y

.NOTPARALLEL:

ifneq ($(words $(MAKECMDGOALS)),1)
$(error Error: only one Makefile target should be specified)
endif

# add silent operation in probevariable[s] targets
ifneq ($(filter probevariable probevariables,$(MAKECMDGOALS)),)
VERBOSE :=
MAKEFLAGS += s
MAKEFLAGS += --no-print-directory
endif

include $(KERNEL_PARENT_PATH)/Makefile.os.in
include $(KERNEL_PARENT_PATH)/Makefile.ut.in
include $(KERNEL_PARENT_PATH)/Makefile.fn.in

ifeq ($(OSTYPE),cmd)
RTS_SRC_ALL_DIRS := $(shell $(CHDIR) src && $(call ls-dirs) 2>nul)
else
RTS_SRC_ALL_DIRS := $(shell ($(CHDIR) src && $(call ls-dirs)) 2> /dev/null)
endif
RTS_SRC_NO_DIRS  := common targets
RTSES            := $(filter-out $(RTS_SRC_NO_DIRS),$(RTS_SRC_ALL_DIRS))

################################################################################
#                                                                              #
# Parameter checks.                                                            #
#                                                                              #
################################################################################

ifeq ($(filter probevariable probevariables,$(MAKECMDGOALS)),)
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
endif

################################################################################
#                                                                              #
# Initialize basic variables and paths.                                        #
#                                                                              #
################################################################################

TARGET := $(CPU)

RTS_PATH := $(RTS)/$(TOOLCHAIN_NAME)/$(MULTILIB)

# assemble RTS source paths
RTS_SOURCE_PATH            := ./src/$(RTS)
RTS_SOURCE_PATH_TARGET     := ./src/targets/$(TARGET)
ifeq ($(OSTYPE),cmd)
RTS_SOURCE_PATH_CMD        := $(subst /,\,$(RTS_SOURCE_PATH))
RTS_SOURCE_PATH_TARGET_CMD := $(subst /,\,$(RTS_SOURCE_PATH_TARGET))
endif

ifneq ($(MULTILIB),)
MULTILIB_DIRECTORY  := $(firstword $(subst ;,$(SPACE),$(MULTILIB)))
MULTILIB_SWITCHES   := $(strip \
                         $(subst @,$(SPACE)-,\
                           $(subst $(MULTILIB_DIRECTORY);,$(SPACE),$(MULTILIB))\
                          )\
                         )
ADAINCLUDE_PATH     := ./$(RTS)/$(TOOLCHAIN_NAME)/$(MULTILIB_DIRECTORY)/adainclude
ADALIB_PATH         := ./$(RTS)/$(TOOLCHAIN_NAME)/$(MULTILIB_DIRECTORY)/adalib
ifeq ($(OSTYPE),cmd)
ADAINCLUDE_PATH_CMD := $(subst /,\,$(ADAINCLUDE_PATH))
ADALIB_PATH_CMD     := $(subst /,\,$(ADALIB_PATH))
endif
endif

ADAC   := $(TOOLCHAIN_ADAC)
CC     := $(TOOLCHAIN_CC)
AR     := $(TOOLCHAIN_AR)
RANLIB := $(TOOLCHAIN_RANLIB)

ADAC_SWITCHES :=
ADAC_SWITCHES += $(MULTILIB_SWITCHES)
ADAC_SWITCHES += -nostdinc -nostdlib
#ADAC_SWITCHES += -gnata    # Assertions enabled.
# -gnatg implies -gnatwae and -gnatyg
ADAC_SWITCHES += -gnatg    # Internal GNAT implementation mode.
#ADAC_SWITCHES += -gnatn    # Activate inlining for subprograms for which pragma inline is specified.
ADAC_SWITCHES += -gnatp    # Suppress all checks.
# turn off some style checks (which are turned on by -gnatg)
#ADAC_SWITCHES += -gnatyC   # Check comments, single space.
#ADAC_SWITCHES += -gnaty132 # Set maximum line length.
ADAC_SWITCHES += -gnatyN   # Turn off all style checks.
ADAC_SWITCHES += -Wextra
ADAC_SWITCHES += -Wall

CC_SWITCHES :=
CC_SWITCHES += $(MULTILIB_SWITCHES)
CC_SWITCHES += -ffreestanding
CC_SWITCHES += -Wall

ADAC_SWITCHES_RTS :=
CC_SWITCHES_RTS   :=

LIBGNAT_SRCS         :=
LIBGNAT_SRCS_COMMON  :=
LIBGNAT_SRCS_TARGET  :=
LIBGNARL_SRCS        :=
LIBGNARL_SRCS_COMMON :=
LIBGNARL_SRCS_TARGET :=

# RTS target-independent part
-include $(RTS_SOURCE_PATH)/configuration.in
# RTS target-dependent part
-include $(RTS_SOURCE_PATH_TARGET)/configuration.in

ADAC_SWITCHES += $(ADAC_SWITCHES_RTS)
CC_SWITCHES   += $(CC_SWITCHES_RTS)

LIBGNAT_SRCS  += $(LIBGNAT_SRCS_COMMON) $(LIBGNAT_SRCS_TARGET)
LIBGNARL_SRCS += $(LIBGNARL_SRCS_COMMON) $(LIBGNARL_SRCS_TARGET)

LIBGNAT       := $(ADALIB_PATH)/libgnat.a
LIBGNAT_ADS   := $(filter-out %.adb,$(LIBGNAT_SRCS))
LIBGNAT_OBJS  := $(addprefix $(ADALIB_PATH)/,$(notdir $(LIBGNAT_ADS:.ads=.o)))
LIBGNAT_ALIS  := $(addprefix $(ADALIB_PATH)/,$(notdir $(LIBGNAT_ADS:.ads=.ali)))

LIBGNARL      := $(ADALIB_PATH)/libgnarl.a
LIBGNARL_ADS  := $(filter-out %.adb,$(LIBGNARL_SRCS))
LIBGNARL_OBJS := $(addprefix $(ADALIB_PATH)/,$(notdir $(LIBGNARL_ADS:.ads=.o)))
LIBGNARL_ALIS := $(addprefix $(ADALIB_PATH)/,$(notdir $(LIBGNARL_ADS:.ads=.ali)))

MULTILIB_SKIPS := $(foreach m,$(MULTILIB_DIRECTORIES_SKIP),"$(m)")

ADAC_SWITCHES := $(filter-out ,$(ADAC_SWITCHES))
CC_SWITCHES   := $(filter-out ,$(CC_SWITCHES))

ifeq ($(or                                               \
  $(if $(findstring RTS_INSTALLED,$(PROBEVARIABLE)),Y,), \
  $(if $(findstring RTS_INSTALLED,$(PROBEVARIABLES)),Y,) \
  ),Y)
ifeq ($(OSTYPE),cmd)
RTS_INSTALLED := $(shell                                         \
                   SETLOCAL ENABLEDELAYEDEXPANSION            && \
                   IF EXIST $(ADAINCLUDE_PATH_CMD)\system.ads    \
                     (ECHO Y) ELSE (ECHO N)                      \
                   )
else
RTS_INSTALLED := $(shell                                            \
                   if [ -e $(ADAINCLUDE_PATH)/system.ads ] ; then   \
                     printf "%s\n" "Y"                            ; \
                   else                                             \
                     printf "%s\n" "N"                            ; \
                   fi                                               \
                   )
endif
endif

################################################################################
#                                                                              #
# Targets.                                                                     #
#                                                                              #
################################################################################

.PHONY: all
ifneq ($(findstring "$(MULTILIB_DIRECTORY)",$(MULTILIB_SKIPS)),)
all:
	$(info *** Skipping target "all" for multilib directory "$(MULTILIB_DIRECTORY)".)
else
all: configure-rts configure-rts-target multilib
endif

.PHONY: configure
ifneq ($(findstring "$(MULTILIB_DIRECTORY)",$(MULTILIB_SKIPS)),)
configure:
	$(info *** Skipping target "configure" for multilib directory "$(MULTILIB_DIRECTORY)".)
else
configure: create-dirs configure-rts configure-rts-target
endif

.PHONY: configure-rts
configure-rts:
ifeq ($(OSTYPE),cmd)
	@FOR %%F IN ($(subst /,\,$(LIBGNAT_SRCS_COMMON)) $(subst /,\,$(LIBGNARL_SRCS_COMMON))) DO \
          @ECHO OFF &&                                                                            \
          IF EXIST $(RTS_SOURCE_PATH_CMD)\%%F.in (                                                \
            $(PROCESSCFG) -r $(RTS_SOURCE_PATH_CMD)\%%F.in $(ADAINCLUDE_PATH_CMD)\%%~nF%%~xF      \
            || EXIT /B 1                                                                          \
          ) ELSE (                                                                                \
            $(CP) "$(RTS_SOURCE_PATH_CMD)"\%%F "$(ADAINCLUDE_PATH_CMD)"\%%~nF%%~xF                \
            || EXIT /B 1                                                                          \
          )
else
	@for f in $(LIBGNAT_SRCS_COMMON) $(LIBGNARL_SRCS_COMMON) ; do                         \
          (                                                                                   \
           if [ -e $(RTS_SOURCE_PATH)/$$f.in ] ; then                                         \
             $(PROCESSCFG) -r $(RTS_SOURCE_PATH)/$$f.in $(ADAINCLUDE_PATH)/$$(basename $$f) ; \
           else                                                                               \
             $(CP) "$(RTS_SOURCE_PATH)"/$$f "$(ADAINCLUDE_PATH)"/$$(basename $$f) ;           \
           fi                                                                                 \
          ) || exit $$? ;                                                                     \
        done
endif

.PHONY: configure-rts-target
configure-rts-target:
ifeq ($(OSTYPE),cmd)
	@FOR %%F IN ($(subst /,\,$(LIBGNAT_SRCS_TARGET)) $(subst /,\,$(LIBGNARL_SRCS_TARGET))) DO   \
          @ECHO OFF &&                                                                              \
          IF EXIST $(RTS_SOURCE_PATH_TARGET_CMD)\%%F.in (                                           \
            $(PROCESSCFG) -r $(RTS_SOURCE_PATH_TARGET_CMD)\%%F.in $(ADAINCLUDE_PATH_CMD)\%%~nF%%~xF \
            || EXIT /B 1                                                                            \
          ) ELSE (                                                                                  \
            $(CP) "$(RTS_SOURCE_PATH_TARGET_CMD)"\%%F "$(ADAINCLUDE_PATH_CMD)"\%%~nF%%~xF           \
            || EXIT /B 1                                                                            \
          )
else
	@for f in $(LIBGNAT_SRCS_TARGET) $(LIBGNARL_SRCS_TARGET) ; do                                \
          (                                                                                          \
           if [ -e $(RTS_SOURCE_PATH_TARGET)/$$f.in ] ; then                                         \
             $(PROCESSCFG) -r $(RTS_SOURCE_PATH_TARGET)/$$f.in $(ADAINCLUDE_PATH)/$$(basename $$f) ; \
           else                                                                                      \
             $(CP) "$(RTS_SOURCE_PATH_TARGET)"/$$f "$(ADAINCLUDE_PATH)"/$$(basename $$f) ;           \
           fi                                                                                        \
          ) || exit $$? ;                                                                            \
        done
endif

.PHONY: create-dirs
create-dirs:
ifeq ($(OSTYPE),cmd)
	@IF EXIST $(ADAINCLUDE_PATH_CMD)\ $(RMDIR) $(ADAINCLUDE_PATH_CMD)\ $(NULL)
	@$(MKDIR) $(ADAINCLUDE_PATH_CMD)
	@IF EXIST $(ADALIB_PATH_CMD)\ $(RMDIR) $(ADALIB_PATH_CMD)\ $(NULL)
	@$(MKDIR) $(ADALIB_PATH_CMD)
else
	@$(RMDIR) $(ADAINCLUDE_PATH)
	@$(MKDIR) $(ADAINCLUDE_PATH)
	@$(RMDIR) $(ADALIB_PATH)
	@$(MKDIR) $(ADALIB_PATH)
endif

.PHONY: multilib
ifneq ($(findstring "$(MULTILIB_DIRECTORY)",$(MULTILIB_SKIPS)),)
multilib:
	$(info *** Skipping target "multilib" for multilib directory "$(MULTILIB_DIRECTORY)".)
else
multilib: $(LIBGNAT) $(LIBGNARL) clean-objs
endif

$(LIBGNAT): $(LIBGNAT_OBJS)
	$(AR) cr $@ $(LIBGNAT_OBJS)
	$(RANLIB) $@

$(LIBGNARL): $(LIBGNARL_OBJS)
	$(AR) cr $@ $(LIBGNARL_OBJS)
	$(RANLIB) $@

.PHONY: clean-objs
clean-objs:
ifeq ($(OSTYPE),cmd)
	@$(RM) $(ADALIB_PATH_CMD)\*.o
else
	@$(RM) $(ADALIB_PATH)/*.o
endif

# RTS target-independent part
-include $(RTS_SOURCE_PATH)/Makefile.in
# RTS target-dependent part
-include $(RTS_SOURCE_PATH_TARGET)/Makefile.in

# Ada sources generic rules
$(ADALIB_PATH)/%.o: $(ADAINCLUDE_PATH)/%.adb
	$(ADAC) -o $@ -c       \
          -g -O2               \
          -I$(ADAINCLUDE_PATH) \
          $(ADAC_SWITCHES)     \
          $<
$(ADALIB_PATH)/%.o: $(ADAINCLUDE_PATH)/%.ads
	$(ADAC) -o $@ -c       \
          -g -O2               \
          -I$(ADAINCLUDE_PATH) \
          $(ADAC_SWITCHES)     \
          $<

# C sources generic rules
$(ADALIB_PATH)/%.o: $(ADAINCLUDE_PATH)/%.c
	$(CC) -o $@ -c         \
          -g -O2               \
          -I$(ADAINCLUDE_PATH) \
          $(CC_SWITCHES)       \
          $<

.PHONY: probevariable
probevariable:
	@$(call echo-print,"$($(PROBEVARIABLE))")

.PHONY: probevariables
probevariables:
ifeq ($(OSTYPE),cmd)
	@$(foreach v,$(PROBEVARIABLES),$(call echo-print,"$(v):=$($(v))|")&)
else
	@$(foreach v,$(PROBEVARIABLES),$(call echo-print,"$(v):=$($(v))|");)
endif

