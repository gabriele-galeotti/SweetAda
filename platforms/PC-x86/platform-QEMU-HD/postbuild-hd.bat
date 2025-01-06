@ECHO OFF

CALL %FILEPAD% %KERNEL_PARENT_PATH%\%KERNEL_ROMFILE% 512

"%PYTHON%"                                             ^
  "%SWEETADA_PATH%"\%SHARE_DIRECTORY%\pc-x86-boothd.py ^
  %KERNEL_PARENT_PATH%\%KERNEL_ROMFILE%                ^
  0x2000                                               ^
  +pcboothd.dsk
REM "%TCLSH%"                                               ^
REM   "%SWEETADA_PATH%"\%SHARE_DIRECTORY%\pc-x86-boothd.tcl ^
REM   %KERNEL_PARENT_PATH%\%KERNEL_ROMFILE%                 ^
REM   0x2000                                                ^
REM   +pcboothd.dsk

EXIT /B %ERRORLEVEL%

