@echo off
set path=\masm32\bin
set lib=\masm32\lib
set name=DosExe
ml.exe /c /nologo /Fo DosExe.obj DosExe.asm
link16.exe /TINY /NOLOGO DosExe.obj,BootLoader.dat,DosExe.map,"",""
del *.OBJ
pause
@echo on
cls