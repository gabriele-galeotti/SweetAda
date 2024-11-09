@ECHO OFF

SET "TERM="
START "GDB" cmd.exe /C %GDB% ^
  -q ^
  -iex "set new-console on" ^
  -iex "set basenames-may-differ" ^
  -ex "target extended-remote tcp:localhost:3333" ^
  -ex "set language asm" ^
  -ex "set $pc=_start" ^
  %KERNEL_OUTFILE%

EXIT /B 0

