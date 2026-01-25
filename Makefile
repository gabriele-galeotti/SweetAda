
#
# Master Makefile
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
# OS
# MSYSTEM
# TEMP
# VERBOSE
# PLATFORM
# SUBPLATFORM
# RTS
# NOBUILD
# PROBEVARIABLE
# PROBEVARIABLES
#

################################################################################
#                                                                              #
# Setup initialization.                                                        #
#                                                                              #
################################################################################

.POSIX:

MAKEFILE_MASTER_INCLUDED := Y

.NOTPARALLEL:

.DEFAULT_GOAL := help

# default kernel basename
KERNEL_BASENAME := kernel

# initialize configuration dependencies
CONFIGURE_DEPS :=

# verbose mode, "Y"/"y"/"1" = enabled
VERBOSE ?=
override VERBOSE := $(subst y,Y,$(subst 1,y,$(VERBOSE)))
export VERBOSE

################################################################################
#                                                                              #
# Partitioning and check of Makefile goals.                                    #
#                                                                              #
################################################################################

#
# List of recognized goals:
#
# C  = cleaning goal
# I  = info goal
# L  = libutils goal
# NP = not-platform goal
# P  = platform goal
# R  = RTS goal
# S  = service goal
# V  = probe variable(s) goal
#
# libutils-elftool      L       S       NP
# libutils-gcc-wrapper  L       S       NP
# libutils-gnat-wrapper L       S       NP
# infodump              I               NP
# probevariable         V               NP
# probevariables        V               NP
# clean                 C               NP
# distclean             C               NP
# createkernelcfg               S       NP
# help                          S       NP
# tools-check                   S       NP
# rts                   R               NP
# configure                             P
# $(KERNEL_BASENAME)                    P
# all                                   P
# kernel_info                           P
# kernel_libinfo                        P
# postbuild                             P
# session-start                         P
# session-end                           P
# run                                   P
# debug                                 P
#

# libutils goals
LIBUTILS_GOALS := libutils-elftool      \
                  libutils-gcc-wrapper  \
                  libutils-gnat-wrapper

# info goals
INFO_GOALS := infodump

# probe variables(s) goals
PROBEVARIABLE_GOALS := probevariable  \
                       probevariables

# clean/distclean goals
CLEANING_GOALS := clean     \
                  distclean

# general service goals
SERVICE_GOALS := createkernelcfg   \
                 help              \
                 tools-check       \
                 $(LIBUTILS_GOALS)

# not-platform-related goals
NOT_PLATFORM_GOALS := $(SERVICE_GOALS)       \
                      $(INFO_GOALS)          \
                      $(CLEANING_GOALS)      \
                      $(PROBEVARIABLE_GOALS) \
                      rts

# platform-related goals
PLATFORM_GOALS := configure          \
                  $(KERNEL_BASENAME) \
                  all                \
                  kernel_info        \
                  kernel_libinfo     \
                  postbuild          \
                  session-start      \
                  session-end        \
                  run                \
                  debug

# all goals
ALL_GOALS := $(NOT_PLATFORM_GOALS) \
             $(PLATFORM_GOALS)

# special set of goals for detection of all informations
INFOCONFIG_GOALS := $(INFO_GOALS)          \
                    $(PROBEVARIABLE_GOALS) \
                    configure

# check Makefile target
NOT_MAKEFILE_GOALS := $(filter-out $(ALL_GOALS),$(MAKECMDGOALS))
ifneq ($(NOT_MAKEFILE_GOALS),)
$(error Error: $(NOT_MAKEFILE_GOALS): no known Makefile target, try "make help")
endif

# probevariable[s] must be issued as single target
ifneq ($(filter probevariable probevariables,$(MAKECMDGOALS)),)
ifneq ($(words $(MAKECMDGOALS)),1)
$(error Error: no multiple targets can be specified)
endif
endif

# add silent operation in non-verbose mode, except when building utilities
ifneq ($(VERBOSE),Y)
ifeq ($(filter $(MAKECMDGOALS),$(LIBUTILS_GOALS)),)
MAKEFLAGS += s
endif
MAKEFLAGS += --no-print-directory
endif

################################################################################
#                                                                              #
# Setup directories and utilities.                                             #
#                                                                              #
################################################################################

# generate SWEETADA_PATH
MAKEFILEDIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
SWEETADA_PATH ?= $(MAKEFILEDIR)
export SWEETADA_PATH

# LIBUTILS_DIRECTORY is special because it is an integral part of the build
# system, it shall be immediately visible in order to use utilities
LIBUTILS_DIRECTORY := libutils
export LIBUTILS_DIRECTORY

# include operating system setup
include Makefile.os.in
CONFIGURE_DEPS += Makefile.os.in

# add LIBUTILS_DIRECTORY to PATH
ifeq      ($(OSTYPE),cmd)
PATH := $(SWEETADA_PATH)\$(LIBUTILS_DIRECTORY);$(PATH)
else ifeq ($(OSTYPE),msys)
PATH := $(PATH):$(SWEETADA_PATH)/$(LIBUTILS_DIRECTORY)
else
PATH := $(SWEETADA_PATH)/$(LIBUTILS_DIRECTORY):$(PATH)
endif
export PATH

# load build system utilities
include Makefile.ut.in
CONFIGURE_DEPS += Makefile.ut.in
# load complex functions
include Makefile.fn.in
CONFIGURE_DEPS += Makefile.fn.in

# make these useful variables publicly available
ifeq ($(OSTYPE),cmd)
PROGRAM_FILES := $(shell ECHO %ProgramFiles%)
export PROGRAM_FILES
PROGRAM_FILES_x86 := $(shell ECHO %ProgramFiles(x86)%)
export PROGRAM_FILES_x86
endif

################################################################################
#                                                                              #
# Setup finalization.                                                          #
#                                                                              #
################################################################################

# build flag and version control
DOTSWEETADA := .sweetada

# default kernel filenames
KERNEL_CFGFILE := $(KERNEL_BASENAME).cfg
KERNEL_DEPFILE := $(KERNEL_BASENAME).d
KERNEL_OBJFILE := $(KERNEL_BASENAME).obj
KERNEL_OUTFILE := $(KERNEL_BASENAME).o
KERNEL_ROMFILE := $(KERNEL_BASENAME).rom

# GNAT .adc filename
GNATADC_FILENAME := gnat.adc

# GNAT target dependent information
GNATTDI_FILENAME := gnat.tdi

# GPRbuild project
KERNEL_GPRFILE := sweetada.gpr

# GPRbuild configuration
CONFIGUREGPR_FILENAME := configure.gpr

# initialize GPRbuild dependencies
GPRBUILD_DEPS :=

# cleaning
CLEAN_OBJECTS_COMMON     := *.a *.aout *.bin *.d *.dwo *.elf *.hex *.log *.lst \
                            *.map *.o *.out* *.srec *.td *.tmp
DISTCLEAN_OBJECTS_COMMON := $(GNATADC_FILENAME)      \
                            $(GNATTDI_FILENAME)      \
                            $(CONFIGUREGPR_FILENAME)

# check for RTS build
ifeq ($(MAKECMDGOALS),rts)
# before setting of a default RTS and loading configuration.in (which defines
# the RTS type used by the platform), save RTS variable from the environment
# in order to correctly build the RTS specified when issuing the "rts" target
RTS_BUILD := $(RTS)
endif

# default system parameters
TOOLCHAIN_PREFIX   :=
GPRBUILD_PREFIX    :=
BUILD_MODE         := GNATMAKE
RTS                :=
PROFILE            :=
ADA_MODE           := ADA22
USE_LIBGCC         :=
USE_LIBM           :=
USE_CLIBRARY       :=
USE_APPLICATION    := dummy
ELABORATION_MODEL  :=
OPTIMIZATION_LEVEL :=
STACK_LIMIT        := 4096
POSTBUILD_ROMFILE  :=
LD_SCRIPT          := linker.lds
KERNEL_ENTRY_POINT := _start
IMPLICIT_ALI_UNITS :=
EXTERNAL_OBJECTS   :=
EXTERNAL_ALIS      :=

# read the master configuration file
include configuration.in
CONFIGURE_DEPS += configuration.in

# check for a configured toolchain
ifneq ($(filter rts $(PLATFORM_GOALS),$(MAKECMDGOALS)),)
ifeq ($(TOOLCHAIN_PREFIX),)
$(error Error: no valid TOOLCHAIN_PREFIX)
endif
endif

# add TOOLCHAIN_PREFIX to PATH
ifneq ($(TOOLCHAIN_PREFIX),)
ifeq      ($(OSTYPE),cmd)
PATH := $(TOOLCHAIN_PREFIX)\bin;$(PATH)
else ifeq ($(OSTYPE),msys)
TOOLCHAIN_PREFIX_MSYS := $(shell cygpath.exe -u "$(TOOLCHAIN_PREFIX)" 2> /dev/null)
PATH := $(TOOLCHAIN_PREFIX_MSYS)/bin:$(PATH)
else
PATH := $(TOOLCHAIN_PREFIX)/bin:$(PATH)
endif
endif

# add GPRBUILD_PREFIX to PATH
ifeq ($(BUILD_MODE),GPRbuild)
ifneq ($(GPRBUILD_PREFIX),)
ifeq      ($(OSTYPE),cmd)
PATH := $(GPRBUILD_PREFIX)\bin;$(PATH)
else ifeq ($(OSTYPE),msys)
GPRBUILD_PREFIX_MSYS := $(shell cygpath.exe -u "$(GPRBUILD_PREFIX)" 2> /dev/null)
PATH := $(GPRBUILD_PREFIX_MSYS)/bin:$(PATH)
else
PATH := $(GPRBUILD_PREFIX)/bin:$(PATH)
endif
endif
endif

# re-export PATH so that we can use everything
export PATH

################################################################################
#                                                                              #
# Physical geometry of the build system.                                       #
#                                                                              #
################################################################################

# hierarchies
PLATFORM_BASE_DIRECTORY := platforms
CPU_BASE_DIRECTORY      := cpus
APPLICATION_DIRECTORY   := application
CLIBRARY_DIRECTORY      := clibrary
CORE_DIRECTORY          := core
DRIVERS_DIRECTORY       := drivers
MODULES_DIRECTORY       := modules
LIBRARY_DIRECTORY       := lib
OBJECT_DIRECTORY        := obj
RTS_DIRECTORY           := rts
SHARE_DIRECTORY         := share

# PLATFORMs - CPUs - RTSes
ifeq ($(OSTYPE),cmd)
PLATFORMS := $(shell $(CHDIR) $(PLATFORM_BASE_DIRECTORY) && $(call ls-dirs) 2>nul)
CPUS      := $(shell $(CHDIR) $(CPU_BASE_DIRECTORY) && $(call ls-dirs) 2>nul)
RTSES     := $(shell                          \
               SET "VERBOSE="              && \
               SET "PATH=$(PATH)"          && \
               SET "KERNEL_PARENT_PATH=.." && \
               "$(MAKE)"                      \
                 --no-print-directory         \
                 -C $(RTS_DIRECTORY)          \
                 PROBEVARIABLE=RTSES          \
                 probevariable                \
               2>nul)
else
PLATFORMS := $(shell ($(CHDIR) $(PLATFORM_BASE_DIRECTORY) && $(call ls-dirs)) 2> /dev/null)
CPUS      := $(shell ($(CHDIR) $(CPU_BASE_DIRECTORY) && $(call ls-dirs)) 2> /dev/null)
RTSES     := $(shell                  \
               VERBOSE=               \
               PATH="$(PATH)"         \
               KERNEL_PARENT_PATH=..  \
               "$(MAKE)"              \
                 --no-print-directory \
                 -C $(RTS_DIRECTORY)  \
                 PROBEVARIABLE=RTSES  \
                 probevariable        \
               2> /dev/null)
endif

################################################################################
#                                                                              #
# Initialize variables.                                                        #
#                                                                              #
################################################################################

#
# TOOLCHAIN_NAME: initialized from configuration.
# TOOLCHAIN_PROGRAM_PREFIX: synthesized from TOOLCHAIN_NAME.
# GCC_VERSION: is the GCC version string; if empty, the toolchain is believed
# to be non-existent.
# LIBGCC_FILENAME: is the filename of the "multilib" LibGCC determined by
# compiler configuration switches.
# RTS_PATH: is the specific path of a well-defined "multilib" RTS (e.g., the
# multilib subdirectory used by the build system), determined by compiler
# configuration switches.
# PLATFORM_DIRECTORY: directory of the configured platform
# CPU_DIRECTORY: directory of the configured CPU
# CPU_MODEL_DIRECTORY: additional directory of the configured CPU
#
TOOLCHAIN_NAME           :=
TOOLCHAIN_PROGRAM_PREFIX :=
GCC_VERSION              :=
LIBGCC_FILENAME          :=
RTS_PATH                 :=
PLATFORM_DIRECTORY       :=
CPU_DIRECTORY            :=
CPU_MODEL_DIRECTORY      :=

#
# Initialize toolchain default switches.
#
AS_SWITCHES_DEFAULT       :=
ADAC_SWITCHES_DEFAULT     :=
CPP_SWITCHES_DEFAULT      :=
CC_SWITCHES_DEFAULT       :=
CXXC_SWITCHES_DEFAULT     :=
GNATPREP_SWITCHES_DEFAULT :=
GNATMAKE_SWITCHES_DEFAULT :=
GNATBIND_SWITCHES_DEFAULT :=
GNATLINK_SWITCHES_DEFAULT :=
GNATLS_SWITCHES_DEFAULT   :=
GPRBUILD_SWITCHES_DEFAULT :=
AR_SWITCHES_DEFAULT       :=
LD_SWITCHES_DEFAULT       :=
NM_SWITCHES_DEFAULT       :=
OBJCOPY_SWITCHES_DEFAULT  :=
OBJDUMP_SWITCHES_DEFAULT  :=
RANLIB_SWITCHES_DEFAULT   :=
READELF_SWITCHES_DEFAULT  :=
SIZE_SWITCHES_DEFAULT     :=
STRIP_SWITCHES_DEFAULT    :=

#
# Initialize warning/style toolchain switches.
#
AS_SWITCHES_WARNING   :=
ADAC_SWITCHES_WARNING :=
ADAC_SWITCHES_STYLE   :=
CPP_SWITCHES_WARNING  :=
CC_SWITCHES_WARNING   :=
CXXC_SWITCHES_WARNING :=

#
# Initialize platform-dependent toolchain switches.
#
AS_SWITCHES_PLATFORM           :=
GCC_SWITCHES_PLATFORM          :=
LOWLEVEL_FILES_PLATFORM        :=
GCC_SWITCHES_LOWLEVEL_PLATFORM :=
LD_SWITCHES_PLATFORM           :=
OBJCOPY_SWITCHES_PLATFORM      :=
OBJDUMP_SWITCHES_PLATFORM      :=

#
# Initialize RTS-imported switches.
#
ADAC_SWITCHES_RTS         :=
CC_SWITCHES_RTS           :=
LIBGNAT                   :=
LIBGNARL                  :=
SUPPRESS_STANDARD_LIBRARY :=

#
# Initialize include directories and implicit units.
#
INCLUDE_DIRECTORIES     :=
CPU_INCLUDE_DIRECTORIES :=
IMPLICIT_CORE_UNITS     :=
IMPLICIT_CLIBRARY_UNITS :=

#
# Support variables.
#
GCCDEFINES_CPU :=
GPR_CORE_CPU   :=

#
# Various features.
#
GNATBIND_SECSTACK  :=
ENABLE_SPLIT_DWARF :=

#
# Platform configuration files.
#
CONFIGURE_FILES_PLATFORM :=

################################################################################
#                                                                              #
# Global PLATFORM/CPU configuration logic.                                     #
#                                                                              #
################################################################################

ifneq ($(filter createkernelcfg,$(MAKECMDGOALS)),createkernelcfg)
-include $(KERNEL_CFGFILE)
endif

ifneq ($(MAKECMDGOALS),)
# PLATFORM processing
ifneq ($(filter $(sort $(CLEANING_GOALS) $(INFOCONFIG_GOALS) rts $(PLATFORM_GOALS)),$(MAKECMDGOALS)),)
ifneq ($(PLATFORM),)
# PLATFORM defined
ifeq ($(filter $(PLATFORM),$(PLATFORMS)),)
$(error Error: no valid PLATFORM)
endif
PLATFORM_DIRECTORY := $(PLATFORM_BASE_DIRECTORY)/$(PLATFORM)
ifeq ($(OSTYPE),cmd)
PLATFORM_DIRECTORY_CMD := $(PLATFORM_BASE_DIRECTORY)\$(PLATFORM)
endif
ifeq ($(filter distclean,$(MAKECMDGOALS)),distclean)
-include $(PLATFORM_DIRECTORY)/configuration.in
else
include $(PLATFORM_DIRECTORY)/configuration.in
endif
CONFIGURE_DEPS += $(PLATFORM_DIRECTORY)/configuration.in
else
# PLATFORM unknown
ifneq ($(filter $(PLATFORM_GOALS),$(MAKECMDGOALS)),)
$(error Error: no valid PLATFORM)
endif
endif
endif
# CPU processing
ifneq ($(CPU),)
# CPU defined
ifneq ($(filter $(sort $(INFOCONFIG_GOALS) rts $(PLATFORM_GOALS)),$(MAKECMDGOALS)),)
ifeq ($(filter $(CPU),$(CPUS)),)
$(error Error: no valid CPU)
else
CPU_DIRECTORY := $(CPU_BASE_DIRECTORY)/$(CPU)
include $(CPU_DIRECTORY)/configuration.in
CONFIGURE_DEPS += $(CPU_DIRECTORY)/configuration.in
endif
endif
else
# CPU must be known for the RTS goal
ifeq ($(filter rts,$(MAKECMDGOALS)),rts)
$(error Error: no valid CPU)
endif
endif
# standard components
include $(APPLICATION_DIRECTORY)/configuration.in
CONFIGURE_DEPS += $(APPLICATION_DIRECTORY)/configuration.in
ifeq ($(USE_CLIBRARY),Y)
include $(CLIBRARY_DIRECTORY)/configuration.in
CONFIGURE_DEPS += $(CLIBRARY_DIRECTORY)/configuration.in
endif
include $(CORE_DIRECTORY)/configuration.in
CONFIGURE_DEPS += $(CORE_DIRECTORY)/configuration.in
include $(DRIVERS_DIRECTORY)/configuration.in
CONFIGURE_DEPS += $(DRIVERS_DIRECTORY)/configuration.in
include $(MODULES_DIRECTORY)/configuration.in
CONFIGURE_DEPS += $(MODULES_DIRECTORY)/configuration.in
endif

################################################################################
#                                                                              #
# Post-configuration finalization.                                             #
#                                                                              #
################################################################################

#
# Now that the complete configuration is known, do a finalization on some
# sensible parameters.
#

ifneq ($(filter $(PLATFORM_GOALS),$(MAKECMDGOALS)),)
ifeq ($(filter GNATMAKE GPRbuild,$(BUILD_MODE)),)
$(warning *** Warning: no valid BUILD_MODE.)
endif
endif

# if RTS_BUILD is null, use the one read from configuration files
ifeq ($(RTS_BUILD),)
RTS_BUILD := $(RTS)
endif

# high-precedence include directories
ifneq ($(PLATFORM),)
ifneq ($(CPU),)
# head-insert CPU directory
INCLUDE_DIRECTORIES := $(CPU_DIRECTORY) $(INCLUDE_DIRECTORIES)
# head-insert optional directories
ifneq ($(CPU_INCLUDE_DIRECTORIES),)
INCLUDE_DIRECTORIES := $(CPU_INCLUDE_DIRECTORIES) $(INCLUDE_DIRECTORIES)
endif
# head-insert CPU_MODEL directory
ifneq ($(CPU_MODEL_DIRECTORY),)
INCLUDE_DIRECTORIES := $(CPU_MODEL_DIRECTORY) $(INCLUDE_DIRECTORIES)
endif
endif
# head-insert PLATFORM directory
INCLUDE_DIRECTORIES := $(PLATFORM_DIRECTORY) $(INCLUDE_DIRECTORIES)
endif

# import implicit units
IMPLICIT_ALI_UNITS += $(IMPLICIT_CORE_UNITS)     \
                      $(IMPLICIT_CLIBRARY_UNITS)

# toolchain specifications
include Makefile.tc.in
CONFIGURE_DEPS += Makefile.tc.in

# fragment included by all library sub-makefiles
CONFIGURE_DEPS += Makefile.lb.in

# GPRbuild configuration dependencies
ifeq ($(BUILD_MODE),GPRbuild)
ifneq ($(filter $(PLATFORM_GOALS),$(MAKECMDGOALS)),)
ifeq ($(OSTYPE),cmd)
GPRBUILD_DEPS += $(sort $(shell                                      \
                   SET "PATH=$(PATH)"                             && \
                   SET "SWEETADA_PATH=$(SWEETADA_PATH)"           && \
                   SET "LIBUTILS_DIRECTORY=$(LIBUTILS_DIRECTORY)" && \
                   $(GPRDEPS) $(KERNEL_GPRFILE)                      \
                   2>nul))
else
GPRBUILD_DEPS += $(sort $(shell                               \
                   PATH="$(PATH)"                             \
                   SWEETADA_PATH="$(SWEETADA_PATH)"           \
                   LIBUTILS_DIRECTORY="$(LIBUTILS_DIRECTORY)" \
                   $(GPRDEPS) $(KERNEL_GPRFILE)               \
                   2> /dev/null))
endif
endif
endif

################################################################################
#                                                                              #
# Query about RTS characteristics.                                             #
#                                                                              #
################################################################################

ifeq ($(OSTYPE),cmd)
$(foreach s,                                                         \
  $(subst |,$(SPACE),$(subst $(SPACE),$(DEL),$(shell                 \
    SET "VERBOSE="                                                && \
    SET "PATH=$(PATH)"                                            && \
    SET "KERNEL_PARENT_PATH=.."                                   && \
    SET "RTS=$(RTS)"                                              && \
    SET "TOOLCHAIN_NAME=$(TOOLCHAIN_NAME)"                        && \
    SET "MULTILIB=$(GCC_MULTIDIR)"                                && \
    "$(MAKE)"                                                        \
      --no-print-directory                                           \
      -C $(RTS_DIRECTORY)                                            \
      PROBEVARIABLES="SUPPRESS_STANDARD_LIBRARY LIBGNAT LIBGNARL"    \
      probevariables                                                 \
    2>nul))),$(eval $(strip $(subst $(DEL),$(SPACE),$(s)))))
else
$(foreach s,                                                        \
  $(subst |,$(SPACE),$(subst $(SPACE),$(DEL),$(shell                \
    VERBOSE=                                                        \
    PATH="$(PATH)"                                                  \
    KERNEL_PARENT_PATH=..                                           \
    RTS=$(RTS)                                                      \
    TOOLCHAIN_NAME=$(TOOLCHAIN_NAME)                                \
    MULTILIB=$(GCC_MULTIDIR)                                        \
    "$(MAKE)"                                                       \
      --no-print-directory                                          \
      -C $(RTS_DIRECTORY)                                           \
      PROBEVARIABLES="SUPPRESS_STANDARD_LIBRARY LIBGNAT LIBGNARL"   \
      probevariables                                                \
    2> /dev/null))),$(eval $(strip $(subst $(DEL),$(SPACE),$(s)))))
endif

################################################################################
#                                                                              #
# Compilation debugging.                                                       #
#                                                                              #
################################################################################

-include Makefile.db.in

################################################################################
#                                                                              #
# Export variables to environment and sub-makefiles.                           #
#                                                                              #
################################################################################

# beautify some variables
INCLUDE_DIRECTORIES     := $(filter-out ,$(INCLUDE_DIRECTORIES))
IMPLICIT_CORE_UNITS     := $(filter-out ,$(IMPLICIT_CORE_UNITS))
ifeq ($(USE_CLIBRARY),Y)
IMPLICIT_CLIBRARY_UNITS := $(filter-out ,$(IMPLICIT_CLIBRARY_UNITS))
endif
IMPLICIT_ALI_UNITS      := $(filter-out ,$(IMPLICIT_ALI_UNITS))
ifeq ($(BUILD_MODE),GPRbuild)
GPR_CORE_CPU            := $(filter-out ,$(GPR_CORE_CPU))
endif

# build system
export                           \
       MAKE                      \
       KERNEL_BASENAME           \
       KERNEL_CFGFILE            \
       KERNEL_DEPFILE            \
       KERNEL_OUTFILE            \
       KERNEL_ROMFILE            \
       PLATFORM_BASE_DIRECTORY   \
       PLATFORM_DIRECTORY        \
       PLATFORM_DIRECTORY_CMD    \
       CPUS                      \
       CPU_BASE_DIRECTORY        \
       CPU_DIRECTORY             \
       CPU_MODEL_DIRECTORY       \
       APPLICATION_DIRECTORY     \
       CLIBRARY_DIRECTORY        \
       CORE_DIRECTORY            \
       DRIVERS_DIRECTORY         \
       MODULES_DIRECTORY         \
       LIBRARY_DIRECTORY         \
       OBJECT_DIRECTORY          \
       RTSES                     \
       RTS_DIRECTORY             \
       SHARE_DIRECTORY           \
       GNATADC_FILENAME          \
       INCLUDE_DIRECTORIES       \
       IMPLICIT_CORE_UNITS       \
       IMPLICIT_CLIBRARY_UNITS   \
       IMPLICIT_ALI_UNITS        \
       CLEAN_OBJECTS_COMMON      \
       DISTCLEAN_OBJECTS_COMMON  \
       CONFIGURE_DEPS

# toolchain
export                           \
       TOOLCHAIN_PREFIX          \
       GPRBUILD_PREFIX           \
       TOOLCHAIN_NAME_AArch64    \
       TOOLCHAIN_NAME_ARM        \
       TOOLCHAIN_NAME_AVR        \
       TOOLCHAIN_NAME_M68k       \
       TOOLCHAIN_NAME_MIPS       \
       TOOLCHAIN_NAME_MIPS64     \
       TOOLCHAIN_NAME_MicroBlaze \
       TOOLCHAIN_NAME_NiosII     \
       TOOLCHAIN_NAME_OpenRISC   \
       TOOLCHAIN_NAME_PowerPC    \
       TOOLCHAIN_NAME_RISCV      \
       TOOLCHAIN_NAME_SPARC      \
       TOOLCHAIN_NAME_SPARC64    \
       TOOLCHAIN_NAME_SuperH     \
       TOOLCHAIN_NAME_SH4        \
       TOOLCHAIN_NAME_System390  \
       TOOLCHAIN_NAME_x86        \
       TOOLCHAIN_NAME_x86_64     \
       TOOLCHAIN_NAME            \
       TOOLCHAIN_PROGRAM_PREFIX  \
       TOOLCHAIN_GCC             \
       TOOLCHAIN_ADAC            \
       TOOLCHAIN_AR              \
       TOOLCHAIN_AS              \
       TOOLCHAIN_CC              \
       TOOLCHAIN_GDB             \
       TOOLCHAIN_LD              \
       TOOLCHAIN_NM              \
       TOOLCHAIN_OBJDUMP         \
       TOOLCHAIN_RANLIB          \
       GCC_VERSION               \
       RTS_PATH                  \
       ADAC                      \
       ADAC_SWITCHES_WARNING     \
       ADAC_SWITCHES_STYLE       \
       AR                        \
       AS                        \
       CC                        \
       CPP                       \
       GDB                       \
       GNATBIND                  \
       GNATCHOP                  \
       GNATLINK                  \
       GNATLS                    \
       GNATMAKE                  \
       GNATMAKE_DEPEND           \
       GNATPREP                  \
       GNATXREF                  \
       GPRBUILD                  \
       GPRCLEAN                  \
       LD                        \
       NM                        \
       OBJCOPY                   \
       OBJDUMP                   \
       RANLIB                    \
       READELF                   \
       SIZE                      \
       STRIP

# configuration
export                                \
       PLATFORM                       \
       SUBPLATFORM                    \
       CPU                            \
       CPU_MODEL                      \
       FPU_MODEL                      \
       GPR_CORE_CPU                   \
       GCCDEFINES_CPU                 \
       BUILD_MODE                     \
       ELABORATION_MODEL              \
       OPTIMIZATION_LEVEL             \
       RTS                            \
       PROFILE                        \
       ADA_MODE                       \
       SUPPRESS_STANDARD_LIBRARY      \
       GNATTDI_FILENAME               \
       USE_LIBGCC                     \
       USE_LIBM                       \
       USE_CLIBRARY                   \
       USE_APPLICATION                \
       CONFIGURE_FILES_PLATFORM       \
       GCC_SWITCHES_PLATFORM          \
       LOWLEVEL_FILES_PLATFORM        \
       GCC_SWITCHES_LOWLEVEL_PLATFORM \
       EXTERNAL_OBJECTS               \
       EXTERNAL_ALIS                  \
       STACK_LIMIT                    \
       GNATBIND_SECSTACK              \
       KERNEL_ENTRY_POINT             \
       LD_SCRIPT                      \
       POSTBUILD_COMMAND

export USE_ELFTOOL
ifeq ($(USE_ELFTOOL),Y)
export ELFTOOL
endif

ifneq ($(PYTHON),)
export PYTHON
endif

ifneq ($(TCLSH),)
export TCLSH
endif

################################################################################
#                                                                              #
# Private non-global definitions and variables.                                #
#                                                                              #
################################################################################

KERNEL_PARENT_PATH := .

MAKE_APPLICATION := SHELL="$(SHELL)" KERNEL_PARENT_PATH=..    -C $(APPLICATION_DIRECTORY)
MAKE_CLIBRARY    := SHELL="$(SHELL)" KERNEL_PARENT_PATH=..    -C $(CLIBRARY_DIRECTORY)
MAKE_CORE        := SHELL="$(SHELL)" KERNEL_PARENT_PATH=..    -C $(CORE_DIRECTORY)
MAKE_CPUS        := SHELL="$(SHELL)" KERNEL_PARENT_PATH=../.. -C $(CPU_BASE_DIRECTORY)
MAKE_CPU         := $(MAKE_CPUS)/$(CPU)
MAKE_DRIVERS     := SHELL="$(SHELL)" KERNEL_PARENT_PATH=..    -C $(DRIVERS_DIRECTORY)
MAKE_MODULES     := SHELL="$(SHELL)" KERNEL_PARENT_PATH=..    -C $(MODULES_DIRECTORY)
MAKE_PLATFORMS   := SHELL="$(SHELL)" KERNEL_PARENT_PATH=../.. -C $(PLATFORM_BASE_DIRECTORY)
MAKE_PLATFORM    := $(MAKE_PLATFORMS)/$(PLATFORM)
MAKE_RTS         := SHELL="$(SHELL)" KERNEL_PARENT_PATH=..    -C $(RTS_DIRECTORY)

CLEAN_OBJECTS     := $(KERNEL_OBJFILE)       \
                     $(KERNEL_OUTFILE)       \
                     $(KERNEL_ROMFILE)       \
                     $(CLEAN_OBJECTS_COMMON)

DISTCLEAN_OBJECTS := $(KERNEL_CFGFILE)           \
                     $(DISTCLEAN_OBJECTS_COMMON)
ifeq ($(OSTYPE),cmd)
DISTCLEAN_OBJECTS += $(CORE_DIRECTORY)\linker.ad*
else
DISTCLEAN_OBJECTS += $(CORE_DIRECTORY)/linker.ad*
endif

################################################################################
#                                                                              #
# Library selection.                                                           #
#                                                                              #
################################################################################

ifeq ($(USE_LIBGCC),Y)
LIBGCC_OBJECT := "$(LIBGCC_FILENAME)"
else
LIBGCC_OBJECT :=
endif

ifeq ($(USE_LIBM),Y)
LIBM_OBJECT := "$(LIBM_FILENAME)"
else
LIBM_OBJECT :=
endif

LIBGNAT_OBJECT  := $(RTS_DIRECTORY)/$(LIBGNAT)
LIBGNARL_OBJECT := $(RTS_DIRECTORY)/$(LIBGNARL)

ifeq ($(USE_CLIBRARY),Y)
CLIBRARY_OBJECT := $(OBJECT_DIRECTORY)/libclibrary.a
else
CLIBRARY_OBJECT :=
endif

################################################################################
#                                                                              #
# Targets.                                                                     #
#                                                                              #
################################################################################

#
# Default target.
#

.PHONY: help
help:
	@$(call echo-print,"make help (default)")
	@$(call echo-print,"  Display an help about Make targets.")
	@$(call echo-print,"make [RTS=<rts>] [CPU=<cpu>] [CPU_MODEL=<cpu_model>] \
                                 [TOOLCHAIN_NAME=<toolchain_name>] rts")
	@$(call echo-print,"  Build RTS <rts> for CPU <cpu> [CPU model <cpu_model>] \
                              using toolchain <toolchain_name>.")
	@$(call echo-print,"make PLATFORM=<platform> [SUBPLATFORM=<subplatform>] createkernelcfg")
	@$(call echo-print,"  Create the '$(KERNEL_CFGFILE)' main configuration file.")
	@$(call echo-print,"make configure")
	@$(call echo-print,"  Create configuration/support files for this platform.")
	@$(call echo-print,"make all")
	@$(call echo-print,"  Perform the same as 'make $(KERNEL_BASENAME)'.")
	@$(call echo-print,"make $(KERNEL_BASENAME)")
	@$(call echo-print,"  Build the kernel target-output file '$(KERNEL_OUTFILE)'.")
	@$(call echo-print,"make postbuild")
	@$(call echo-print,"  Perform platform-specific finalizations \
                              and build a customized binary file '$(KERNEL_ROMFILE)'.")
	@$(call echo-print,"make session-start")
	@$(call echo-print,"  Perform session start activities.")
	@$(call echo-print,"make session-end activities")
	@$(call echo-print,"  Perform session end activities.")
	@$(call echo-print,"make run")
	@$(call echo-print,"  Run the kernel.")
	@$(call echo-print,"make debug")
	@$(call echo-print,"  Run the kernel with debugger active.")
	@$(call echo-print,"make infodump")
	@$(call echo-print,"  Dump essential informations.")
	@$(call echo-print,"make kernel_libinfo")
	@$(call echo-print,"  Generate library informations.")
	@$(call echo-print,"make kernel_info")
	@$(call echo-print,"  Generate kernel informations.")
	@$(call echo-print,"make clean")
	@$(call echo-print,"  Clean object files.")
	@$(call echo-print,"make distclean")
	@$(call echo-print,"  Clean object files and all configuration/support files.")
	@$(call echo-print,"make tools-check")
	@$(call echo-print,"  Check wheter Makefile tools are available.")
	@$(call echo-print,"make libutils-elftool")
	@$(call echo-print,"  Build ELFtool.")
	@$(call echo-print,"make libutils-gcc-wrapper")
	@$(call echo-print,"  Build GCC-wrapper.")
	@$(call echo-print,"make libutils-gnat-wrapper")
	@$(call echo-print,"  Build GNAT-wrapper.")
	@$(call echo-print,"make PROBEVARIABLE=<variablename> probevariable")
	@$(call echo-print,"  Obtain the value of a variable.")
	@$(call echo-print,"make PROBEVARIABLES=<variablename_list> probevariables")
	@$(call echo-print,"  Generate a list of assignments to define variables$(COMMA) \
                              each assignment ends with a '|'.")
	@$(call echo-print,"")
	@$(call echo-print,"Available CPUs: $(CPUS)")
	@$(call echo-print,"")
	@$(call echo-print,"Available RTSes: $(RTSES)")
	@$(call echo-print,"")
	@$(call echo-print,"Available Platforms: $(PLATFORMS)")
	@$(call echo-print,"")
ifneq ($(PLATFORM),)
	@$(call echo-print,"Current PLATFORM: $(PLATFORM)")
	@$(call echo-print,"")
ifneq ($(SUBPLATFORM),)
	@$(call echo-print,"Current SUBPLATFORM: $(SUBPLATFORM)")
	@$(call echo-print,"")
endif
endif

#
# Compile phase.
#

.PHONY: FORCE
FORCE:

$(PLATFORM_DIRECTORY)/$(LD_SCRIPT): FORCE
	@$(MAKE) $(MAKE_PLATFORM) $(LD_SCRIPT)

$(CORE_DIRECTORY)/linker.ads \
$(CORE_DIRECTORY)/linker.adb: $(PLATFORM_DIRECTORY)/$(LD_SCRIPT)
	$(LINKERADSB)                                    \
                      $(PLATFORM_DIRECTORY)/$(LD_SCRIPT) \
                      $(CORE_DIRECTORY)/linker

$(OBJECT_DIRECTORY)/libplatform.a: FORCE
	$(MAKE) $(MAKE_PLATFORM) all

$(OBJECT_DIRECTORY)/libcpu.a: FORCE
	$(MAKE) $(MAKE_CPU) all

$(OBJECT_DIRECTORY)/libcore.a: FORCE
	$(MAKE) $(MAKE_CORE) all

$(CLIBRARY_OBJECT): FORCE
ifeq ($(USE_CLIBRARY),Y)
	$(MAKE) $(MAKE_CLIBRARY) all
endif

$(GCC_GNAT_WRAPPER_TIMESTAMP_FILENAME): FORCE
ifeq      ($(BUILD_MODE),GNATMAKE)
	@$(REM) GNATMAKE-driven procedure
	$(call brief-command, \
        $(GNATMAKE)                             \
                    -c                          \
                    -gnatec=$(GNATADC_FILENAME) \
                    -D $(OBJECT_DIRECTORY)      \
                    $(foreach                   \
                      d,$(INCLUDE_DIRECTORIES), \
                      -I$(d)                    \
                      )                         \
                    main.adb                    \
        ,[GNATMAKE],main.adb)
else ifeq ($(BUILD_MODE),GPRbuild)
	@$(REM) GPRbuild-driven procedure
	$(call brief-command, \
        $(GPRBUILD)                      \
                    -c -p                \
                    -P $(KERNEL_GPRFILE) \
        ,[GPRBUILD-C],$(KERNEL_GPRFILE))
endif

#
# Bind phase.
#

B__MAIN_ADB_DEPS :=
B__MAIN_ADB_DEPS += $(OBJECT_DIRECTORY)/libplatform.a
B__MAIN_ADB_DEPS += $(OBJECT_DIRECTORY)/libcpu.a
B__MAIN_ADB_DEPS += $(OBJECT_DIRECTORY)/libcore.a
B__MAIN_ADB_DEPS += $(CLIBRARY_OBJECT)
B__MAIN_ADB_DEPS += $(GCC_GNAT_WRAPPER_TIMESTAMP_FILENAME)
$(OBJECT_DIRECTORY)/b__main.adb: $(B__MAIN_ADB_DEPS)
	@$(REM) bind all units and generate b__main
ifeq      ($(BUILD_MODE),GNATMAKE)
	$(call brief-command, \
        $(GNATBIND)                                \
                    -o b__main.adb                 \
                    -F -e -l -n -s                 \
                    -A=gnatbind_alis.lst           \
                    -O=gnatbind_objs.lst           \
                    $(foreach                      \
                      d,$(INCLUDE_DIRECTORIES),    \
                      -I$(d)                       \
                      )                            \
                    $(patsubst                     \
                      %,$(OBJECT_DIRECTORY)/%.ali, \
                      main $(IMPLICIT_ALI_UNITS)   \
                      )                            \
                    $(EXTERNAL_ALIS)               \
                    > gnatbind_elab.lst            \
        ,[GNATBIND],b__main.adb)
ifeq ($(OSTYPE),cmd)
	$(call create-emptyfile,gnatbind_alis.lst.tmp)
	@SETLOCAL ENABLEDELAYEDEXPANSION                    && \
        FOR /F "delims=?" %%A IN (gnatbind_alis.lst) DO        \
          (                                                    \
           SET "A1=%%A" && SET "A2=!A1:$(SWEETADA_PATH)/=!" && \
           (ECHO !A2!>>gnatbind_alis.lst.tmp)                  \
          )
	-@$(MV) .\gnatbind_alis.lst.tmp .\gnatbind_alis.lst
	@$(MV) b__main.ad* $(OBJECT_DIRECTORY)\ $(NULL)
else
ifeq ($(OSTYPE),darwin)
	sed -i '' -e "s|$(SWEETADA_PATH)/||g" gnatbind_alis.lst
else
	sed -i -e "s|$(SWEETADA_PATH)/||g" gnatbind_alis.lst
endif
	@$(MV) b__main.ad* $(OBJECT_DIRECTORY)/
endif
else ifeq ($(BUILD_MODE),GPRbuild)
	@$(REM) force rebind under GPRbuild
ifeq ($(OSTYPE),cmd)
	-@$(RM) $(OBJECT_DIRECTORY)\main.bexch
else
	-@$(RM) $(OBJECT_DIRECTORY)/main.bexch
endif
ifeq ($(OSTYPE),cmd)
	$(call brief-command, \
        (                                    \
         $(GPRBUILD)                         \
                     -b                      \
                     -P $(KERNEL_GPRFILE)    \
         || (ECHO __exitstatus__=1)          \
        ) | $(GPRBINDFILT) gnatbind_elab.lst \
        ,[GPRBUILD-B],$(KERNEL_GPRFILE))
else
	$(call brief-command, \
        (                                      \
         $(GPRBUILD)                           \
                     -b                        \
                     -P $(KERNEL_GPRFILE)      \
         || printf "%s\n" "__exitstatus__=$$?" \
        ) | $(GPRBINDFILT) gnatbind_elab.lst   \
        ,[GPRBUILD-B],$(KERNEL_GPRFILE))
endif
ifeq ($(OSTYPE),cmd)
	-@$(MV) $(OBJECT_DIRECTORY)\gnatbind_objs.lst .\ 2>nul
else
	-@$(MV) $(OBJECT_DIRECTORY)/gnatbind_objs.lst ./ 2> /dev/null
endif
endif
ifeq      ($(OSTYPE),cmd)
	$(call create-emptyfile,gnatbind_objs.lst.tmp)
ifeq      ($(BUILD_MODE),GNATMAKE)
	@SETLOCAL ENABLEDELAYEDEXPANSION                                       && \
        FOR /F "delims=?" %%U IN (gnatbind_objs.lst) DO                           \
          (                                                                       \
           ECHO $(foreach u,$(IMPLICIT_ALI_UNITS),$(OBJECT_DIRECTORY)/$(u).o)|    \
           %SystemRoot%\System32\findstr.exe >nul /C:"%%U"                     || \
           (CALL REM & ECHO %%U>>gnatbind_objs.lst.tmp)                           \
          )
else ifeq ($(BUILD_MODE),GPRbuild)
	@SETLOCAL ENABLEDELAYEDEXPANSION                                               && \
        SET "PWD=$(shell ECHO %CD%)"                                                   && \
        FOR /F "delims=?" %%U IN (gnatbind_objs.lst) DO                                   \
          (                                                                               \
           ECHO $(foreach u,$(IMPLICIT_ALI_UNITS),"!PWD!\$(OBJECT_DIRECTORY)\$(u).o")|    \
           %SystemRoot%\System32\findstr.exe >nul /C:"%%U"                             || \
           (                                                                              \
            CALL REM                                                                    & \
            SET "U1=%%U" && SET "U2=!U1:\=/!" && SET "U3=!U2: =\ !"                    && \
            (ECHO !U3!>>gnatbind_objs.lst.tmp)                                            \
           )                                                                              \
          )
endif
	-@$(MV) .\gnatbind_objs.lst.tmp .\gnatbind_objs.lst
else ifeq ($(OSTYPE),msys)
	@sed                                                   \
             -i                                                \
             -e "s|\\\\|/|g" -e "s| |\\\\ |g"                  \
             $(foreach u,$(IMPLICIT_ALI_UNITS),-e "/$(u).o/d") \
             gnatbind_objs.lst
else ifeq ($(OSTYPE),darwin)
	@sed                                                   \
             -i ''                                             \
             -e "s| |\\\\ |g"                                  \
             $(foreach u,$(IMPLICIT_ALI_UNITS),-e "/$(u).o/d") \
             gnatbind_objs.lst
else
	@sed                                                   \
             -i                                                \
             -e "s| |\\\\ |g"                                  \
             $(foreach u,$(IMPLICIT_ALI_UNITS),-e "/$(u).o/d") \
             gnatbind_objs.lst
endif

#
# Compile the binder-generated source file.
#

B__MAIN_O_DEPS :=
B__MAIN_O_DEPS += $(CORE_DIRECTORY)/linker.ads
B__MAIN_O_DEPS += $(CORE_DIRECTORY)/linker.adb
B__MAIN_O_DEPS += $(OBJECT_DIRECTORY)/b__main.adb
$(OBJECT_DIRECTORY)/b__main.o: $(B__MAIN_O_DEPS)
	@$(REM) compile the main program, incorporating the given elaboration order
ifeq      ($(BUILD_MODE),GNATMAKE)
ifeq ($(OSTYPE),cmd)
	$(call brief-command, \
        $(ADAC_GNATBIND)                                  \
                         -o $(OBJECT_DIRECTORY)\b__main.o \
                         -c                               \
                         $(OBJECT_DIRECTORY)\b__main.adb  \
        ,[ADAC],$(<F))
else
	$(call brief-command, \
        $(ADAC_GNATBIND)                                  \
                         -o $(OBJECT_DIRECTORY)/b__main.o \
                         -c                               \
                         $(OBJECT_DIRECTORY)/b__main.adb  \
        ,[ADAC],$(<F))
endif
endif

#
# Link phase.
#

ifeq ($(NOBUILD),Y)
$(KERNEL_OUTFILE):
else
KERNEL_OUTFILE_DEPS :=
KERNEL_OUTFILE_DEPS += $(DOTSWEETADA)
KERNEL_OUTFILE_DEPS += $(PLATFORM_DIRECTORY)/$(LD_SCRIPT)
KERNEL_OUTFILE_DEPS += $(OBJECT_DIRECTORY)/b__main.o
$(KERNEL_OUTFILE): $(KERNEL_OUTFILE_DEPS)
endif
	@$(REM) link phase
	$(call brief-command, \
        $(LD)                                       \
              -o $@                                 \
              -T $(PLATFORM_DIRECTORY)/$(LD_SCRIPT) \
              --start-group                         \
              @gnatbind_objs.lst                    \
              $(OBJECT_DIRECTORY)/b__main.o         \
              $(EXTERNAL_OBJECTS)                   \
              $(LIBM_OBJECT)                        \
              $(CLIBRARY_OBJECT)                    \
              $(OBJECT_DIRECTORY)/libcore.a         \
              $(LIBGNARL_OBJECT) $(LIBGNAT_OBJECT)  \
              $(OBJECT_DIRECTORY)/libcpu.a          \
              $(OBJECT_DIRECTORY)/libplatform.a     \
              $(LIBGCC_OBJECT)                      \
              --end-group                           \
        ,[LD],$@ @ $(LD_SCRIPT))
ifneq ($(OSTYPE),cmd)
	@chmod a-x $@
endif
	$(UPDATETM) -r $@ $(DOTSWEETADA)
	$(call brief-command, \
        $(OBJDUMP) -dx $@ > $(KERNEL_BASENAME).lst \
        ,[OBJDUMP],$(KERNEL_BASENAME).lst)
	$(call brief-command, \
        $(OBJDUMP) -Sdx $@ > $(KERNEL_BASENAME).src.lst \
        ,[OBJDUMP-S],$(KERNEL_BASENAME).src.lst)
	$(call brief-command, \
        $(READELF) $@ > $(KERNEL_BASENAME).elf.lst \
        ,[READELF],$(KERNEL_BASENAME).elf.lst)
	@$(call echo-print,"")
	@$(call echo-print,"$(PLATFORM): ELF sections dump.")
	@$(call echo-print,"")
ifeq ($(USE_ELFTOOL),Y)
	@$(ELFTOOL) -c dumpsections $@
	@$(call echo-print,"")
else
	@$(SIZE) $@
endif
ifeq ($(USE_ELFTOOL),Y)
	@$(ELFTOOL) -p "Kernel entry point: " -c findsymbol=$(KERNEL_ENTRY_POINT) $@
else
	@$(ELFSYMBOL) -p "Kernel entry point: " $(KERNEL_ENTRY_POINT) $@
endif
	@$(call echo-print,"")

#
# Auxiliary targets.
#

.PHONY: kernel_lib_obj_dir
kernel_lib_obj_dir:
ifeq ($(OSTYPE),cmd)
	@IF NOT EXIST $(LIBRARY_DIRECTORY)\ $(MKDIR) $(LIBRARY_DIRECTORY)
	@IF NOT EXIST $(OBJECT_DIRECTORY)\ $(MKDIR) $(OBJECT_DIRECTORY)
else
	@$(MKDIR) $(LIBRARY_DIRECTORY)
	@$(MKDIR) $(OBJECT_DIRECTORY)
endif

.PHONY: kernel_start
kernel_start:
ifneq ($(RTS_INSTALLED),Y)
	$(error Error: no RTS available)
endif
	@$(call echo-print,"")
	@$(call echo-print,"$(PLATFORM): start kernel build.")
	@$(call echo-print,"")

.PHONY: kernel_end
kernel_end:
	@$(call echo-print,"")
	@$(call echo-print,"$(PLATFORM): kernel compiled successfully.")
	@$(call echo-print,"")

$(KERNEL_BASENAME).lst     \
$(KERNEL_BASENAME).src.lst \
$(KERNEL_BASENAME).elf.lst: $(KERNEL_OUTFILE)

libgnat.lst      \
libgnat.elf.lst  \
libgnarl.lst     \
libgnarl.elf.lst: $(KERNEL_OUTFILE)
	@$(OBJDUMP) -Sdx $(LIBGNAT_OBJECT) > libgnat.lst
	@$(READELF) $(LIBGNAT_OBJECT) > libgnat.elf.lst
	@$(OBJDUMP) -Sdx $(LIBGNARL_OBJECT) > libgnarl.lst
	@$(READELF) $(LIBGNARL_OBJECT) > libgnarl.elf.lst

libgcc.lst     \
libgcc.elf.lst: $(KERNEL_OUTFILE)
	@$(OBJDUMP) -Sdx $(LIBGCC_OBJECT) > libgcc.lst
	@$(READELF) $(LIBGCC_OBJECT) > libgcc.elf.lst

.PHONY: kernel_libinfo
kernel_libinfo:
ifeq ($(USE_LIBGCC),Y)
kernel_libinfo: libgcc.lst libgcc.elf.lst
endif
kernel_libinfo: libgnat.lst libgnat.elf.lst libgnarl.lst libgnarl.elf.lst

.PHONY: kernel_info
kernel_info: kernel_libinfo             \
             $(KERNEL_BASENAME).lst     \
             $(KERNEL_BASENAME).src.lst \
             $(KERNEL_BASENAME).elf.lst

#
# Main targets.
#

.PHONY: $(KERNEL_BASENAME)
$(KERNEL_BASENAME): $(KERNEL_OUTFILE)

.PHONY: all
all: kernel_start       \
     $(KERNEL_BASENAME) \
     kernel_end         \
     kernel_info

#
# Configuration targets.
#

# create KERNEL_CFGFILE file and eventually install subplatform-dependent
# files (subsequent "configure" phase needs all target files in place)
.PHONY: createkernelcfg
createkernelcfg: kernel_lib_obj_dir
ifneq ($(filter $(PLATFORM),$(PLATFORMS)),)
	-$(MAKE) distclean
	@$(RM) $(KERNEL_CFGFILE)
	@$(call echo-print,"PLATFORM := $(PLATFORM)")> $(KERNEL_CFGFILE)
ifneq ($(SUBPLATFORM),)
	@$(call echo-print,"SUBPLATFORM := $(SUBPLATFORM)")>> $(KERNEL_CFGFILE)
endif
	@$(call echo-print,"")
	@$(call echo-print,"$(PLATFORM): configuration file $(KERNEL_CFGFILE) created successfully.")
	@$(call echo-print,"")
ifneq ($(SUBPLATFORM),)
	@$(REM) if SUBPLATFORM does exist, execute the "installfiles" target
	-@$(MAKE) $(MAKE_PLATFORM) installfiles
endif
else
	$(error Error: no valid PLATFORM, configuration not created)
endif

define configure-subdirs-command =
@$(MAKE) $(MAKE_APPLICATION) configure
@$(MAKE) $(MAKE_CLIBRARY) configure
@$(MAKE) $(MAKE_CORE) configure
@$(MAKE) $(MAKE_CPU) configure
@$(MAKE) $(MAKE_DRIVERS) configure
@$(MAKE) $(MAKE_MODULES) configure
@$(MAKE) $(MAKE_PLATFORM) configure
endef

DOTSWEETADA_DEPS :=
DOTSWEETADA_DEPS += $(CONFIGURE_DEPS)
DOTSWEETADA_DEPS += $(GNATADC_FILENAME)
DOTSWEETADA_DEPS += $(CONFIGUREGPR_FILENAME)
DOTSWEETADA_DEPS += $(filter-out $(CONFIGUREGPR_FILENAME),$(GPRBUILD_DEPS))
./$(DOTSWEETADA): $(DOTSWEETADA_DEPS)
	$(MAKE) clean
	$(configure-subdirs-command)
	$(UPDATETM) $@

.PHONY: configure-gnatadc
configure-gnatadc: $(GNATADC_FILENAME)
$(GNATADC_FILENAME): $(CONFIGURE_DEPS) $(GNATADC_FILENAME).in
ifneq ($(RTS_INSTALLED),Y)
	$(error Error: no RTS available)
endif
	$(CREATEGNATADC) "$(PROFILE)" $(GNATADC_FILENAME)

.PHONY: configure-gnattdi
configure-gnattdi:
ifeq ($(OSTYPE),cmd)
	-$(ADAC)                                            \
                 -c __tdi__.ads -gnatet=$(GNATTDI_FILENAME) \
                 1>nul 2>nul
else
	-$(ADAC)                                            \
                 -c __tdi__.ads -gnatet=$(GNATTDI_FILENAME) \
                 1> /dev/null 2> /dev/null
endif
	-$(RM) __tdi__.*

.PHONY: configure-configuregpr
configure-configuregpr: $(CONFIGUREGPR_FILENAME)
$(CONFIGUREGPR_FILENAME): $(CONFIGURE_DEPS)
ifneq ($(RTS_INSTALLED),Y)
	$(error Error: no RTS available)
endif
	$(CREATECONFIGUREGPR) Configure $(CONFIGUREGPR_FILENAME)

.PHONY: configure-subdirs
configure-subdirs:
	$(configure-subdirs-command)

.PHONY: configure-start
configure-start:
	@$(call echo-print,"")
	@$(call echo-print,"$(PLATFORM): start configuration.")
	@$(call echo-print,"")

.PHONY: configure-end
configure-end:
	@$(call echo-print,"")
	@$(call echo-print,"$(PLATFORM): configuration completed.")
	@$(call echo-print,"")

.PHONY: configure-linkeradsb
configure-linkeradsb: $(CORE_DIRECTORY)/linker.ads $(CORE_DIRECTORY)/linker.adb

.PHONY: configure-aux
CONFIGURE_AUX_DEPS :=
CONFIGURE_AUX_DEPS += configure-start
CONFIGURE_AUX_DEPS += configure-gnatadc
CONFIGURE_AUX_DEPS += configure-gnattdi
CONFIGURE_AUX_DEPS += configure-configuregpr
CONFIGURE_AUX_DEPS += configure-subdirs
CONFIGURE_AUX_DEPS += configure-linkeradsb
CONFIGURE_AUX_DEPS += configure-end
configure-aux: $(CONFIGURE_AUX_DEPS)

.PHONY: configure
configure: clean clean-configure configure-aux infodump
	$(UPDATETM) $(DOTSWEETADA)

.PHONY: infodump
infodump:
	@$(call echo-print,"Configuration parameters:")
	@$(call echo-print,"PLATFORM:                $(PLATFORM)")
ifneq ($(SUBPLATFORM),)
	@$(call echo-print,"SUBPLATFORM:             $(SUBPLATFORM)")
endif
	@$(call echo-print,"CPU:                     $(CPU)")
ifneq ($(CPU_MODEL),)
	@$(call echo-print,"CPU MODEL:               $(CPU_MODEL)")
endif
ifneq ($(FPU_MODEL),)
	@$(call echo-print,"FPU MODEL:               $(FPU_MODEL)")
endif
	@$(call echo-print,"OSTYPE:                  $(OSTYPE)")
	@$(call echo-print,"SHELL:                   $(SHELL)")
	@$(call echo-print,"SWEETADA PATH:           $(SWEETADA_PATH)")
	@$(call echo-print,"TOOLCHAIN PREFIX:        $(TOOLCHAIN_PREFIX)")
	@$(call echo-print,"TOOLCHAIN NAME:          $(TOOLCHAIN_NAME)")
	@$(call echo-print,"MAKE:                    $(MAKE)")
	@$(call echo-print,"MAKE VERSION:            $(MAKE_VERSION)")
	@$(call echo-print,"BUILD MODE:              $(BUILD_MODE)")
ifeq      ($(BUILD_MODE),GNATMAKE)
	@$(call echo-print,"GNATMAKE VERSION:        $(GNATMAKE_VERSION)")
else ifeq ($(BUILD_MODE),GPRbuild)
	@$(call echo-print,"GPRBUILD PREFIX:         $(GPRBUILD_PREFIX)")
	@$(call echo-print,"GPRBUILD VERSION:        $(GPRBUILD_VERSION)")
endif
ifneq ($(TOOLCHAIN_NAME),)
	@$(call echo-print,"GCC VERSION:             $(GCC_VERSION)")
	@$(call echo-print,"AS VERSION:              $(AS_VERSION)")
	@$(call echo-print,"LD VERSION:              $(LD_VERSION)")
endif
	@$(call echo-print,"RTS:                     $(RTS)")
	@$(call echo-print,"GNAT.ADC PROFILE:        $(PROFILE)")
	@$(call echo-print,"ADA MODE:                $(ADA_MODE)")
ifeq ($(USE_LIBGCC),Y)
	@$(call echo-print,"LIBGCC FILENAME:         $(LIBGCC_FILENAME)")
endif
ifeq ($(USE_LIBM),Y)
	@$(call echo-print,"LIBM FILENAME:           $(LIBM_FILENAME)")
endif
	@$(call echo-print,"USE CLIBRARY:            $(USE_CLIBRARY)")
	@$(call echo-print,"ELABORATION MODEL:       $(ELABORATION_MODEL)")
	@$(call echo-print,"OPTIMIZATION LEVEL:      $(OPTIMIZATION_LEVEL)")
ifneq ($(TOOLCHAIN_NAME),)
	@$(call echo-print,"ADA GCC SWITCHES (RTS):  $(strip $(ADAC_SWITCHES_RTS))")
	@$(call echo-print,"C GCC SWITCHES (RTS):    $(strip $(CC_SWITCHES_RTS))")
	@$(call echo-print,"GCC SWITCHES (PLATFORM): $(strip $(GCC_SWITCHES_PLATFORM))")
	@$(call echo-print,"GCC MULTIDIR:            $(GCC_MULTIDIR)")
ifneq ($(RTS),)
	@$(call echo-print,"RTS PATH:                $(RTS_PATH)")
endif
	@$(call echo-print,"LOWLEVEL FILES:          $(strip $(LOWLEVEL_FILES_PLATFORM))")
	@$(call echo-print,"GCC SWITCHES (LOWLEVEL): $(strip $(GCC_SWITCHES_LOWLEVEL_PLATFORM))")
	@$(call echo-print,"LD SCRIPT:               $(LD_SCRIPT)")
	@$(call echo-print,"LD SWITCHES:             $(strip $(LD_SWITCHES_PLATFORM))")
	@$(call echo-print,"OBJCOPY SWITCHES:        $(strip $(OBJCOPY_SWITCHES_PLATFORM))")
	@$(call echo-print,"OBJDUMP SWITCHES:        $(strip $(OBJDUMP_SWITCHES_PLATFORM))")
endif
ifneq ($(EXTERNAL_OBJECTS),)
	@$(call echo-print,"EXTERNAL OBJECTS:        $(EXTERNAL_OBJECTS)")
endif
	@$(call echo-print,"USE APPLICATION:         $(USE_APPLICATION)")
	@$(call echo-print,"KERNEL ENTRY POINT:      $(KERNEL_ENTRY_POINT)")
	@$(call echo-print,"")

#
# KERNEL_ROMFILE/postbuild/session-start/session-end/run/debug targets.
#
# Commands are executed with current directory = SWEETADA_PATH.
#

.PHONY: debug_notify_off
debug_notify_off: $(KERNEL_OUTFILE)
ifeq ($(USE_ELFTOOL),Y)
	$(call brief-command, \
        $(ELFTOOL) -c setdebugflag=0x00 $(KERNEL_OUTFILE) \
        ,[ELFTOOL],Debug_Flag=0)
endif

.PHONY: debug_notify_on
debug_notify_on: $(KERNEL_OUTFILE)
ifeq ($(USE_ELFTOOL),Y)
	$(call brief-command, \
        $(ELFTOOL) -c setdebugflag=0x01 $(KERNEL_OUTFILE) \
        ,[ELFTOOL],Debug_Flag=1)
endif

$(KERNEL_ROMFILE): $(KERNEL_OUTFILE)
ifeq ($(POSTBUILD_ROMFILE),Y)
	$(call brief-command, \
        $(OBJCOPY) $(KERNEL_OUTFILE) $(KERNEL_ROMFILE) \
        ,[OBJCOPY],$(KERNEL_ROMFILE))
ifneq ($(OSTYPE),cmd)
	@chmod a-x $(KERNEL_ROMFILE)
endif
endif

.PHONY: postbuild
postbuild: $(KERNEL_ROMFILE)
	@$(MAKE) $(MAKE_PLATFORM) postbuild

.PHONY: session-start
session-start:
ifneq ($(SESSION_START_COMMAND),)
	-$(SESSION_START_COMMAND)
else
	$(error Error: no SESSION_START_COMMAND defined)
endif

.PHONY: session-end
session-end:
ifneq ($(SESSION_END_COMMAND),)
	-$(SESSION_END_COMMAND)
else
	$(error Error: no SESSION_END_COMMAND defined)
endif

.PHONY: run
run: debug_notify_off
	$(MAKE) NOBUILD=Y postbuild
ifneq ($(RUN_COMMAND),)
	-$(RUN_COMMAND)
else
	$(error Error: no RUN_COMMAND defined)
endif

.PHONY: debug
debug: debug_notify_on
	$(MAKE) NOBUILD=Y postbuild
ifneq ($(DEBUG_COMMAND),)
	-$(DEBUG_COMMAND)
else
	$(error Error: no DEBUG_COMMAND defined)
endif

#
# RTS.
#

.PHONY: rts
rts: clean clean-configure
ifeq ($(OSTYPE),cmd)
	@SETLOCAL ENABLEDELAYEDEXPANSION                                  && \
        FOR %%M IN ($(foreach m,$(GCC_MULTILIBS),"$(m)")) DO                 \
          (                                                                  \
           ECHO.&& ECHO $(CPU): RTS = $(RTS_BUILD), multilib = %%M&& ECHO.&& \
           SET "MAKEFLAGS=" && SET "RTS=$(RTS_BUILD)"                     && \
           "$(MAKE)" $(MAKE_RTS) MULTILIB=%%M configure                   && \
           "$(MAKE)" $(MAKE_RTS) MULTILIB=%%M multilib                       \
          ) || EXIT /B 1
else
	for m in $(foreach m,$(GCC_MULTILIBS),"$(m)") ; do                               \
          (                                                                              \
           printf "%s\n" ""                                                           && \
           printf "%s\n" "$(CPU): RTS = $(RTS_BUILD), multilib = \"$$m\""             && \
           printf "%s\n" ""                                                           && \
           MAKEFLAGS= RTS=$(RTS_BUILD) "$(MAKE)" $(MAKE_RTS) MULTILIB="$$m" configure && \
           MAKEFLAGS= RTS=$(RTS_BUILD) "$(MAKE)" $(MAKE_RTS) MULTILIB="$$m" multilib     \
          ) || exit $$? ;                                                                \
        done
endif

#
# Cleaning targets.
#

.PHONY: clean
clean:
ifeq ($(OSTYPE),cmd)
	-IF EXIST $(LIBRARY_DIRECTORY)\    \
          $(CHDIR) $(LIBRARY_DIRECTORY) && \
          DEL /F /Q 2>nul *.*
	-IF EXIST $(OBJECT_DIRECTORY)\                \
          $(CHDIR) $(OBJECT_DIRECTORY)             && \
          DEL /F /Q 2>nul *.*                      && \
          $(RMDIR) ..\$(OBJECT_DIRECTORY)\ $(NULL)
else
	-$(RM) $(LIBRARY_DIRECTORY)/*
	-$(RMDIR) $(OBJECT_DIRECTORY)/*
endif
	$(MAKE) $(MAKE_APPLICATION) clean
	$(MAKE) $(MAKE_CLIBRARY) clean
	$(MAKE) $(MAKE_CORE) clean
ifneq ($(CPU),)
ifeq ($(filter $(CPU),$(CPUS)),$(CPU))
	$(MAKE) $(MAKE_CPU) clean
endif
endif
	$(MAKE) $(MAKE_DRIVERS) clean
	$(MAKE) $(MAKE_MODULES) clean
ifneq ($(PLATFORM),)
ifeq ($(filter $(PLATFORM),$(PLATFORMS)),$(PLATFORM))
	$(MAKE) $(MAKE_PLATFORM) clean
endif
endif
	-$(RM) $(CLEAN_OBJECTS)

.PHONY: clean-configure
clean-configure:
	@-$(RM) $(GNATADC_FILENAME)
	@-$(RM) $(CONFIGUREGPR_FILENAME)
ifeq ($(OSTYPE),cmd)
	@-$(RM) $(CORE_DIRECTORY)\linker.ad*
else
	@-$(RM) $(CORE_DIRECTORY)/linker.ad*
endif

.PHONY: distclean
distclean: clean
	$(MAKE) $(MAKE_APPLICATION) distclean
	$(MAKE) $(MAKE_CLIBRARY) distclean
	$(MAKE) $(MAKE_CORE) distclean
ifneq ($(CPU),)
	$(MAKE) $(MAKE_CPU) distclean
endif
	$(MAKE) $(MAKE_DRIVERS) distclean
	$(MAKE) $(MAKE_MODULES) distclean
ifneq ($(PLATFORM),)
	$(MAKE) $(MAKE_PLATFORM) distclean
endif
	$(RM) $(DISTCLEAN_OBJECTS)

#
# Utility targets.
#

#
# Check basic tools.
#
.PHONY: tools-check
tools-check:
	$(GCC_WRAPPER) -v
	$(GNAT_WRAPPER) -v
ifeq ($(USE_ELFTOOL),Y)
	$(ELFTOOL) -v
endif

#
# Libutils tools.
#
.PHONY: libutils-elftool
libutils-elftool:
	$(MAKE) -C $(LIBUTILS_DIRECTORY)/src/ELFtool clean
	$(MAKE) -C $(LIBUTILS_DIRECTORY)/src/ELFtool all
	$(MAKE) -C $(LIBUTILS_DIRECTORY)/src/ELFtool install
.PHONY: libutils-gcc-wrapper
libutils-gcc-wrapper:
	$(MAKE) -C $(LIBUTILS_DIRECTORY)/src/GCC-wrapper clean
	$(MAKE) -C $(LIBUTILS_DIRECTORY)/src/GCC-wrapper all
	$(MAKE) -C $(LIBUTILS_DIRECTORY)/src/GCC-wrapper install
.PHONY: libutils-gnat-wrapper
libutils-gnat-wrapper:
	$(MAKE) -C $(LIBUTILS_DIRECTORY)/src/GNAT-wrapper clean
	$(MAKE) -C $(LIBUTILS_DIRECTORY)/src/GNAT-wrapper all
	$(MAKE) -C $(LIBUTILS_DIRECTORY)/src/GNAT-wrapper install

#
# Probe variable values.
#
# Example:
# $ VERBOSE= PROBEVARIABLE="PLATFORMS" make probevariable 2> /dev/null
# $ VERBOSE= PROBEVARIABLES="OSTYPE PLATFORMS" make probevariables 2> /dev/null
#

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

