@ECHO OFF

CALL %FILEPAD% %KERNEL_PARENT_PATH%\%KERNEL_ROMFILE% 512

IF "%USE_PYTHON%"=="Y" (
  %PYTHON%                                               ^
    "%SWEETADA_PATH%"\%SHARE_DIRECTORY%\pc-x86-bootfd.py ^
    %KERNEL_PARENT_PATH%\%KERNEL_ROMFILE%                ^
    0x4000                                               ^
    ""                                                   ^
  ) ELSE (
  "%TCLSH%"                                               ^
    "%SWEETADA_PATH%"\%SHARE_DIRECTORY%\pc-x86-bootfd.tcl ^
    %KERNEL_PARENT_PATH%\%KERNEL_ROMFILE%                 ^
    0x4000                                                ^
    ""                                                    ^
  )

EXIT /B %ERRORLEVEL%

