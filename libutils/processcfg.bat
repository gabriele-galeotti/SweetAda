@ECHO OFF

REM
REM SweetAda cmd.exe PowerShell wrapper.
REM
REM Copyright (C) 2020-2025 Gabriele Galeotti
REM
REM This work is licensed under the terms of the MIT License.
REM Please consult the LICENSE.txt file located in the top-level directory.
REM

REM
REM Arguments:
REM all arguments are passed to .ps1
REM
REM Environment variables:
REM SWEETADA_PATH
REM LIBUTILS_DIRECTORY
REM

powershell.exe                                                ^
  -NoProfile                                                  ^
  -ExecutionPolicy Bypass                                     ^
  -File "%SWEETADA_PATH%"/%LIBUTILS_DIRECTORY%/processcfg.ps1 ^
  %*

EXIT /B %ERRORLEVEL%

