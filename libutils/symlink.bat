@ECHO OFF

REM
REM SweetAda cmd.exe launch utility.
REM
REM Copyright (C) 2020-2026 Gabriele Galeotti
REM
REM This work is licensed under the terms of the MIT License.
REM Please consult the LICENSE.txt file located in the top-level directory.
REM

REM
REM Arguments:
REM all arguments are passed to the executable and the .ps1 script
REM
REM Environment variables:
REM none
REM

REM ############################################################################
REM # Script initialization.                                                   #
REM #                                                                          #
REM ############################################################################

SETLOCAL ENABLEEXTENSIONS
SETLOCAL ENABLEDELAYEDEXPANSION

REM ############################################################################
REM # Main loop.                                                               #
REM #                                                                          #
REM ############################################################################

IF EXIST "%~dp0symlink.exe" ( ^
  "%~dp0symlink.exe"          ^
    %*                        ^
  ) ELSE (                    ^
  powershell.exe              ^
    -NoLogo                   ^
    -NoProfile                ^
    -ExecutionPolicy Bypass   ^
    -File "%~dp0symlink.ps1"  ^
    %*                        ^
  )

EXIT /B %ERRORLEVEL%

