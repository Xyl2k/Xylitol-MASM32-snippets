@echo off
\masm32\bin\rc /v base.rc
\masm32\bin\ml.exe /c /coff /Cp /nologo RandomYZ.asm
\masm32\bin\link.exe /SUBSYSTEM:WINDOWS /RELEASE /VERSION:4.0 /OUT:RandomYZ.exe RandomYZ.obj base.res
del base.res
del RandomYZ.obj
pause