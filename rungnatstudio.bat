@ECHO OFF

REM
REM Start GNAT Studio.
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

REM force OSTYPE
SET OSTYPE=cmd

REM be sure to have a Make available online
SET MAKE=make.exe
REM SET MAKE=mingw32-make.exe

REM GNAT Studio executable
SET GNATSTUDIO="%ProgramFiles%"\GNATSTUDIO\bin\gnatstudio.exe

REM detect toolchain from configuration.in
FOR /F "delims=" %%T IN ('SET "VERBOSE=" ^&^& %MAKE% PROBEVARIABLE^=TOOLCHAIN_PREFIX probevariable 2^>nul') DO (
  SET TOOLCHAIN_PREFIX=%%T
  )
IF "%TOOLCHAIN_PREFIX%" == "" ECHO *** Warning: no TOOLCHAIN_PREFIX detected.>&2

REM
REM The "--autoconf" option will generate a suitable auto.cgpr file if the
REM gprconfig executable is present, then a --config=<cgpr_filename> could be
REM used in the command line.
REM
SET "CGPR_OPTION="
REM SET "CGPR_OPTION=--config=auto.cgpr"
REM SET "CGPR_OPTION=--config=..."

START "GNATSTUDIO" %GNATSTUDIO% ^
  --pwd="%CD%" ^
  --path="%TOOLCHAIN_PREFIX%"/bin ^
  %CGPR_OPTION% ^
  -P sweetada.gpr

EXIT /B %ERRORLEVEL%

