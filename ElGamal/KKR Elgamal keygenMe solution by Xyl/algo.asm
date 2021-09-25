include bignum.inc
includelib  bignum.lib

Generate    PROTO   :HWND
HexToChar   PROTO   :DWORD,:DWORD,:DWORD
Clean       PROTO

.data
szName      db  100h    dup(?)
szSerial    db  100h    dup(?)
Message     dd  20h     dup(?)
hash        dd  20h     dup(?)
SerPart1    db  30h     dup(?)
SerPart2    db  30h     dup(?)

.code
Generate    Proc    hWnd:HWND
LOCAL   P,G,X,R,S,M,KRND:DWORD
    pushad
    invoke bnInit,128
    bnCreateX P,G,X,R,S,M,KRND
   
    invoke  GetDlgItemText,hWnd,IDC_NAME,addr szName,sizeof szName
    .if eax <= 2
        invoke  SetDlgItemText,hWnd,IDC_SERIAL,chr$('Type more chars!')
    .elseif eax >= 50
        invoke  SetDlgItemText,hWnd,IDC_SERIAL,chr$('Type less chars!')
    .elseif
        invoke  CRC32,addr szName,eax,0
        bswap eax
        mov dword ptr hash,eax
        invoke  HexToChar,addr hash,addr Message,4
        invoke  bnFromHex,addr Message,M
        invoke  bnFromHex,chr$('2EDFC37E594D7DAA7'),P
        invoke  bnFromHex,chr$('1212B2B299533F80'),G
        invoke  bnFromHex,chr$('20359107FD6277AD1'),X
        invoke  bnRsaGenPrime,KRND,32
        invoke  bnModExp,G,KRND,P,R
        invoke  bnDec,P
        invoke  bnModInv,KRND,P,KRND
        invoke  bnAdd,M,P
        invoke  bnMul,X,R,S
        invoke  bnMod,S,P,S
        invoke  bnSub,M,S
        invoke  bnMod,M,P,M
        invoke  bnMul,M,KRND,S
        invoke  bnMod,S,P,S
        invoke  bnInc,P
        invoke  bnToStr,R,addr SerPart1
        invoke  bnToStr,S,addr SerPart2
        invoke  lstrcat,addr szSerial,addr SerPart1
        invoke  lstrcat,addr szSerial,chr$('-')
        invoke  lstrcat,addr szSerial,addr SerPart2
        invoke  SetDlgItemText,hWnd,IDC_SERIAL,addr szSerial
    .endif

    bnDestroyX
    invoke bnFinish
    popad
    Ret
Generate endp
HexToChar Proc HexValue:DWORD,CharValue:DWORD,HexLength:DWORD
    mov esi,[ebp+8]
    mov edi,[ebp+0Ch]
    mov ecx,[ebp+10h]
    @HexToChar:
    lodsb
    mov ah, al
    and ah, 0fh
    shr al, 4
    add al, '0'
    add ah, '0'
    .if al > '9'
    add al, 'A'-'9'-1
    .endif
    .if ah > '9'
    add ah, 'A'-'9'-1
    .endif
    stosw
    loopd @HexToChar
    Ret
HexToChar endp
Clean   Proc
    invoke  RtlZeroMemory,addr szName,sizeof szName
    invoke  RtlZeroMemory,addr szSerial,sizeof szSerial
    invoke  RtlZeroMemory,addr Message,sizeof Message
    invoke  RtlZeroMemory,addr hash,sizeof hash
    invoke  RtlZeroMemory,addr SerPart1,sizeof SerPart1
    invoke  RtlZeroMemory,addr SerPart2,sizeof SerPart2
    Ret
Clean endp