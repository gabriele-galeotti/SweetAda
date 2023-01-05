@ECHO OFF

REM
REM SweetAda cmd.exe PowerShell wrapper.
REM
REM Copyright (C) 2020-2023 Gabriele Galeotti
REM
REM This work is licensed under the terms of the MIT License.
REM Please consult the LICENSE.txt file located in the top-level directory.
REM

REM
REM Arguments:
REM $1 = PROFILE
REM $2 = GNATADC_FILENAME
REM
REM Environment variables:
REM SWEETADA_PATH
REM LIBUTILS_DIRECTORY
REM

powershell -ExecutionPolicy Bypass -File "%SWEETADA_PATH%"/%LIBUTILS_DIRECTORY%/creategnatadc.ps1 ""%*""

EXIT /B %ERRORLEVEL%

