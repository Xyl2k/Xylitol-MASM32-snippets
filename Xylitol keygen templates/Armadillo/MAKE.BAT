@echo off
\masm32\bin\rc /v KeyGenTemplate.rc
\masm32\bin\ml.exe /c /coff /Cp /nologo KeyGenTemplate.asm
\masm32\bin\link.exe /SUBSYSTEM:WINDOWS /RELEASE /VERSION:4.0 /NODEFAULTLIB:libcmt /NODEFAULTLIB:oldnames /NODEFAULTLIB:uuid /OUT:"KeyGen Template.exe" KeyGenTemplate.obj KeyGenTemplate.res
del KeyGenTemplate.res
del KeyGenTemplate.obj
del "KeyGen Template.lib"
del "KeyGen Template.exp"
pause