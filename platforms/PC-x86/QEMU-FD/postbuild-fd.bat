@ECHO OFF

CALL %FILEPAD% %KERNEL_PARENT_PATH%\%KERNEL_ROMFILE% 512

"%PYTHON%"                                             ^
  "%SWEETADA_PATH%"\%SHARE_DIRECTORY%\pc-x86-bootfd.py ^
  %KERNEL_PARENT_PATH%\%KERNEL_ROMFILE%                ^
  0x2000                                               ^
  +pcbootfd.dsk
REM "%TCLSH%"                                               ^
REM   "%SWEETADA_PATH%"\%SHARE_DIRECTORY%\pc-x86-bootfd.tcl ^
REM   %KERNEL_PARENT_PATH%\%KERNEL_ROMFILE%                 ^
REM   0x2000                                                ^
REM   +pcbootfd.dsk

EXIT /B %ERRORLEVEL%

