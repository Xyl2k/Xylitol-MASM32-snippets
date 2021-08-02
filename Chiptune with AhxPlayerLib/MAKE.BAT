@echo off
\masm32\bin\rc /v base.rc
\masm32\bin\ml.exe /c /coff /Cp /nologo base.asm
\masm32\bin\link.exe /SUBSYSTEM:WINDOWS /RELEASE /VERSION:4.0 /NODEFAULTLIB:libcmt /NODEFAULTLIB:oldnames /NODEFAULTLIB:uuid /OUT:base.exe base.obj base.res
del base.res
del base.obj
del base.lib
del base.exp
pause