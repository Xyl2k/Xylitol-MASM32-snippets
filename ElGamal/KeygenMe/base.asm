.486
.model flat,stdcall
option casemap:none ;case sensitive

include          \masm32\include\windows.inc

include          \masm32\macros\macros.asm
include          \masm32\include\user32.inc
include          \masm32\include\kernel32.inc

includelib       \masm32\lib\user32.lib
includelib       \masm32\lib\kernel32.lib

include          libs/biglib.inc
include          libs/cryptohash.inc

includelib       libs/biglib.lib
includelib       libs/cryptohash.lib

DlgProc          PROTO :DWORD,:DWORD,:DWORD,:DWORD
KeygenProc       PROTO :HWND

.const
IDC_NAME         equ 1002
IDC_SERIAL       equ 1003
IDC_STATiC       equ 1026
        
BTN_CHECK        equ 1005
BTN_CLOSE        equ 1004
        
MAXSiZE          equ 512

.data
Prime            db "1B17D9B6579F77A9",0 ;P
Base             db "7F05F26551F2767",0 ;G
PubKey           db "177A5D687A598663",0 ;Y

szName           dd MAXSiZE dup(00)
szSerial         dd MAXSiZE dup(00)
szSerial1        dd MAXSiZE dup(00)
szSerial2        dd MAXSiZE dup(00)
szMD5            dd MAXSiZE dup(00)
UnRev            dd MAXSiZE dup(00) 

.data?
hInstance        dd ? ;dd can be written as dword
R                dd ?
S                dd ?
P                dd ?
G                dd ?
Y                dd ?
M                dd ?
tmp1             dd ?
tmp2             dd ?
tmp3             dd ?
szlen            dd ? 

.code
start:
    invoke GetModuleHandle,NULL
    mov hInstance,eax
    invoke DialogBoxParam,hInstance,101,0,ADDR DlgProc,0
    invoke ExitProcess,eax

DlgProc proc hWin:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
    .if uMsg == WM_COMMAND
        .if wParam == BTN_CHECK
            ;Name length check
            invoke GetDlgItemText,hWin,IDC_NAME,ADDR szName,MAXSiZE
            .if eax == 0
                invoke SetDlgItemText,hWin,IDC_STATiC,chr$("NAME STATUS: NO NAME")
            .elseif eax > 15
                invoke SetDlgItemText,hWin,IDC_STATiC,chr$("NAME STATUS: TOO LONG")
            .elseif eax < 3
                invoke SetDlgItemText,hWin,IDC_STATiC,chr$("NAME STATUS: TOO SHORT")
            .elseif
                ;Serial lenght check
                invoke GetDlgItemText,hWin,IDC_SERIAL,ADDR szSerial,MAXSiZE
                .if eax == 0
                    invoke SetDlgItemText,hWin,IDC_STATiC,chr$("SERiAL STATUS: NO SERiAL")
                .elseif
                    .if eax >= 33
                        invoke SetDlgItemText,hWin,IDC_STATiC,chr$("TYPE LESS CHARS")
                    .elseif
                        invoke KeygenProc,hWin
                    .endif
                .endif
            .endif
        .elseif wParam == BTN_CLOSE
            invoke EndDialog,hWin,0
        .endif
    .elseif uMsg == WM_CLOSE
        invoke EndDialog,hWin,0
    .endif

    xor eax,eax
    ret
DlgProc    endp

KeygenProc proc hWND
;REVERSE
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
            invoke RtlZeroMemory,addr szlen,MAXSiZE
;MD5
            invoke lstrlen,addr UnRev
            mov szlen,eax
            invoke MD5Init
            invoke MD5Update,addr UnRev,szlen
            invoke MD5Final
            invoke HexEncode,eax,MD5_DIGESTSIZE,addr szMD5

            invoke RtlZeroMemory,addr szlen,MAXSiZE
            invoke RtlZeroMemory,addr UnRev,MAXSiZE    

;Seperate Serial to 2 parts with 64 bit size (each one)        
            invoke lstrcpyn,addr szSerial1,addr szSerial,16+1
            invoke lstrcpyn,addr szSerial2,addr szSerial+16,16+1

            invoke _BigCreate,0
            mov R,eax
            invoke _BigCreate,0
            mov S,eax
            invoke _BigCreate,0
            mov P,eax
            invoke _BigCreate,0
            mov Y,eax
            invoke _BigCreate,0
            mov G,eax
            invoke _BigCreate,0
            mov M,eax
            invoke _BigCreate,0
            mov tmp1,eax
            invoke _BigCreate,0
            mov tmp2,eax
            invoke _BigCreate,0
            mov tmp3,eax
                    
            invoke _BigIn,addr szSerial1,16,R
            invoke _BigIn,addr szSerial2,16,S
            invoke _BigIn,addr Prime,16,P
            invoke _BigIn,addr Base,16,G
            invoke _BigIn,addr PubKey,16,Y
            invoke _BigIn,addr szMD5,16,M
                    
            invoke _BigMod,M,P,M ;Make sure if M <P
                    
            invoke _BigPowMod,Y,R,P,tmp1
            invoke _BigPowMod,R,S,P,tmp2
            invoke _BigMulMod,tmp1,tmp2,P,tmp1 ;Y^R * R^S (mod P)
                    
            invoke _BigPowMod,G,M,P,tmp3 ;G^M (mod P)
                    
            invoke _BigCompare,tmp1,tmp3 ;IF Y^R * R^S = G^M (mod P) then !signature is valid!

            test eax,eax
            jnz @szWrong
                    
            invoke SetDlgItemText,hWND,IDC_STATiC,chr$("Good serial :>")
            call BiGDESTROY
            ret

            @szWrong:
            invoke SetDlgItemText,hWND,IDC_STATiC,chr$("Bad serial :<")
            call BiGDESTROY
            ret
                    
BiGDESTROY:
            invoke _BigDestroy,R
            invoke _BigDestroy,S
            invoke _BigDestroy,P
            invoke _BigDestroy,G
            invoke _BigDestroy,Y
            invoke _BigDestroy,M
            invoke _BigDestroy,tmp1
            invoke _BigDestroy,tmp2
            invoke _BigDestroy,tmp3
                
KeygenProc    endp


end start
