.486
.model	flat, stdcall
option	casemap :none   ; case sensitive

include	\masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc

includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
include  \masm32\macros\macros.asm

DlgProc		PROTO :DWORD,:DWORD,:DWORD,:DWORD
FadeIn      		proto		:DWORD
FadeOut		    	proto		:DWORD
MakeDialogTransparent 	PROTO :DWORD,:DWORD

IDC_OK 			equ	1003
IDC_IDCANCEL 	equ	1004

.data?
hInstance		dd		?	;dd can be written as dword

.data
Transparency		dd		?
TRANSPARENT_VALUE	equ 200							;Opacity Value ( max value is 254 )

.const
DELAY_VALUE		equ		10

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
	.if uMsg==WM_INITDIALOG
		invoke FadeIn,hWin
		invoke MakeDialogTransparent,hWin,TRANSPARENT_VALUE
	.elseif	uMsg == WM_COMMAND
		.if	wParam == IDC_OK
; -----------------------------------------------------------------------
;			TODO
; -----------------------------------------------------------------------
			invoke FadeOut,hWin
			invoke FadeIn,hWin
; -----------------------------------------------------------------------
        .elseif	wParam == IDC_IDCANCEL
        invoke FadeOut,hWin
			invoke EndDialog,hWin,0
		.endif
	.elseif	uMsg == WM_CLOSE
		invoke	EndDialog,hWin,0
	.endif

	xor	eax,eax
	ret
DlgProc	endp


align dword
FadeIn proc hWin:HWND
	invoke ShowWindow,hWin,SW_SHOW
	mov Transparency,250
@@:
	invoke SetLayeredWindowAttributes,hWin,0,Transparency,LWA_ALPHA
	invoke Sleep,DELAY_VALUE
	add Transparency,5
	cmp Transparency,255
	jne @b
	ret 
FadeIn endp

FadeOut proc hWin:HWND
	mov Transparency,250
@@:
	invoke SetLayeredWindowAttributes,hWin,0,Transparency,LWA_ALPHA
	invoke Sleep,DELAY_VALUE
	sub Transparency,5
	cmp Transparency,0
	jne @b
	ret
FadeOut endp

MakeDialogTransparent proc _handle:dword,_transvalue:dword
	
	pushad
	invoke GetModuleHandle,chr$("user32.dll")
	invoke GetProcAddress,eax,chr$("SetLayeredWindowAttributes")
	.if eax!=0
		invoke GetWindowLong,_handle,GWL_EXSTYLE	;get EXSTYLE
		
		.if _transvalue==255
			xor eax,WS_EX_LAYERED	;remove WS_EX_LAYERED
		.else
			or eax,WS_EX_LAYERED	;eax = oldstlye + new style(WS_EX_LAYERED)
		.endif
		
		invoke SetWindowLong,_handle,GWL_EXSTYLE,eax
		
		.if _transvalue<255
			invoke SetLayeredWindowAttributes,_handle,0,_transvalue,LWA_ALPHA
		.endif	
	.endif
	popad
	ret
MakeDialogTransparent endp

end start
