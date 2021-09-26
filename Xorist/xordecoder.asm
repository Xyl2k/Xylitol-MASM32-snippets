.486
.model flat, stdcall
option casemap :none ; case sensitive

comment /*
Tested successfully with:
- ENCYCLO_UT_19_CD (L'encyclopédie des utilitaires PC 19)
- UTPM_3 (Utilitaire PC Pratique)
- HACKERCD_8 (Hacker CD 8)
- PC_PIRATE_5 (PC Pirate 5)
- PCPR_22 (PC Pirate 22)
- PCPR_28 (PC Pirate 28)
- JPMN_4 (Japan Mania 4)
/

include                 \masm32\include\windows.inc
include                 \masm32\include\user32.inc
include                 \masm32\include\kernel32.inc
include                 \masm32\macros\macros.asm

includelib              \masm32\lib\user32.lib
includelib              \masm32\lib\kernel32.lib

WndProc                 proto  :DWORD,:DWORD,:DWORD,:DWORD 
List                    proto  :DWORD,:DWORD
ScanForParticularFiles  proto  :HWND
CryptFile               proto  :HWND
Crypt                   proto  :DWORD,:DWORD,:BYTE

.const
IDD_DIALOG              equ 1000
IDB_QUIT                equ 1001
IDB_CRYPT               equ 1002
IDC_GROUPRESULT         equ 1003
IDC_GROUPPATH           equ 1004
IDC_STATICFound         equ 1005
IDC_LISTBOXJPG          equ 1006
IDC_EDITPATH            equ 1007
IDC_COUNTER             equ 1008
IDB_AIDE                equ 1009

.data
szTitle                 db "3617 pr0n Dcoder v0.1",0
szIDBCrypt              db "uNCRYPT *.jpg iMAGES",0
szIDCGroupFound         db "pROCESSED iMAGES",0
szIDCGroupPath          db "pATH OF THE FOLDER CONTAiNiNG THE iMAGES",0
szStaticFound           db "tOTAL:",0
szIDBQUit               db "qUiT",0
szIDBAIDE               db "hELP",0
szIDCcounter            db "0",0
MsgBoxCaption           db "Manuel d'utilisation",0
MsgBoxText              db "1: Explorer votre CD et copier le dossier contenant vos images chiffrées en dehors du CD sur votre disque.",13,10
                        db "Les images stockées sur le CD peuvent avoir l'attribut caché.",13,10
                        db "Cela signifie que, par défaut, ces fichiers ne seront pas visibles dans l'explorateur Windows.",13,10
                        db "Il vous faudra donc (peut-être) activer l'option de Windows pour afficher les fichiers et dossiers cachés dans l'explorateur.",13,10,13,10
                        db "2: Placer cette utilitaire dans le même dossier contenant vos images JPG chiffrées",13,10
                        db "3: Appuyer sur 'dÉCHIFFRER LES IMAGES *.jpg'",13,10,13,10,13,10
                        db "L'auteur décline toute responsabilité concernant l'utilisation, par l'Utilisateur de ce logiciel.",0

Dect                    db "%d",0
szFilter                db "*.jpg",0
cnt                     db 0
bKey                    db 0A5h ; ¥

.data? 
hInstance               HINSTANCE ? 
ThreadID                dd ?
CountJPG                dd ?
hthread                 dd ?
hFile                   dd ?
dwFileSize              dd ?
dwBytesDone             dd ?
hMemory                 dd ?
hBuffer                 dd ?
dpath                   db 256 dup (?)
hDir                    db 256 dup (?)
fpath                   db 256 dup (?)
cuntBuffer              db 8 dup(?)

.code
start:
    invoke GetModuleHandle, NULL 
    mov hInstance,eax 
    invoke DialogBoxParam,hInstance,IDD_DIALOG,NULL,addr WndProc,NULL 
    invoke ExitProcess,eax 
    
WndProc proc hWin:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
    .if uMsg == WM_INITDIALOG
        ; Set the dialog controls texts. Done here in the code instead of resource
        ; file to reduce the required bytes (strings in the rc file are UNICODE not ANSI)
        invoke SetWindowText,hWin,addr szTitle
        invoke SetDlgItemText,hWin,IDB_CRYPT,addr szIDBCrypt
        invoke SetDlgItemText,hWin,IDC_GROUPRESULT,addr szIDCGroupFound
        invoke SetDlgItemText,hWin,IDC_GROUPPATH,addr szIDCGroupPath
        invoke SetDlgItemText,hWin,IDC_STATICFound,addr szStaticFound
        invoke SetDlgItemText,hWin,IDB_QUIT,addr szIDBQUit
        invoke SetDlgItemText,hWin,IDB_AIDE,addr szIDBAIDE
        invoke GetCurrentDirectory,1024,addr hDir
        invoke SetDlgItemText,hWin,IDC_EDITPATH,addr hDir
        invoke SetDlgItemText,hWin,IDC_COUNTER,addr szIDCcounter
        xor eax, eax
        ret
    .elseif uMsg == WM_COMMAND
        .if wParam == IDB_CRYPT
            invoke RtlZeroMemory,addr dpath,sizeof dpath
            invoke GetDlgItemText,hWin,IDC_EDITPATH,addr dpath,sizeof dpath
            invoke SetCurrentDirectory,ADDR dpath
            mov CountJPG,0
            invoke wsprintf,addr cuntBuffer,addr Dect,CountJPG
            invoke SetDlgItemText,hWin,IDC_COUNTER,addr cuntBuffer
            invoke CreateThread,NULL,NULL,offset ScanForParticularFiles,hWin,NULL,ADDR ThreadID
            mov hthread,eax 
        .elseif wParam == IDB_AIDE
            invoke MessageBox, NULL, addr MsgBoxText, addr MsgBoxCaption, MB_OK
        .elseif wParam == IDB_QUIT
            invoke EndDialog,hWin,0
        .endif
    .elseif uMsg == WM_CLOSE
        invoke EndDialog,hWin,0
    .endif
    xor eax, eax
     ret
WndProc endp

List proc hWin:HWND, pMsg:DWORD
    invoke SendDlgItemMessage,hWin,IDC_LISTBOXJPG,LB_ADDSTRING,0,pMsg
    invoke SendDlgItemMessage,hWin,IDC_LISTBOXJPG,WM_VSCROLL,SB_BOTTOM,0
    Ret
List EndP

ScanForParticularFiles proc hWnd:HWND
    LOCAL fnd      :WIN32_FIND_DATA
    LOCAL hFind    :DWORD
    invoke FindFirstFile,addr szFilter,addr fnd
    .if eax != INVALID_HANDLE_VALUE
        mov hFind, eax
        .repeat
            invoke GetCurrentDirectory,1024,ADDR hDir
            invoke lstrcat,addr fpath,addr hDir
            invoke lstrcat,addr fpath,chr$("\")
            invoke lstrcat,addr fpath,addr fnd.cFileName
            invoke List,hWnd,addr fpath
            inc CountJPG
            invoke wsprintf,addr cuntBuffer,addr Dect,CountJPG
            invoke SetDlgItemText,hWnd,IDC_COUNTER,addr cuntBuffer
            invoke CryptFile,hWnd
            invoke RtlZeroMemory,addr fpath,sizeof fpath
            inc cnt
            .if cnt == 25
                mov cnt,0
            .endif
            invoke FindNextFile,hFind,addr fnd
        .until eax == 0            
        invoke FindClose,hFind    
    .endif  
    ret          
ScanForParticularFiles endp

CryptFile proc hWnd:HWND
    invoke CreateFile,addr fpath,GENERIC_READ OR GENERIC_WRITE,0,0,OPEN_EXISTING,0,0
    mov hFile,eax
    .if eax == INVALID_HANDLE_VALUE
        jmp err0rz
    .else
        invoke GetFileSize,eax,0
        mov [dwFileSize],eax
        push eax
        invoke GlobalAlloc,GMEM_MOVEABLE,eax
        mov [hMemory],eax
        invoke GlobalLock,eax
        mov [hBuffer],eax
        push eax
        invoke ReadFile,[hFile],eax,dwFileSize,OFFSET dwBytesDone,0
        pop edx
        pop ecx
        mov ah,bKey
        invoke Crypt,[hBuffer],[dwFileSize],[bKey]
        invoke SetFilePointer,[hFile],0,0,FILE_BEGIN
        invoke WriteFile,[hFile],[hBuffer],[dwFileSize],OFFSET dwBytesDone,0
        invoke GlobalUnlock,[hMemory]
        invoke GlobalFree,[hMemory]
        invoke CloseHandle,[hFile]
    .endif
    ret
err0rz:     
    invoke MessageBox,NULL,chr$("Error opening file!"),chr$("Error"),MB_ICONERROR
    ret
CryptFile endp

Crypt proc pszBuffer:DWORD, dwSize:DWORD, Key:BYTE
doxor:
    mov al,[edx+ecx]
    xor al,ah
    mov [edx+ecx],al
    dec ecx
    .if ecx == 0FFFFFFFFh ; -1
       ret
    .else
       jmp doxor
    .endif
Crypt endp

end start