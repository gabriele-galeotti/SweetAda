
#
# Makefile to build ELFtool.
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
# HOST_CC
# HOST_CC_SWITCHES
# HOST_LD_SWITCHES
#

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

ifeq      ($(OSTYPE),cmd)
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
else ifeq ($(OSTYPE),linux)
HOST_CC          ?= gcc
HOST_CC_SWITCHES ?= -g -std=gnu99 -Wall
HOST_LD_SWITCHES ?= -g
endif

OBJECTS :=
OBJECTS += elftool.o
OBJECTS += library.o

.PHONY: all
all: elftool$(EXEEXT)

elftool$(EXEEXT): $(OBJECTS)
	$(HOST_CC) -o $@ $(HOST_LD_SWITCHES) $^
elftool.o: elftool.c
	$(HOST_CC) -o $@ -c -I. -I.. $(HOST_CC_SWITCHES) $<
library.o: ../library.c
	$(HOST_CC) -o $@ -c -DNO_DLL_HANDLING=1 $(HOST_CC_SWITCHES) $<

.PHONY: install
install: elftool$(EXEEXT)
ifeq      ($(OSTYPE),cmd)
	$(CP) elftool$(EXEEXT) ..\..\elftool-win$(EXEEXT)
else ifeq ($(OSTYPE),msys)
	$(CP) elftool$(EXEEXT) ../../elftool-win$(EXEEXT)
else ifeq ($(OSTYPE),darwin)
	$(CP) elftool$(EXEEXT) ../../elftool-osx$(EXEEXT)
else ifeq ($(OSTYPE),linux)
	$(CP) elftool$(EXEEXT) ../../elftool-lnx$(EXEEXT)
endif

.PHONY: clean
clean:
	$(RM) *.o elftool$(EXEEXT)

