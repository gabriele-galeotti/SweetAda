@ECHO OFF

REM
REM QEMU-OpenRISC (QEMU emulator).
REM
REM Copyright (C) 2020-2024 Gabriele Galeotti
REM
REM This work is licensed under the terms of the MIT License.
REM Please consult the LICENSE.txt file located in the top-level directory.
REM

REM
REM Arguments:
REM -debug
REM
REM Environment variables:
REM TOOLCHAIN_PREFIX
REM KERNEL_OUTFILE
REM PUTTY
REM GDB
REM

REM ############################################################################
REM # Main loop.                                                               #
REM #                                                                          #
REM ############################################################################

REM QEMU executable and CPU model
SET "QEMU_FILENAME=qemu-system-or1kw.exe"
SET "QEMU_EXECUTABLE=C:\Program Files\qemu\%QEMU_FILENAME%"

REM debug options
IF "%1"=="-debug" (
  SET "QEMU_DEBUG=-S -gdb tcp:localhost:1234,ipv4"
  SET "PYTHONHOME=%TOOLCHAIN_PREFIX%"
  ) ELSE (
  SET QEMU_DEBUG=
  )

REM telnet port numbers and listening timeout in s
SET MONITORPORT=4445
SET SERIALPORT0=4446
SET SERIALPORT1=4447
SET TILTIMEOUT=3

REM QEMU machine
START "" "%QEMU_EXECUTABLE%" ^
  -M virt ^
  -kernel %KERNEL_OUTFILE% ^
  -monitor telnet:localhost:%MONITORPORT%,server,nowait ^
  -chardev socket,id=SERIALPORT0,port=%SERIALPORT0%,host=localhost,ipv4=on,server=on,telnet=on,wait=on ^
  -serial chardev:SERIALPORT0 ^
  -chardev socket,id=SERIALPORT1,port=%SERIALPORT1%,host=localhost,ipv4=on,server=on,telnet=on,wait=on ^
  -serial chardev:SERIALPORT1 ^
  %QEMU_DEBUG%

REM console for serial port
CALL :TCPPORT_IS_LISTENING %SERIALPORT0% %TILTIMEOUT%
START "" %PUTTY% telnet://localhost:%SERIALPORT0%/
REM console for serial port
CALL :TCPPORT_IS_LISTENING %SERIALPORT1% %TILTIMEOUT%
START "" %PUTTY% telnet://localhost:%SERIALPORT1%/

REM debug session
IF "%1"=="-debug" (
  "%GDB%" ^
    -q ^
    -iex "set new-console on" ^
    -iex "set basenames-may-differ" ^
    -ex "target extended-remote tcp:localhost:1234" ^
    %KERNEL_OUTFILE%
  ) ELSE (
  CALL :QEMUWAIT
  )

:SCRIPTEXIT
EXIT /B %ERRORLEVEL%

REM ############################################################################
REM # SLEEP                                                                    #
REM #                                                                          #
REM ############################################################################
:SLEEP
FOR /F "tokens=1-3 delims=:." %%A IN ("%TIME%") DO SET /A ^
  H=%%A,M=1%%B%%100,S=1%%C%%100,END=(H*60+M)*60+S+%1
:SLEEP2
FOR /F "tokens=1-3 delims=:." %%A IN ("%TIME%") DO SET /A ^
  H=%%A,M=1%%B%%100,S=1%%C%%100,CUR=(H*60+M)*60+S
IF "%CUR%" LSS "%END%" GOTO :SLEEP2
GOTO :EOF

REM ############################################################################
REM # TCPPORT_IS_LISTENING                                                     #
REM #                                                                          #
REM ############################################################################
:TCPPORT_IS_LISTENING
SET "PORTOK=N"
SET "NLOOPS=0"
:TIL_LOOP
CALL :SLEEP 1
FOR /F "tokens=*" %%I IN ('                    ^
  %SystemRoot%\System32\NETSTAT.EXE -an ^|     ^
  %SystemRoot%\System32\find.exe ":%1"  ^|     ^
  %SystemRoot%\System32\find.exe /C "LISTENING"^
  ') DO SET VAR=%%I
IF "%VAR%" NEQ "0" (
  SET "PORTOK=Y"
  GOTO :TIL_LOOPEND
  )
SET /A NLOOPS += 1
IF "%NLOOPS%" NEQ "%2" GOTO :TIL_LOOP
:TIL_LOOPEND
IF NOT "%PORTOK%"=="Y" ECHO TIMEOUT WAITING FOR PORT %1
GOTO :EOF

REM ############################################################################
REM # QEMUWAIT                                                                 #
REM #                                                                          #
REM ############################################################################
:QEMUWAIT
:QW_LOOP
%SystemRoot%\System32\tasklist.exe | %SystemRoot%\System32\find.exe /I "%QEMU_FILENAME%" >nul 2>&1
IF ERRORLEVEL 1 (
  GOTO :QW_LOOPEND
  ) ELSE (
  CALL :SLEEP 1
  GOTO :QW_LOOP
  )
:QW_LOOPEND
GOTO :EOF

