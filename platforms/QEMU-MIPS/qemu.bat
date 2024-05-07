@ECHO OFF

REM
REM QEMU-MIPS (QEMU emulator).
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
REM GDB
REM KERNEL_OUTFILE
REM KERNEL_ROMFILE
REM CPU_MODEL
REM

REM ############################################################################
REM # Main loop.                                                               #
REM #                                                                          #
REM ############################################################################

REM QEMU executable and CPU model
IF /I "%CPU_MODEL:~0,6%"=="MIPS32" (
  SET "QEMU_FILENAME=qemu-system-mipsw"
  SET "QEMU_CPU=24Kf"
  SET "GDB_ARCH=mips:isa32"
  GOTO :QEMU_OK
  )
IF /I "%CPU_MODEL:~0,6%"=="MIPS64" (
  SET "QEMU_FILENAME=qemu-system-mips64w"
  SET "QEMU_CPU=5Kf"
  SET "GDB_ARCH=mips:isa64"
  GOTO :QEMU_OK
  )
ECHO %~nx0: *** Error: %CPU_MODEL%: no CPU or CPU unsupported.
SET ERRORLEVEL=1
GOTO :SCRIPTEXIT
:QEMU_OK
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
SET TILTIMEOUT=3

REM QEMU machine
START "" "%QEMU_EXECUTABLE%" ^
  -M mipssim -cpu %QEMU_CPU% -m 16 ^
  -bios %KERNEL_ROMFILE% ^
  -monitor telnet:localhost:%MONITORPORT%,server,nowait ^
  -chardev socket,id=SERIALPORT0,port=%SERIALPORT0%,host=localhost,ipv4=on,server=on,telnet=on,wait=on ^
  -serial chardev:SERIALPORT0 ^
  %QEMU_DEBUG%

REM console for serial port
CALL :TCPPORT_IS_LISTENING %SERIALPORT0% %TILTIMEOUT%
START "" "C:\Program Files"\PuTTY\putty-w64.exe telnet://localhost:%SERIALPORT0%/

REM debug session
IF "%1"=="-debug" (
  "%GDB%" -q ^
  -iex "set new-console on" ^
  -iex "set basenames-may-differ" ^
  -iex "set architecture %GDB_ARCH%" ^
  -ex "target remote tcp:localhost:1234" ^
  %KERNEL_OUTFILE%
  ) ELSE (
  CALL :QEMUWAIT
  )

:SCRIPTEXIT
EXIT /B %ERRORLEVEL%

REM ############################################################################
REM # TCPPORT_IS_LISTENING                                                     #
REM #                                                                          #
REM ############################################################################
:TCPPORT_IS_LISTENING
SET "PORTOK=N"
SET "NLOOPS=0"
:TIL_LOOP
  %SystemRoot%\System32\timeout.exe /NOBREAK /T 1 >NUL
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
%SystemRoot%\System32\tasklist.exe | %SystemRoot%\System32\find.exe /I "%QEMU_FILENAME%" >NUL 2>&1
IF ERRORLEVEL 1 (
  GOTO :QW_LOOPEND
  ) ELSE (
  %SystemRoot%\System32\timeout.exe /NOBREAK /T 5 >NUL
  GOTO :QW_LOOP
  )
:QW_LOOPEND
GOTO :EOF

