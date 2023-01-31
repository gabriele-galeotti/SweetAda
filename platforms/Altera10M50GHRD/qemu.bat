@ECHO OFF

REM
REM Altera 10M50GHRD QEMU.
REM

REM QEMU executable
SET "QEMU_EXECUTABLE=C:\Program Files\QEMU\qemu-system-nios2w.exe

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

REM QEMU machine
%QEMU_BKGND% "%QEMU_EXECUTABLE%" ^
  -M 10m50-ghrd ^
  -kernel %KERNEL_OUTFILE% ^
  -monitor telnet:localhost:%MONITORPORT%,server,nowait ^
  -chardev socket,id=SERIALPORT0,port=%SERIALPORT0%,host=localhost,ipv4=on,server=on,telnet=on,wait=off ^
  -serial chardev:SERIALPORT0 ^
  %QEMU_DEBUG%

REM debug session
IF "%1"=="-debug" (
  "%GDB%" -q ^
  -iex "set new-console on" ^
  -iex "set basenames-may-differ" ^
  %KERNEL_OUTFILE% ^
  -ex "target remote tcp:localhost:1234" ^
  )

EXIT /B %ERRORLEVEL%

