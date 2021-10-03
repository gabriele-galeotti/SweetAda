
#
# Makefile to build GCC/GNAT-wrapper and elftool.
#
# Copyright (C) 2020, 2021 Gabriele Galeotti
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
# COMPILE
#

COMPILE ?= linux

ifeq ($(COMPILE),linux)
CC            := gcc
CC_SWITCHES   := -g -std=c99 -Wall
LD_SWITCHES   := -g
LIBELF        := /usr/local/lib/libelf.a
LIBWINPTHREAD :=
endif
ifeq ($(COMPILE),windows)
CC            := /usr/x86_64-w64-mingw32/bin/x86_64-w64-mingw32-gcc
CC_SWITCHES   := -g -std=c99 -Wall -Wno-format-extra-args -Wno-format -Wno-pedantic-ms-format -mconsole
LD_SWITCHES   := -g -mconsole
LIBELF        := /usr/x86_64-w64-mingw32/mingw/lib/libelf.a
LIBWINPTHREAD := -l:libwinpthread.a
endif
ifeq ($(COMPILE),osx)
CC            := /usr/x86_64-apple-darwin15/bin/x86_64-apple-darwin15-gcc
CC_SWITCHES   := -g -std=c99 -Wall
LD_SWITCHES   := -g
LIBELF        := /usr/x86_64-apple-darwin15/x86_64-apple-darwin15/usr/local/lib/libelf.a
LIBWINPTHREAD :=
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
# detect OSTYPE and normalize it to a simple all-alphabetic lowercase name
OSTYPE := $(shell uname -s 2> /dev/null | tr "[:upper:]" "[:lower:]" | sed -e "s|[^a-z].*||" -e "s|mingw|msys|")
endif
ifeq ($(OSTYPE),)
$(error Error: no valid OSTYPE)
endif
export OSTYPE

# define OS commands
ifeq ($(OSTYPE),cmd)
EXEEXT := .exe
# cmd.exe OS commands
CP     := COPY /B /Y 1> nul
MV     := MOVE /Y 1> nul
REM    := REM
RM     := DEL /F /Q 2> nul __dummyfile__
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

.PHONY : all
all : wrappers elftool

.PHONY : wrappers
wrappers : gcc-wrapper gnat-wrapper

gcc-wrapper : gcc-wrapper.o library.o
	$(CC) -o $@ $(LD_SWITCHES) $^ $(LIBWINPTHREAD)
gcc-wrapper.o : gcc-wrapper.c
	$(CC) -o $@ -c $(CC_SWITCHES) $<

gnat-wrapper : gnat-wrapper.o library.o
	$(CC) -o $@ $(LD_SWITCHES) $^ $(LIBWINPTHREAD)
gnat-wrapper.o : gnat-wrapper.c
	$(CC) -o $@ -c $(CC_SWITCHES) $<

elftool : elftool.o library.o
	$(CC) -o $@ $(LD_SWITCHES) $^ $(LIBELF) $(LIBWINPTHREAD)
elftool.o : elftool.c
	$(CC) -o $@ -c $(CC_SWITCHES) $<

library.o : library.c
	$(CC) -o $@ -c -DNO_DLL_HANDLING=1 $(CC_SWITCHES) $<

.PHONY : install
install : install-wrappers
ifeq ($(OSTYPE),darwin)
	$(CP) elftool$(EXEEXT) ../elftool-osx$(EXEEXT)
else
	$(CP) elftool$(EXEEXT) ../
endif

.PHONY : install-wrappers
install-wrappers :
ifeq ($(OSTYPE),darwin)
	$(CP) gcc-wrapper$(EXEEXT) ../gcc-wrapper-osx$(EXEEXT)
	$(CP) gnat-wrapper$(EXEEXT) ../gnat-wrapper-osx$(EXEEXT)
else
	$(CP) gcc-wrapper$(EXEEXT) ../
	$(CP) gnat-wrapper$(EXEEXT) ../
endif

.PHONY : clean
clean :
	$(RM) *.o gcc-wrapper gcc-wrapper.exe gnat-wrapper gnat-wrapper.exe elftool elftool.exe

