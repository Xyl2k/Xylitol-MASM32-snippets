.486
.model	flat, stdcall
option	casemap :none

include	\masm32\include\windows.inc
include cryptohash.inc
includelib cryptohash.lib

UseLib	MACRO	libname
	include		\masm32\include\libname.inc
	includelib	\masm32\lib\libname.lib
ENDM

UseLib	user32
UseLib	kernel32


DlgProc		PROTO :DWORD,:DWORD,:DWORD,:DWORD

IDC_OK 			equ	1003
IDC_IDCANCEL 	equ	1004
szSize			equ	256

.data?
hInstance		dd		?
szInput 		db szSize dup(?)
szOutput 		db szSize dup(?)

.code
start:
	invoke	GetModuleHandle, NULL
	mov	hInstance, eax
	invoke	DialogBoxParam, hInstance, 101, 0, ADDR DlgProc, 0
	invoke	ExitProcess, eax
	
DlgProc	proc hWin:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
	.if	uMsg == WM_COMMAND
			MOV EAX,wParam
			MOV EDX,EAX
			SHR EDX,16
			AND EAX,0FFFFH
		.if edx == EN_CHANGE
			.if eax == 1001
				invoke GetDlgItemText,hWin,1001,addr szInput,szSize
				mov edx,eax
				invoke SHA1Init
				invoke SHA1Update,addr szInput,edx
				invoke SHA1Final
				invoke HexEncode,eax,SHA1_DIGESTSIZE,addr szOutput
				invoke SetDlgItemText,hWin,1002,addr szOutput
			.endif
		.endif	
	.elseif	uMsg == WM_CLOSE
		invoke	EndDialog,hWin,0
	.endif
	xor	eax,eax
	ret
DlgProc	endp

end start
