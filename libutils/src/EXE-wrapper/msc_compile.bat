@ECHO OFF

cl.exe /I.. /Feexe-wrapper-win.exe ..\library.c exe-wrapper.c

COPY /B /Y exe-wrapper-win.exe ..\..\

EXIT /B %ERRORLEVEL%

