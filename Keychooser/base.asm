.486
.model  flat, stdcall
option  casemap :none   ; case sensitive

include     base.inc

.code
start:
    invoke  GetModuleHandle, NULL
    mov hInstance, eax
    invoke  DialogBoxParam, hInstance, 101, 0, ADDR DlgProc, 0

    invoke  ExitProcess, eax

; -----------------------------------------------------------------------

DlgProc proc    hWin    :DWORD,
        uMsg    :DWORD,
        wParam  :DWORD,
        lParam  :DWORD
    .if uMsg == WM_COMMAND
        .if wParam == IDC_OK
; -----------------------------------------------------------------------
            add Rndm,'abcd' ;       Generating some random values
            Rol Rndm,4
            mov eax,Rndm
            mov ecx,1000     ;       Serials
            xor edx,edx
            idiv ecx        ;       Rndm    mod 1000
            mov eax,dword ptr [edx*4+DTbase]        ;   Get Serial to eax
            invoke  SetDlgItemText,hWin,1002,eax
; -----------------------------------------------------------------------
        .elseif wParam == IDC_IDCANCEL
            invoke EndDialog,hWin,0
        .endif
    .elseif eax == WM_INITDIALOG
        mov Rndm,'Xyli'
        invoke  GetLocalTime,addr pTime
        mov eax,dword ptr pTime
        add eax,dword ptr pTime+2
        add eax,dword ptr pTime+4
        add eax,dword ptr pTime+6
        add eax,dword ptr pTime+8
        add Rndm,eax

    .elseif uMsg == WM_CLOSE
        invoke  EndDialog,hWin,0
    .endif
    xor eax,eax
    ret
DlgProc endp

end start