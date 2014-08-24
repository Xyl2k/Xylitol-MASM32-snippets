.486
.model	flat, stdcall
option	casemap :none   ; case sensitive

include	windows.inc

uselib	MACRO	libname
	include		libname.inc
	includelib	libname.lib
ENDM

uselib	user32
uselib	kernel32
uselib	comctl32
uselib	masm32
uselib	gdi32
uselib	ole32
uselib	oleaut32
uselib	advapi32
uselib	comdlg32
uselib	shell32

include 	\masm32\macros\macros.asm
include crc32.inc



DlgProc		PROTO :DWORD,:DWORD,:DWORD,:DWORD

IDC_OK 			equ	1003
IDC_IDCANCEL 	equ	1004

.data
TargetCRC32  dd 48EBC948h

.data?
hInstance		dd		?	;dd can be written as dword
szFileName db 512 dup(?)

.code
start:
	invoke	GetModuleHandle, NULL
	mov	hInstance, eax
	invoke	DialogBoxParam, hInstance, 101, 0, ADDR DlgProc, 0
	invoke	ExitProcess, eax
; -----------------------------------------------------------------------
DlgProc	proc hWin:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
LOCAL pFileMem:DWORD
LOCAL ff32:WIN32_FIND_DATA

	.if	uMsg == WM_COMMAND
		.if	wParam == IDC_OK
; ------------------------------------------------------------------------------------------------
;			TODO
; ------------------------------------------------------------------------------------------------
					invoke FindFirstFile,ADDR szFileName,ADDR ff32
					call InitCRC32Table
					mov pFileMem,InputFile(ADDR szFileName)
					invoke CRC32,pFileMem,ff32.nFileSizeLow
					mov edx,TargetCRC32
					.if eax != edx
						invoke SetDlgItemText,hWin,1005,CTXT("crc32 is incorrect")
					.else
						invoke SetDlgItemText,hWin,1005,CTXT("crc32 is correct")
					.endif
; ------------------------------------------------------------------------------------------------
        .elseif	wParam == IDC_IDCANCEL
			invoke EndDialog,hWin,0
		.endif
.elseif uMsg == WM_DROPFILES
		invoke DragQueryFile,wParam,NULL,addr szFileName,sizeof szFileName
		invoke DragFinish,wParam
		invoke SetDlgItemText,hWin,1001,addr szFileName
		
	.elseif	uMsg == WM_CLOSE
		invoke	EndDialog,hWin,0
	.endif

	xor	eax,eax
	ret
DlgProc	endp

end start
