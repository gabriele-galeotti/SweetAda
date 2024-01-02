@ECHO OFF

REM
REM AVRDUDE front-end script.
REM
REM Copyright (C) 2020-2024 Gabriele Galeotti
REM
REM This work is licensed under the terms of the MIT License.
REM Please consult the LICENSE.txt file located in the top-level directory.
REM

REM
REM Arguments:
REM none
REM
REM Environment variables:
REM KERNEL_ROMFILE
REM

REM ############################################################################
REM # Main loop.                                                               #
REM #                                                                          #
REM ############################################################################

SET "AVRDUDE_PREFIX=C:\Program Files\avrdude"

SET "AVRDUDE_ARGS="
SET "AVRDUDE_ARGS=%AVRDUDE_ARGS% -v -v -V"
SET "AVRDUDE_ARGS=%AVRDUDE_ARGS% -p atmega328p"
SET "AVRDUDE_ARGS=%AVRDUDE_ARGS% -P USB"
SET "AVRDUDE_ARGS=%AVRDUDE_ARGS% -c arduino"
SET "AVRDUDE_ARGS=%AVRDUDE_ARGS% -D"
SET "AVRDUDE_ARGS=%AVRDUDE_ARGS% -U flash:w:%KERNEL_ROMFILE%:i"

ECHO Press RESET on board and press <ENTER>, then release RESET ...
PAUSE > nul

"%AVRDUDE_PREFIX%"\bin\avrdude.exe %AVRDUDE_ARGS%

EXIT /B %ERRORLEVEL%

