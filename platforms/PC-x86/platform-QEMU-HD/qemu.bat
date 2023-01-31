@ECHO OFF

REM
REM PC-x86 QEMU.
REM

REM QEMU executable
SET "QEMU_EXECUTABLE=C:\Program Files\QEMU\qemu-system-i386w.exe

REM debug options
IF "%1"=="-debug" (
  SET "QEMU_BKGND=START """""
  SET "QEMU_DEBUG=-S -gdb tcp:localhost:1234,ipv4"
  SET "PYTHONHOME=%TOOLCHAIN_PREFIX%"
  ) ELSE (
  SET QEMU_BKGND=
  SET QEMU_DEBUG=
)

REM telnet ports
SET MONITORPORT=4445
SET SERIALPORT0=4446
SET SERIALPORT1=4447

REM console for serialports
START "" "C:\Program Files"\PuTTY\putty-w64.exe telnet://localhost:%SERIALPORT0%/
START "" "C:\Program Files"\PuTTY\putty-w64.exe telnet://localhost:%SERIALPORT1%/

REM QEMU machine
%QEMU_BKGND% "%QEMU_EXECUTABLE%" ^
  -M pc -cpu pentium3 -m 256 -vga std ^
  -monitor telnet:localhost:%MONITORPORT%,server,nowait ^
  -chardev socket,id=SERIALPORT0,port=%SERIALPORT0%,host=localhost,ipv4=on,server=on,telnet=on,wait=off ^
  -serial chardev:SERIALPORT0 ^
  -chardev socket,id=SERIALPORT1,port=%SERIALPORT1%,host=localhost,ipv4=on,server=on,telnet=on,wait=off ^
  -serial chardev:SERIALPORT1 ^
  -device ide-hd,drive=disk,bus=ide.0 ^
  -drive "id=disk,if=none,format=raw,file=%PLATFORM_DIRECTORY%/pcboothd.dsk" -boot c ^
  %QEMU_DEBUG%

REM debug session
IF "%1"=="-debug" (
  "%GDB%" -q ^
  -iex "set new-console on" ^
  -iex "set basenames-may-differ" ^
  %KERNEL_OUTFILE% ^
  -ex "target remote tcp:localhost:1234" ^
  -ex "break bsp_setup" -ex "continue" ^
  )

EXIT /B %ERRORLEVEL%

