include		windows.inc
include		user32.inc
include		kernel32.inc
include		comctl32.inc	;windows common controls

includelib	user32.lib
includelib	kernel32.lib
includelib	comctl32.lib	;windows common controls

DlgProc		PROTO	:DWORD,:DWORD,:DWORD,:DWORD

.const
IDD_MAIN	equ	1000
IDB_EXIT	equ	1001
.data


.data?
hInstance	dd	?