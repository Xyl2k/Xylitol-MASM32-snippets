.486
.model	flat, stdcall
option	casemap :none ; case sensitive
; SendDlgItemMessageA, this  example works with WindowsXP calc.

include         \masm32\include\windows.inc
include         \masm32\include\user32.inc
include         \masm32\include\kernel32.inc

includelib      \masm32\lib\user32.lib
includelib      \masm32\lib\kernel32.lib

DlgProc         PROTO :DWORD,:DWORD,:DWORD,:DWORD

.const
IDB_EXIT        equ 1001
IDC_TEXT        equ 1002
IDC_GROUPBOX    equ 1003
IDC_STATIC1004  equ 1004

.data
; App Target detail
szAppNameDlg    db "Calculator",0
szAppClassDlg   db "SciCalc",0

; Dialog details
szTitle         db  "SendDlgItemMessageA example",0
szGroupBox      db  "Text to send inside winXP calc",0
szIDBExit       db  "eXiT",0
szNotFound      db  "FindWindow failed !",0
szAppFound      db  "calc.exe found !",0

.data?
hInstance       dd      ? ;dd can be written as dword
szSize          DWORD   ?
szName          db      100h dup(?)
windhand        dd      ? ; Window handle of the target

.code
start:
	invoke	GetModuleHandle, NULL
	mov	hInstance, eax
	invoke	DialogBoxParam, hInstance, 101, 0, ADDR DlgProc, 0
	invoke	ExitProcess, eax

DlgProc	proc hWin :DWORD,
       uMsg  :DWORD,
       wParam  :DWORD,
       lParam  :DWORD
	.if	uMsg == WM_INITDIALOG
    ; Set the dialog controls texts. Done here in the code instead of resource
    ; file to reduce the required bytes (strings in the rc file are UNICODE not ANSI)
    invoke SetWindowText,hWin,ADDR szTitle ; Set the window title text
    invoke SetDlgItemText,hWin,IDC_GROUPBOX,ADDR szGroupBox
    invoke SetDlgItemText,hWin,IDB_EXIT,ADDR szIDBExit
	.elseif	uMsg == WM_COMMAND
        mov eax,wParam
        mov edx,eax
        shr edx,16
        and eax,0FFFFh
          .if edx == EN_CHANGE
              .if eax == IDC_TEXT
                ;send the text on the fly
                invoke GetDlgItemText,hWin,IDC_TEXT,addr szName,sizeof szName
                ; Try to get the handle of running calc.exe, you can do it from dialog CLASS, or dialog TITLE.
                ;invoke FindWindow,NULL,addr szAppNameDlg
                invoke FindWindow,addr szAppClassDlg,0
                  .if eax
                      ;yes! we have a calculator handle!
                      mov windhand, eax
                      invoke SetDlgItemText,hWin,IDC_STATIC1004,ADDR szAppFound
                      ; 403: control ID for the 'result' edit control on calc.exe
                      invoke SendDlgItemMessageA,windhand,403,WM_SETTEXT,0,addr szName
                  .else
                  invoke SetDlgItemText,hWin,IDC_STATIC1004,ADDR szNotFound
              .endif
          .endif
		.endif
	.endif
	.if	wParam == IDB_EXIT
	; Exit button, so send a close message
         invoke EndDialog,hWin,0
	.endif
	.if	uMsg == WM_CLOSE
         invoke EndDialog,hWin,0
	.endif

	xor	eax,eax
	ret
DlgProc	endp

end start