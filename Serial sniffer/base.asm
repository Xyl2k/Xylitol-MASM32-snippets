.486
.model	flat, stdcall
option	casemap :none   ; case sensitive

include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
include \masm32\include\windows.inc
include \masm32\include\comdlg32.inc
include \masm32\include\comctl32.inc ;XP Style

includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\comdlg32.lib
includelib \masm32\lib\comctl32.lib ;XP Style

include	base.inc
include standardfunctions.asm

.code
start:
    push @@handler ; <- standardfunctions.asm is needed
    ;call UnhandledExceptionFilter
   
    invoke GetModuleHandle, NULL
    mov hInstance, eax
    invoke InitCommonControls ;required for XP style
    invoke DialogBoxParam, hInstance,IDD_DIALOG, 0, ADDR DlgProc, 0
    invoke ExitProcess, eax

DlgProc	proc    hWin    :DWORD,
        uMsg    :DWORD,
        wParam  :DWORD,
        lParam  :DWORD
LOCAL ff32:WIN32_FIND_DATA
    pushad
    mov     eax,uMsg
    .if uMsg == WM_INITDIALOG
    push    hWin
    pop     hWnd
    ; Set the dialog controls texts. Done here in the code instead of resource
    ; file to reduce the required bytes (strings in the rc file are UNICODE not ANSI)
    invoke SetWindowText,hWin,ADDR szTitle ; Set the window title text
    invoke SetDlgItemText,hWin,IDB_PATCH,ADDR szIDBPatch
    invoke SetDlgItemText,hWin,IDB_QUIT,ADDR szIDBExit
    invoke SetDlgItemText,hWin,IDC_STATIC,ADDR szLblSer
      .elseif uMsg == WM_COMMAND
        mov eax,wParam
        and eax,0FFFFh
          .if wParam == IDB_PATCH
            invoke FindFirstFile,ADDR szTarget,ADDR ff32
            ; File to sniff is not in same dir
              .if eax != INVALID_HANDLE_VALUE
                ; If ok kill the process in case already running
                invoke TerminateProcess,pinfo.hProcess,0
                invoke TerminateThread,SerialThtreadID,0
                ; Spawn the process
                invoke CreateTheProcess, ADDR szTarget
                invoke FullHook,403979h ; OEP
                mov eax, offset SerialThtread
                invoke CreateThread,0,0,eax,0,0,offset SerialThtreadID
              .else
                invoke MessageBox,NULL,ADDR szErrNotFOund,ADDR szErrCaption,MB_ICONERROR ; Not found
              .endif
          .elseif wParam == IDB_QUIT
          jmp @close
          .endif
      .elseif uMsg == WM_CLOSE
      @close:
      invoke TerminateProcess,pinfo.hProcess,0
      invoke TerminateThread,SerialThtreadID,0
      invoke EndDialog,hWin,0
      .endif
    xor eax,eax
    ret

    SerialThtread:
    invoke FullHook,4038EBh
    ;004038E6    > /B8 30024200     MOV EAX,CrackMe1.00420230    ;  ASCII "8640-48735208654Dyn"
    ;004038EB    .^|EB DB           JMP SHORT CrackMe1.004038C8  ; Serial in EAX.
    mov tcont.ContextFlags,CONTEXT_FULL
    invoke GetThreadContext,pinfo.hThread, offset tcont; Context of running thread so we can get the value in eax
    mov eax,tcont.regEax
    invoke ReadProcessMemory,pinfo.hProcess,eax, offset szSerial,30h,0 ; Read out our serial
    invoke SetDlgItemText, hWnd,IDC_SERIAL, offset szSerial ; Send it back
    invoke TerminateProcess,pinfo.hProcess,0 ; Crackme is killed after getting the Serial
    invoke ExitThread,0

DlgProc endp

end start