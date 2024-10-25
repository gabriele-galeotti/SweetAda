@ECHO OFF

REM be sure to have a Make available online
SET MAKE=make.exe
REM SET MAKE=mingw32-make.exe

REM GNAT Studio executable
SET "GNATSTUDIO=C:\GNATSTUDIO\bin\gnatstudio.exe"

REM detect toolchain from configuration.in
FOR /F "delims=" %%A IN ('%MAKE% PROBEVARIABLE^=TOOLCHAIN_PREFIX probevariable') DO SET TOOLCHAIN_PREFIX=%%A
IF "%TOOLCHAIN_PREFIX%"=="" ECHO *** Warning: no TOOLCHAIN_PREFIX detected. 1>&2

REM avoid complaints about gnatls
SET "PATH=%TOOLCHAIN_PREFIX%\bin;%PATH%

START "" "%GNATSTUDIO%" sweetada.gpr

EXIT /B %ERRORLEVEL%

