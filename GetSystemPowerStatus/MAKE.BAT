@echo off
set path=\masm32\bin
set lib=\masm32\lib
set name=sysp

ml.exe /c /coff /Cp /nologo "%name%".asm
  if not exist==*.res goto no_res
  link.exe /SUBSYSTEM:WINDOWS /RELEASE /VERSION:4.0 /LIBPATH:"%lib%" "%name%".obj
       
rem .idata есть только в TASM


 goto final
:no_res
  link.exe /SUBSYSTEM:WINDOWS /opt:nowin98 /LIBPATH:"%lib%" "%name%".obj
:final
  if errorlevel 1 goto End
  del *.OBJ
:End
 pause
@echo on
 cls
