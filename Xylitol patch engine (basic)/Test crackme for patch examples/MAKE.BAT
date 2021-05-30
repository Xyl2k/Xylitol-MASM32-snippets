@echo off
\masm32\bin\ml.exe /c /coff /Cp /nologo crackme.asm
\masm32\bin\link.exe /SUBSYSTEM:WINDOWS /RELEASE /VERSION:4.0 /OUT:My_Crackme.exe crackme.obj
del crackme.obj
echo **************************************************************
echo AS YOU HAVE RECOMPILED DONT FORGET TO EDIT PATH WITH NEW CRC32
echo **************************************************************
pause