@ECHO OFF

REM
REM FRDM-KL46Z OpenOCD-GDB.
REM
REM Copyright (C) 2020-2025 Gabriele Galeotti
REM
REM This work is licensed under the terms of the MIT License.
REM Please consult the LICENSE.txt file located in the top-level directory.
REM

REM
REM Arguments:
REM none
REM
REM Environment variables:
REM OSTYPE
REM SHARE_DIRECTORY
REM KERNEL_OUTFILE
REM TERMINAL
REM GDB
REM

REM ############################################################################
REM # Main loop.                                                               #
REM #                                                                          #
REM ############################################################################

SETLOCAL ENABLEDELAYEDEXPANSION

REM undefine possible corrupted TERM variable
SET "TERM="

REM GDB options
SET "GDB_EXEC_CMD=%GDB%"
SET "GDB_EXEC_CMD=!GDB_EXEC_CMD! -q"
SET "GDB_EXEC_CMD=!GDB_EXEC_CMD! -iex "set basenames-may-differ""
SET "GDB_EXEC_CMD=!GDB_EXEC_CMD! -ex "target extended-remote tcp:localhost:3333""
SET "GDB_EXEC_CMD=!GDB_EXEC_CMD! -ex "set language asm""
SET "GDB_EXEC_CMD=!GDB_EXEC_CMD! -ex "set $pc=_start""
SET "GDB_EXEC_CMD=!GDB_EXEC_CMD! %KERNEL_OUTFILE%"

REM GDB session
IF "%OSTYPE%"=="msys" (
  SET "MSYS_TERMINAL=. %SHARE_DIRECTORY%/terminal.sh ; terminal %TERMINAL%"
  FOR /F "delims=" %%T IN ('sh -c "!MSYS_TERMINAL!"') DO SET "CONSOLE=%%T"
  SET GDB_EXEC_CMD=!GDB_EXEC_CMD:"=\"!
  SET GDB_EXEC_CMD=!GDB_EXEC_CMD:$=\$!
  SET "GDB_EXEC_CMD_FAIL= || cmd.exe //C PAUSE"
  START "GDB" /WAIT !CONSOLE! sh -c "!GDB_EXEC_CMD!!GDB_EXEC_CMD_FAIL!"
  IF NOT "!ERRORLEVEL!"=="0" CALL :SCRIPTEXIT
  ) ELSE (
  SET "CMD_TERMINAL=%SHARE_DIRECTORY%\terminal.bat %TERMINAL%"
  FOR /F "delims=" %%T IN ('cmd.exe /C "!CMD_TERMINAL!"') DO SET "CONSOLE=%%T"
  SET "GDB_EXEC_CMD_FAIL= || PAUSE"
  START "GDB" /WAIT !CONSOLE! cmd.exe /C "!GDB_EXEC_CMD!!GDB_EXEC_CMD_FAIL!"
  IF NOT "!ERRORLEVEL!"=="0" CALL :SCRIPTEXIT
  )

:SCRIPTEXIT
EXIT /B 0

