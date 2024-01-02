@ECHO OFF

REM
REM SweetAda cmd.exe PowerShell wrapper.
REM
REM Copyright (C) 2020-2024 Gabriele Galeotti
REM
REM This work is licensed under the terms of the MIT License.
REM Please consult the LICENSE.txt file located in the top-level directory.
REM

REM
REM Arguments:
REM optional initial -m <filelist> to record symlinks
REM optional initial -v for verbosity
REM $1 = target filename or directory
REM $2 = link name filename or directory
REM every following pair is another symlink
REM
REM Environment variables:
REM SWEETADA_PATH
REM LIBUTILS_DIRECTORY
REM

powershell.exe -ExecutionPolicy Bypass -File "%SWEETADA_PATH%"/%LIBUTILS_DIRECTORY%/createsymlink.ps1 ""%*""

EXIT /B %ERRORLEVEL%

