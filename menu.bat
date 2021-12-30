@ECHO OFF

REM
REM SweetAda build cmd.exe environment.
REM
REM Copyright (C) 2020, 2021 Gabriele Galeotti
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

REM defaults to standard installation directory, see configuration.in
SET MAKEEXE="C:\Program Files\SweetAda"\bin\make.exe

IF "%PLATFORM%"=="" CALL :setplatform

SET ACTION_VALID=
IF "%1"=="createkernelcfg" SET "ACTION_VALID=Y" & SET "PLATFORM=%PLATFORM%" & SET "SUBPLATFORM=%SUBPLATFORM%" & %MAKEEXE% createkernelcfg
IF "%1"=="configure" SET "ACTION_VALID=Y" & %MAKEEXE% configure
IF "%1"=="all" SET "ACTION_VALID=Y" & %MAKEEXE% all
IF "%1"=="postbuild" SET "ACTION_VALID=Y" & %MAKEEXE% postbuild
IF "%1"=="session-start" SET "ACTION_VALID=Y" & %MAKEEXE% session-start
IF "%1"=="session-end" SET "ACTION_VALID=Y" & %MAKEEXE% session-end
IF "%1"=="run" SET "ACTION_VALID=Y" & %MAKEEXE% run
IF "%1"=="debug" SET "ACTION_VALID=Y" & %MAKEEXE% debug
IF "%1"=="clean" SET "ACTION_VALID=Y" & %MAKEEXE% clean
IF "%1"=="distclean" SET "ACTION_VALID=Y" & %MAKEEXE% distclean
IF NOT "%ACTION_VALID%"=="Y" CALL :usage
SET ACTION_VALID=

SET MAKEEXE=

EXIT /B %ERRORLEVEL%

:setplatform
REM select a platform
REM SET "PLATFORM=Altera10M50GHRD" & SET "SUBPLATFORM="
REM SET "PLATFORM=ArduinoUno" & SET "SUBPLATFORM="
REM SET "PLATFORM=DE10-Lite" & SET "SUBPLATFORM="
REM SET "PLATFORM=IntegratorCP" & SET "SUBPLATFORM="
REM SET "PLATFORM=LEON3" & SET "SUBPLATFORM="
REM SET "PLATFORM=ML605" & SET "SUBPLATFORM="
REM SET "PLATFORM=Malta" & SET "SUBPLATFORM="
SET "PLATFORM=PC-x86" & SET "SUBPLATFORM=QEMU-ROM"
REM SET "PLATFORM=PC-x86-64" & SET "SUBPLATFORM=QEMU-ROM"
REM SET "PLATFORM=QEMU-RISC-V" & SET "SUBPLATFORM="
REM SET "PLATFORM=SBC5206" & SET "SUBPLATFORM="
REM SET "PLATFORM=SPARCstation5" & SET "SUBPLATFORM="
REM SET "PLATFORM=System390" & SET "SUBPLATFORM="
REM SET "PLATFORM=Taihu" & SET "SUBPLATFORM="
REM SET "PLATFORM=XilinxZynqA9" & SET "SUBPLATFORM="
GOTO :eof

:usage
ECHO Usage:
ECHO menu.bat ^<action^>
ECHO.
ECHO ^<action^> is one of:
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
ECHO.
ECHO Specify PLATFORM=^<platform^> (and optionally SUBPLATFORM) in the
ECHO environment variable space before executing a createkernelcfg action.
ECHO.
ECHO MAKE:                %MAKEEXE%
ECHO default PLATFORM:    %PLATFORM%
ECHO default SUBPLATFORM: %SUBPLATFORM%
ECHO.
GOTO :eof

