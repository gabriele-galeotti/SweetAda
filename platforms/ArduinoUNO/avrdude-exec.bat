@ECHO OFF

REM
REM AVRDUDE front-end script.
REM
REM Copyright (C) 2020-2023 Gabriele Galeotti
REM
REM This work is licensed under the terms of the MIT License.
REM Please consult the LICENSE.txt file located in the top-level directory.
REM

REM
REM Arguments:
REM none
REM
REM Environment variables:
REM SWEETADA_PATH
REM KERNEL_ROMFILE
REM

REM ############################################################################
REM # Main loop.                                                               #
REM #                                                                          #
REM ############################################################################

SET "AVRDUDE_PATH=C:\Program Files\avrdude"
SET "AVRDUDE_EXEC=%AVRDUDE_PATH%\bin\avrdude.exe"

ECHO Press RESET on board and press <ENTER>, then release RESET ...
PAUSE > nul

"%AVRDUDE_EXEC%" -v -v -V -p atmega328p -P USB -c arduino -D -U flash:w:"%SWEETADA_PATH%"\%KERNEL_ROMFILE%:i

EXIT /B %ERRORLEVEL%

