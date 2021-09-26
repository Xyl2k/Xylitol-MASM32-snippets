@echo off
\masm32\bin\rc /v rsagendlg.rc
\masm32\bin\ml.exe /c /coff /Cp /nologo rsagen.asm
\masm32\bin\link.exe /SUBSYSTEM:CONSOLE /RELEASE /VERSION:4.0 /OUT:RSA-1024.exe rsagen.obj rsagendlg.res
del rsagendlg.res
del rsagen.obj
pause