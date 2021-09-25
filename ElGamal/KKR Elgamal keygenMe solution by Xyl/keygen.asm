.586
.model  flat, stdcall
option  casemap :none

include     keygen.inc
include     crc32.asm
include     algo.asm

.code
start:
    invoke  GetModuleHandle, NULL
    mov hInstance, eax
    invoke  DialogBoxParam, hInstance, IDD_MAIN, 0, offset DlgProc, 0
    invoke  ExitProcess, eax
    invoke  InitCommonControls

DlgProc proc uses esi edi hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
    mov eax,uMsg

    .if eax == WM_INITDIALOG
        invoke  LoadIcon,hInstance,200
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
end start