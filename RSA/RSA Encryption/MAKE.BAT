@echo off
\masm32\bin\rc /v base.rc
\masm32\bin\ml.exe /c /coff /Cp /nologo base.asm
\masm32\bin\link.exe /SUBSYSTEM:WINDOWS /RELEASE /VERSION:4.0 /OUT:Keygen.exe base.obj base.res
del base.res
del base.obj
pause