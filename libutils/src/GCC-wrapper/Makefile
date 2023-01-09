
#
# Makefile to build GCC-wrapper.
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
# HOST_CC
# HOST_CC_SWITCHES
# HOST_LD_SWITCHES
#

NULL  :=

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

# define OS commands
ifeq ($(OSTYPE),cmd)
EXEEXT := .exe
# cmd.exe OS commands
CP     := COPY /B /Y 1> nul
MV     := MOVE /Y 1> nul
REM    := REM
RM     := DEL /F /Q 2> nul
else
ifeq ($(OSTYPE),msys)
EXEEXT := .exe
else
EXEEXT :=
endif
# POSIX OS commands
CP     := cp -f
MV     := mv -f
REM    := \#
RM     := rm -f
endif

ifeq      ($(OSTYPE),linux)
HOST_CC          ?= gcc
HOST_CC_SWITCHES ?= -g -std=gnu99 -Wall
HOST_LD_SWITCHES ?= -g
else ifeq ($(OSTYPE),cmd)
HOST_CC          ?= gcc
HOST_CC_SWITCHES ?= -g -std=gnu99 -Wall -Wno-format-extra-args -Wno-format -Wno-pedantic-ms-format -mconsole
HOST_LD_SWITCHES ?= -g -static -mconsole
else ifeq ($(OSTYPE),msys)
HOST_CC          ?= gcc
HOST_CC_SWITCHES ?= -g -std=gnu99 -Wall -Wno-format-extra-args -Wno-format -Wno-pedantic-ms-format -mconsole
HOST_LD_SWITCHES ?= -g -static -mconsole
else ifeq ($(OSTYPE),darwin)
HOST_CC          ?= gcc
HOST_CC_SWITCHES ?= -g -std=gnu99 -Wall
HOST_LD_SWITCHES ?= -g -static-libgcc -static-libstdc++
endif

.PHONY : all
all : gcc-wrapper$(EXEEXT)

gcc-wrapper$(EXEEXT) : gcc-wrapper.o library.o
	$(HOST_CC) -o $@ $(HOST_LD_SWITCHES) $^
gcc-wrapper.o : gcc-wrapper.c
	$(HOST_CC) -o $@ -c -I.. $(HOST_CC_SWITCHES) $<
library.o : ../library.c
	$(HOST_CC) -o $@ -c -I.. -DNO_DLL_HANDLING=1 $(HOST_CC_SWITCHES) $<

.PHONY : install
install : gcc-wrapper$(EXEEXT)
ifeq      ($(OSTYPE),linux)
	$(CP) gcc-wrapper$(EXEEXT) ../../gcc-wrapper-lnx$(EXEEXT)
else ifeq ($(OSTYPE),cmd)
	$(CP) gcc-wrapper$(EXEEXT) ..\..\gcc-wrapper-win$(EXEEXT) $(NULL)
else ifeq ($(OSTYPE),msys)
	$(CP) gcc-wrapper$(EXEEXT) ../../gcc-wrapper-win$(EXEEXT)
else ifeq ($(OSTYPE),darwin)
	$(CP) gcc-wrapper$(EXEEXT) ../../gcc-wrapper-osx$(EXEEXT)
endif

.PHONY : clean
clean :
	$(RM) *.o gcc-wrapper$(EXEEXT)

