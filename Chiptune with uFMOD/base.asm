.486
.model	flat, stdcall
option	casemap :none   ; case sensitive

include	\masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc

includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
include  \masm32\macros\macros.asm

includelib 		\masm32\lib\winmm.lib
include			ufmod.inc
includelib		ufmod.lib


DlgProc		PROTO :DWORD,:DWORD,:DWORD,:DWORD

IDC_OK 			equ	1003
IDC_IDCANCEL 	equ	1004

.data?
hInstance		dd		?	;dd can be written as dword

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

	.if	uMsg == WM_COMMAND
		.if	wParam == IDC_OK
; -----------------------------------------------------------------------
invoke uFMOD_PlaySong,666,hInstance,XM_RESOURCE
; -----------------------------------------------------------------------
        .elseif	wParam == IDC_IDCANCEL
			invoke uFMOD_PlaySong,0,0,0
		.endif
	.elseif	uMsg == WM_CLOSE
		invoke	EndDialog,hWin,0
	.endif

	xor	eax,eax
	ret
DlgProc	endp

end start

