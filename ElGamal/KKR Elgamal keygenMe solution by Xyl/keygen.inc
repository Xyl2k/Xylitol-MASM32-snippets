include          \masm32\include\windows.inc
include          \masm32\macros\macros.asm
include          \masm32\include\user32.inc
include          \masm32\include\kernel32.inc
include          \masm32\include\advapi32.inc
include          \masm32\include\comctl32.inc

includelib       \masm32\lib\user32.lib
includelib       \masm32\lib\kernel32.lib
includelib       \masm32\lib\advapi32.lib
includelib       \masm32\lib\comctl32.lib

DlgProc		PROTO	:DWORD,:DWORD,:DWORD,:DWORD

.const
IDD_MAIN		equ	1000
IDB_EXIT		equ	1001
IDC_NAME		equ	1002
IDC_SERIAL		equ	1005
IDB_GENERATE	equ	1006
IDB_ABOUT       equ 1007

.data?
hInstance   dd  ?