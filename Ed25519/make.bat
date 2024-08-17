@echo off
\masm32\bin\rc /v EdDSA_dlg.rc
\masm32\bin\ml.exe /c /coff /Cp /nologo EdDSA.asm
\masm32\bin\link.exe /SUBSYSTEM:WINDOWS /RELEASE /VERSION:4.0 /OUT:EdDSA.exe EdDSA.obj EdDSA_dlg.res
del EdDSA_dlg.res
del EdDSA.obj