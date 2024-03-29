.486
.model    flat, stdcall
option    casemap :none   ; case sensitive

include    \masm32\include\windows.inc
include    \masm32\include\user32.inc
include    \masm32\include\kernel32.inc
include    \masm32\macros\macros.asm

includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\winmm.lib
includelib \masm32\lib\msvcrt.lib

include    AhxPlayerLib.inc
includelib AhxPlayerLib.lib

DlgProc        PROTO :DWORD,:DWORD,:DWORD,:DWORD

IDC_OK             equ    1003
IDC_IDCANCEL       equ    1004

.data?
hInstance        dd ?    ;dd can be written as dword
	hRes		dd ?
	lenRes		dd ?
.data
status           dd ?
	szFileName	db "AHXs\\A new beginning II.ahx", 0
	ID_MSX		EQU 1001
.code
start:
    invoke GetModuleHandle, NULL
    mov hInstance, eax
    invoke DialogBoxParam,hInstance,101,0,ADDR DlgProc,0
    invoke ExitProcess, eax

DlgProc    proc    hWin    :DWORD,
                   uMsg    :DWORD,
                   wParam  :DWORD,
                   lParam  :DWORD

    .if uMsg == WM_INITDIALOG
    mov status,1 
    invoke AHX_Init
    .elseif uMsg == WM_COMMAND
        .if wParam == IDC_OK
            .if status == 1
                mov status,0
                ; Load from resources
                invoke FindResource, hInstance, ID_MSX, RT_RCDATA
                .if eax
                    mov hRes, eax
                    invoke SizeofResource, hInstance, eax
                    mov lenRes, eax
                    invoke LoadResource, hInstance, hRes
                        .if eax
                            invoke LockResource, eax
                               .if eax
                                    invoke AHX_LoadBuffer, eax, lenRes
                               .endif
                        .endif
                .endif
                .if eax
                     invoke AHX_Play
                .endif
                invoke SetDlgItemText,hWin,IDC_OK,chr$("Stop")
            .else
                invoke  AHX_Stop
                invoke SetDlgItemText,hWin,IDC_OK,chr$("Play")
                mov status,1

            .endif
        .elseif wParam == IDC_IDCANCEL
                invoke  AHX_Stop
                invoke  AHX_Free
                invoke SendMessage,hWin,WM_CLOSE,0,0
        .endif
    .elseif uMsg == WM_CLOSE
                invoke AHX_Stop
                invoke AHX_Free
                invoke EndDialog,hWin,0
    .endif

    xor eax,eax
    ret
DlgProc endp

end start

