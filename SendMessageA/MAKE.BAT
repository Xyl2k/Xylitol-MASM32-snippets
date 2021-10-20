@echo off
\masm32\bin\rc /v SendMessage.rc
\masm32\bin\ml.exe /c /coff /Cp /nologo SendMessage.asm
\masm32\bin\link.exe /SUBSYSTEM:WINDOWS /RELEASE /VERSION:4.0 /OUT:SendMessageA.exe SendMessage.obj SendMessage.res
del SendMessage.res
del SendMessage.obj
pause