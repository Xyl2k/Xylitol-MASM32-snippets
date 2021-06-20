.486
.model flat, stdcall
option casemap :none ; case sensitive

include		\masm32\include\windows.inc
include		\masm32\include\kernel32.inc
include		\masm32\include\user32.inc
include		\masm32\macros\macros.asm

includelib	\masm32\lib\kernel32.lib
includelib	\masm32\lib\user32.lib

include md5.asm

comment /*
MD5 Hasher
with no cryptohash.lib
/

DlgProc     PROTO :DWORD,:DWORD,:DWORD,:DWORD

.const
IDC_NAME        equ 1001
IDC_SERIAL      equ 1002
IDB_QUIT        equ 1003
IDC_GROUPBOX    equ 1004
IDC_DATE_STATIC equ 1005
MAXSiZE         equ 256

.data
; Keygen details
szNameMD5       dd MAXSiZE dup (0)

; Dialog details
szTitle         db "MD5 Hasher",0
szGroupBox      db "pLAiN ^ hASH",0
szIDBExit       db "eXiT",0
szDateStatic    db "20/06/2021",0
szTesting       db "Hello",0

.data?
hInstance       dd ? ;dd can be written as dword
szBufName       db 265 dup (?)
szName_len      dd ?

.code
start:
    invoke GetModuleHandle,NULL
    mov hInstance,eax
    invoke DialogBoxParam,hInstance,101,0,ADDR DlgProc,0
    invoke ExitProcess,eax

HexToChar Proc    HexValue    :DWORD,
                  CharValue   :DWORD,
                  HexLength   :DWORD
    mov esi,[ebp+8]
    mov edi,[ebp+0Ch]
    mov ecx,[ebp+10h]
    @HexToChar:
      lodsb
      mov ah, al
      and ah, 0fh
      shr al, 4
      add al, '0'
      add ah, '0'
       .if al > '9'
          add al, 'A'-'9'-1
       .endif
       .if ah > '9'
          add ah, 'A'-'9'-1
       .endif
      stosw
    loopd @HexToChar
    Ret
HexToChar endp

DlgProc proc    hWin    :DWORD,
                uMsg    :DWORD,
                wParam  :DWORD,
                lParam  :DWORD

    .if uMsg == WM_INITDIALOG
    ; Set the dialog controls texts. Done here in the code instead of resource
    ; file to reduce the required bytes (strings in the rc file are UNICODE not ANSI)
    invoke SetWindowText,hWin,ADDR szTitle ; Set the window title text
    invoke SetDlgItemText,hWin,IDC_GROUPBOX,ADDR szGroupBox
    invoke SetDlgItemText,hWin,IDB_QUIT,ADDR szIDBExit
    invoke SetDlgItemText,hWin,IDC_DATE_STATIC,ADDR szDateStatic
    invoke SetDlgItemText,hWin,IDC_NAME,ADDR szTesting
    .elseif uMsg == WM_COMMAND
	    mov eax,wParam
        mov edx,eax
        shr edx,16
        and eax,0FFFFh
          .if edx == EN_CHANGE
              .if eax == IDC_NAME
                  invoke GetDlgItemText,hWin,IDC_NAME,Addr szBufName,MAXSiZE
                           invoke lstrlen,addr szBufName
                           mov szName_len,eax
                           ;Compute the MD5 hash for the entered name
                           invoke MD5Init
                           invoke MD5Update,addr szBufName,szName_len
                           invoke MD5Final
                           ;hex to chars the MD5
                           invoke HexToChar,addr MD5Digest,addr szNameMD5,16
                           invoke SetDlgItemText,hWin,IDC_SERIAL,addr szNameMD5
                           call clean
              .endif
          .endif
        .if wParam == IDB_QUIT
            invoke EndDialog,hWin,0
        .endif
    .elseif	uMsg == WM_CLOSE
        invoke EndDialog,hWin,0
    .endif
    xor eax,eax
    ret
DlgProc	endp

clean proc
	invoke RtlZeroMemory,addr szBufName,sizeof szBufName
	invoke RtlZeroMemory,addr szNameMD5,sizeof szNameMD5
	invoke RtlZeroMemory,addr szName_len,sizeof szName_len
	ret
clean endp

end start
