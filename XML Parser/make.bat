@echo off
\masm32\bin\rc /v rsrc.rc
\masm32\bin\ml.exe /c /coff /Cp /nologo main.asm
\masm32\bin\link.exe /SUBSYSTEM:WINDOWS /RELEASE /VERSION:4.0 /OUT:xml_parser.exe main.obj rsrc.res
del rsrc.res
del main.obj