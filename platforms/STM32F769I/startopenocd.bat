@ECHO OFF

REM
REM OpenOCD server startup script.
REM
REM Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
REM
REM This work is licensed under the terms of the MIT License.
REM Please consult the LICENSE.txt file located in the top-level directory.
REM

REM
REM Arguments:
REM none
REM
REM Environment variables:
REM none
REM

SET "OPENOCD_PATH=C:\Program Files\OpenOCD"
SET "OPENOCD_EXECUTABLE=%OPENOCD_PATH%\bin\openocd"

START "OpenOCD" "%OPENOCD_EXECUTABLE%" -f "%OPENOCD_PATH%"\share\openocd\scripts\board\stm32f769i-disco.cfg

EXIT /B %ERRORLEVEL%

