@ECHO OFF

cl.exe /I.. /Feelftool-win.exe ..\library.c elftool.c

COPY /B /Y elftool-win.exe ..\..\

EXIT /B %ERRORLEVEL%

