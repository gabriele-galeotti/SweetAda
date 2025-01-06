@ECHO OFF

REM
REM Terminal handling utilities.
REM
REM Copyright (C) 2020-2025 Gabriele Galeotti
REM
REM This work is licensed under the terms of the MIT License.
REM Please consult the LICENSE.txt file located in the top-level directory.
REM

REM
REM Arguments:
REM $1 <TERMINAL name>
REM $2 ... $9 terminal options
REM
REM Environment variables:
REM none
REM

REM ############################################################################
REM # Main loop.                                                               #
REM #                                                                          #
REM ############################################################################

IF "%1" == "conemu" (
  ECHO ConEmu64.exe %2 %3 %4 %5 %6 %7 %8 %9 -run
  )

EXIT /B 0

