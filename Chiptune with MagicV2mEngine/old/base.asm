; For compiling, please read.
;
;link with this:
; Link=/SUBSYSTEM:WINDOWS /RELEASE /VERSION:4.0 /NODEFAULTLIB:libc.lib /NODEFAULTLIB:libcmt.lib /NODEFAULTLIB:oldnames.lib
;
; make your tune into .obj using bin2o v0.4 by f0dder, also included in the repo.

.486
.model	flat, stdcall
option	casemap :none   ; case sensitive

include		windows.inc 
include		kernel32.inc 
include		user32.inc 
include		winmm.inc
include		masm32.inc
include		oleaut32.inc
include		ole32.inc
include		msvcrt.inc
include	MagicV2mEngine.inc
include \masm32\macros\macros.asm

includelib	kernel32.lib
includelib	user32.lib 
includelib	winmm.lib
includelib 	masm32.lib
includelib  oleaut32.lib
includelib  ole32.lib
includelib	msvcrt.lib
includelib	MagicV2mEngine.lib


DlgProc		PROTO :DWORD,:DWORD,:DWORD,:DWORD

IDC_OK 			equ	1003
IDC_IDCANCEL 	equ	1004

.data
include sharedsouls.inc ; v2m
WindowTitle	db "MagicV2mEngine.lib by: Magic_h2001",0

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
	.if	uMsg == WM_INITDIALOG
	invoke SetWindowText, hWin, addr WindowTitle
	.elseif	uMsg == WM_COMMAND
		.if	wParam == IDC_OK
; -----------------------------------------------------------------------
		invoke  MAGICV2MENGINE_DllMain,hInstance,DLL_PROCESS_ATTACH,0
		invoke 	V2mPlayStream, addr v2m_Data,TRUE
; -----------------------------------------------------------------------
        .elseif	wParam == IDC_IDCANCEL
		invoke  V2mStop
  		invoke  MAGICV2MENGINE_DllMain,hInstance,DLL_PROCESS_DETACH,0
		.endif
	.elseif	uMsg == WM_CLOSE
		invoke	EndDialog,hWin,0
	.endif

	xor	eax,eax
	ret
DlgProc	endp

end start
