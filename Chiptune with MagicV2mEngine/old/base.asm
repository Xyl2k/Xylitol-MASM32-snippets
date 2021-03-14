; For compiling, please read.
;
;link with this:
; Link=/SUBSYSTEM:WINDOWS /RELEASE /VERSION:4.0 /NODEFAULTLIB:libc.lib /NODEFAULTLIB:libcmt.lib /NODEFAULTLIB:oldnames.lib
;
; make your tune into .obj using bin2o v0.4 by f0dder, also included in the repo.

.486
.model	flat, stdcall
option	casemap :none   ; case sensitive

include		\masm32\include\windows.inc 
include		\masm32\include\kernel32.inc 
include		\masm32\include\user32.inc  
include		\masm32\include\winmm.inc
include		\masm32\include\masm32.inc
include		\masm32\include\oleaut32.inc
include		\masm32\include\ole32.inc
include		\masm32\include\msvcrt.inc
include	MagicV2mEngine.inc
include		\masm32\macros\macros.asm

includelib	\masm32\lib\kernel32.lib
includelib	\masm32\lib\user32.lib 
includelib	\masm32\lib\winmm.lib
includelib 	\masm32\lib\masm32.lib
includelib  \masm32\lib\oleaut32.lib
includelib  \masm32\lib\ole32.lib
includelib	\masm32\lib\msvcrt.lib
includelib	MagicV2mEngine.lib


DlgProc		PROTO :DWORD,:DWORD,:DWORD,:DWORD

IDC_OK 			equ	1003
IDC_IDCANCEL 	equ	1004

.data
include sharedsouls.inc ; v2m
WindowTitle	db "MagicV2mEngine.lib by: Magic_h2001",0
status 		   dd ?

.data?
hInstance		dd		?	;dd can be written as dword

.code
start:
	invoke	GetModuleHandle, NULL
	mov	hInstance, eax

	invoke	DialogBoxParam, hInstance, 101, 0, ADDR DlgProc, 0
	invoke	ExitProcess, eax

DlgProc	proc	hWin	:DWORD,
		uMsg	:DWORD,
		wParam	:DWORD,
		lParam	:DWORD
	.if	uMsg == WM_INITDIALOG
    mov status,1 
	.elseif	uMsg == WM_COMMAND
		.if wParam == IDC_OK
			.if status == 1
				mov status,0
				invoke  MAGICV2MENGINE_DllMain,hInstance,DLL_PROCESS_ATTACH,0
				invoke 	V2mPlayStream, addr v2m_Data,TRUE
				invoke SetDlgItemText,hWin,IDC_OK,chr$("Stop")
			.else
				invoke  V2mStop
				invoke  MAGICV2MENGINE_DllMain,hInstance,DLL_PROCESS_DETACH,0
				invoke SetDlgItemText,hWin,IDC_OK,chr$("Play")
				mov status,1
		.endif
        .elseif	wParam == IDC_IDCANCEL
		invoke	SendMessage, hWin, WM_CLOSE, 0, 0
		.endif
	.elseif	uMsg == WM_CLOSE
		invoke EndDialog,hWin,0
	.endif

	xor	eax,eax
	ret
DlgProc	endp

end start