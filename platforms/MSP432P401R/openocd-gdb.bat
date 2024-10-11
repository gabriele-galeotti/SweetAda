@ECHO OFF

%GDB%                                         ^
  -ex "target extended-remote localhost:3333" ^
  -ex "set language asm"                      ^
  -ex "set $pc=_start"                        ^
  %KERNEL_OUTFILE%

EXIT /B 0

