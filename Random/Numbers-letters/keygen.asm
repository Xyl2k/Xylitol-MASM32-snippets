.386
.model	flat, stdcall
option	casemap :none

include		windows.inc
include		user32.inc
include		kernel32.inc
include		comctl32.inc

includelib	user32.lib
includelib	kernel32.lib
includelib	comctl32.lib

DlgProc		PROTO	:DWORD,:DWORD,:DWORD,:DWORD
GenRandomNumbers	PROTO	:DWORD,:DWORD
Randomize		PROTO

;
.const
IDD_MAIN		equ	1000
IDB_EXIT		equ	1001
IDC_NAME		equ	1002
IDC_SERIAL		equ	1005
IDB_GENERATE	equ	1006
IDB_ABOUT       equ 1007

.data
Rndm			dd	0
B32Chars		db	"0123456789ABCDEFGHIJKLMNOPQRSTUV",0

.data?
hInstance   dd  ?
szSerial	db	100h	dup(?)
szSerial2	db	100h	dup(?)

.code
start:
	invoke	GetModuleHandle, NULL
	mov	hInstance, eax
	invoke	DialogBoxParam, hInstance, IDD_MAIN, 0, offset DlgProc, 0
	invoke	ExitProcess, eax
	invoke	InitCommonControls
	
DlgProc proc uses esi edi hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
	mov	eax,uMsg

	.if	eax == WM_INITDIALOG
		invoke	LoadIcon,hInstance,200
		invoke	SendMessage, hWnd, WM_SETICON, 1, eax
	.elseif eax == WM_COMMAND
		mov	eax,wParam
		.if	eax == IDB_EXIT
			invoke	SendMessage, hWnd, WM_CLOSE, 0, 0
		.elseif eax == IDB_GENERATE
			invoke	GenRandomNumbers,addr szSerial, 2
			invoke lstrcpy,addr szSerial2,addr szSerial
			invoke RtlZeroMemory,addr szSerial,sizeof szSerial
			invoke	SetDlgItemText,hWnd,IDC_SERIAL,addr szSerial2
			invoke	RtlZeroMemory,addr szSerial2,sizeof szSerial2
		.endif
	.elseif	eax == WM_CLOSE
		invoke	EndDialog, hWnd, 0
	.endif
	xor	eax,eax
	ret
DlgProc endp

GenRandomNumbers	Proc uses ebx	pIn:DWORD,pLen:DWORD
	mov edi,pIn
	mov ebx,pLen
	.repeat
		invoke	Randomize
		mov ecx,32			; Change this number to a new Alphabet size if your gonna modify it
		xor edx,edx
		idiv ecx
		movzx eax,byte ptr [edx+B32Chars]
		stosb
		dec ebx
	.until zero?
	Ret
GenRandomNumbers endp

Randomize	Proc uses ecx
	invoke	GetTickCount
	add Rndm,eax
	add Rndm,eax
	add Rndm,'abcd'
	Rol Rndm,4
	mov eax,Rndm
;	imul eax,'seed'
	Ret
Randomize endp
end start