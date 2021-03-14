@echo off
title Compiler
echo.
echo     ____/\_____/\____/\____/\____/\____/\____/\__/\____/\____/\
echo    /  ___/  /   /  - _/  __ / __  /  ___/ __  /   /     /  ___/\
echo   /  /  /__  __/  -  /  _/_/    _/  /  /    _/   / / / /  _/__\/
echo  /_____/ /___//_____/_____/__/__/_____/__/__/___/_/_/_/_____/\nf!
echo  \_____\/\___\\_____\_____\__\__\_____\__\__\___\_\_\_\_____\/CYBERCRIME
echo.
echo http://atm.cybercrime-tracker.net/
echo.
set path=\masm32\bin
set lib=\masm32\lib
set name=Code
del CSCWCNG.dll

ml.exe /c /coff %name%.asm
link.exe /SUBSYSTEM:WINDOWS /ENTRY:_DllMainCRTStartup /DLL /DEF:Exports.def "%name%".obj 

del *.lib
del *.obj
del *.exp
pause