@ECHO OFF

REM
REM Terminal handling utilities.
REM
REM Copyright (C) 2020-2024 Gabriele Galeotti
REM
REM This work is licensed under the terms of the MIT License.
REM Please consult the LICENSE.txt file located in the top-level directory.
REM

REM
REM Arguments:
REM <TERMINAL name>
REM
REM Environment variables:
REM none
REM

REM ############################################################################
REM # Main loop.                                                               #
REM #                                                                          #
REM ############################################################################

IF "%1" == "conemu" (
  ECHO ConEmu64.exe -run
  ) ELSE (
  ECHO cmd.exe /C
  )

EXIT /B 0

