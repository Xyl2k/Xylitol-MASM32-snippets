include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
include \masm32\include\windows.inc
include \masm32\include\shell32.inc
include \masm32\include\comctl32.inc
include \masm32\include\comdlg32.inc
include \masm32\include\advapi32.inc
include \masm32\include\gdi32.inc

includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\shell32.lib
includelib \masm32\lib\comctl32.lib
includelib \masm32\lib\comdlg32.lib
includelib \masm32\lib\advapi32.lib
includelib \masm32\lib\gdi32.lib

WinMain				  PROTO :DWORD,:DWORD,:DWORD,:DWORD
DlgProc				  PROTO :DWORD,:DWORD,:DWORD,:DWORD

.const
IDD_DIALOG 	equ 1000
IDC_STATIC 	equ	1002
IDC_PATH 	equ	1003
IDC_QUIT 	equ	1004
IDC_SERIAL 	equ	1005

.data
ClassName			  db 'DLGCLASS',0
AppName				  db 'anx Crackme Serial Retriever',0
serial          db 30h dup (0)

.data?
hInstance		dd		?	;dd can be written as dword
CommandLine		  dd ?

hWnd				    dd ?
tcont           CONTEXT <>
SerialThtreadID dd ?

