.486
.model flat, stdcall
option casemap :none ; case sensitive

include        \masm32\include\windows.inc
include        \masm32\include\user32.inc
include        \masm32\include\kernel32.inc

includelib     \masm32\lib\user32.lib
includelib     \masm32\lib\kernel32.lib

DlgProc        PROTO :DWORD,:DWORD,:DWORD,:DWORD

comment /
Random number generator within a range..
Decimal and hexadecimal version.
The decimal code part have a feature for unwanted numbers.
*/

.const
; Dialog members
IDB_GEN_DEC             equ 1002
IDB_GEN_HEX             equ 1003
IDB_IDCANCEL            equ 1004
IDC_STATIC1             equ 1005
IDC_STATIC2             equ 1006

; Constants
LIMIT_LOW_Y             equ 10000
LIMIT_HIGH_Y            equ 99999
MASK_Y                  equ 00001FFFFh
OFFSET_BUFFER_Y         equ 4
CHUNK_SIZE_Y            equ 5


LIMIT_LOW_Z             equ 830606030
LIMIT_HIGH_Z            equ 1474302168
MASK_Z                  equ 03FFFFFFFh
CHUNK_SIZE_Z            equ 8

; Initialized data section
.data
hexadecimal_digits      db "0123456789ABCDEF",0
Forbidden_Numbers       DWORD 10218, 10224, 11297, 11396,
                              11597, 20255, 65205, 65619,
                              65620, 66563, 66564, 97387,
                              (-1)

; Uninitialized data section
.data?
hInstance               dd ?
timeData                dd ?

HexBuffer               db 20 dup (?)
DecBuffer               db 10 dup (?)

RandomHexFinal          db 20 dup (?)
RandomDecFinal          db 10 dup (?)

seedY                   dd ?
seedZ                   dd ?

presentY                dd ?
presentZ                dd ?

valueY                  dd ?
valueZ                  dd ?

; Program code section
.code
start:
    ; This function is the entrypoint of the program. 
    invoke GetModuleHandle,NULL
    mov hInstance,eax
    invoke DialogBoxParam,hInstance,101,0,addr DlgProc,0
    invoke ExitProcess,eax



CopyChunk proc chunkSize:DWORD, destination:DWORD, source:DWORD
    ; This procedure copies a chunk of data of given size from a source
    ; in memory to a destination.
    push esi
    push edi

    mov esi,source
    mov edi,destination

    mov ecx,chunkSize

CopyChunk_Loop:
    cmp ecx,0
    jz CopyChunk_End
    sub ecx,1

    mov al,[esi]
    mov [edi],al
    add esi,1
    add edi,1
    jmp CopyChunk_Loop

CopyChunk_End:

CopyChunk_return:
    pop edi
    pop esi
    ret
CopyChunk endp



WriteDecimal proc integer:DWORD, buffer:DWORD
             LOCAL numberTen:DWORD
    ; This procedure produces a string with the decimal representation of
    ; an unsigned 32-bit integer into the provided buffer, padded with zeros
    mov [numberTen], 10

    mov ecx,buffer
    mov al,'0'
    mov edx,9

WriteDecimal_ForwardLoop:
    cmp edx,0
    jz WriteDecimal_ForwardEnd
    sub edx,1

    mov [ecx],al
    add ecx,1
    jmp WriteDecimal_ForwardLoop

WriteDecimal_ForwardEnd:
    xor al,al
    mov [ecx],al

    mov eax,integer

WriteDecimal_BackwardLoop:
    sub ecx,1

    xor edx, edx
    div numberTen

    add dl,'0'
    mov [ecx],dl

    cmp eax,0
    jnz WriteDecimal_BackwardLoop

WriteDecimal_BackwardEnd:

WriteDecimal_return:
    ret
WriteDecimal endp



WriteHex proc integer:DWORD, buffer:DWORD
    ; This procedure produces a string with the hex representation of an
    ; unsigned 32-bit integer into the provided buffer, padded with zeros 
    mov ecx,buffer
    mov al,[hexadecimal_digits]
    mov edx,8

WriteHex_ForwardLoop:
    cmp edx,0
    jz WriteHex_ForwardEnd
    sub edx,1

    mov [ecx],al
    add ecx,1
    jmp WriteHex_ForwardLoop

WriteHex_ForwardEnd:
    xor al,al
    mov [ecx],al

    mov eax,integer

    push ebx
    lea ebx,[hexadecimal_digits]

WriteHex_BackwardLoop:
    sub ecx,1

    mov edx,eax
    and edx,00Fh
    shr eax,4

    mov dl,[ebx+edx]
    mov [ecx],dl

    cmp eax,0
    jnz WriteHex_BackwardLoop

WriteHex_BackwardEnd:
    pop ebx

WriteHex_return:
    ret
WriteHex endp



NextRandomY proc
    ; This procedure calculates the "Y" part of the random code
    ; And check it against a list of forbidden numbers.
    mov edx,seedY

NextRandomY_Loop:
    add presentY,edx

    mov eax,presentY
    and eax,MASK_Y
    add eax,LIMIT_LOW_Y

    cmp eax,LIMIT_HIGH_Y
    ja NextRandomY_Loop

    lea ecx,[Forbidden_Numbers]

NextRandomY_ForbiddenLoop:
    mov edx,[ecx]
    cmp edx,0
    jl NextRandomY_ForbiddenEnd

    cmp edx,eax
    jz NextRandomY_ForbiddenLoop_Reset

    add ecx,4
    jmp NextRandomY_ForbiddenLoop

NextRandomY_ForbiddenLoop_Reset:
    mov edx,seedY
    jmp NextRandomY_Loop

NextRandomY_ForbiddenEnd:

NextRandomY_End:

NextRandomY_return:
    mov [valueY],eax
    ret
NextRandomY endp



NextRandomZ proc
    ; This procedure calculates the "Z" part of the random code
    mov edx,seedZ

NextRandomZ_Loop:
    add presentZ,edx

    mov eax,presentZ
    and eax,MASK_Z
    add eax,LIMIT_LOW_Z

    cmp eax,LIMIT_HIGH_Z
    ja NextRandomZ_Loop

NextRandomZ_return:
    mov [valueZ],eax
    ret
NextRandomZ endp



DlgProc proc    hWin    :DWORD,
                uMsg    :DWORD,
                wParam  :DWORD,
                lParam  :DWORD

    .if uMsg == WM_INITDIALOG
        ; Initialize the random seeds
        invoke GetSystemTimeAsFileTime,addr timeData
        lea eax,[timeData]
        mov eax,[eax]
        or eax,1
        mov seedY,eax
        ror eax,8
        or eax,1
        mov seedZ,eax
        
        ; Initialize the present data for Y and Z
        xor eax,eax
        mov presentY,eax
        mov presentZ,eax
       
    .elseif uMsg == WM_COMMAND
    
        .if wParam == IDB_GEN_DEC
            ; This is generating a number,
            ; In this example it can be any number superior to 10000 and inferior to 99999.
            ; The number is then checked against a list of forbidden numbers.
            ; This should output a 5 chars long result like: 46257
            invoke NextRandomY
            invoke WriteDecimal,valueY,addr DecBuffer
            invoke CopyChunk,CHUNK_SIZE_Y,addr RandomDecFinal,addr DecBuffer+OFFSET_BUFFER_Y
            invoke SetDlgItemTextA,hWin,IDC_STATIC1,addr RandomDecFinal

        .elseif wParam == IDB_GEN_HEX
            ; This is generating a number,
            ; In this example it can be any number superior to 830606030 and inferior to 1474302168.
            ; Then it's converted to HEX.
            ; This should output a 8 chars long result like: 517D8CBA (1367182522 in decimal)
            invoke NextRandomZ
            invoke WriteHex,valueZ,addr HexBuffer
            invoke CopyChunk,CHUNK_SIZE_Z,addr RandomHexFinal,addr HexBuffer
            invoke SetDlgItemTextA,hWin,IDC_STATIC2,addr RandomHexFinal
         
        .elseif wParam == IDB_IDCANCEL
            invoke EndDialog,hWin,0
        .endif
    .elseif uMsg == WM_CLOSE
        invoke EndDialog,hWin,0
    .endif
    xor eax,eax
    ret
DlgProc endp

end start