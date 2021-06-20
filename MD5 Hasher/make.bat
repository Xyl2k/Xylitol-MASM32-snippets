@echo off
\masm32\bin\rc /v base.rc
\masm32\bin\ml.exe /c /coff /Cp /nologo hashermd5.asm
\masm32\bin\link.exe /SUBSYSTEM:WINDOWS /RELEASE /VERSION:4.0 /OUT:MD5_Hasher.exe hashermd5.obj base.res
del base.res
del base.obj
del hashermd5.obj
pause