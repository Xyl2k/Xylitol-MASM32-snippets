.386
.model  flat, stdcall
option  casemap :none

include          \masm32\include\windows.inc
include          \masm32\macros\macros.asm
include          \masm32\include\user32.inc
include          \masm32\include\kernel32.inc

includelib       \masm32\lib\user32.lib
includelib       \masm32\lib\kernel32.lib

include          Libs/biglib.inc
includelib       Libs/biglib.lib
include          Libs/cryptohash.inc
includelib       Libs/cryptohash.lib

DlgProc          PROTO :DWORD,:DWORD,:DWORD,:DWORD

.const
IDD_MAIN         equ 1000
IDB_EXIT         equ 1001
IDC_NAME         equ 1002
IDC_SERIAL       equ 1005
IDB_GENERATE     equ 1006
MAXSIZE          equ 512

.data
N                db "2F774486FD3B97FFA559687F7F9D5335CA3D16FBB60C0019",0
D                db "2312552808E487A2F561E2BBEF5FB7275C2BD350491DB9A1",0

.data?
hInstance        dd ?

szName           db MAXSIZE dup(?)
szSerial         db MAXSIZE dup(?)
szHash           db MAXSIZE dup(?)

BigN             dword ?
BigD             dword ?
BigC             dword ?
BigM             dword ?

.code
start:
    invoke GetModuleHandle, NULL
    mov hInstance, eax
    invoke DialogBoxParam,hInstance,IDD_MAIN,0,offset DlgProc,0
    invoke ExitProcess,eax


DlgProc proc uses esi edi hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
        mov eax,uMsg
            .if eax == WM_INITDIALOG
                invoke GetDlgItem,hWnd,IDC_NAME
                invoke SendMessage,eax,EM_LIMITTEXT,60,0
                invoke GetDlgItem,hWnd,IDC_SERIAL
                invoke SendMessage,eax,EM_LIMITTEXT,32,0
                jmp @KEYGENNiNG
            .elseif eax == WM_COMMAND
                mov eax,wParam
                    .if eax == IDB_EXIT
                        
                        invoke SendMessage,hWnd,WM_CLOSE,0,0
                    .elseif ax == IDC_NAME
                        shr eax, 16
                        .if ax == EN_CHANGE
                            jmp @KEYGENNiNG
                        .endif
                    .elseif eax == IDB_GENERATE
                        @KEYGENNiNG:
                            invoke GetDlgItemText,hWnd,IDC_NAME,addr szName,MAXSIZE
                            cmp eax,0
                            jnz @NEXT
                            invoke SetDlgItemText,hWnd,IDC_SERIAL,chr$('Enter your name, buddy!')
                        @NEXT:
                            ;MD5
                            mov edx,eax
                            invoke MD5Init
                            invoke MD5Update,addr szName,edx
                            invoke MD5Final
                            invoke HexEncode,eax,MD5_DIGESTSIZE,addr szHash
                            ;RSA
                            invoke _BigCreate,0
                            mov BigN,eax
                            invoke _BigCreate,0
                            mov BigD,eax
                            invoke _BigCreate,0
                            mov BigC,eax
                            invoke _BigCreate,0
                            mov BigM,eax
                            invoke _BigIn,addr N,16,BigN
                            invoke _BigIn,addr D,16,BigD
                            invoke _BigIn,addr szHash,16,BigM
                            invoke _BigPowMod,BigM,BigD,BigN,BigC
                            invoke _BigOutB16,BigC,addr szSerial
                            invoke SetDlgItemText,hWnd,IDC_SERIAL,addr szSerial
                            ;releasing
                            invoke RtlZeroMemory,addr szName,sizeof szName
                            invoke RtlZeroMemory,addr szHash,sizeof szHash   
                            invoke RtlZeroMemory,addr szSerial,sizeof szSerial
                            invoke _BigDestroy,BigN
                            invoke _BigDestroy,BigD
                            invoke _BigDestroy,BigC
                            invoke _BigDestroy,BigM
                    .endif  
            .elseif eax == WM_CLOSE
                invoke  EndDialog, hWnd, 0
            .endif
        XOR EAX,EAX
        RET
DlgProc endp
end start
