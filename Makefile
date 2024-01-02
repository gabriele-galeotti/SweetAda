
#
# Master Makefile
#
# Copyright (C) 2020-2024 Gabriele Galeotti
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
# NOBUILD
# PROBEVARIABLE
#

################################################################################
#                                                                              #
# Setup initialization.                                                        #
#                                                                              #
################################################################################

.POSIX:

.NOTPARALLEL:

.DEFAULT_GOAL := help

NULL  :=
SPACE := $(NULL) $(NULL)
export NULL SPACE

KERNEL_BASENAME := kernel

LIBUTILS_GOALS := libutils-elftool      \
                  libutils-gcc-wrapper  \
                  libutils-gnat-wrapper

SERVICE_GOALS := help              \
                 $(LIBUTILS_GOALS) \
                 infodump          \
                 createkernelcfg   \
                 clean             \
                 distclean         \
                 freeze            \
                 probevariable

RTS_GOAL := rts

NON_PLATFORM_GOALS := $(SERVICE_GOALS) \
                      $(RTS_GOAL)

PLATFORM_GOALS := configure          \
                  configure-subdirs  \
                  all                \
                  $(KERNEL_BASENAME) \
                  kernel_libinfo     \
                  kernel_info        \
                  postbuild          \
                  session-start      \
                  session-end        \
                  run                \
                  debug

ALL_GOALS := $(NON_PLATFORM_GOALS) \
             $(PLATFORM_GOALS)

# check Makefile target
NON_MAKEFILE_TARGETS := $(filter-out $(ALL_GOALS),$(MAKECMDGOALS))
ifneq ($(NON_MAKEFILE_TARGETS),)
$(error Error: $(NON_MAKEFILE_TARGETS): no known Makefile target)
endif

# detect OS type
# detected OS names: "cmd"/"msys"/"darwin"/"linux"
ifeq ($(OS),Windows_NT)
ifneq ($(MSYSTEM),)
OSTYPE := msys
else
OSTYPE := cmd
endif
else
OSTYPE_UNAME := $(shell uname -s 2> /dev/null)
ifeq      ($(OSTYPE_UNAME),Darwin)
OSTYPE := darwin
else ifeq ($(OSTYPE_UNAME),Linux)
OSTYPE := linux
else
$(error Error: no valid OSTYPE)
endif
endif
export OSTYPE

# workarounds for some environments
ifeq      ($(OSTYPE),cmd)
SHELL := cmd
else ifeq ($(OSTYPE),msys)
export temp :=
export tmp :=
endif

# executable and script extensions
SCREXT_cmd := .bat
SCREXT_unx := .sh
ifeq ($(OSTYPE),cmd)
EXEEXT     := .exe
SCREXT     := $(SCREXT_cmd)
SHELL_EXEC := $(SHELL) /C
else
ifeq ($(OSTYPE),msys)
EXEEXT     := .exe
else
EXEEXT     :=
endif
SCREXT     := $(SCREXT_unx)
SHELL_EXEC := $(SHELL)
endif
export EXEEXT SCREXT_cmd SCREXT_unx SCREXT SHELL_EXEC

# define a minimum set of variables that are required for functions and
# various utilities
ifeq ($(OSTYPE),cmd)
ECHO := ECHO
REM  := REM
else
ECHO := printf "%s\n"
REM  := \#
endif
SED  := sed$(EXEEXT)
export ECHO REM SED

# TMPDIR handling
ifeq      ($(OSTYPE),cmd)
TMPDIR := $(TEMP)
else ifeq ($(OSTYPE),msys)
TMPDIR := $(TEMP)
else
TMPDIR ?= /tmp
endif
export TMPDIR

# generate SWEETADA_PATH
MAKEFILEDIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
SWEETADA_PATH ?= $(MAKEFILEDIR)
export SWEETADA_PATH

# include the utilities
LIBUTILS_DIRECTORY := libutils
export LIBUTILS_DIRECTORY
# add LIBUTILS_DIRECTORY to PATH
ifeq      ($(OSTYPE),cmd)
PATH := $(SWEETADA_PATH)\$(LIBUTILS_DIRECTORY);$(PATH)
else ifeq ($(OSTYPE),msys)
PATH := $(PATH):$(SWEETADA_PATH)/$(LIBUTILS_DIRECTORY)
else
PATH := $(SWEETADA_PATH)/$(LIBUTILS_DIRECTORY):$(PATH)
endif
include Makefile.ut.in

# check for RTS build
ifeq ($(MAKECMDGOALS),$(RTS_GOAL))
# before loading configuration.in (which defines the RTS type used by the
# platform), save the RTS variable from the environment in order to correctly
# build the RTS specified when issuing the "rts" target
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
USE_LIBADA         :=
USE_CLIBRARY       :=
USE_APPLICATION    := dummy
OPTIMIZATION_LEVEL :=
STACK_LIMIT        := 4096
LD_SCRIPT          := linker.lds
POSTBUILD_ROMFILE  :=

IMPLICIT_ALI_UNITS :=
EXTERNAL_OBJECTS   :=

# initialize configuration dependencies
CONFIGURE_FILES_PLATFORM :=
CONFIGURE_DEPS           :=
GPRBUILD_DEPS            :=

# read the master configuration file
include configuration.in
CONFIGURE_DEPS += configuration.in

ifneq ($(filter $(RTS_GOAL) $(PLATFORM_GOALS),$(MAKECMDGOALS)),)
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

# export PATH so that we can use everything
export PATH

# check basic utilities
ifeq ($(TOOLS_CHECK),Y)
-include Makefile.ck.in
endif

# detect Make version
ifeq ($(OSTYPE),cmd)
MAKE_VERSION := $(shell SET "PATH=$(PATH)" && "$(MAKE)" --version 2> nul| $(SED) -e "2,$$d")
else
MAKE_VERSION := $(shell PATH="$(PATH)" "$(MAKE)" --version 2> /dev/null | $(SED) -e "2,\$$d")
endif

################################################################################
#                                                                              #
# Setup finalization.                                                          #
#                                                                              #
################################################################################

# verbose output, "Y/y/1" = enabled
VERBOSE ?=
# normalize VERBOSE
ifeq ($(OSTYPE),cmd)
override VERBOSE := $(shell $(ECHO) $(VERBOSE)| $(SED) -e "s|\(.\).*|\1|" -e "s|[y|1]|Y|")
else
override VERBOSE := $(shell $(ECHO) "$(VERBOSE)" | $(SED) -e "s|\(.\).*|\1|" -e "s|[y|1]|Y|")
endif
export VERBOSE

# load complex functions
include Makefile.fn.in

# define every other OS command
ifeq ($(OSTYPE),cmd)
CAT   := TYPE
CD    := CD
CP    := COPY /B /Y 1> nul
LS    := DIR /B
MKDIR := MKDIR
MV    := MOVE /Y 1> nul
RM    := DEL /F /Q 2> nul
RMDIR := RMDIR /Q /S 2> nul
TOUCH := TYPE nul >
else
# POSIX
CAT   := cat
CD    := cd
CP    := cp -f
LS    := ls -A
MKDIR := mkdir -p
MV    := mv -f
RM    := rm -f
RMDIR := $(RM) -r
TOUCH := touch
endif
ifeq ($(OSTYPE),msys)
CP += --preserve=all
endif

ifeq ($(VERBOSE),Y)
ifeq ($(OSTYPE),cmd)
# no verbosity
else
CP += -v
MV += -v
RM += -v
endif
else
ifeq ($(filter $(MAKECMDGOALS),$(LIBUTILS_GOALS)),)
MAKEFLAGS += s
endif
GNUMAKEFLAGS += --no-print-directory
endif

export CAT CD CP LS MKDIR MV RM RMDIR TOUCH

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

# RTS_BASE_PATH: where all RTSes live
RTS_BASE_PATH := $(SWEETADA_PATH)/$(RTS_DIRECTORY)

# PLATFORMS and CPUs
ifeq ($(OSTYPE),cmd)
PLATFORMS := $(shell $(CD) $(PLATFORM_BASE_DIRECTORY) && $(call ls-dirs) 2> nul)
CPUS      := $(shell $(CD) $(CPU_BASE_DIRECTORY) && $(call ls-dirs) 2> nul)
else
PLATFORMS := $(shell ($(CD) $(PLATFORM_BASE_DIRECTORY) && $(call ls-dirs)) 2> /dev/null)
CPUS      := $(shell ($(CD) $(CPU_BASE_DIRECTORY) && $(call ls-dirs)) 2> /dev/null)
endif

# RTSes
RTS_SRC_NO_DIRS  := common targets
ifeq ($(OSTYPE),cmd)
RTS_SRC_ALL_DIRS := $(shell $(CD) $(RTS_DIRECTORY)\src && $(call ls-dirs) 2> nul)
else
RTS_SRC_ALL_DIRS := $(shell ($(CD) $(RTS_DIRECTORY)/src && $(call ls-dirs)) 2> /dev/null)
endif
RTSES            := $(filter-out $(RTS_SRC_NO_DIRS),$(RTS_SRC_ALL_DIRS))

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

# GPRbuild filenames
KERNEL_GPRFILE        := sweetada.gpr
CONFIGUREGPR_FILENAME := configure.gpr

# cleaning
CLEAN_OBJECTS_COMMON     := *.a *.aout *.bin *.d *.dwo *.elf *.hex *.log *.lst \
                            *.map *.o *.out* *.srec *.td *.tmp
DISTCLEAN_OBJECTS_COMMON := $(GNATADC_FILENAME)

################################################################################
#                                                                              #
# Initialize toolchain variables.                                              #
#                                                                              #
################################################################################

#
# TOOLCHAIN_NAME: initialized by configuration.
# TOOLCHAIN_PROGRAM_PREFIX: synthesized from TOOLCHAIN_NAME.
# GCC_VERSION: is the GCC version string; if empty, the toolchain is believed
# to be non-existent.
# LIBGCC_FILENAME: is the filename of the "multilib" LibGCC determined by
# compiler configuration switches.
# RTS_ROOT_PATH: RTS path of a specific toolchain, which contains all its
# various "multilib" RTSes, arranged in a classic LibGCC-hierarchy fashion.
# RTS_PATH: is the specific path of a well-defined "multilib" RTS (e.g., the
# multilib subdirectory used by the build system), determined by compiler
# configuration switches.
# PLATFORM_DIRECTORY: directory of the configured platform
# CPU_DIRECTORY: directory of the configured CPU
#
TOOLCHAIN_NAME           :=
TOOLCHAIN_PROGRAM_PREFIX :=
GCC_VERSION              :=
LIBGCC_FILENAME          :=
RTS_ROOT_PATH            :=
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
# Initialize RTS-imported toolchain switches.
#
ADAC_SWITCHES_RTS :=
CC_SWITCHES_RTS   :=

#
# Initialize include directories and implicit units.
#
INCLUDE_DIRECTORIES     :=
CPU_INCLUDE_DIRECTORIES :=
IMPLICIT_CORE_UNITS     :=
IMPLICIT_CLIBRARY_UNITS :=

#
# Various features.
#
GNATBIND_SECSTACK       :=
USE_UNPREFIXED_GNATMAKE :=
CPU_SUPPORT_DEFLIST     :=
ENABLE_SPLIT_DWARF      :=

################################################################################
#                                                                              #
# Global PLATFORM/CPU configuration logic.                                     #
#                                                                              #
################################################################################

#
# PLATFORM should be always defined, but when a generic goal is issued, no
# diagnostic messages are shown (avoiding output text corruption with, e.g.,
# the "probevariable" target).
#

# try to read PLATFORM from configuration file
ifneq ($(filter createkernelcfg,$(MAKECMDGOALS)),createkernelcfg)
-include $(KERNEL_CFGFILE)
endif

# declare all toolchain-related informations
ifneq ($(PLATFORM),)
# platform known
PLATFORM_DIRECTORY     := $(PLATFORM_BASE_DIRECTORY)/$(PLATFORM)
PLATFORM_DIRECTORY_CMD := $(PLATFORM_BASE_DIRECTORY)\$(PLATFORM)
ifneq ($(filter createkernelcfg,$(MAKECMDGOALS)),createkernelcfg)
include $(PLATFORM_DIRECTORY)/configuration.in
CONFIGURE_DEPS += $(PLATFORM_DIRECTORY)/configuration.in
endif
else
# platform not known, output an error message
ifneq ($(filter $(PLATFORM_GOALS),$(MAKECMDGOALS)),)
$(error Error: no valid PLATFORM)
endif
endif

ifneq ($(CPU),)
# CPU known
CPU_DIRECTORY     := $(CPU_BASE_DIRECTORY)/$(CPU)
CPU_DIRECTORY_CMD := $(CPU_BASE_DIRECTORY)\$(CPU)
include $(CPU_DIRECTORY)/configuration.in
CONFIGURE_DEPS += $(CPU_DIRECTORY)/configuration.in
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

# GPRbuild configuration dependencies
ifeq ($(BUILD_MODE),GPRbuild)
ifeq ($(OSTYPE),cmd)
GPRBUILD_DEPS += $(sort $(shell                                                   \
                                SET "PATH=$(PATH)"                             && \
                                SET "SWEETADA_PATH=$(SWEETADA_PATH)"           && \
                                SET "LIBUTILS_DIRECTORY=$(LIBUTILS_DIRECTORY)" && \
                                $(GPRDEPS) $(KERNEL_GPRFILE)                      \
                                2> nul))
else
GPRBUILD_DEPS += $(sort $(shell                                               \
                                PATH="$(PATH)"                             && \
                                SWEETADA_PATH="$(SWEETADA_PATH)"           && \
                                LIBUTILS_DIRECTORY="$(LIBUTILS_DIRECTORY)" && \
                                $(GPRDEPS) $(KERNEL_GPRFILE)                  \
                                2> /dev/null))
endif
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
# head-insert CPU_MODEL directory
ifneq ($(CPU_MODEL_DIRECTORY),)
INCLUDE_DIRECTORIES := $(CPU_MODEL_DIRECTORY) $(INCLUDE_DIRECTORIES)
endif
# head-insert optional directories
ifneq ($(CPU_INCLUDE_DIRECTORIES),)
INCLUDE_DIRECTORIES := $(CPU_INCLUDE_DIRECTORIES) $(INCLUDE_DIRECTORIES)
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
       CPU_DIRECTORY_CMD         \
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
       RTS_BASE_PATH             \
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
       TOOLCHAIN_OBJDUMP         \
       TOOLCHAIN_RANLIB          \
       GCC_VERSION               \
       RTS_ROOT_PATH             \
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
       BUILD_MODE                     \
       OPTIMIZATION_LEVEL             \
       RTS                            \
       PROFILE                        \
       ADA_MODE                       \
       USE_LIBGCC                     \
       USE_LIBM                       \
       USE_LIBADA                     \
       USE_CLIBRARY                   \
       USE_APPLICATION                \
       CONFIGURE_FILES_PLATFORM       \
       GCC_SWITCHES_PLATFORM          \
       LOWLEVEL_FILES_PLATFORM        \
       GCC_SWITCHES_LOWLEVEL_PLATFORM \
       EXTERNAL_OBJECTS               \
       STACK_LIMIT                    \
       GNATBIND_SECSTACK              \
       POSTBUILD_COMMAND              \
       CPU_SUPPORT_DEFLIST

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

INCLUDES := $(foreach d,$(INCLUDE_DIRECTORIES),-I$(d))

ifeq ($(BUILD_MODE),GNATMAKE)
IMPLICIT_ALI_UNITS_GNATMAKE := $(patsubst %,$(OBJECT_DIRECTORY)/%.ali,$(IMPLICIT_ALI_UNITS))
endif

CLEAN_OBJECTS     := $(KERNEL_OBJFILE)       \
                     $(KERNEL_OUTFILE)       \
                     $(KERNEL_ROMFILE)       \
                     $(CLEAN_OBJECTS_COMMON)

DISTCLEAN_OBJECTS := $(KERNEL_CFGFILE)           \
                     $(CONFIGUREGPR_FILENAME)    \
                     $(DISTCLEAN_OBJECTS_COMMON)

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
LIBM_OBJECT := "$(TOOLCHAIN_PREFIX)"/$(TOOLCHAIN_NAME)/lib/$(GCC_MULTIDIR)/libm.a
else
LIBM_OBJECT :=
endif

ifneq ($(RTS),zfp)
USE_LIBADA := Y
endif

ifeq ($(USE_LIBADA),Y)
ifeq ($(OSTYPE),msys)
LIBGNAT_OBJECT  := "$(shell cygpath.exe -m "$(RTS_PATH)")"/adalib/libgnat.a
LIBGNARL_OBJECT := "$(shell cygpath.exe -m "$(RTS_PATH)")"/adalib/libgnarl.a
else
LIBGNAT_OBJECT  := "$(RTS_PATH)"/adalib/libgnat.a
LIBGNARL_OBJECT := "$(RTS_PATH)"/adalib/libgnarl.a
endif
LIBADA_OBJECTS  := $(LIBGNAT_OBJECT) $(LIBGNARL_OBJECT)
else
LIBADA_OBJECTS  :=
endif

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
	@$(call echo-print,"  Display an help about make targets.")
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
	@$(call echo-print,"make libutils-elftool")
	@$(call echo-print,"  Build ELFtool.")
	@$(call echo-print,"make libutils-gcc-wrapper")
	@$(call echo-print,"  Build GCC-wrapper.")
	@$(call echo-print,"make libutils-gnat-wrapper")
	@$(call echo-print,"  Build GNAT-wrapper.")
	@$(call echo-print,"make PROBEVARIABLE=<variablename> probevariable")
	@$(call echo-print,"  Obtain the value of a variable.")
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

$(OBJECT_DIRECTORY)/libcore.a: FORCE
	$(MAKE) $(MAKE_CORE) all

$(OBJECT_DIRECTORY)/libcpu.a: FORCE
	$(MAKE) $(MAKE_CPU) all

$(OBJECT_DIRECTORY)/libplatform.a: FORCE
	$(MAKE) $(MAKE_PLATFORM) all

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
                    $(INCLUDES)                 \
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
B__MAIN_ADB_DEPS += $(OBJECT_DIRECTORY)/libcore.a
B__MAIN_ADB_DEPS += $(OBJECT_DIRECTORY)/libcpu.a
B__MAIN_ADB_DEPS += $(OBJECT_DIRECTORY)/libplatform.a
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
                    $(INCLUDES)                    \
                    $(OBJECT_DIRECTORY)/main.ali   \
                    $(IMPLICIT_ALI_UNITS_GNATMAKE) \
                    > gnatbind_elab.lst            \
        ,[GNATBIND],b__main.adb)
ifeq ($(OSTYPE),cmd)
	@$(MV) b__main.ad* $(OBJECT_DIRECTORY)\ $(NULL)
else
	@$(MV) b__main.ad* $(OBJECT_DIRECTORY)/
endif
else ifeq ($(BUILD_MODE),GPRbuild)
	@$(REM) force rebind under GPRbuild
ifeq ($(OSTYPE),cmd)
	-@$(RM) $(OBJECT_DIRECTORY)\main.bexch
else
	-@$(RM) $(OBJECT_DIRECTORY)/main.bexch
endif
	$(call brief-command, \
        $(GPRBUILD)                      \
                    -b                   \
                    -P $(KERNEL_GPRFILE) \
                    > gnatbind_elab.lst  \
        ,[GPRBUILD-B],$(KERNEL_GPRFILE))
ifeq ($(OSTYPE),cmd)
	-@$(MV) $(OBJECT_DIRECTORY)\gnatbind_objs.lst .\ 2> nul
else
	-@$(MV) $(OBJECT_DIRECTORY)/gnatbind_objs.lst ./ 2> /dev/null
endif
endif

#
# Compile the binder-generated source file.
#

$(OBJECT_DIRECTORY)/b__main.o: $(OBJECT_DIRECTORY)/b__main.adb
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
else ifeq ($(BUILD_MODE),GPRbuild)
	-@$(RM) $(GCC_WRAPPER_TIMESTAMP_FILENAME)
endif
ifeq      ($(OSTYPE),cmd)
	@$(SED) -i -e "s|\\|/|g" -e "s| |\\ |g" gnatbind_objs.lst
else ifeq ($(OSTYPE),msys)
	@$(SED) -i -e "s|\\\\|/|g" -e "s| |\\\\ |g" gnatbind_objs.lst
else ifeq ($(OSTYPE),darwin)
	@$(SED) -i '' -e "s| |\\\\ |g" gnatbind_objs.lst
else
	@$(SED) -i -e "s| |\\\\ |g" gnatbind_objs.lst
endif

#
# Link phase.
#

$(PLATFORM_DIRECTORY)/%.lds: $(PLATFORM_DIRECTORY)/%.lds.S
	$(CPP) -o $@ -E $<

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
              $(LIBADA_OBJECTS)                     \
              $(OBJECT_DIRECTORY)/libcpu.a          \
              $(OBJECT_DIRECTORY)/libplatform.a     \
              $(LIBGCC_OBJECT)                      \
              --end-group                           \
        ,[LD],$@)
ifneq ($(OSTYPE),cmd)
	@chmod a-x $@
endif
	$(call update-timestamp-reffile,$@,$(DOTSWEETADA))
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
else
	@$(SIZE) $@
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
ifeq ($(GCC_VERSION),)
	$(error Error: no valid toolchain)
endif
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
ifeq ($(USE_LIBADA),Y)
kernel_libinfo: libgnat.lst libgnat.elf.lst libgnarl.lst libgnarl.elf.lst
endif
ifeq ($(USE_LIBGCC),Y)
kernel_libinfo: libgcc.lst libgcc.elf.lst
endif

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
     kernel_lib_obj_dir \
     $(KERNEL_BASENAME) \
     kernel_end         \
     kernel_info

#
# Configuration targets.
#

# create KERNEL_CFGFILE file and eventually install subplatform-dependent
# files (subsequent "configure" phase needs all target files in place)
.PHONY: createkernelcfg
createkernelcfg:
	$(MAKE) distclean
ifneq ($(PLATFORM),)
	@$(RM) $(KERNEL_CFGFILE)
	@$(TOUCH) $(KERNEL_CFGFILE)
	@$(call echo-print,"PLATFORM := $(PLATFORM)")>> $(KERNEL_CFGFILE)
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
ifeq ($(BUILD_MODE),GPRbuild)
DOTSWEETADA_DEPS += $(GPRBUILD_DEPS)
endif
./$(DOTSWEETADA): $(DOTSWEETADA_DEPS)
	$(MAKE) clean
	$(configure-subdirs-command)
	$(TOUCH) $@

.PHONY: configure-gnatadc
configure-gnatadc: $(GNATADC_FILENAME)
$(GNATADC_FILENAME): $(CONFIGURE_DEPS) $(GNATADC_FILENAME).in
ifneq ($(RTS_INSTALLED),Y)
	$(error Error: no RTS available)
endif
	$(CREATEGNATADC) $(PROFILE) $(GNATADC_FILENAME)

ifeq ($(BUILD_MODE),GPRbuild)
.PHONY: configure-gpr
configure-gpr: $(CONFIGUREGPR_FILENAME)
$(CONFIGUREGPR_FILENAME): $(CONFIGURE_DEPS)
ifneq ($(RTS_INSTALLED),Y)
	$(error Error: no RTS available)
endif
	$(CREATECONFIGUREGPR) Configure $(CONFIGUREGPR_FILENAME)
endif

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

.PHONY: configure-delete
configure-delete:
	@$(RM) $(GNATADC_FILENAME)
ifeq ($(BUILD_MODE),GPRbuild)
	@$(RM) $(CONFIGUREGPR_FILENAME)
endif

.PHONY: configure-aux
CONFIGURE_AUX_DEPS :=
CONFIGURE_AUX_DEPS += configure-start
CONFIGURE_AUX_DEPS += configure-gnatadc
ifeq ($(BUILD_MODE),GPRbuild)
CONFIGURE_AUX_DEPS += configure-gpr
endif
CONFIGURE_AUX_DEPS += configure-subdirs
CONFIGURE_AUX_DEPS += configure-end
configure-aux: $(CONFIGURE_AUX_DEPS)

.PHONY: configure
configure: clean configure-delete configure-aux infodump
	$(TOUCH) $(DOTSWEETADA)

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
ifeq ($(BUILD_MODE),GPRbuild)
	@$(call echo-print,"GPRBUILD PREFIX:         $(GPRBUILD_PREFIX)")
endif
	@$(call echo-print,"TOOLCHAIN NAME:          $(TOOLCHAIN_NAME)")
	@$(call echo-print,"MAKE VERSION:            $(MAKE_VERSION)")
	@$(call echo-print,"BUILD MODE:              $(BUILD_MODE)")
ifneq ($(TOOLCHAIN_NAME),)
	@$(call echo-print,"GCC VERSION:             $(GCC_VERSION)")
	@$(call echo-print,"AS VERSION:              $(AS_VERSION)")
	@$(call echo-print,"LD VERSION:              $(LD_VERSION)")
endif
ifeq      ($(BUILD_MODE),GNATMAKE)
	@$(call echo-print,"GNATMAKE VERSION:        $(GNATMAKE_VERSION)")
else ifeq ($(BUILD_MODE),GPRbuild)
	@$(call echo-print,"GPRBUILD VERSION:        $(GPRBUILD_VERSION)")
endif
	@$(call echo-print,"GCC MULTIDIR:            $(GCC_MULTIDIR)")
	@$(call echo-print,"RTS:                     $(RTS)")
	@$(call echo-print,"GNAT.ADC PROFILE:        $(PROFILE)")
ifneq ($(RTS),)
	@$(call echo-print,"RTS ROOT PATH:           $(RTS_ROOT_PATH)")
	@$(call echo-print,"RTS PATH:                $(RTS_PATH)")
endif
	@$(call echo-print,"ADA MODE:                $(ADA_MODE)")
ifeq ($(USE_LIBGCC),Y)
	@$(call echo-print,"LIBGCC FILENAME:         $(LIBGCC_OBJECT)")
endif
ifeq ($(USE_LIBM),Y)
	@$(call echo-print,"LIBM FILENAME:           $(LIBM_OBJECT)")
endif
	@$(call echo-print,"USE LIBADA:              $(USE_LIBADA)")
	@$(call echo-print,"USE CLIBRARY:            $(USE_CLIBRARY)")
	@$(call echo-print,"OPTIMIZATION LEVEL:      $(OPTIMIZATION_LEVEL)")
ifneq ($(TOOLCHAIN_NAME),)
	@$(call echo-print,"ADA GCC SWITCHES (RTS):  $(strip $(ADAC_SWITCHES_RTS))")
	@$(call echo-print,"C GCC SWITCHES (RTS):    $(strip $(CC_SWITCHES_RTS))")
	@$(call echo-print,"GCC SWITCHES (PLATFORM): $(strip $(GCC_SWITCHES_PLATFORM))")
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
	@$(call echo-print,"")

#
# KERNEL_ROMFILE/postbuild/session-start/session-end/run/debug targets.
#
# Commands are executed with current directory = SWEETADA_PATH.
#

.PHONY: debug_notify_off
debug_notify_off: $(KERNEL_OUTFILE)
ifeq ($(USE_ELFTOOL),Y)
	@$(REM) patch Debug_Flag := False
	$(call brief-command, \
        $(ELFTOOL) -c setdebugflag=0x00 $(KERNEL_OUTFILE) \
        ,[ELFTOOL],Debug_Flag: 0)
endif

.PHONY: debug_notify_on
debug_notify_on: $(KERNEL_OUTFILE)
ifeq ($(USE_ELFTOOL),Y)
	@$(REM) patch Debug_Flag := True
	$(call brief-command, \
        $(ELFTOOL) -c setdebugflag=0x01 $(KERNEL_OUTFILE) \
        ,[ELFTOOL],Debug_Flag: 1)
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
rts: clean
ifeq ($(OSTYPE),cmd)
	FOR %%M IN ($(foreach m,$(GCC_MULTILIBS),"$(m)")) DO                 \
          (                                                                  \
           ECHO.&& ECHO $(CPU): RTS = $(RTS_BUILD), multilib = %%M&& ECHO.&& \
           SET "MAKEFLAGS=" && SET "RTS=$(RTS_BUILD)"                     && \
           "$(MAKE)" $(MAKE_RTS) MULTILIB=%%M configure                   && \
           "$(MAKE)" $(MAKE_RTS) MULTILIB=%%M multilib                       \
          ) || EXIT /B 1
else
	for m in $(foreach m,$(GCC_MULTILIBS),"$(m)") ; do                                \
          (                                                                               \
           echo "" && echo "$(CPU): RTS = $(RTS_BUILD), multilib = \"$$m\"" && echo "" && \
           MAKEFLAGS= RTS=$(RTS_BUILD) "$(MAKE)" $(MAKE_RTS) MULTILIB="$$m" configure  && \
           MAKEFLAGS= RTS=$(RTS_BUILD) "$(MAKE)" $(MAKE_RTS) MULTILIB="$$m" multilib      \
          ) || exit $$? ;                                                                 \
        done
endif

#
# Cleaning targets.
#

.PHONY: clean
clean:
ifeq      ($(OSTYPE),cmd)
	-@RENAME \\.\"$(shell cd)"\nul. deletefile.tmp 2> nul
else ifeq ($(OSTYPE),msys)
	-@cmd.exe /C "RENAME \\\\.\\\"$$(cygpath.exe -w "$$(pwd)")\"\\nul. deletefile.tmp" 2> /dev/null
endif
	$(MAKE) $(MAKE_APPLICATION) clean
	$(MAKE) $(MAKE_CLIBRARY) clean
	$(MAKE) $(MAKE_CORE) clean
ifneq ($(CPU),)
	$(MAKE) $(MAKE_CPU) clean
endif
	$(MAKE) $(MAKE_DRIVERS) clean
	$(MAKE) $(MAKE_MODULES) clean
ifneq ($(PLATFORM),)
	$(MAKE) $(MAKE_PLATFORM) clean
endif
ifeq ($(OSTYPE),cmd)
	-IF EXIST $(LIBRARY_DIRECTORY)\ \
          $(CD) $(LIBRARY_DIRECTORY) && \
          $(RM) *.*
	-IF EXIST $(OBJECT_DIRECTORY)\                \
          $(CD) $(OBJECT_DIRECTORY)                && \
          $(RM) *.*                                && \
          $(RMDIR) ..\$(OBJECT_DIRECTORY)\ $(NULL)
else
	-$(RM) $(LIBRARY_DIRECTORY)/*
	-$(RMDIR) $(OBJECT_DIRECTORY)/*
endif
	-$(RM) $(CLEAN_OBJECTS)

.PHONY: distclean
distclean: clean
	$(MAKE) $(MAKE_APPLICATION) distclean
	$(MAKE) $(MAKE_CLIBRARY) distclean
	$(MAKE) $(MAKE_CORE) distclean
ifeq ($(OSTYPE),cmd)
	FOR %%C IN ($(CPUS)) DO "$(MAKE)" $(MAKE_CPUS)/%%C distclean
else
	for c in $(CPUS) ; do "$(MAKE)" $(MAKE_CPUS)/$$c distclean ; done
endif
	$(MAKE) $(MAKE_DRIVERS) distclean
	$(MAKE) $(MAKE_MODULES) distclean
ifeq ($(OSTYPE),cmd)
	FOR %%P IN ($(PLATFORMS)) DO "$(MAKE)" $(MAKE_PLATFORMS)/%%P distclean
else
	for p in $(PLATFORMS) ; do "$(MAKE)" $(MAKE_PLATFORMS)/$$p distclean ; done
endif
	$(RM) $(DISTCLEAN_OBJECTS)

#
# Utility targets.
#

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
# Kernel "freezing".
#
FREEZE_DIRECTORY    := freeze
FILES_TO_BE_FREEZED :=
-include $(FREEZE_DIRECTORY)/Makefile.fz.in
.PHONY: freeze
freeze:
ifneq ($(FILES_TO_BE_FREEZED),)
ifeq ($(OSTYPE),cmd)
	-$(CP) $(FILES_TO_BE_FREEZED) $(FREEZE_DIRECTORY)\ $(NULL)
else
	-$(CP) $(FILES_TO_BE_FREEZED) $(FREEZE_DIRECTORY)/
endif
endif

#
# Probe a variable value.
#
# Example:
# $ VERBOSE= PROBEVARIABLE="PLATFORMS" make probevariable 2> /dev/null
#
.PHONY: probevariable
probevariable:
	@$(call echo-print,"$($(PROBEVARIABLE))")

