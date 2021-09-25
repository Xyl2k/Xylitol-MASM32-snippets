@echo off
\masm32\bin\rc /v keygen.rc
\masm32\bin\ml.exe /c /coff /Cp /nologo keygen.asm
\masm32\bin\link.exe /SUBSYSTEM:WINDOWS /RELEASE /VERSION:4.0 /OUT:Keygen.exe keygen.obj keygen.res
del keygen.res
del keygen.obj
pause