
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
#

CC          := gcc
CC_SWITCHES := -g -std=c99 -Wall -pedantic
LD_SWITCHES := -g
# location of libelf library
LIBELF      := /usr/local/lib/libelf.a

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
	$(CC) -o $@ $(LD_SWITCHES) $^
gcc-wrapper.o : gcc-wrapper.c
	$(CC) -o $@ -c $(CC_SWITCHES) $<

gnat-wrapper : gnat-wrapper.o library.o
	$(CC) -o $@ $(LD_SWITCHES) $^
gnat-wrapper.o : gnat-wrapper.c
	$(CC) -o $@ -c $(CC_SWITCHES) $<

elftool : elftool.o library.o
	$(CC) -o $@ $(LD_SWITCHES) $^ $(LIBELF)
elftool.o : elftool.c
	$(CC) -o $@ -c $(CC_SWITCHES) $<

library.o : library.c
	$(CC) -o $@ -c -DNO_DLL_HANDLING=1 $(CC_SWITCHES) $<

.PHONY : install
install : install-wrappers
	$(CP) elftool$(EXEEXT) ..

.PHONY : install-wrappers
install-wrappers :
	$(CP) gcc-wrapper$(EXEEXT) ../
	$(CP) gnat-wrapper$(EXEEXT) ../

.PHONY : clean
clean :
	$(RM) *.o gcc-wrapper gnat-wrapper elftool

