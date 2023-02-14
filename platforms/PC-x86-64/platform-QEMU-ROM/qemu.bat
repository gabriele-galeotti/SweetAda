@ECHO OFF

REM
REM PC-x86 QEMU.
REM

REM QEMU executable
SET "QEMU_FILENAME=qemu-system-x86_64w.exe"
SET "QEMU_EXECUTABLE=C:\Program Files\QEMU\%QEMU_FILENAME%"

REM debug options
IF "%1"=="-debug" (
  SET "QEMU_DEBUG=-S -gdb tcp:localhost:1234,ipv4"
  SET "PYTHONHOME=%TOOLCHAIN_PREFIX%"
  ) ELSE (
  SET QEMU_DEBUG=
  )

REM telnet ports
SET MONITORPORT=4445
SET SERIALPORT0=4446
SET SERIALPORT1=4447

REM QEMU machine
START "" "%QEMU_EXECUTABLE%" ^
  -M q35 -cpu core2duo -m 256 -vga std ^
  -bios %KERNEL_ROMFILE% ^
  -monitor telnet:localhost:%MONITORPORT%,server,nowait ^
  -chardev socket,id=SERIALPORT0,port=%SERIALPORT0%,host=localhost,ipv4=on,server=on,telnet=on,wait=on ^
  -serial chardev:SERIALPORT0 ^
  -chardev socket,id=SERIALPORT1,port=%SERIALPORT1%,host=localhost,ipv4=on,server=on,telnet=on,wait=on ^
  -serial chardev:SERIALPORT1 ^
  %QEMU_DEBUG%

REM console for serial port
CALL :TCPPORT_IS_LISTENING %SERIALPORT0%
START "" "C:\Program Files"\PuTTY\putty-w64.exe telnet://localhost:%SERIALPORT0%/
REM console for serial port
CALL :TCPPORT_IS_LISTENING %SERIALPORT1%
START "" "C:\Program Files"\PuTTY\putty-w64.exe telnet://localhost:%SERIALPORT1%/

REM debug session
IF "%1"=="-debug" (
  "%GDB%" -q ^
    -iex "set new-console on" ^
    -iex "set basenames-may-differ" ^
    %KERNEL_OUTFILE% ^
    -ex "target remote tcp:localhost:1234" ^
    -ex "break bsp_setup" -ex "continue" ^
  ) ELSE (
  CALL :QEMUWAIT
  )

EXIT /B %ERRORLEVEL%

:TCPPORT_IS_LISTENING
SET "PORTOK=N"
SET "NLOOPS=0"
:TIL_LOOP
  timeout /NOBREAK /T 1 >NUL
  FOR /F "tokens=*" %%I in ('netstat -an ^| find ":%1" ^| find /C "LISTENING"') DO SET VAR=%%I
  IF "%VAR%" NEQ "0" (
    SET "PORTOK=Y"
    GOTO :TIL_LOOPEND
    )
  SET /A NLOOPS += 1
  IF "%NLOOPS%" NEQ "3" GOTO :TIL_LOOP
:TIL_LOOPEND
IF NOT "%PORTOK%"=="Y" ECHO TIMEOUT WAITING FOR PORT %1
GOTO :EOF

:QEMUWAIT
:QW_LOOP
tasklist | find /I "%QEMU_FILENAME%" >NUL 2>&1
IF ERRORLEVEL 1 (
  GOTO :QW_LOOPEND
  ) ELSE (
  timeout /NOBREAK /T 5 >NUL
  GOTO :QW_LOOP
  )
:QW_LOOPEND
GOTO :EOF

