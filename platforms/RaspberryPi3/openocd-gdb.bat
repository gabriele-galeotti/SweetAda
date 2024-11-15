@ECHO OFF

SETLOCAL ENABLEDELAYEDEXPANSION

IF "%OSTYPE%" == "msys" (
  SET "MSYS_TERMINAL=source %SHARE_DIRECTORY%/terminal.sh ; terminal %TERMINAL%"
  FOR /F "delims=" %%T IN ('sh -c "!MSYS_TERMINAL!"') DO (
    SET "CONSOLE=%%T"
    )
  ) ELSE (
  SET "CMD_TERMINAL=%SHARE_DIRECTORY%\terminal.bat %TERMINAL%"
  FOR /F "delims=" %%T IN ('cmd.exe /C "!CMD_TERMINAL!"') DO (
    SET "CONSOLE=%%T"
    )
  )
SET "TERM="
START "GDB" !CONSOLE! %GDB% ^
  -q ^
  -ex "target extended-remote localhost:3333" ^
  -ex "set language asm" ^
  -ex "set $pc=_start" ^
  %KERNEL_OUTFILE%

EXIT /B 0

