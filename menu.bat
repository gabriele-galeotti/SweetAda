@ECHO OFF

REM
REM SweetAda build cmd.exe environment.
REM
REM Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
REM
REM This work is licensed under the terms of the MIT License.
REM Please consult the LICENSE.txt file located in the top-level directory.
REM

REM
REM Arguments:
REM <action> = action to perform: "configure", "all", etc
REM
REM Environment variables:
REM PLATFORM
REM SUBPLATFORM
REM

SETLOCAL EnableDelayedExpansion

REM defaults to standard installation directory, see configuration.in
SET MAKEEXE="C:\Program Files\SweetAda"\bin\make.exe

SET ACTION_VALID=
IF "%1"=="help" SET "ACTION_VALID=Y" && %MAKEEXE% help
IF "%1"=="createkernelcfg" SET "ACTION_VALID=Y" && CALL :setplatform && SET "PLATFORM=!PLATFORM!" && SET "SUBPLATFORM=!SUBPLATFORM!" && %MAKEEXE% createkernelcfg
IF "%1"=="configure" SET "ACTION_VALID=Y" && %MAKEEXE% configure
IF "%1"=="all" SET "ACTION_VALID=Y" && %MAKEEXE% all
IF "%1"=="postbuild" SET "ACTION_VALID=Y" && %MAKEEXE% postbuild
IF "%1"=="session-start" SET "ACTION_VALID=Y" && %MAKEEXE% session-start
IF "%1"=="session-end" SET "ACTION_VALID=Y" && %MAKEEXE% session-end
IF "%1"=="run" SET "ACTION_VALID=Y" && %MAKEEXE% run
IF "%1"=="debug" SET "ACTION_VALID=Y" && %MAKEEXE% debug
IF "%1"=="clean" SET "ACTION_VALID=Y" && %MAKEEXE% clean
IF "%1"=="distclean" SET "ACTION_VALID=Y" && %MAKEEXE% distclean
IF "%1"=="rts" SET "ACTION_VALID=Y" && %MAKEEXE% rts
IF NOT "%ACTION_VALID%"=="Y" CALL :usage
SET ACTION_VALID=

SET MAKEEXE=

EXIT /B %ERRORLEVEL%

:setplatform
REM select a platform
IF NOT "%PLATFORM%"=="" GOTO :eof
REM SET "PLATFORM=Altera10M50GHRD" && SET "SUBPLATFORM="
REM SET "PLATFORM=ArduinoUNO" && SET "SUBPLATFORM="
REM SET "PLATFORM=DE10-Lite" && SET "SUBPLATFORM="
REM SET "PLATFORM=IntegratorCP" && SET "SUBPLATFORM="
REM SET "PLATFORM=LEON3" && SET "SUBPLATFORM="
REM SET "PLATFORM=ML605" && SET "SUBPLATFORM="
REM SET "PLATFORM=Malta" && SET "SUBPLATFORM="
SET "PLATFORM=PC-x86" && SET "SUBPLATFORM=QEMU-ROM"
REM SET "PLATFORM=PC-x86-64" && SET "SUBPLATFORM=QEMU-ROM"
REM SET "PLATFORM=QEMU-RISC-V" && SET "SUBPLATFORM="
REM SET "PLATFORM=SBC5206" && SET "SUBPLATFORM="
REM SET "PLATFORM=SPARCstation5" && SET "SUBPLATFORM="
REM SET "PLATFORM=System390" && SET "SUBPLATFORM="
REM SET "PLATFORM=Taihu" && SET "SUBPLATFORM="
REM SET "PLATFORM=XilinxZynqA9" && SET "SUBPLATFORM="
GOTO :eof

:usage
ECHO Usage:
ECHO menu.bat ^<action^>
ECHO.
ECHO ^<action^> is one of:
ECHO help            - build system help
ECHO createkernelcfg - create a kernel.cfg file
ECHO configure       - configure the system for a build
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
ECHO MAKE:                %MAKEEXE%
ECHO default PLATFORM:    %PLATFORM%
ECHO default SUBPLATFORM: %SUBPLATFORM%
ECHO.
GOTO :eof

