.686
.model flat,stdcall
option casemap:none


include		\masm32\include\windows.inc
include		\masm32\include\kernel32.inc
include		\masm32\include\user32.inc
include		\masm32\include\gdi32.inc
include		\masm32\include\comctl32.inc
include		\masm32\include\winmm.inc
include		\masm32\include\masm32.inc
include 	\masm32\macros\macros.asm
include		\masm32\include\ole32.inc
include 	\masm32\include\oleaut32.inc

includelib		\masm32\lib\kernel32.lib
includelib		\masm32\lib\user32.lib
includelib		\masm32\lib\gdi32.lib
includelib		\masm32\lib\comctl32.lib
includelib		\masm32\lib\winmm.lib
includelib		\masm32\lib\ole32.lib
includelib  	\masm32\lib\oleaut32.lib
includelib		\masm32\lib\masm32.lib


include btnt.inc

DlgProc		PROTO :DWORD,:DWORD,:DWORD,:DWORD

.data?
hIcon		dd	?
hCursor		dd	?

.const
IDC_ABOUT		= 	1006
IDC_IDCANCEL	= 	1007


.code
start:
	invoke	GetModuleHandle, NULL
	mov	hInstance, eax
	
	invoke LoadCursor,hInstance,300
	mov hCursor,eax
	
	invoke	DialogBoxParam, hInstance, 101, 0, ADDR DlgProc, 0
	invoke	ExitProcess, eax
; -----------------------------------------------------------------------
DlgProc	proc	hWin	:DWORD,
		uMsg	:DWORD,
		wParam	:DWORD,
		lParam	:DWORD

	.if uMsg==WM_INITDIALOG
invoke ImageButton,hWin,3,3,601,603,602,IDC_ABOUT	;custom image button (JPG,BMP,PNG) Left,Up,DownID,UpID,OverID
mov hAbout,eax
invoke ImageButton,hWin,38,3,701,703,702,IDC_IDCANCEL		;custom image button (JPG,BMP,PNG) Left,Up,DownID,UpID,OverID
mov hExit,eax

	.elseif	uMsg == WM_COMMAND
		.if	wParam == IDC_ABOUT
			invoke MessageBox,hWin,CTXT("this is about box"),CTXT("about"),MB_ICONINFORMATION
		.elseif	wParam == IDC_IDCANCEL
			invoke EndDialog,hWin,0
		.endif
	.elseif uMsg == WM_RBUTTONDOWN
		invoke SetCursor,hCursor
	.elseif uMsg == WM_LBUTTONDOWN
		invoke SetCursor,hCursor
	.elseif uMsg == WM_MOUSEMOVE
		invoke SetCursor,hCursor
	.elseif uMsg == WM_LBUTTONUP
		invoke SetCursor,hCursor
	.elseif uMsg == WM_LBUTTONDBLCLK
		invoke SetCursor,hCursor
	.elseif uMsg == WM_RBUTTONDBLCLK
		invoke SetCursor,hCursor
	.elseif uMsg == WM_RBUTTONUP
		invoke SetCursor,hCursor
	.elseif uMsg == WM_MBUTTONDBLCLK
		invoke SetCursor,hCursor
	.elseif uMsg == WM_MBUTTONDOWN
		invoke SetCursor,hCursor
	.elseif uMsg == WM_MBUTTONUP
		invoke SetCursor,hCursor
		
	.elseif	uMsg == WM_CLOSE
		invoke	EndDialog,hWin,0
	.endif

	xor	eax,eax
	ret
DlgProc	endp

end start
