@echo off
\masm32\bin\rc /v ttdecrypt_dlg.rc
\masm32\bin\ml.exe /c /coff /Cp /nologo ttdecrypt.asm
\masm32\bin\link.exe /SUBSYSTEM:WINDOWS /RELEASE /VERSION:4.0 /OUT:tt_decrypter.exe ttdecrypt.obj ttdecrypt_dlg.res
del ttdecrypt_dlg.res
del ttdecrypt.obj
pause