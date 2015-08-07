@echo off
\masm32\bin\rc /v Str2Dec.rc
\masm32\bin\cvtres.exe /machine:ix86 Str2Dec.res
\masm32\bin\ml.exe /c /coff Str2Dec.asm
\masm32\bin\link.exe /SUBSYSTEM:WINDOWS /OUT:xss.exe Str2Dec.obj Str2Dec.res
del Str2Dec.RES
del Str2Dec.OBJ
echo -------------------------------------
echo.
echo               DONE
echo.
echo -------------------------------------
pause