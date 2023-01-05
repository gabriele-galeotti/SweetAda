
#
# Master Makefile
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
# OS
# MSYSTEM
# TEMP
# VERBOSE
# PLATFORM
# SUBPLATFORM
# PROBEVARIABLE
#

################################################################################
#                                                                              #
# Setup initialization.                                                        #
#                                                                              #
################################################################################

.DEFAULT_GOAL := help

NULL  :=
SPACE := $(NULL) $(NULL)
export NULL SPACE

KERNEL_BASENAME := kernel

PLATFORM_GOALS := infodump           \
                  configure          \
                  all                \
                  $(KERNEL_BASENAME) \
                  kernel_libinfo     \
                  kernel_info        \
                  postbuild          \
                  session-start      \
                  session-end        \
                  run                \
                  debug
RTS_GOAL       := rts
SERVICE_GOALS  := help                  \
                  libutils-elftool      \
                  libutils-gcc-wrapper  \
                  libutils-gnat-wrapper \
                  createkernelcfg       \
                  clean                 \
                  distclean             \
                  freeze                \
                  probevariable

# check Makefile target
ifneq ($(MAKECMDGOALS),)
ifeq ($(filter $(RTS_GOAL) $(SERVICE_GOALS),$(MAKECMDGOALS)),)
ifeq ($(filter $(PLATFORM_GOALS),$(MAKECMDGOALS)),)
$(error Error: not a known Makefile target)
endif
endif
endif

# detect OS type
# detected OS names: "linux"/"cmd"/"msys"/"darwin"
ifeq ($(OS),Windows_NT)
ifneq ($(MSYSTEM),)
OSTYPE := msys
else
OSTYPE := cmd
endif
else
OSTYPE_UNAME := $(shell uname -s 2> /dev/null)
ifeq      ($(OSTYPE_UNAME),Linux)
OSTYPE := linux
else ifeq ($(OSTYPE_UNAME),Darwin)
OSTYPE := darwin
else
$(error Error: no valid OSTYPE)
endif
endif
export OSTYPE

# workarounds for some environments
ifeq      ($(OSTYPE),cmd)
ifeq ($(basename $(notdir $(MAKE))),mingw32-make)
# even in a Windows cmd shell, if MSYS2 is present in path, then mingw32-make
# will use the MSYS2 Bash shell; avoid this problem by setting explicitly the
# native shell
SHELL := cmd
endif
else ifeq ($(OSTYPE),msys)
# Powershell complains about variable names
export temp :=
export tmp :=
endif

# executables and scripts extensions
SCREXT_cmd := .bat
SCREXT_unx := .sh
ifeq ($(OSTYPE),cmd)
EXEEXT     := .exe
SCREXT     := $(SCREXT_cmd)
else
ifeq ($(OSTYPE),msys)
EXEEXT     := .exe
else
EXEEXT     :=
endif
SCREXT     := $(SCREXT_unx)
endif
export EXEEXT SCREXT_cmd SCREXT_unx SCREXT

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
ifeq ($(OSTYPE),cmd)
PATH := $(SWEETADA_PATH)\$(LIBUTILS_DIRECTORY);$(PATH)
else
PATH := $(SWEETADA_PATH)/$(LIBUTILS_DIRECTORY):$(PATH)
endif
include Makefile.ut.in

# check for RTS build
ifeq ($(MAKECMDGOALS),rts)
ifeq ($(CPU),)
$(error Error: no valid CPU)
endif
ifeq ($(TOOLCHAIN_NAME),)
$(error Error: no valid TOOLCHAIN_NAME)
endif
ifeq ($(RTS),)
$(error Error: no valid RTS)
endif
# before loading configuration.in (which defines the RTS type used by the
# platform), save the RTS variable from the environment in order to correctly
# build the RTS specified when issuing the "rts" target
RTS_BUILD := $(RTS)
endif

# default system parameters
TOOLCHAIN_PREFIX   :=
ADA_MODE           := ADA22
BUILD_MODE         := MAKEFILE
RTS                :=
PROFILE            :=
USE_LIBGCC         :=
USE_LIBADA         :=
USE_CLIBRARY       :=
USE_APPLICATION    :=
OPTIMIZATION_LEVEL :=
STACK_LIMIT        := 4096
LD_SCRIPT          := linker.lds
POSTBUILD_ROMFILE  :=

IMPLICIT_ALI_UNITS :=
ADDITIONAL_OBJECTS :=

# read the master configuration file
include configuration.in

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

# export PATH so that we can use everything
export PATH

# check basic utilities
ifeq ($(TOOLS_CHECK),Y)
-include Makefile.ck.in
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
VERBOSE := $(shell $(ECHO) $(VERBOSE)| $(SED) -e "s|\(.\).*|\1|" -e "s|[y|1]|Y|")
else
VERBOSE := $(shell $(ECHO) "$(VERBOSE)" | $(SED) -e "s|\(.\).*|\1|" -e "s|[y|1]|Y|")
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

ifeq ($(VERBOSE),Y)
ifeq ($(OSTYPE),cmd)
# no verbosity
else
CP += -v
MV += -v
RM += -v
endif
else
MAKEFLAGS += s
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
OBJECT_DIRECTORY        := obj
RTS_DIRECTORY           := rts
SHARE_DIRECTORY         := share

# RTS_BASE_PATH: where all RTSes live
RTS_BASE_PATH := $(SWEETADA_PATH)/$(RTS_DIRECTORY)

ifeq ($(OSTYPE),cmd)
PLATFORMS := $(shell $(CD) $(PLATFORM_BASE_DIRECTORY) && $(call ls-dirs) 2> nul)
CPUS      := $(shell $(CD) $(CPU_BASE_DIRECTORY) && $(call ls-dirs) 2> nul)
RTSES     := $(filter-out targets,$(shell $(CD) $(RTS_DIRECTORY)\src && $(call ls-dirs) 2> nul))
else
PLATFORMS := $(shell ($(CD) $(PLATFORM_BASE_DIRECTORY) && $(call ls-dirs)) 2> /dev/null)
CPUS      := $(shell ($(CD) $(CPU_BASE_DIRECTORY) && $(call ls-dirs)) 2> /dev/null)
RTSES     := $(filter-out targets,$(shell ($(CD) $(RTS_DIRECTORY)/src && $(call ls-dirs)) 2> /dev/null))
endif

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
CLEAN_OBJECTS        :=
CLEAN_OBJECTS_COMMON := *.a *.aout *.bin *.d *.dwo *.elf *.hex *.log *.lst \
                        *.map *.o *.out *.srec *.tmp
DISTCLEAN_OBJECTS    :=

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
TOOLCHAIN_NAME           ?=
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
AS_SWITCHES_PLATFORM      :=
GCC_SWITCHES_PLATFORM     :=
LD_SWITCHES_PLATFORM      :=
OBJCOPY_SWITCHES_PLATFORM :=
OBJDUMP_SWITCHES_PLATFORM :=

#
# Initialize RTS-imported toolchain switches.
#
ADAC_SWITCHES_RTS :=
CC_SWITCHES_RTS   :=

#
# Initialize include directories.
#
INCLUDE_DIRECTORIES     :=
CPU_INCLUDE_DIRECTORIES :=

#
# Various features.
#
ENABLE_SPLIT_DWARF  :=
DISABLE_STACK_USAGE :=

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

# standard components
-include $(APPLICATION_DIRECTORY)/configuration.in
-include $(DRIVERS_DIRECTORY)/configuration.in
-include $(MODULES_DIRECTORY)/configuration.in
-include $(CORE_DIRECTORY)/configuration.in

# try to read PLATFORM from configuration file
ifneq (,$(filter-out createkernelcfg rts,$(MAKECMDGOALS)))
-include $(KERNEL_CFGFILE)
endif

# declare all toolchain-related informations
ifneq ($(PLATFORM),)
# platform known
PLATFORM_DIRECTORY := $(PLATFORM_BASE_DIRECTORY)/$(PLATFORM)
-include $(PLATFORM_DIRECTORY)/configuration.in
else
# platform not known, output an error message
ifneq ($(filter $(PLATFORM_GOALS),$(MAKECMDGOALS)),)
$(error Error: no valid PLATFORM)
endif
endif

ifneq ($(CPU),)
# CPU known
CPU_DIRECTORY := $(CPU_BASE_DIRECTORY)/$(CPU)
-include $(CPU_DIRECTORY)/configuration.in
endif

-include $(CLIBRARY_DIRECTORY)/configuration.in

-include Makefile.tc.in

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
export                         \
       MAKE                    \
       KERNEL_BASENAME         \
       KERNEL_CFGFILE          \
       KERNEL_DEPFILE          \
       KERNEL_OUTFILE          \
       KERNEL_ROMFILE          \
       PLATFORM_BASE_DIRECTORY \
       PLATFORM_DIRECTORY      \
       CPU_BASE_DIRECTORY      \
       CPU_DIRECTORY           \
       CPU_MODEL_DIRECTORY     \
       APPLICATION_DIRECTORY   \
       CLIBRARY_DIRECTORY      \
       CORE_DIRECTORY          \
       DRIVERS_DIRECTORY       \
       MODULES_DIRECTORY       \
       OBJECT_DIRECTORY        \
       RTS_DIRECTORY           \
       SHARE_DIRECTORY         \
       RTS_BASE_PATH           \
       INCLUDE_DIRECTORIES     \
       IMPLICIT_ALI_UNITS      \
       CLEAN_OBJECTS_COMMON

# configuration
export                    \
       PLATFORM           \
       SUBPLATFORM        \
       CPU                \
       CPU_MODEL          \
       FPU_MODEL          \
       ADA_MODE           \
       RTS                \
       PROFILE            \
       USE_LIBGCC         \
       USE_LIBADA         \
       USE_CLIBRARY       \
       BUILD_MODE         \
       OPTIMIZATION_LEVEL \
       ADDITIONAL_OBJECTS \
       STACK_LIMIT        \
       USE_APPLICATION

# toolchain
export                           \
       TOOLCHAIN_PREFIX          \
       TOOLCHAIN_NAME_AArch64    \
       TOOLCHAIN_NAME_ARM        \
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
       TOOLCHAIN_CC              \
       TOOLCHAIN_GDB             \
       TOOLCHAIN_LD              \
       TOOLCHAIN_OBJDUMP         \
       TOOLCHAIN_RANLIB          \
       GCC_VERSION               \
       GCC_SWITCHES_PLATFORM     \
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
       GNATPREP                  \
       GNATXREF                  \
       LD                        \
       NM                        \
       OBJCOPY                   \
       OBJDUMP                   \
       RANLIB                    \
       READELF                   \
       SIZE                      \
       STRIP

export USE_ELFTOOL
ifneq ($(USE_ELFTOOL),)
export ELFTOOL
endif

ifneq ($(TCLSH),)
export TCLSH
endif

export USE_PYTHON
ifneq ($(PYTHON),)
export PYTHON
endif

################################################################################
#                                                                              #
# Private non-global definitions and variables.                                #
#                                                                              #
################################################################################

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

ifeq ($(BUILD_MODE),MAKEFILE)
IMPLICIT_ALI_UNITS_MAKEFILE := $(patsubst %,$(OBJECT_DIRECTORY)/%.ali,$(IMPLICIT_ALI_UNITS))
endif

CLEAN_OBJECTS     += $(KERNEL_OBJFILE) $(KERNEL_OUTFILE) $(KERNEL_ROMFILE)
DISTCLEAN_OBJECTS += $(KERNEL_CFGFILE) $(GNATADC_FILENAME) $(CONFIGUREGPR_FILENAME)

################################################################################
#                                                                              #
# Library selection.                                                           #
#                                                                              #
################################################################################

ifeq ($(USE_LIBGCC),Y)
LIBGCC_OBJECT += $(LIBGCC_FILENAME)
else
LIBGCC_OBJECT :=
endif

ifeq ($(USE_LIBADA),Y)
LIBGNAT_OBJECT  := "$(RTS_PATH)"/adalib/libgnat.a
LIBGNARL_OBJECT := "$(RTS_PATH)"/adalib/libgnarl.a
LIBADA_OBJECTS  += $(LIBGNAT_OBJECT)
LIBADA_OBJECTS  += $(LIBGNARL_OBJECT)
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

.PHONY : help
help :
	@$(call echo-print,"make help (default)")
	@$(call echo-print,"  Display an help about make targets.")
	@$(call echo-print,"make RTS=<rts> CPU=<cpu> TOOLCHAIN_NAME=<toolchain_name> rts")
	@$(call echo-print,"  Create RTS <rts> for CPU <cpu> with toolchain <toolchain_name>.")
	@$(call echo-print,"make PLATFORM=<platform> [SUBPLATFORM=<subplatform>] createkernelcfg")
	@$(call echo-print,"  Create the '$(KERNEL_CFGFILE)' main configuration file.")
	@$(call echo-print,"make configure")
	@$(call echo-print,"  Create configuration/support files for this platform.")
	@$(call echo-print,"make all")
	@$(call echo-print,"  Perform the same as 'make $(KERNEL_BASENAME)'.")
	@$(call echo-print,"make $(KERNEL_BASENAME)")
	@$(call echo-print,"  Build the kernel binary output file '$(KERNEL_OUTFILE)'.")
	@$(call echo-print,"make postbuild")
	@$(call echo-print,"  Perform platform-specific finalizations and create a physical kernel file '$(KERNEL_ROMFILE)'.")
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
	@$(call echo-print,"Current PLATFORM:    $(PLATFORM)")
	@$(call echo-print,"")
ifneq ($(SUBPLATFORM),)
	@$(call echo-print,"Current SUBPLATFORM: $(SUBPLATFORM)")
	@$(call echo-print,"")
endif
endif

#
# Compile phase.
#

.PHONY : FORCE
FORCE :

$(CLIBRARY_OBJECT) : FORCE
ifeq ($(USE_CLIBRARY),Y)
	$(MAKE) $(MAKE_CLIBRARY) all
endif

$(OBJECT_DIRECTORY)/libcore.a : FORCE
	$(MAKE) $(MAKE_CORE) all

$(OBJECT_DIRECTORY)/libcpu.a : FORCE
	$(MAKE) $(MAKE_CPU) all

$(OBJECT_DIRECTORY)/libplatform.a : FORCE
	$(MAKE) $(MAKE_PLATFORM) all

$(GCC_GNAT_WRAPPER_TIMESTAMP_FILENAME) : FORCE
ifeq ($(BUILD_MODE),MAKEFILE)
	@$(REM) perform makefile-driven procedure
	$(call brief-command, \
        $(GNATMAKE)                        \
                    -c                     \
                    -D $(OBJECT_DIRECTORY) \
                    $(INCLUDES)            \
                    main.adb               \
        ,[GNATMAKE],main.adb)
else ifeq ($(BUILD_MODE),GPR)
	@$(REM) perform gpr-driven project build procedure
	$(call brief-command, \
        $(GPRBUILD)                      \
                    -c -p                \
                    -P$(KERNEL_GPRFILE)  \
        ,[GPRBUILD-C],$(KERNEL_GPRFILE))
endif

#
# Bind phase.
#

$(OBJECT_DIRECTORY)/b__main.adb : $(CLIBRARY_OBJECT)                     \
                                  $(OBJECT_DIRECTORY)/libcore.a          \
                                  $(OBJECT_DIRECTORY)/libcpu.a           \
                                  $(OBJECT_DIRECTORY)/libplatform.a      \
                                  $(GCC_GNAT_WRAPPER_TIMESTAMP_FILENAME)
	@$(REM) bind all units and generate b__main
ifeq ($(BUILD_MODE),MAKEFILE)
	$(call brief-command, \
        $(GNATBIND)                                \
                    -F -e -l -n -s                 \
                    -A=gnatbind_alis.lst           \
                    -O=gnatbind_objs.lst           \
                    -o b__main.adb                 \
                    $(INCLUDES)                    \
                    $(OBJECT_DIRECTORY)/main.ali   \
                    $(IMPLICIT_ALI_UNITS_MAKEFILE) \
                    > gnatbind_elab.lst            \
        ,[GNATBIND],b__main.adb)
ifeq ($(OSTYPE),cmd)
	@$(MV) b__main.adb $(OBJECT_DIRECTORY)\ $(NULL)
	@$(MV) b__main.ads $(OBJECT_DIRECTORY)\ $(NULL)
else
	@$(MV) b__main.adb $(OBJECT_DIRECTORY)/
	@$(MV) b__main.ads $(OBJECT_DIRECTORY)/
endif
else ifeq ($(BUILD_MODE),GPR)
	@$(REM) force rebind under GPRbuild
ifeq ($(OSTYPE),cmd)
	-@$(RM) $(OBJECT_DIRECTORY)\main.bexch
else
	-@$(RM) $(OBJECT_DIRECTORY)/main.bexch
endif
	$(call brief-command, \
        $(GPRBUILD)                      \
                    -b                   \
                    -P$(KERNEL_GPRFILE)  \
                    > gnatbind_elab.lst  \
        ,[GPRBUILD-B],$(KERNEL_GPRFILE))
ifeq ($(OSTYPE),cmd)
	-@$(MV) $(OBJECT_DIRECTORY)\gnatbind_objs.lst .\ $(NULL)
else
	-@$(MV) $(OBJECT_DIRECTORY)/gnatbind_objs.lst ./
endif
endif

#
# Compile the binder-generated source file.
#

$(OBJECT_DIRECTORY)/b__main.o : $(OBJECT_DIRECTORY)/b__main.adb
	@$(REM) compile the main program, incorporating the given elaboration order
ifeq ($(OSTYPE),cmd)
	$(call brief-command, \
        $(ADAC_GNATBIND)                                  \
                         -o $(OBJECT_DIRECTORY)\b__main.o \
                         -c                               \
                         $(OBJECT_DIRECTORY)\b__main.adb  \
        ,[ADAC],b__main.adb)
else
	$(call brief-command, \
        $(ADAC_GNATBIND)                                  \
                         -o $(OBJECT_DIRECTORY)/b__main.o \
                         -c                               \
                         $(OBJECT_DIRECTORY)/b__main.adb  \
        ,[ADAC],b__main.adb)
endif
ifeq ($(BUILD_MODE),GPR)
	-@$(RM) $(GCC_WRAPPER_TIMESTAMP_FILENAME)
endif
ifeq ($(OSTYPE),cmd)
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

$(KERNEL_OUTFILE) : $(OBJECT_DIRECTORY)/b__main.o      \
                    $(PLATFORM_DIRECTORY)/$(LD_SCRIPT)
	@$(REM) link phase
	$(call brief-command, \
        $(LD)                                       \
              -T $(PLATFORM_DIRECTORY)/$(LD_SCRIPT) \
              -o $(KERNEL_OUTFILE)                  \
              --start-group                         \
              @gnatbind_objs.lst                    \
              $(OBJECT_DIRECTORY)/b__main.o         \
              $(CLIBRARY_OBJECT)                    \
              $(OBJECT_DIRECTORY)/libcore.a         \
              $(OBJECT_DIRECTORY)/libcpu.a          \
              $(OBJECT_DIRECTORY)/libplatform.a     \
              $(LIBADA_OBJECTS)                     \
              $(LIBGCC_OBJECT)                      \
              --end-group                           \
        ,[LD],$(KERNEL_OUTFILE))
ifneq ($(OSTYPE),cmd)
	@chmod a-x $(KERNEL_OUTFILE)
endif

#
# Auxiliary targets.
#

.PHONY : kernel_objdir
kernel_objdir:
ifneq ($(OSTYPE),cmd)
	@$(MKDIR) $(OBJECT_DIRECTORY)
else
	@IF NOT EXIST $(OBJECT_DIRECTORY)\ $(MKDIR) $(OBJECT_DIRECTORY)
endif

.PHONY : kernel_start
kernel_start :
ifeq ($(GCC_VERSION),)
	$(error Error: no valid toolchain)
endif
ifneq ($(RTS_INSTALLED),Y)
	$(error Error: no RTS available)
endif
	@$(call echo-print,"")
	@$(call echo-print,"$(PLATFORM): start kernel build.")
	@$(call echo-print,"")

.PHONY : kernel_end
kernel_end :
	@$(call echo-print,"")
	@$(call echo-print,"$(PLATFORM): kernel compiled successfully.")
	@$(call echo-print,"")

.PHONY : kernel_dependencies
kernel_dependencies :
ifeq ($(BUILD_MODE),MAKEFILE)
	@$(REM) generates dependencies
	$(call brief-command, \
        $(GNATMAKE)                        \
                    -M                     \
                    -D $(OBJECT_DIRECTORY) \
                    $(INCLUDES)            \
                    main.adb               \
                    > $(KERNEL_DEPFILE)    \
        ,[GNATMAKE-M],$(KERNEL_DEPFILE))
endif

$(KERNEL_BASENAME).lst     \
$(KERNEL_BASENAME).src.lst \
$(KERNEL_BASENAME).elf.lst : $(KERNEL_OUTFILE)
	$(call brief-command, \
        $(OBJDUMP) -dx $(KERNEL_OUTFILE) > $(KERNEL_BASENAME).lst \
        ,[OBJDUMP],$(KERNEL_BASENAME).lst)
	$(call brief-command, \
        $(OBJDUMP) -Sdx $(KERNEL_OUTFILE) > $(KERNEL_BASENAME).src.lst \
        ,[OBJDUMP-S],$(KERNEL_BASENAME).src.lst)
	$(call brief-command, \
        $(READELF) $(KERNEL_OUTFILE) > $(KERNEL_BASENAME).elf.lst \
        ,[READELF],$(KERNEL_BASENAME).elf.lst)
	@$(call echo-print,"")
	@$(call echo-print,"$(PLATFORM): ELF sections dump.")
	@$(call echo-print,"")
ifeq ($(USE_ELFTOOL),Y)
	@$(ELFTOOL) -c dumpsections $(KERNEL_OUTFILE)
else
	@$(SIZE) $(KERNEL_OUTFILE)
endif
	@$(call echo-print,"")

libgnat.lst      \
libgnat.elf.lst  \
libgnarl.lst     \
libgnarl.elf.lst : $(KERNEL_OUTFILE)
	@$(OBJDUMP) -Sdx $(LIBGNAT_OBJECT) > libgnat.lst
	@$(READELF) $(LIBGNAT_OBJECT) > libgnat.elf.lst
	@$(OBJDUMP) -Sdx $(LIBGNARL_OBJECT) > libgnarl.lst
	@$(READELF) $(LIBGNARL_OBJECT) > libgnarl.elf.lst

libgcc.lst     \
libgcc.elf.lst : $(KERNEL_OUTFILE)
	@$(OBJDUMP) -Sdx $(LIBGCC_OBJECT) > libgcc.lst
	@$(READELF) $(LIBGCC_OBJECT) > libgcc.elf.lst

.PHONY : kernel_libinfo
kernel_libinfo :
ifeq ($(USE_LIBADA),Y)
kernel_libinfo : libgnat.lst libgnat.elf.lst libgnarl.lst libgnarl.elf.lst
endif
ifeq ($(USE_LIBGCC),Y)
kernel_libinfo : libgcc.lst libgcc.elf.lst
endif

.PHONY : kernel_info
kernel_info : kernel_libinfo             \
              $(KERNEL_BASENAME).lst     \
              $(KERNEL_BASENAME).src.lst \
              $(KERNEL_BASENAME).elf.lst

#
# Main targets.
#

.PHONY : $(KERNEL_BASENAME)
$(KERNEL_BASENAME) : $(KERNEL_OUTFILE)

.PHONY : all
all : kernel_start       \
      kernel_objdir      \
      $(KERNEL_BASENAME) \
      kernel_end         \
      kernel_info

#
# Configuration targets.
#

# create KERNEL_CFGFILE file and eventually install subplatform-dependent
# files (subsequent "configure" phase needs all target files in place)
.PHONY : createkernelcfg
createkernelcfg : distclean
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

.PHONY : configure-start
configure-start :
	@$(call echo-print,"")
	@$(call echo-print,"$(PLATFORM): start configuration.")
	@$(call echo-print,"")

.PHONY : configure-subdirs
configure-subdirs :
	@$(MAKE) $(MAKE_APPLICATION) configure
	@$(MAKE) $(MAKE_CLIBRARY) configure
	@$(MAKE) $(MAKE_CORE) configure
	@$(MAKE) $(MAKE_CPU) configure
	@$(MAKE) $(MAKE_DRIVERS) configure
	@$(MAKE) $(MAKE_MODULES) configure
	@$(MAKE) $(MAKE_PLATFORM) configure

.PHONY : configure-gnatadc
configure-gnatadc :
	$(CREATEGNATADC) $(PROFILE) $(GNATADC_FILENAME)

.PHONY : configure-gpr
configure-gpr :
	$(CREATECONFIGUREGPR) Configure $(CONFIGUREGPR_FILENAME)

.PHONY : configure-end
configure-end :
	@$(call echo-print,"")
	@$(call echo-print,"$(PLATFORM): configuration completed.")
	@$(call echo-print,"")

.PHONY : configure-aux
configure-aux : configure-start   \
                configure-subdirs \
                configure-gnatadc \
                configure-gpr     \
                configure-end

.PHONY : infodump
infodump :
	@$(call echo-print,"Configuration parameters:")
	@$(call echo-print,"PLATFORM:            $(PLATFORM)")
ifneq ($(SUBPLATFORM),)
	@$(call echo-print,"SUBPLATFORM:         $(SUBPLATFORM)")
endif
	@$(call echo-print,"CPU:                 $(CPU)")
ifneq ($(CPU_MODEL),)
	@$(call echo-print,"CPU MODEL:           $(CPU_MODEL)")
endif
ifneq ($(FPU_MODEL),)
	@$(call echo-print,"FPU MODEL:           $(FPU_MODEL)")
endif
	@$(call echo-print,"OSTYPE:              $(OSTYPE)")
	@$(call echo-print,"SWEETADA PATH:       $(SWEETADA_PATH)")
	@$(call echo-print,"TOOLCHAIN PREFIX:    $(TOOLCHAIN_PREFIX)")
	@$(call echo-print,"TOOLCHAIN NAME:      $(TOOLCHAIN_NAME)")
	@$(call echo-print,"RTS ROOT PATH:       $(RTS_ROOT_PATH)")
	@$(call echo-print,"RTS PATH:            $(RTS_PATH)")
	@$(call echo-print,"RTS:                 $(RTS)")
	@$(call echo-print,"PROFILE:             $(PROFILE)")
	@$(call echo-print,"ADA MODE:            $(ADA_MODE)")
	@$(call echo-print,"USE LIBADA:          $(USE_LIBADA)")
	@$(call echo-print,"USE C LIBRARY:       $(USE_CLIBRARY)")
ifneq ($(ADDITIONAL_OBJECTS),)
	@$(call echo-print,"ADDITIONAL OBJECTS:  $(ADDITIONAL_OBJECTS)")
endif
ifeq ($(USE_LIBGCC),Y)
	@$(call echo-print,"LIBGCC FILENAME:     $(LIBGCC_FILENAME)")
endif
	@$(call echo-print,"BUILD MODE:          $(BUILD_MODE)")
	@$(call echo-print,"OPTIMIZATION LEVEL:  $(OPTIMIZATION_LEVEL)")
ifeq ($(DISABLE_STACK_USAGE),Y)
	@$(call echo-print,"DISABLE STACK USAGE: Y")
endif
	@$(call echo-print,"MAKE:                $(MAKE)")
	@$(call echo-print,"GCC VERSION:         $(GCC_VERSION)")
	@$(call echo-print,"GCC SWITCHES (RTS):  $(strip $(ADAC_SWITCHES_RTS))")
	@$(call echo-print,"GCC SWITCHES:        $(strip $(GCC_SWITCHES_PLATFORM))")
	@$(call echo-print,"GCC MULTIDIR:        $(GCC_MULTIDIR)")
	@$(call echo-print,"LD SCRIPT:           $(LD_SCRIPT)")
	@$(call echo-print,"LD SWITCHES:         $(strip $(LD_SWITCHES_PLATFORM))")
	@$(call echo-print,"OBJCOPY SWITCHES:    $(strip $(OBJCOPY_SWITCHES_PLATFORM))")
	@$(call echo-print,"OBJDUMP SWITCHES:    $(strip $(OBJDUMP_SWITCHES_PLATFORM))")
	@$(call echo-print,"")

.PHONY : configure
configure : clean configure-aux infodump

#
# KERNEL_ROMFILE/postbuild/session-start/session-end/run/debug targets.
#
# Commands are executed with current directory = SWEETADA_PATH.
#

.PHONY : debug_notify_off
debug_notify_off : $(KERNEL_OUTFILE)
ifeq ($(USE_ELFTOOL),Y)
	@$(REM) patch Debug_Flag := False
	@$(ELFTOOL) -c setdebugflag=0x00 $(KERNEL_OUTFILE)
endif

.PHONY : debug_notify_on
debug_notify_on : $(KERNEL_OUTFILE)
ifeq ($(USE_ELFTOOL),Y)
	@$(REM) patch Debug_Flag := True
	@$(ELFTOOL) -c setdebugflag=0x01 $(KERNEL_OUTFILE)
endif

$(KERNEL_ROMFILE) : $(KERNEL_OUTFILE)
ifeq ($(POSTBUILD_ROMFILE),Y)
	$(call brief-command, \
        $(OBJCOPY) $(KERNEL_OUTFILE) $(KERNEL_ROMFILE) \
        ,[OBJCOPY],$(KERNEL_ROMFILE))
ifneq ($(OSTYPE),cmd)
	@chmod a-x $(KERNEL_ROMFILE)
endif
endif

.PHONY : postbuild
postbuild : $(KERNEL_ROMFILE)
	@$(MAKE) $(MAKE_PLATFORM) postbuild

.PHONY : session-start
session-start :
ifneq ($(SESSION_START_COMMAND),)
	-$(SESSION_START_COMMAND)
else
	$(error Error: no SESSION_START_COMMAND defined)
endif

.PHONY : session-end
session-end :
ifneq ($(SESSION_END_COMMAND),)
	-$(SESSION_END_COMMAND)
else
	$(error Error: no SESSION_END_COMMAND defined)
endif

.PHONY : run
run : debug_notify_off
	$(MAKE) postbuild
ifneq ($(RUN_COMMAND),)
	-$(RUN_COMMAND)
else
	$(error Error: no RUN_COMMAND defined)
endif

.PHONY : debug
debug : debug_notify_on
	$(MAKE) postbuild
ifneq ($(DEBUG_COMMAND),)
	-$(DEBUG_COMMAND)
else
	$(error Error: no DEBUG_COMMAND defined)
endif

#
# RTS.
#

.PHONY : rts
rts :
ifeq ($(GCC_VERSION),)
	$(error Error: no valid toolchain)
endif
ifeq ($(OSTYPE),cmd)
	FOR %%M IN ($(foreach m,$(GCC_MULTILIBS),"$(m)")) DO                 \
          (                                                                  \
           ECHO.&& ECHO $(CPU): RTS = $(RTS_BUILD), multilib = %%M&& ECHO.&& \
           SET "MAKEFLAGS=" && SET "RTS=$(RTS_BUILD)"                     && \
           "$(MAKE)" $(MAKE_RTS) --eval="MULTILIB := %%M" configure       && \
           "$(MAKE)" $(MAKE_RTS) --eval="MULTILIB := %%M" multilib           \
           || EXIT /B %ERRORLEVEL%                                           \
          )
else
	for m in $(foreach m,$(GCC_MULTILIBS),"$(m)") ; do                                         \
          (                                                                                        \
           echo "" && echo "$(CPU): RTS = $(RTS_BUILD), multilib = $$m" && echo ""              && \
           MAKEFLAGS= RTS=$(RTS_BUILD) "$(MAKE)" $(MAKE_RTS) --eval="MULTILIB := $$m" configure && \
           MAKEFLAGS= RTS=$(RTS_BUILD) "$(MAKE)" $(MAKE_RTS) --eval="MULTILIB := $$m" multilib     \
          ) || exit $$? ;                                                                          \
        done
endif

#
# Cleaning targets.
#

.PHONY : clean
clean :
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
	-$(CD) $(OBJECT_DIRECTORY) && $(RM) *.* && $(RMDIR) ..\$(OBJECT_DIRECTORY)\ $(NULL)
else
	-$(RMDIR) $(OBJECT_DIRECTORY)/*
endif
	-$(RM) $(CLEAN_OBJECTS_COMMON) $(CLEAN_OBJECTS)

.PHONY : distclean
distclean : clean
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
.PHONY : libutils-elftool
libutils-elftool :
	$(MAKE) -C $(LIBUTILS_DIRECTORY)/src/ELFtool elftool
	$(MAKE) -C $(LIBUTILS_DIRECTORY)/src/ELFtool install
.PHONY : libutils-gcc-wrapper
libutils-gcc-wrapper :
	$(MAKE) -C $(LIBUTILS_DIRECTORY)/src/GCC-wrapper gcc-wrapper
	$(MAKE) -C $(LIBUTILS_DIRECTORY)/src/GCC-wrapper install
.PHONY : libutils-gnat-wrapper
libutils-gnat-wrapper :
	$(MAKE) -C $(LIBUTILS_DIRECTORY)/src/GNAT-wrapper gnat-wrapper
	$(MAKE) -C $(LIBUTILS_DIRECTORY)/src/GNAT-wrapper install

#
# Kernel "freezing".
#
FREEZE_DIRECTORY    := freeze
FILES_TO_BE_FREEZED :=
-include $(FREEZE_DIRECTORY)/Makefile.fz.in
.PHONY : freeze
freeze :
ifneq ($(FILES_TO_BE_FREEZED),)
	-$(CP) $(FILES_TO_BE_FREEZED) $(FREEZE_DIRECTORY)/
endif

#
# Probe a variable value.
#
# Example:
# $ VERBOSE= PROBEVARIABLE="PLATFORMS" make -s probevariable 2> /dev/null
#
.PHONY : probevariable
probevariable :
	@$(call echo-print,"$($(PROBEVARIABLE))")

