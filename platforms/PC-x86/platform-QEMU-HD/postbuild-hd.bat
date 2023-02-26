@ECHO OFF

CALL %FILEPAD% %KERNEL_PARENT_PATH%\%KERNEL_ROMFILE% 512

IF "%USE_PYTHON%"=="Y" (
  "%PYTHON%"                                             ^
    "%SWEETADA_PATH%"\%SHARE_DIRECTORY%\pc-x86-boothd.py ^
    %KERNEL_PARENT_PATH%\%KERNEL_ROMFILE%                ^
    0x4000                                               ^
    +pcboothd.dsk                                        ^
  ) ELSE (
  "%TCLSH%"                                               ^
    "%SWEETADA_PATH%"\%SHARE_DIRECTORY%\pc-x86-boothd.tcl ^
    %KERNEL_PARENT_PATH%\%KERNEL_ROMFILE%                 ^
    0x4000                                                ^
    +pcboothd.dsk                                         ^
  )

EXIT /B %ERRORLEVEL%

