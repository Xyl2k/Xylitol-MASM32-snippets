comment ~---------------------------------------------------------------------
	Example code to use the YM files player library by Leonard (Arnaud Carre)
	(http://leonard.oxg.free.fr)
	
	by UFO-Pu55y[SnD] 2012, embeded into rc by Xyl2k
-----------------------------------------------------------------------------~

.386
.model	flat, stdcall
option	casemap :none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
include	\masm32\include\comctl32.inc	;windows common controls
include		\masm32\macros\macros.asm

includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib
includelib	\masm32\lib\comctl32.lib	;windows common controls

include StSoundLibrary\StSoundLibrary.inc

DlgProc		PROTO	:DWORD,:DWORD,:DWORD,:DWORD

.const
IDD_MAIN	equ	1000
IDB_EXIT	equ	1001
IDC_BUTTON1002 equ	1002
.data?
hInstance	dd ?
hRes		dd ?
lenRes		dd ?
pMusic		dd ?
	
.data
szFileName	   db "YMs\\Union Tcb 2.ym", 0
ID_MSX		   EQU 1001
IDC_BUTTON1002 equ 1002
status 		   dd ?
	
.code
start:
	invoke	GetModuleHandle, NULL
	mov	hInstance, eax
	invoke	InitCommonControls
	invoke	DialogBoxParam, hInstance, IDD_MAIN, 0, offset DlgProc, 0
	invoke	ExitProcess, eax

DlgProc proc hWin:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
	mov	eax,uMsg
	
	.if	eax == WM_INITDIALOG
		invoke	LoadIcon,hInstance,200
		invoke	SendMessage, hWin, WM_SETICON, 1, eax
		invoke ymMusicCreate
		mov pMusic, eax
		;invoke ymMusicLoad, pMusic, addr szFileName ; Load from file
		invoke FindResource, hInstance, ID_MSX, RT_RCDATA ; Load from resources
            .if eax
				mov hRes, eax
				invoke SizeofResource, hInstance, eax
				mov lenRes, eax
				invoke LoadResource, hInstance, hRes
				.if eax
					invoke LockResource, eax
					.if eax
						invoke ymMusicLoadMemory, pMusic, eax, lenRes
					.endif
				.endif
			.endif
					invoke ymMusicSetLoopMode, pMusic, TRUE

		mov status,1 
	.elseif eax == WM_COMMAND
		mov	eax,wParam
		.if	eax == IDB_EXIT
			invoke ymMusicSoundServerStop, pMusic
			invoke ymMusicDestroy, pMusic
			invoke	SendMessage, hWin, WM_CLOSE, 0, 0
		.endif
		.if eax == IDC_BUTTON1002
			.if status == 1
				mov status,0
				invoke SetDlgItemText,hWin,IDC_BUTTON1002,chr$("Stop")
				invoke ymMusicSoundServerStart, pMusic
				invoke ymMusicPlay, pMusic
			.else
				invoke SetDlgItemText,hWin,IDC_BUTTON1002,chr$("Play")
				invoke ymMusicSoundServerStop, pMusic
				mov status,1
			.endif
		.endif
	.elseif	eax == WM_CLOSE
		invoke ymMusicSoundServerStop, pMusic
		invoke ymMusicDestroy, pMusic
		invoke	EndDialog, hWin, 0
	.endif

	xor	eax,eax
	ret
DlgProc endp

end start