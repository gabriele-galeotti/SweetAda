@ECHO OFF

REM
REM SweetAda build cmd.exe environment.
REM
REM Copyright (C) 2020-2026 Gabriele Galeotti
REM
REM This work is licensed under the terms of the MIT License.
REM Please consult the LICENSE.txt file located in the top-level directory.
REM

REM
REM Arguments:
REM <action> = action to perform: "configure", "all", etc
REM
REM Environment variables:
REM MAKE
REM PLATFORM
REM SUBPLATFORM
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

REM hidden feature: if the script is called with -p <logfile>, it acts
REM like a "tee"
IF "%1"=="-p" SET LOGFILE=%2 && CALL :PIPE && EXIT /B %ERRORLEVEL%

IF NOT DEFINED MAKE SET MAKE=make.exe

SET ACTION_VALID=
IF "%1"=="help"            SET "ACTION_VALID=Y" && %MAKE% help
IF "%1"=="createkernelcfg" (
  SET "ACTION_VALID=Y"
  CALL :SETPLATFORM
  SET "PLATFORM=!PLATFORM!"
  SET "SUBPLATFORM=!SUBPLATFORM!"
  %MAKE% createkernelcfg
  )
IF "%1"=="configure"       SET "ACTION_VALID=Y" && %MAKE% configure
IF "%1"=="infodump"        SET "ACTION_VALID=Y" && %MAKE% infodump
IF "%1"=="all" (
  SET "ACTION_VALID=Y"
  %MAKE% all 2>make.log.err| menu.bat -p make.log.run
  CALL :SHOWERRORLOG
  )
IF "%1"=="postbuild" (
  SET "ACTION_VALID=Y"
  %MAKE% postbuild 2>make.log.err| menu.bat -p make.log.run
  CALL :SHOWERRORLOG
  )
IF "%1"=="session-start"   SET "ACTION_VALID=Y" && %MAKE% session-start
IF "%1"=="session-end"     SET "ACTION_VALID=Y" && %MAKE% session-end
IF "%1"=="run"             SET "ACTION_VALID=Y" && %MAKE% run
IF "%1"=="debug"           SET "ACTION_VALID=Y" && %MAKE% debug
IF "%1"=="clean"           SET "ACTION_VALID=Y" && %MAKE% clean
IF "%1"=="distclean"       SET "ACTION_VALID=Y" && %MAKE% distclean
IF "%1"=="rts"             SET "ACTION_VALID=Y" && %MAKE% rts
IF NOT "%ACTION_VALID%"=="Y" CALL :USAGE
SET ACTION_VALID=

EXIT /B %ERRORLEVEL%

REM ############################################################################
REM # SETPLATFORM                                                              #
REM #                                                                          #
REM ############################################################################
:SETPLATFORM
REM select a platform
IF NOT "%PLATFORM%"=="" GOTO :EOF
REM SET "PLATFORM=ArduinoUNO" && SET "SUBPLATFORM="
REM SET "PLATFORM=DE10-Lite" && SET "SUBPLATFORM="
REM SET "PLATFORM=Malta" && SET "SUBPLATFORM="
SET "PLATFORM=PC-x86" && SET "SUBPLATFORM=QEMU-ROM"
REM SET "PLATFORM=PC-x86-64" && SET "SUBPLATFORM=QEMU-ROM"
REM SET "PLATFORM=QEMU-10M50GHRD" && SET "SUBPLATFORM="
REM SET "PLATFORM=QEMU-IntegratorCP" && SET "SUBPLATFORM="
REM SET "PLATFORM=QEMU-LEON3" && SET "SUBPLATFORM="
REM SET "PLATFORM=QEMU-ML605" && SET "SUBPLATFORM="
REM SET "PLATFORM=QEMU-RISC-V" && SET "SUBPLATFORM="
REM SET "PLATFORM=QEMU-SBC5206" && SET "SUBPLATFORM="
REM SET "PLATFORM=QEMU-XilinxZynqA9" && SET "SUBPLATFORM="
REM SET "PLATFORM=SPARCstation5" && SET "SUBPLATFORM="
REM SET "PLATFORM=System390" && SET "SUBPLATFORM="
GOTO :EOF

REM ############################################################################
REM # PIPE                                                                     #
REM #                                                                          #
REM ############################################################################
:PIPE
COPY /Y nul %LOGFILE% >nul 2>&1
FOR /F "tokens=1* delims=]" %%A IN ('%SystemRoot%\System32\find.exe /N /V ""') DO (
  >con ECHO.%%B
  >>%LOGFILE% ECHO.%%B
  )
GOTO :EOF

REM ############################################################################
REM # SHOWERRORLOG                                                             #
REM #                                                                          #
REM ############################################################################
:SHOWERRORLOG
FOR /F %%I IN ("make.log.err") DO SET ERRORLOGSIZE=%%~zI
IF %ERRORLOGSIZE% GTR 0 (
  ECHO.
  ECHO Detected errors and/or warnings:
  ECHO --------------------------------
  TYPE make.log.err
  ECHO.
  )
GOTO :EOF

REM ############################################################################
REM # USAGE                                                                    #
REM #                                                                          #
REM ############################################################################
:USAGE
ECHO Usage:
ECHO menu.bat ^<action^>
ECHO.
ECHO ^<action^> is one of:
ECHO help            - build system help
ECHO createkernelcfg - create a kernel.cfg file
ECHO configure       - configure the system for a build
ECHO infodump        - dump essential informations
ECHO all             - build target
ECHO postbuild       - auxiliary post-processing
ECHO session-start   - perform session start activities
ECHO session-end     - perform session end activities
ECHO run             - run the target
ECHO debug           - debug the target
ECHO clean           - cleanup a build
ECHO distclean       - cleanup and reset the build system
ECHO rts             - build an RTS
ECHO.
ECHO Specify PLATFORM=^<platform^> (and optionally SUBPLATFORM) in the
ECHO environment variable space before executing the "createkernelcfg" action.
ECHO.
ECHO Specify CPU=^<cpu^> TOOLCHAIN_NAME=^<toolchain_name^> RTS=^<rts^> (and
ECHO optionally CPU_MODEL=^<cpu_model^>) in the environment variable space
ECHO before executing the "rts" action.
ECHO.
ECHO MAKE:                %MAKE%
ECHO default PLATFORM:    %PLATFORM%
ECHO default SUBPLATFORM: %SUBPLATFORM%
ECHO.
GOTO :EOF

