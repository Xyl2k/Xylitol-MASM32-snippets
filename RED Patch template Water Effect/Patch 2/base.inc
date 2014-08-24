include	windows.inc

uselib	MACRO	libname
	include		libname.inc
	includelib	libname.lib
ENDM

uselib	user32
uselib	kernel32

DlgProc		PROTO :DWORD,:DWORD,:DWORD,:DWORD

IDC_OK 			equ	1003
IDC_IDCANCEL 	equ	1004

.data?
hInstance		dd		?	;dd can be written as dword
