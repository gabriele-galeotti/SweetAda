
#
# Makefile to build ELFtool.
#
# Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
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
#

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
CC          ?= gcc
CC_SWITCHES ?= -g -std=gnu99 -Wall
LD_SWITCHES ?= -g
else ifeq ($(OSTYPE),cmd)
CC          ?= gcc
CC_SWITCHES ?= -g -std=gnu99 -Wall -Wno-format-extra-args -Wno-format -Wno-pedantic-ms-format -mconsole
LD_SWITCHES ?= -g -mconsole
else ifeq ($(OSTYPE),msys)
CC          ?= gcc
CC_SWITCHES ?= -g -std=gnu99 -Wall -Wno-format-extra-args -Wno-format -Wno-pedantic-ms-format -mconsole
LD_SWITCHES ?= -g -mconsole
else ifeq ($(OSTYPE),darwin)
CC          ?= gcc
CC_SWITCHES ?= -g -std=gnu99 -Wall
LD_SWITCHES ?= -g -static-libgcc -static-libstdc++
endif

OBJECTS :=
OBJECTS += elftool.o
OBJECTS += library.o

.PHONY : elftool
elftool : $(OBJECTS)
	$(CC) -o $@ $(LD_SWITCHES) $^
elftool.o : elftool.c
	$(CC) -o $@ -c -I./ -I../ $(CC_SWITCHES) $<
library.o : ../library.c
	$(CC) -o $@ -c -DNO_DLL_HANDLING=1 $(CC_SWITCHES) $<

.PHONY : install
install :
ifeq ($(OSTYPE),darwin)
	$(CP) elftool$(EXEEXT) ../../elftool-osx$(EXEEXT)
else
	$(CP) elftool$(EXEEXT) ../../
endif

.PHONY : clean
clean :
	$(RM) *.o elftool elftool.exe

