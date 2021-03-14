; For compiling, please read.
;
;link with this:
; Link=/SUBSYSTEM:WINDOWS /RELEASE /VERSION:4.0 /NODEFAULTLIB:libc.lib /NODEFAULTLIB:libcmt.lib /NODEFAULTLIB:oldnames.lib tune.obj
;
; You need to use a new msvcrt.lib file (not the one from masm32 sdk): https://github.com/Aekras1a/Labs/blob/master/Labs/WinDDK/7600.16385.1/lib/Crt/i386/msvcrt.lib
; it is also included in this repo, but you can keep the msvcrt.inc from the masm32 folder. 
; make your tune into .obj using bin2o v0.4 by f0dder.
; LibV2M Version 1.5 with Replay-Function by eNeRGy/dAWN

.486
.model	flat, stdcall
option	casemap :none   ; case sensitive

include		\masm32\include\windows.inc 
include		\masm32\include\kernel32.inc 
include		\masm32\include\user32.inc  
include		\masm32\include\winmm.inc
include		\masm32\include\masm32.inc

include     \masm32\macros\macros.asm
include     \masm32\include\msvcrt.inc
include	V2M_V15.inc

includelib	\masm32\lib\kernel32.lib
includelib	\masm32\lib\user32.lib 
includelib	\masm32\lib\winmm.lib
includelib 	\masm32\lib\masm32.lib

includelib	V2M_V15.lib
includelib	msvcrt.lib

DlgProc		PROTO :DWORD,:DWORD,:DWORD,:DWORD

IDC_OK 			equ	1003
IDC_IDCANCEL 	equ	1004

; linking v2m through tune.obj (added in the linker command line)
externdef c theTune:byte 

.data
WindowTitle	db "MagicH's LibV2 v1.5",0
status 		   dd ?

.data?
hInstance		dd		?	;dd can be written as dword
; tune.obj is added in the linker command line
externdef c theTune:byte 

.code
start:
	invoke	GetModuleHandle, NULL
	mov	hInstance, eax

	invoke	DialogBoxParam, hInstance, 101, 0, ADDR DlgProc, 0
	invoke	ExitProcess, eax
; -----------------------------------------------------------------------

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
				invoke  V2M_V15_Init,FUNC(GetForegroundWindow),offset theTune,1000,44100,1 ; v2m initialization with current window
				invoke  V2M_V15_Play,0
				invoke SetDlgItemText,hWin,IDC_OK,chr$("Stop")
			.else
				invoke  V2M_V15_Stop,0
				invoke  V2M_V15_Close
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
