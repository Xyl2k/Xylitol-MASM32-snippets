.486
.model	flat, stdcall
option	casemap :none   ; case sensitive

include	\masm32\include\windows.inc

uselib	MACRO	libname
	include		\masm32\include\libname.inc
	includelib	\masm32\lib\libname.lib
ENDM

uselib	user32
uselib	kernel32

include  \masm32\macros\macros.asm

DlgProc		PROTO :DWORD,:DWORD,:DWORD,:DWORD
SetClipboard	   		proto:DWORD

IDC_OK 			equ	1003
IDC_IDCANCEL 	equ	1004

.data
szBuffer db 256 dup(?)
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
;			TODO
; -----------------------------------------------------------------------
		invoke GetDlgItemText,hWin,1001,addr szBuffer,sizeof szBuffer
		test eax,eax
		jz nothing
		invoke SetClipboard,addr szBuffer
		ret
		
		nothing:
		invoke MessageBox,hWin,CTXT("write something please!!!"),CTXT("b0ring"),MB_ICONEXCLAMATION
		ret
        .elseif	wParam == IDC_IDCANCEL
			invoke EndDialog,hWin,0
		.endif
	.elseif	uMsg == WM_CLOSE
		invoke	EndDialog,hWin,0
	.endif

	xor	eax,eax
	ret
DlgProc	endp

SetClipboard	proc	txtSerial:DWORD
local	sLen:DWORD
local	hMem:DWORD
local	pMem:DWORD
	
invoke lstrlen, txtSerial
inc eax
mov sLen, eax
invoke OpenClipboard, 0
invoke GlobalAlloc, GHND, sLen
mov hMem, eax
invoke GlobalLock, eax
mov pMem, eax
mov esi, txtSerial
mov edi, eax
mov ecx, sLen
rep movsb
invoke EmptyClipboard
invoke GlobalUnlock, hMem
invoke SetClipboardData, CF_TEXT, hMem
invoke CloseClipboard
	
ret

SetClipboard endp
end start
