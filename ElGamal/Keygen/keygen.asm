.586
.model flat,stdcall
option casemap:none

include          \masm32\include\windows.inc
include          \masm32\macros\macros.asm
include          \masm32\include\user32.inc
include          \masm32\include\kernel32.inc
include          \masm32\include\advapi32.inc

includelib       \masm32\lib\user32.lib
includelib       \masm32\lib\kernel32.lib
includelib       \masm32\lib\advapi32.lib

include          libs/cryptohash.inc
includelib       libs/cryptohash.lib

include          Libs/bignum.inc
includelib       Libs/bignum.lib

DlgProc          PROTO :DWORD,:DWORD,:DWORD,:DWORD
Generate         PROTO :HWND
HexToChar        PROTO :DWORD,:DWORD,:DWORD
Clean            PROTO

.const
IDD_MAIN         equ 1000
IDB_EXIT         equ 1001
IDC_NAME         equ 1002
IDC_SERIAL       equ 1005
IDB_GENERATE     equ 1006
IDB_ABOUT        equ 1007

.data
szSerialDialog   db "KeygenMe by Xyl",0
szName           db 100h dup(?)
UnRev            db 100h dup(?)
szSerial         db 100h dup(?)
Message          dd 20h  dup(?)
hash             dd 20h  dup(?)
SerPart1         db 30h  dup(?)
SerPart2         db 30h  dup(?)

.data?
hInstance        dd ?
windhand         dd ?
.code
start:
    invoke GetModuleHandle,NULL
    mov hInstance,eax
    invoke DialogBoxParam,hInstance,IDD_MAIN,0,offset DlgProc,0
    invoke ExitProcess,eax

DlgProc proc uses esi edi hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
    mov eax,uMsg

    .if eax == WM_INITDIALOG
        invoke  LoadIcon,hInstance,1337
        invoke  SendMessage, hWnd, WM_SETICON, 1, eax
    .elseif eax == WM_COMMAND
        mov eax,wParam
        .if eax == IDB_EXIT
            invoke  SendMessage, hWnd, WM_CLOSE, 0, 0
        .elseif eax == IDB_GENERATE
            invoke  Generate,hWnd
            invoke  Clean
        .endif
    .elseif eax == WM_CLOSE
        invoke  EndDialog, hWnd, 0
    .endif
    xor eax,eax
    ret
DlgProc endp

Generate proc hWnd:HWND
LOCAL P,G,X,R,S,M,KRND,szlen:DWORD

    pushad
    invoke bnInit,128
    bnCreateX P,G,X,R,S,M,KRND
   
    invoke GetDlgItemText,hWnd,IDC_NAME,addr szName,sizeof szName
    .if eax <= 2
        invoke SetDlgItemText,hWnd,IDC_SERIAL,chr$('Type more chars!')
    .elseif eax >= 50
        invoke SetDlgItemText,hWnd,IDC_SERIAL,chr$('Type less chars!')
    .elseif
        invoke lstrlen,addr szName
        mov szlen,eax
        lea esi,szName
        lea edi, UnRev
        mov ecx, szlen
        xor ebx, ebx
        Reversor:
            mov al, byte ptr[esi+ecx-1]
            mov byte ptr[edi+ebx], al
            inc ebx
            dec ecx
        jnz Reversor
        mov byte ptr[edi+ebx], 0

;MD5
        invoke lstrlen,addr UnRev
        mov szlen,eax
        invoke MD5Init
        invoke MD5Update,addr UnRev,szlen
        invoke MD5Final
        invoke HexToChar,eax,addr Message,16
        invoke RtlZeroMemory,addr UnRev,sizeof UnRev
        invoke bnFromHex,addr Message,M
        invoke bnFromHex,chr$('1B17D9B6579F77A9'),P ; Prime
        invoke bnFromHex,chr$('7F05F26551F2767'),G ; Generator
        invoke bnFromHex,chr$('6BB11B5EBEF098B'),X ; Private
        invoke bnRsaGenPrime,KRND,32
        invoke bnMod,M,P,M
        invoke bnModExp,G,KRND,P,R
        invoke bnDec,P
        invoke bnModInv,KRND,P,KRND
        invoke bnAdd,M,P
        invoke bnMul,X,R,S
        invoke bnMod,S,P,S
        invoke bnSub,M,S
        invoke bnMod,M,P,M
        invoke bnMul,M,KRND,S
        invoke bnMod,S,P,S
        invoke bnInc,P
        invoke bnToHex,R,addr SerPart1
        invoke bnToHex,S,addr SerPart2
        invoke lstrcat,addr szSerial,addr SerPart1
        invoke lstrcat,addr szSerial,addr SerPart2
        invoke SetDlgItemText,hWnd,IDC_SERIAL,addr szSerial

        invoke FindWindow,NULL,addr szSerialDialog
        .if eax
            mov windhand, eax
            invoke SendDlgItemMessageA,windhand,1002,WM_SETTEXT,0,addr szName
            invoke SendDlgItemMessageA,windhand,1003,WM_SETTEXT,0,addr szSerial
        .endif
    .endif

    bnDestroyX
    invoke bnFinish
    popad
    Ret
Generate endp

HexToChar Proc HexValue:DWORD,CharValue:DWORD,HexLength:DWORD
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

Clean   Proc
    invoke  RtlZeroMemory,addr szName,sizeof szName
    invoke  RtlZeroMemory,addr szSerial,sizeof szSerial
    invoke  RtlZeroMemory,addr Message,sizeof Message
    invoke  RtlZeroMemory,addr hash,sizeof hash
    invoke  RtlZeroMemory,addr SerPart1,sizeof SerPart1
    invoke  RtlZeroMemory,addr SerPart2,sizeof SerPart2
    Ret
Clean endp

end start