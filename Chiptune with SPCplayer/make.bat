@echo off
\masm32\bin\rc /v bones.rc
\masm32\bin\ml.exe /c /coff /Cp /nologo bones.asm
\masm32\bin\link.exe /SUBSYSTEM:WINDOWS /RELEASE /VERSION:4.0 /OUT:music.exe bones.obj bones.res
del bones.res
del bones.obj