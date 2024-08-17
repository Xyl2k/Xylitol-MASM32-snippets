.486
.model flat, stdcall
option casemap :none ; case sensitive

include           \masm32\include\windows.inc
include           \masm32\include\user32.inc
include           \masm32\include\kernel32.inc
include           \masm32\macros\macros.asm
include           \masm32\include\shlwapi.inc

includelib        \masm32\lib\user32.lib
includelib        \masm32\lib\kernel32.lib
includelib        \masm32\lib\shlwapi.lib

DlgProc            PROTO :DWORD,:DWORD,:DWORD,:DWORD

LIBCRYPTO          equ 500
IDB_GENERATE       equ 1003
IDB_CANCEL         equ 1004
IDB_SIGN           equ 1005
IDC_PRIVATEKEY     equ 1008
IDC_PUBLICKEY      equ 1009
IDC_SIGNATURE      equ 1010
IDC_MESSAGE        equ 1013
IDC_STATICPUB      equ 1006
IDC_STATICPRIV     equ 1007
IDC_GROUPBOXGEN    equ 1011
IDC_GROUPBOXSIGN   equ 1012
MAXSIZE            equ 256h

EVP_PKEY_ED25519   equ 043Fh
PRIVATE_KEY_SIZE   equ 020h
PUBLIC_KEY_SIZE    equ 020h ;(32 bytes)
SIGNATURE_SIZE     equ 040h ;(64 bytes)

.data
PubKey \
                 db 02dh,00fh,0c1h,0f9h,0f9h,029h,036h,0b9h,0dfh,0a6h,07bh,09ch,0ach,09eh,0f9h,0cch
                 db 06ah,04ch,095h,043h,002h,082h,016h,0b8h,074h,008h,066h,053h,018h,034h,07bh,0cbh
                 ; 2d0fc1f9f92936b9dfa67b9cac9ef9cc6a4c9543028216b87408665318347bcb

PrivKey \
                 db 063h,0d4h,058h,0fbh,0e1h,029h,03ah,032h,09eh,095h,035h,04ch,020h,0c7h,0a4h,053h
                 db 0c8h,0e7h,0feh,08ah,097h,034h,00dh,09eh,0dfh,0adh,0dfh,0cfh,054h,014h,085h,0d2h
                 ; 63d458fbe1293a329e95354c20c7a453c8e7fe8a97340d9edfaddfcf541485d2
Signature \
                 db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
                 db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
                 db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
                 db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h

;If you want to try out this generator against another ed25519 generator:
; => https://cyphr.me/ed25519_applet/ed.html

;Some test commands for OpenSSL on debian
;openssl genpkey -algorithm Ed25519 -out private.pem // generate a Ed25519 private key
;openssl pkey -in private.pem -pubout // view the pubkey out of the private key
;openssl asn1parse -in private.pem //parse the key
;openssl asn1parse -in private.pem -offset 14

;dialog details
szTitle                 db "Ed25519 siGNiNG kEYGENERATOR v0.1 by Xyl2k",0
szBtnGenerator          db "gENERATE ED25519 kEY pAiR",0
szBtnVerify             db "SiGN aND vERiFY",0
szBtnQuit               db "qUiT sOFT",0
szGrpBoxGen             db "gENERATOR",0
szGrpBoxSign            db "siGN",0
szMessage               db "Hello World",0
szStaticPrivate         db "pRiVATE:",0
szStaticPublic          db "pUBLiC:",0

OpenSSLDll              db "libcrypto-3.dll",0 ; OpenSSL 3.3.1 of June 2024
MessageToCheck          db MAXSIZE dup (0)
sLen                    dd 0

;crypto stuff
AlgoToUse               db "ED25519",0
handle                  dd 0 ;handle for api calling libcrypto

; error handling
ErrorMessage            db 100 dup(0)

Format                  db '%02x',0

.data?
hInstance               dd ? ; Handle for loaded program

;to drop the openssl dll
SizeRes                 dd ?
hResource               dd ?
pData                   dd ?
Handle2                 dd ?
Bytes                   dd ?
SysDirect               db 100h dup(?)

;crypto stuff
pctx                    dd ?
pkey                    dd ?
mdctx                   dd ?

; Private key buffer, len, buffer in hex string
privLen                 dd ?
privStr                 db 65 dup(?)

; Public key buffer, len, buffer in hex string
pubLen                  dd ?
pubStr                  db 65 dup(?)

; Signature
sigLen                  dd ?
sigStr                  db 129 dup(?)

; handling error
hError                  dd ?

.code
start:
    invoke GetModuleHandle,NULL
    mov hInstance,eax
    invoke DialogBoxParam,hInstance,101,0,ADDR DlgProc,0
    invoke ExitProcess,eax

; Convert uint8[] buffer (pBuf) to hex string (pStr) and set pStr to hWnd
SetText proc pBuf: DWORD,
             pStr: DWORD,
             Len: DWORD, ; Size of pBuf
             hWnd: DWORD
    mov ecx, 0
    .repeat
        push ecx

        mov esi, pBuf
        movzx ebx, byte ptr [esi+ecx]
        push ebx                ; Binary Value
        push offset Format      ; Format

        mov eax, pStr
        mov ebx, ecx
        shl ebx, 1
        add eax, ebx
        push eax                ; &pStr[ecx * 2]

        call wsprintf
        add esp, 12             ; Clean stack

        pop ecx
        inc ecx
    .until ecx==Len
    invoke SetWindowText,hWnd,pStr

    xor eax, eax
    ret
SetText endp

DlgProc proc hWin    :DWORD,
             uMsg    :DWORD,
             wParam  :DWORD,
             lParam  :DWORD

    .if uMsg == WM_INITDIALOG
            invoke SendMessage,hWin,WM_SETTEXT,0,addr szTitle ; Set the window title text
            invoke SetDlgItemText,hWin,IDB_GENERATE,addr szBtnGenerator
            invoke SetDlgItemText,hWin,IDB_SIGN,addr szBtnVerify
            invoke SetDlgItemText,hWin,IDC_GROUPBOXGEN,addr szGrpBoxGen
            invoke SetDlgItemText,hWin,IDC_GROUPBOXSIGN,addr szGrpBoxSign
            invoke SetDlgItemText,hWin,IDC_MESSAGE,addr szMessage
            invoke SetDlgItemText,hWin,IDB_CANCEL,addr szBtnQuit
            invoke SetDlgItemText,hWin,IDC_STATICPRIV,addr szStaticPrivate
            invoke SetDlgItemText,hWin,IDC_STATICPUB,addr szStaticPublic

            ;Drop the OpenSSL dll from ressource to current dir
            invoke FindResource,hInstance,LIBCRYPTO,RT_RCDATA 
            mov hResource, eax
            invoke LoadResource,hInstance,hResource
            push eax
            invoke SizeofResource,hInstance,hResource
            mov SizeRes, eax
            pop eax
            invoke LockResource,eax
            push eax
            invoke GlobalAlloc,GPTR,SizeRes
            mov pData, eax
            mov ecx, SizeRes
            mov dword ptr[eax], ecx
            pop esi
            add edi, 4
            mov edi, pData
            rep movsb
            invoke GetModuleFileName,NULL,addr SysDirect,0FFh
            invoke PathRemoveFileSpec,addr SysDirect
            invoke lstrcat,addr SysDirect,chr$('\libcrypto-3.dll')
            invoke DeleteFile,addr SysDirect
            invoke GetLastError
            cmp eax, 5
            jz _end_
            invoke CreateFile,addr SysDirect,GENERIC_ALL,0,0,CREATE_ALWAYS,FILE_ATTRIBUTE_HIDDEN,0
            mov Handle2,eax
            cmp eax, -1
            jnz @F
            invoke MessageBox,hWin,chr$('Cannot create file libcrypto-3.dll!'),0,MB_ICONERROR
            jmp _end_1
            @@:invoke WriteFile,eax,pData,SizeRes,offset Bytes,0
            cmp eax, -1
            jnz _end_1
            invoke MessageBox,hWin,chr$('Cannot write data into libcrypto-3.dll!'),0,MB_ICONERROR
            _end_1:invoke CloseHandle,Handle2
            _end_:

            invoke LoadLibrary, offset OpenSSLDll
            xor edx,edx
            mov handle,eax
           
    .elseif uMsg == WM_COMMAND
        .if wParam == IDB_GENERATE
        
            ; ======= based on https://www.openssl.org/docs/man1.1.1/man7/Ed25519.html ======= 
            invoke GetProcAddress,handle,chr$('EVP_PKEY_CTX_new_id') ;https://www.openssl.org/docs/man3.0/man3/EVP_PKEY_CTX_new_id.html
            push 0                       ; ENGINE *e
            push EVP_PKEY_ED25519        ; int id (43F for ED25519)
            call eax                     ; invoke EVP_PKEY_CTX_new_id
            mov pctx, eax                ; EVP_PKEY_CTX *ctx
            .if eax == 0
                invoke MessageBox,hWin,chr$('EVP_PKEY_CTX_new_id failed'),0,0
            .endif

            invoke GetProcAddress,handle,chr$('EVP_PKEY_keygen_init') ;https://www.openssl.org/docs/man1.0.2/man3/EVP_PKEY_keygen_init.html
            push pctx                    ; EVP_PKEY_CTX *ctx
            call eax                     ; invoke EVP_PKEY_keygen_init
            .if eax != 1
                invoke MessageBox,hWin,chr$('EVP_PKEY_keygen_init failed'),0,0
            .endif

            invoke GetProcAddress,handle,chr$('EVP_PKEY_keygen') ;https://www.openssl.org/docs/man1.1.1/man3/EVP_PKEY_keygen.html
            push offset pkey             ; EVP_PKEY **ppkey
            push pctx                    ; EVP_PKEY_CTX *ctx
            call eax                     ; invoke EVP_PKEY_keygen
            .if eax != 1
                invoke MessageBox,hWin,chr$('EVP_PKEY_keygen failed'),0,0
            .endif

            ; Get private key
            mov privLen, PRIVATE_KEY_SIZE

            invoke GetProcAddress,handle,chr$('EVP_PKEY_get_raw_private_key') ; https://www.openssl.org/docs/man1.1.1/man3/EVP_PKEY_get_raw_private_key.html
            push offset privLen ; size_t *len
            push offset PrivKey ; unsigned char *priv
            push pkey           ; const EVP_PKEY *pkey
            call eax
            .if eax != 1 || privLen != PRIVATE_KEY_SIZE
                invoke MessageBox,hWin,chr$('EVP_PKEY_get_raw_private_key failed'),0,0
            .endif

            ; Get public key
            mov pubLen, PUBLIC_KEY_SIZE

            invoke GetProcAddress,handle,chr$('EVP_PKEY_get_raw_public_key') ; https://www.openssl.org/docs/man1.1.1/man3/EVP_PKEY_get_raw_public_key.html
            push offset pubLen ; size_t *len
            push offset PubKey ; unsigned char *pub
            push pkey          ; const EVP_PKEY *pkey
            call eax
            .if eax != 1 || pubLen != PUBLIC_KEY_SIZE
                invoke MessageBox,hWin,chr$('EVP_PKEY_get_raw_public_key failed'),0,0
            .endif

            ; Output private key and public key to dialog
            invoke GetDlgItem,hWin,IDC_PRIVATEKEY
            invoke SetText,offset PrivKey,offset privStr,PRIVATE_KEY_SIZE,eax

            invoke GetDlgItem,hWin,IDC_PUBLICKEY
            invoke SetText,offset PubKey,offset pubStr,PUBLIC_KEY_SIZE,eax

            ; Free key
            invoke GetProcAddress,handle,chr$('EVP_PKEY_free')
            push pkey
            call eax

            ; Free ctx
            invoke GetProcAddress,handle,chr$('EVP_PKEY_CTX_free')
            push pctx                    ; EVP_PKEY_CTX *ctx
            call eax                     ; invoke EVP_PKEY_CTX_free
            

        .elseif wParam == IDB_SIGN
                invoke GetDlgItemText,hWin,IDC_MESSAGE,addr MessageToCheck,sizeof MessageToCheck
                mov sLen,eax

                ; Output private key and public key to dialog
                invoke GetDlgItem,hWin,IDC_PRIVATEKEY
                invoke SetText,offset PrivKey,offset privStr,PRIVATE_KEY_SIZE,eax

                invoke GetDlgItem,hWin,IDC_PUBLICKEY
                invoke SetText,offset PubKey,offset pubStr,PUBLIC_KEY_SIZE,eax

                ; Ctx
                invoke GetProcAddress,handle,chr$('EVP_PKEY_CTX_new_id') ;https://www.openssl.org/docs/man3.0/man3/EVP_PKEY_CTX_new_id.html
                push 0                       ; ENGINE *e
                push EVP_PKEY_ED25519        ; int id (43F for ED25519)
                call eax                     ; invoke EVP_PKEY_CTX_new_id
                mov pctx, eax                ; EVP_PKEY_CTX *ctx

                ; Key
                invoke GetProcAddress,handle,chr$('EVP_PKEY_new_raw_private_key') ; https://www.openssl.org/docs/man1.1.1/man3/EVP_PKEY_new_raw_private_key.html
                push PRIVATE_KEY_SIZE                ; size_t keylen
                push offset PrivKey                  ; const unsigned char *key
                push 0                               ; ENGINE *e
                push EVP_PKEY_ED25519                ; int type
                call eax
                mov pkey, eax

                .if pkey == 0
                    invoke MessageBox,hWin,chr$('EVP_PKEY_new_raw_private_key failed'),0,0
                .endif

                ; MdCtx
                invoke GetProcAddress,handle,chr$('EVP_MD_CTX_new')
                call eax
                mov mdctx, eax
                .if mdctx == 0
                    invoke MessageBox,hWin,chr$('EVP_MD_CTX_new failed'),0,0
                .endif

                ; Sign
                invoke GetProcAddress,handle,chr$('EVP_DigestSignInit') ; https://www.openssl.org/docs/man1.1.1/man3/EVP_DigestSignInit.html
                push pkey       ; EVP_PKEY *pkey
                push 0          ; ENGINE *e
                push 0          ; const EVP_MD *type
                push 0          ; EVP_PKEY_CTX **pctx
                push mdctx      ; EVP_MD_CTX *ctx
                call eax
                .if eax != 1
                    invoke MessageBox,hWin,chr$('EVP_DigestSignInit failed'),0,0
                .endif

                mov sigLen, SIGNATURE_SIZE

                invoke GetProcAddress,handle,chr$('EVP_DigestSign') ; https://www.openssl.org/docs/man1.1.1/man3/EVP_DigestSign.html
                push sLen    ; size_t tbslen
                push offset MessageToCheck   ; const unsigned char *tbs
                push offset sigLen          ; size_t *siglen
                push offset Signature          ; unsigned char *sigret
                push mdctx                  ; EVP_MD_CTX *ctx
                call eax
                .if sigLen != SIGNATURE_SIZE
                    invoke MessageBox,hWin,chr$('EVP_DigestSign failed'),0,0
                .endif
                ; End sign

                ; Output signature to dialog
                invoke GetDlgItem,hWin,IDC_SIGNATURE
                invoke SetText,offset Signature,offset sigStr,SIGNATURE_SIZE,eax

                ; Verify
                invoke GetProcAddress,handle,chr$('EVP_DigestVerifyInit')   ; https://www.openssl.org/docs/man3.0/man3/EVP_DigestVerifyInit.html
                push pkey       ; EVP_PKEY *pkey
                push 0          ; ENGINE *e
                push 0          ; const EVP_MD *type
                push 0          ; EVP_PKEY_CTX **pctx
                push mdctx      ; EVP_MD_CTX *ctx
                call eax
                .if eax != 1
                    invoke MessageBox,hWin,chr$('EVP_DigestVerifyInit failed'),0,0
                .endif

                invoke GetProcAddress,handle,chr$('EVP_DigestVerify')
                push sLen      ; size_t tbslen
                push offset MessageToCheck     ; const unsigned char *tbs
                push sigLen                     ; size_t siglen
                push offset Signature           ; const unsigned char *sigret
                push mdctx                      ; EVP_MD_CTX *ctx
                call eax
                .if eax != 1
                    invoke MessageBox,hWin,chr$('EVP_DigestVerify failed'),0,0
                .else
                    invoke MessageBox,hWin,chr$('EVP_DigestVerify OK'),chr$('Worked'),0
                .endif
                ; End verify

                ; Free MdCtx
                invoke GetProcAddress,handle,chr$('EVP_MD_CTX_free')
                push mdctx
                call eax

                ; Free key
                invoke GetProcAddress,handle,chr$('EVP_PKEY_free')
                push pkey           ;EVP_PKEY_CTX *ctx
                call eax

                ; Free ctx
                invoke GetProcAddress,handle,chr$('EVP_PKEY_CTX_free')
                push pctx           ; EVP_PKEY_CTX *ctx
                call eax            ; invoke EVP_PKEY_CTX_free

                ; Clean buffers
                invoke RtlZeroMemory,addr MessageToCheck,sizeof MessageToCheck
                invoke RtlZeroMemory,addr sLen,sizeof sLen
        .elseif wParam == IDB_CANCEL
                invoke SendMessage,hWin,WM_CLOSE,0,0
        .endif
    .elseif uMsg == WM_CLOSE
            invoke CloseHandle,Handle2
            invoke FreeLibrary,handle
            invoke GlobalFree,pData
            invoke DeleteFile,addr SysDirect
            invoke GetLastError
            cmp eax,-1
            jnz @F
               invoke MessageBox,hWin,chr$('Cannot delete file libcrypto-3.dll!'),0,MB_ICONERROR
            @@:
            invoke EndDialog,hWin,0
    .endif

    xor eax,eax
    ret
DlgProc EndP

end start