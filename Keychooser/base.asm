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
    
DlgProc proc    hWin    :DWORD,
                uMsg    :DWORD,
                wParam  :DWORD,
                lParam  :DWORD
                
    .if uMsg == WM_INITDIALOG
        ; Set the dialog controls texts. Done here in the code instead of resource
        ; file to reduce the required bytes (strings in the rc file are UNICODE not ANSI)
        invoke SetWindowText,hWin,ADDR szTitle ; Set the window title text
        invoke SetDlgItemText,hWin,IDB_GEN,ADDR szGenButton
        invoke SetDlgItemText,hWin,IDB_QUIT,ADDR szQuitButton
        invoke SetDlgItemText,hWin,IDC_DATE_STATIC,ADDR szDateStatic
        invoke SetDlgItemText,hWin,IDC_SERIAL_STATIC,ADDR szSerialStatic
        mov Rndm,'abcd'
        invoke  GetLocalTime,addr pTime
        mov eax,dword ptr pTime
        add eax,dword ptr pTime+2 ;wMonth
        add eax,dword ptr pTime+4 ;wDay
        add eax,dword ptr pTime+6 ;wMinute
        add eax,dword ptr pTime+7 ;wSecond
        add eax,dword ptr pTime+8 ;wMilliseconds
        add Rndm,eax
    .elseif uMsg == WM_COMMAND
        .if wParam == IDB_GEN
            invoke KeychooseRand
            mov eax,dword ptr [edx*4+szSerialTable] ; Get Serial to eax
            invoke SetDlgItemText,hWin,IDC_SERIAL,eax
        .elseif wParam == IDB_QUIT
            invoke EndDialog,hWin,0
        .endif
    .elseif uMsg == WM_CLOSE
        invoke  EndDialog,hWin,0
    .endif
    xor eax,eax
    ret
DlgProc endp

KeychooseRand Proc
        add Rndm,'abcd' ; Generating some random values
        Rol Rndm,4
        mov eax,Rndm
        mov ecx,999 ; Serials
        xor edx,edx
        idiv ecx ; Rndm mod 999
        Ret
KeychooseRand endp

end start