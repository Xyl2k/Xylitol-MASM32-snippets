@echo off
\masm32\bin\rc /v base.rc
\masm32\bin\ml.exe /c /coff /Cp /nologo trainer.asm
\masm32\bin\link.exe /SUBSYSTEM:WINDOWS /RELEASE /VERSION:4.0 /OUT:DS_Trainer.exe trainer.obj base.res
del base.res
del trainer.obj
pause