.386
.model    flat, stdcall
option    casemap :none

include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
include \masm32\include\comctl32.inc
include    \masm32\include\masm32.inc

includelib    \masm32\lib\comctl32.lib
includelib    \masm32\lib\masm32.lib
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\comctl32.lib
DlgProc        PROTO    :DWORD,:DWORD,:DWORD,:DWORD

.const
IDD_MAIN    equ    1000
IDB_EXIT    equ    1001
IDC_COMBOBOX  equ 1002
IDC_NAME     equ 405
IDC_SERIAL   equ 406
IDB_GEN    equ 404

.data
String1        db 'SomeApp v1.0',0
String2        db 'SomeApp v2.0',0
String3        db 'SomeApp v3.0',0
String4        db 'SomeApp v4.0',0
String5        db 'SomeApp v5.0',0
String6        db 'SomeApp v6.0',0
String7        db 'SomeApp v7.0',0
String8        db 'SomeApp v8.0',0
String9        db 'SomeApp v9.0',0
String10	db 'SomeApp v10.0',0
template      TCHAR "%d",0

.data?
szName     TCHAR 100 dup(?)
szSerial TCHAR 100 dup(?)
hInstance    dd    ?
hCombo        dd ?

.code
start:
    invoke    GetModuleHandle, NULL
    mov    hInstance, eax
    invoke    InitCommonControls
    invoke    DialogBoxParam, hInstance, IDD_MAIN, 0, offset DlgProc, 0
    invoke    ExitProcess, eax

Combo proc
LOCAL buffer[256]:BYTE
    
        invoke SendMessage,hCombo,CB_ADDSTRING,0,offset String1
        invoke SendMessage,hCombo,CB_ADDSTRING,0,offset String2
        invoke SendMessage,hCombo,CB_ADDSTRING,0,offset String3
        invoke SendMessage,hCombo,CB_ADDSTRING,0,offset String4
        invoke SendMessage,hCombo,CB_ADDSTRING,0,offset String5
        invoke SendMessage,hCombo,CB_ADDSTRING,0,offset String6
        invoke SendMessage,hCombo,CB_ADDSTRING,0,offset String7
        invoke SendMessage,hCombo,CB_ADDSTRING,0,offset String8
        invoke SendMessage,hCombo,CB_ADDSTRING,0,offset String9
        invoke SendMessage,hCombo,CB_ADDSTRING,0,offset String10
        invoke SendMessage,hCombo,CB_SETCURSEL,0,0
    ret

Combo endp

DlgProc proc hWin:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
    mov    eax,uMsg
    .if    eax == WM_INITDIALOG
    
        invoke GetDlgItem,hWin,1002
        mov hCombo,eax
        invoke Combo
        
        invoke    LoadIcon,hInstance,200
        invoke    SendMessage, hWin, WM_SETICON, 1, eax

    .elseif eax == WM_COMMAND
        MOV EAX,wParam
        MOV EDX,EAX
        SHR EDX,16
        AND EAX,0FFFFh
        
        .if    eax == IDB_EXIT
            invoke    SendMessage, hWin, WM_CLOSE, 0, 0
        
        .elseif    eax == IDB_GEN
            jmp @lbox
        .endif

        
        .If EDX==LBN_SELCHANGE ;==CBN_SELCHANGE
            .If EAX==1002        ;ComboBox
                @lbox:
                Invoke SendDlgItemMessage,hWin,1002,CB_GETCURSEL,0,0
                .If EAX==CB_ERR
                .ElseIf EAX==0
                  push eax
                    push edi
                    push esi
                    push ebx
                    push SIZEOF szName
                    push OFFSET szName
                    push IDC_NAME
                    push hWin
                    call GetDlgItemText
                    ; #########################################################################
                    ; ############## (¯`·._.·[ SomeApp v1.0 algo here ! ]·._.·´¯) #############
                    ; #########################################################################
                    mov edi, offset szName
                    mov esi, offset szName
                    add esi, 2
                    A0:
                    lodsb
                    stosb
                    cmp al, 0
                    jnz A0
                     invoke atol, offset szName
                      ADD EAX,04E1h
                      MOV ECX,10h
                      MOV EDI,EDI
                    L001:
                      ADD EAX,EAX
                      TEST EAX,10000h
                      JE L002
                      XOR EAX,0C75h
                    L002:
                      SUB ECX,1
                      JNZ L001
                      AND EAX,0FFFFh
                    invoke wsprintf, OFFSET szSerial, OFFSET template, eax    ; TRANSFORM THE NUMBER IN ESI INTO DECIMAL
                    invoke    SetDlgItemText,hWin,IDC_SERIAL, OFFSET szSerial   ; Puts szSerial in DialogBox
                    pop ebx
                    pop esi
                    pop edi
                    pop eax
                .ElseIf EAX==1
                  push eax
                    push edi
                    push esi
                    push ebx
                    push SIZEOF szName
                    push OFFSET szName
                    push IDC_NAME
                    push hWin
                    call GetDlgItemText
                    ; #########################################################################
                    ; ############## (¯`·._.·[ SomeApp v2.0 algo here ! ]·._.·´¯) #############
                    ; #########################################################################
                    mov edi, offset szName
                    mov esi, offset szName
                    add esi, 2
                    A1:
                    lodsb
                    stosb
                    cmp al, 0
                    jnz A1
                     invoke atol, offset szName
                      MOV ECX,10h
                      ADD EAX,38Fh
                    L003:
                      SHL EAX,1
                      MOV EDX,EAX
                      AND EDX,10000h
                      CMP EDX,10000h
                      JNZ L004
                      XOR EAX,0C75h
                    L004:
                      DEC ECX
                      JNZ L003
                      AND EAX,0FFFFh
                    invoke wsprintf, OFFSET szSerial, OFFSET template, eax
                    invoke    SetDlgItemText,hWin,IDC_SERIAL, OFFSET szSerial
                    pop ebx
                    pop esi
                    pop edi
                    pop eax
                .ElseIf EAX==2
                  push eax
                    push edi
                    push esi
                    push ebx
                    push SIZEOF szName
                    push OFFSET szName
                    push IDC_NAME
                    push hWin
                    call GetDlgItemText
                    ; #########################################################################
                    ; ############## (¯`·._.·[ SomeApp v3.0 algo here ! ]·._.·´¯) #############
                    ; #########################################################################
                    mov edi, offset szName
                    mov esi, offset szName
                    add esi, 2
                    A2:
                    lodsb
                    stosb
                    cmp al, 0
                    jnz A2
                     invoke atol, offset szName
                      ADD EAX,511h
                      MOV ECX,10h
                      MOV EDI,EDI
                    L005:
                      ADD EAX,EAX
                      TEST EAX,10000h
                      JE L006
                      XOR EAX,0C75h
                    L006:
                      SUB ECX,1
                      JNZ L005
                      AND EAX,0FFFFh
                    invoke wsprintf, OFFSET szSerial, OFFSET template, eax
                    invoke    SetDlgItemText,hWin,IDC_SERIAL, OFFSET szSerial
                    pop ebx
                    pop esi
                    pop edi
                    pop eax
                .ElseIf EAX==3
                  push eax
                    push edi
                    push esi
                    push ebx
                    push SIZEOF szName
                    push OFFSET szName
                    push IDC_NAME
                    push hWin
                    call GetDlgItemText
                    ; #########################################################################
                    ; ############## (¯`·._.·[ SomeApp v4.0 algo here ! ]·._.·´¯) #############
                    ; #########################################################################
                    mov edi, offset szName
                    mov esi, offset szName
                    add esi, 2
                    A3:
                    lodsb
                    stosb
                    cmp al, 0
                    jnz A3
                     invoke atol, offset szName
                      ADD EAX,6DFh
                      MOV ECX,10h
                      MOV EDI,EDI
                    L008:
                      ADD EAX,EAX
                      TEST EAX,10000h
                      JE L007
                      XOR EAX,0C75h
                    L007:
                      SUB ECX,1
                      JNZ L008
                      AND EAX,0FFFFh
                    invoke wsprintf, OFFSET szSerial, OFFSET template, eax
                    invoke    SetDlgItemText,hWin,IDC_SERIAL, OFFSET szSerial
                    pop ebx
                    pop esi
                    pop edi
                    pop eax
                .ElseIf EAX==4
                  push eax
                    push edi
                    push esi
                    push ebx
                    push SIZEOF szName
                    push OFFSET szName
                    push IDC_NAME
                    push hWin
                    call GetDlgItemText
                    ; #########################################################################
                    ; ############## (¯`·._.·[ SomeApp v5.0 algo here ! ]·._.·´¯) #############
                    ; #########################################################################
                    mov edi, offset szName
                    mov esi, offset szName
                    add esi, 2
                    A4:
                    lodsb
                    stosb
                    cmp al, 0
                    jnz A4
                     invoke atol, offset szName
                      ADD EAX,41Bh
                      MOV ECX,10h
                      MOV EDI,EDI
                    L009:
                      ADD EAX,EAX
                      TEST EAX,10000h
                      JE L0010
                      XOR EAX,0C75h
                    L0010:
                      SUB ECX,1
                      JNZ L009
                      AND EAX,0FFFFh
                    invoke wsprintf, OFFSET szSerial, OFFSET template, eax
                    invoke    SetDlgItemText,hWin,IDC_SERIAL, OFFSET szSerial
                    pop ebx
                    pop esi
                    pop edi
                    pop eax
                .ElseIf EAX==5
                  push eax
                    push edi
                    push esi
                    push ebx
                    push SIZEOF szName
                    push OFFSET szName
                    push IDC_NAME
                    push hWin
                    call GetDlgItemText
                    ; #########################################################################
                    ; ############## (¯`·._.·[ SomeApp v6.0 algo here ! ]·._.·´¯) #############
                    ; #########################################################################
                    mov edi, offset szName
                    mov esi, offset szName
                    add esi, 2
                    A5:
                    lodsb
                    stosb
                    cmp al, 0
                    jnz A5
                     invoke atol, offset szName
                      MOV ECX,10h
                      ADD EAX,3D1h
                    L0012:
                      SHL EAX,1
                      MOV EDX,EAX
                      AND EDX,10000h
                      CMP EDX,10000h
                      JNZ L0011
                      XOR EAX,0C75h
                    L0011:
                      DEC ECX
                      JNZ L0012
                      AND EAX,0FFFFh
                    invoke wsprintf, OFFSET szSerial, OFFSET template, eax
                    invoke    SetDlgItemText,hWin,IDC_SERIAL, OFFSET szSerial
                    pop ebx
                    pop esi
                    pop edi
                    pop eax
                .ElseIf EAX==6
                  push eax
                    push edi
                    push esi
                    push ebx
                    push SIZEOF szName
                    push OFFSET szName
                    push IDC_NAME
                    push hWin
                    call GetDlgItemText
                    ; #########################################################################
                    ; ############## (¯`·._.·[ SomeApp v7.0 algo here ! ]·._.·´¯) #############
                    ; #########################################################################
                    mov edi, offset szName
                    mov esi, offset szName
                    add esi, 2
                    A6:
                    lodsb
                    stosb
                    cmp al, 0
                    jnz A6
                     invoke atol, offset szName
                      MOV ECX,10h
                      ADD EAX,3CBh
                    L0013:
                      SHL EAX,1
                      MOV EDX,EAX
                      AND EDX,10000h
                      CMP EDX,10000h
                      JNZ L0014
                      XOR EAX,0C75h
                    L0014:
                      DEC ECX
                      JNZ L0013
                      AND EAX,0FFFFh
                    invoke wsprintf, OFFSET szSerial, OFFSET template, eax
                    invoke    SetDlgItemText,hWin,IDC_SERIAL, OFFSET szSerial
                    pop ebx
                    pop esi
                    pop edi
                    pop eax
                .ElseIf EAX==7
                  push eax
                    push edi
                    push esi
                    push ebx
                    push SIZEOF szName
                    push OFFSET szName
                    push IDC_NAME
                    push hWin
                    call GetDlgItemText
                    ; #########################################################################
                    ; ############## (¯`·._.·[ SomeApp v8.0 algo here ! ]·._.·´¯) #############
                    ; #########################################################################
                    mov edi, offset szName
                    mov esi, offset szName
                    add esi, 2
                    A7:
                    lodsb
                    stosb
                    cmp al, 0
                    jnz A7
                     invoke atol, offset szName
                      MOV ECX,10h
                      ADD EAX,49Dh
                    L0016:
                      SHL EAX,1
                      MOV EDX,EAX
                      AND EDX,10000h
                      CMP EDX,10000h
                      JNZ L0015
                      XOR EAX,0C75h
                    L0015:
                      DEC ECX
                      JNZ L0016
                      AND EAX,0FFFFh
                    invoke wsprintf, OFFSET szSerial, OFFSET template, eax
                    invoke    SetDlgItemText,hWin,IDC_SERIAL, OFFSET szSerial
                    pop ebx
                    pop esi
                    pop edi
                    pop eax
                .ElseIf EAX==8
                  push eax
                    push edi
                    push esi
                    push ebx
                    push SIZEOF szName
                    push OFFSET szName
                    push IDC_NAME
                    push hWin
                    call GetDlgItemText
                    ; #########################################################################
                    ; ############## (¯`·._.·[ SomeApp v9.0 algo here ! ]·._.·´¯) #############
                    ; #########################################################################
                    mov edi, offset szName
                    mov esi, offset szName
                    add esi, 2
                    A8:
                    lodsb
                    stosb
                    cmp al, 0
                    jnz A8
                     invoke atol, offset szName
                      MOV ECX,10h
                      ADD EAX,17Bh
                    L0017:
                      SHL EAX,1
                      MOV EDX,EAX
                      AND EDX,10000h
                      CMP EDX,10000h
                      JNZ L0018
                      XOR EAX,0C75h
                    L0018:
                      DEC ECX
                      JNZ L0017
                      AND EAX,0FFFFh
                    invoke wsprintf, OFFSET szSerial, OFFSET template, eax
                    invoke    SetDlgItemText,hWin,IDC_SERIAL, OFFSET szSerial
                    pop ebx
                    pop esi
                    pop edi
                    pop eax
                .ElseIf EAX==9
                  push eax
                    push edi
                    push esi
                    push ebx
                    push SIZEOF szName
                    push OFFSET szName
                    push IDC_NAME
                    push hWin
                    call GetDlgItemText
                    ; #########################################################################
                    ; ############# (¯`·._.·[ SomeApp v10.0 algo here ! ]·._.·´¯) #############
                    ; #########################################################################
                    mov edi, offset szName
                    mov esi, offset szName
                    add esi, 2
                    A9:
                    lodsb
                    stosb
                    cmp al, 0
                    jnz A9
                     invoke atol, offset szName
                      MOV ECX,10h
                      ADD EAX,5ADh
                    L0020:
                      SHL EAX,1
                      MOV EDX,EAX
                      AND EDX,10000h
                      CMP EDX,10000h
                      JNZ L0019
                      XOR EAX,0C75h
                    L0019:
                      DEC ECX
                      JNZ L0020
                      AND EAX,0FFFFh
                    invoke wsprintf, OFFSET szSerial, OFFSET template, eax
                    invoke    SetDlgItemText,hWin,IDC_SERIAL, OFFSET szSerial
                    pop ebx
                    pop esi
                    pop edi
                    pop eax
                .EndIf
            .EndIf
.EndIf
    .elseif    eax == WM_CLOSE
        invoke    EndDialog, hWin, 0
    .endif

    xor    eax,eax
    ret
            
DlgProc endp

end start