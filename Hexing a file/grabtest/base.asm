.486
.model	flat, stdcall
option	casemap :none   ; case sensitive

include			\masm32\include\windows.inc
include			\masm32\include\user32.inc
include			\masm32\include\kernel32.inc
include			\masm32\include\shell32.inc
include			\masm32\include\advapi32.inc
include			\masm32\include\gdi32.inc
include			\masm32\include\comctl32.inc
include			\masm32\include\comdlg32.inc
include			\masm32\include\masm32.inc
include			\masm32\macros\macros.asm
includelib		\masm32\lib\user32.lib
includelib		\masm32\lib\kernel32.lib
includelib		\masm32\lib\shell32.lib
includelib		\masm32\lib\advapi32.lib
includelib		\masm32\lib\gdi32.lib
includelib		\masm32\lib\comctl32.lib
includelib		\masm32\lib\comdlg32.lib
includelib		\masm32\lib\masm32.lib

DlgProc				PROTO :DWORD,:DWORD,:DWORD,:DWORD

IDC_IDCANCEL 	equ	1004

.data? 
hInstance  				dd ?

.code
start:
	invoke	GetModuleHandle, NULL
	mov	hInstance, eax
	invoke	DialogBoxParam, hInstance, 101, 0, ADDR DlgProc, 0
	invoke	ExitProcess, eax
; -----------------------------------------------------------------------
DlgProc	proc hWin:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD

	.if	uMsg == WM_COMMAND
		.if	wParam == IDC_IDCANCEL
			invoke EndDialog,hWin,0
		.endif
	.elseif	uMsg == WM_CLOSE
		invoke	EndDialog,hWin,0
	.endif

	xor	eax,eax
	ret
DlgProc	endp

end start
