DlgProc     PROTO :DWORD,:DWORD,:DWORD,:DWORD

.const
IDD_DIALOG      equ 1000
IDB_PATCH       equ 1001
IDB_QUIT        equ 1002
IDC_SERIAL      equ 1003
IDC_STATIC      equ 1004

.data
; Dialog texts
szTitle         db "CrackMe #1 by Dynasty *Serial sniffer*",0
szErrCaption    db "Err0r",0 
szErrNotFOund   db "Target not found!",13,10
                db "put crackme.exe in same dir!",0 
szIDBPatch      db "LAUNCh aPP/gET SERiAL",0
szIDBExit       db "eXIT",0
szLblSer        db "Serial:",0

; App Details
szSerial        db 30h dup (0)
szTarget        db "CrackMe1.exe",0

.data?
hInstance       dd ? ;dd can be written as dword
CommandLine     dd ?
hWnd            dd ?
tcont           CONTEXT <>
SerialThtreadID dd ?