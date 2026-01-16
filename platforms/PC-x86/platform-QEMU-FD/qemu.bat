@ECHO OFF

REM
REM PC-x86 (QEMU emulator).
REM
REM Copyright (C) 2020-2025 Gabriele Galeotti
REM
REM This work is licensed under the terms of the MIT License.
REM Please consult the LICENSE.txt file located in the top-level directory.
REM

REM
REM Arguments:
REM -debug
REM
REM Environment variables:
REM OSTYPE
REM PLATFORM_DIRECTORY
REM SHARE_DIRECTORY
REM TOOLCHAIN_PREFIX
REM KERNEL_OUTFILE
REM TERMINAL
REM PUTTY
REM GDB
REM

REM ############################################################################
REM # Main loop.                                                               #
REM #                                                                          #
REM ############################################################################

SETLOCAL ENABLEDELAYEDEXPANSION

REM QEMU executable and CPU model
SET "QEMU_FILENAME=qemu-system-i386w.exe"
SET QEMU_EXECUTABLE="C:\Program Files\qemu\%QEMU_FILENAME%"

REM debug options
IF "%1"=="-debug" (
  SET "QEMU_DEBUG=-S -gdb tcp:localhost:1234,ipv4"
  ) ELSE (
  SET "QEMU_DEBUG="
  )

REM telnet port numbers and listening timeout in s
SET MONITORPORT=4445
SET SERIALPORT0=4446
SET SERIALPORT1=4447
SET TILTIMEOUT=3

REM QEMU machine
START "QEMU" %QEMU_EXECUTABLE% ^
  -M pc -cpu pentium3 -m 256 -vga std ^
  -monitor telnet:localhost:%MONITORPORT%,server,nowait ^
  -chardev socket,id=SERIALPORT0,port=%SERIALPORT0%,host=localhost,ipv4=on,server=on,telnet=on,wait=on ^
  -serial chardev:SERIALPORT0 ^
  -chardev socket,id=SERIALPORT1,port=%SERIALPORT1%,host=localhost,ipv4=on,server=on,telnet=on,wait=on ^
  -serial chardev:SERIALPORT1 ^
  -drive "if=floppy,format=raw,file=%PLATFORM_DIRECTORY%/pcbootfd.dsk" -boot a ^
  %QEMU_DEBUG%
IF NOT "%ERRORLEVEL%"=="0" (
  ECHO *** Error: executing %QEMU_EXECUTABLE%.>&2
  GOTO :SCRIPTEXIT
  )

REM console for serial port
CALL :TCPPORT_IS_LISTENING %SERIALPORT0% %TILTIMEOUT%
START "PUTTY-1" %PUTTY% telnet://localhost:%SERIALPORT0%/
IF NOT "%ERRORLEVEL%"=="0" (
  ECHO *** Error: executing %PUTTY%.>&2
  CALL :ERRORLEVEL_RESET
  )
REM console for serial port
CALL :TCPPORT_IS_LISTENING %SERIALPORT1% %TILTIMEOUT%
START "PUTTY-2" %PUTTY% telnet://localhost:%SERIALPORT1%/
IF NOT "%ERRORLEVEL%"=="0" (
  ECHO *** Error: executing %PUTTY%.>&2
  CALL :ERRORLEVEL_RESET
  )

REM debug session
IF "%1"=="-debug" (
  SET TERM=
  SET "GDB_EXEC_CMD=%GDB%"
  SET "GDB_EXEC_CMD=!GDB_EXEC_CMD! -q"
  SET "GDB_EXEC_CMD=!GDB_EXEC_CMD! -iex "set basenames-may-differ""
  SET "GDB_EXEC_CMD=!GDB_EXEC_CMD! -iex "set architecture i386""
  SET "GDB_EXEC_CMD=!GDB_EXEC_CMD! -ex "set tcp connect-timeout 30""
  SET "GDB_EXEC_CMD=!GDB_EXEC_CMD! -ex "target extended-remote tcp:localhost:1234""
  SET "GDB_EXEC_CMD=!GDB_EXEC_CMD! -ex "tbreak _start" -ex "continue""
  SET "GDB_EXEC_CMD=!GDB_EXEC_CMD! %KERNEL_OUTFILE%"
  IF "%OSTYPE%"=="msys" (
    SET "MSYS_TERMINAL=. %SHARE_DIRECTORY%/terminal.sh ; terminal %TERMINAL%"
    FOR /F "delims=" %%T IN ('sh -c "!MSYS_TERMINAL!"') DO SET "CONSOLE=%%T"
    SET GDB_EXEC_CMD=!GDB_EXEC_CMD:"=\"!
    SET "GDB_EXEC_CMD_FAIL= || cmd.exe //C PAUSE"
    START "GDB" /WAIT !CONSOLE! sh -c "!GDB_EXEC_CMD!!GDB_EXEC_CMD_FAIL!"
    IF NOT "!ERRORLEVEL!"=="0" CALL :ERRORLEVEL_RESET
    ) ELSE (
    SET "CMD_TERMINAL=%SHARE_DIRECTORY%\terminal.bat %TERMINAL%"
    FOR /F "delims=" %%T IN ('cmd.exe /C "!CMD_TERMINAL!"') DO SET "CONSOLE=%%T"
    SET "GDB_EXEC_CMD_FAIL= || PAUSE"
    START "GDB" /WAIT !CONSOLE! cmd.exe /C "!GDB_EXEC_CMD!!GDB_EXEC_CMD_FAIL!"
    IF NOT "!ERRORLEVEL!"=="0" CALL :ERRORLEVEL_RESET
    )
  )

REM wait QEMU termination
CALL :PROCESSWAIT -e %QEMU_FILENAME%

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
FOR /F "tokens=*" %%L IN (' ^
  %SystemRoot%\System32\NETSTAT.EXE -an ^| ^
  %SystemRoot%\System32\find.exe ":%1" ^| ^
  %SystemRoot%\System32\find.exe /C "LISTENING" ^
  ') DO SET LISTEN=%%L
IF "%LISTEN%" NEQ "0" (
  SET "PORTOK=Y"
  GOTO :TIL_LOOPEND
  )
SET /A NLOOPS+=1
IF "%NLOOPS%" LEQ "%2" (
  CALL :SLEEP 1
  GOTO :TIL_LOOP
  )
:TIL_LOOPEND
IF NOT "%PORTOK%"=="Y" ECHO *** Error: timeout waiting for port %1.>&2
GOTO :EOF

REM ############################################################################
REM # PROCESSWAIT                                                              #
REM #                                                                          #
REM ############################################################################
:PROCESSWAIT
IF "%1"=="-s" (
  SET EL=0
  ) ELSE (
    IF "%1"=="-e" (
      SET EL=1
    ) ELSE (
      ECHO *** Error: wrong PROCESSWAIT parameter.>&2
      GOTO :EOF
    )
  )
:PW_LOOP
%SystemRoot%\System32\tasklist.exe | %SystemRoot%\System32\find.exe /I "%2" >nul 2>&1
IF "%ERRORLEVEL%"=="%EL%" (
  GOTO :PW_LOOPEND
  ) ELSE (
  CALL :SLEEP 1
  GOTO :PW_LOOP
  )
:PW_LOOPEND
GOTO :EOF

REM ############################################################################
REM # SLEEP                                                                    #
REM #                                                                          #
REM ############################################################################
:SLEEP
%SystemRoot%\System32\waitfor.exe QEMUPAUSE /T %1 2>nul
CALL :ERRORLEVEL_RESET
GOTO :EOF

REM ############################################################################
REM # ERRORLEVEL_RESET                                                         #
REM #                                                                          #
REM ############################################################################
:ERRORLEVEL_RESET
EXIT /B 0

