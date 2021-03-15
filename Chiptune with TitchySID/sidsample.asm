.486
.model	flat, stdcall
option	casemap :none   ; case sensitive

include		\masm32\include\windows.inc
include		\masm32\include\user32.inc
include		\masm32\include\kernel32.inc
include		\masm32\macros\macros.asm

includelib  \masm32\lib\user32.lib
includelib  \masm32\lib\kernel32.lib
includelib 	\masm32\lib\winmm.lib

include		resource.inc
include		titchysid.inc
includelib  titchysid_extras.lib


DlgProc		PROTO :DWORD,:DWORD,:DWORD,:DWORD

IDC_OK 			equ	1003
IDC_IDCANCEL 	equ	1004

.data?
hInstance		dd		?	;dd can be written as dword

.data
status 		   dd ?

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
				invoke SIDOpen, IDR_MUSIC, 0, SID_RESOURCE, SID_DEFAULT, 0
				call SIDPlay
				invoke SetDlgItemText,hWin,IDC_OK,chr$("Stop")
			.else
				call SIDStop
				call SIDClose
				invoke SetDlgItemText,hWin,IDC_OK,chr$("Play")
				mov status,1
		.endif
        .elseif	wParam == IDC_IDCANCEL
        call SIDClose
		invoke	SendMessage, hWin, WM_CLOSE, 0, 0
		.endif
	.elseif	uMsg == WM_CLOSE
		invoke EndDialog,hWin,0
	.endif

	xor	eax,eax
	ret
DlgProc	endp

end start

