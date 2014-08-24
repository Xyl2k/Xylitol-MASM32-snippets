;Xyl2k!
.486
.model  flat, stdcall
option  casemap :none   ; case sensitive

include windows.inc

uselib  MACRO   libname
    include     libname.inc
    includelib  libname.lib
ENDM

uselib  user32
uselib  kernel32

DlgProc     PROTO :DWORD,:DWORD,:DWORD,:DWORD

IDC_OK          equ 1003
IDC_IDCANCEL    equ 1004
cfg             equ 1


.data?
hInstance       dd      ?   ;dd can be written as dword
buffer1 db 9999 dup(?)
buffer2 db 9999 dup(?)
buffer3 db 256 dup(?)
buffer4 db 256 dup(?)
nSize dd     ?
pM  dd     ?

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


    .if uMsg == WM_COMMAND
        .if wParam == IDC_OK
 INVOKE FindResource,0, cfg, RT_RCDATA
 push eax
 INVOKE SizeofResource,0, eax
 mov nSize, eax
 pop eax
 INVOKE LoadResource,0, eax
 INVOKE LockResource, eax
 mov esi, eax
 mov eax, nSize
 add eax, SIZEOF nSize
 INVOKE GlobalAlloc, GPTR, eax
 mov pM, eax
 mov ecx, nSize
 mov dword ptr [eax], ecx
 add eax, SIZEOF nSize
 mov edi, eax
 rep movsb
        PUSH 55Dh
        PUSH eax
        PUSH offset buffer1
        CALL RtlMoveMemory
        invoke FreeResource,eax
        mov ebx,offset buffer1
        PUSH 10h
        PUSH ebx
        PUSH offset buffer2
        CALL RtlMoveMemory
        ADD EBX,010h
        MOV EAX,nSize
        SUB EAX,010h
        PUSH EAX
        PUSH EBX
        CALL decrypt
        MOV AL,BYTE PTR DS:[EBX]
        MOV BYTE PTR DS:[buffer3],AL
        ADD EBX,1
        MOV AL,BYTE PTR DS:[EBX]
        MOV BYTE PTR DS:[buffer3+1],AL
        ADD EBX,1
        MOV EAX,DWORD PTR DS:[EBX]
        MOV DWORD PTR DS:[buffer3+2],EAX
        ADD EBX,8
        MOV ECX,DWORD PTR DS:[EBX]
        invoke SetDlgItemText,hWin,1002,ebx
         pop esi
        .elseif wParam == IDC_IDCANCEL
            invoke EndDialog,hWin,0
        .endif
    .elseif uMsg == WM_CLOSE
        invoke  EndDialog,hWin,0
    .endif
    xor eax,eax
    ret
DlgProc endp
decrypt proc
        PUSHAD
        MOV ESI,EBX
        MOV EDI,ESI
        XOR EDX,EDX
        MOV ECX,EAX
@gpcode_00401755:
        CMP EDX,010h
        JNZ @gpcode_0040175C
        XOR EDX,EDX
@gpcode_0040175C:
        LODS BYTE PTR DS:[ESI]
        XOR AL,BYTE PTR DS:[EDX+buffer2]
        STOS BYTE PTR ES:[EDI]
        INC EDX
        DEC ECX
        JNZ @gpcode_00401755
        POPAD
    RET
decrypt endp
end start