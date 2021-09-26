.486
.model flat, stdcall
option casemap :none ;case sensitive

include \masm32\include\windows.inc

include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
include \masm32\include\advapi32.inc

includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\advapi32.lib

include \masm32\macros\macros.asm

DlgProc          PROTO :DWORD,:DWORD,:DWORD,:DWORD
WriteHexadecimal PROTO :DWORD,:DWORD

.const
IDC_SIGN         equ 1003
IDC_QUIT         equ 1004
IDC_GENKEY       equ 1005
CALG_MD5         equ 8003h
PRIVATE_KEY_SIZE equ 0254h
PUBLIC_KEY_SIZE  equ 094h
SIGNATURE_SIZE   equ 080h
HCRYPTHASH       equ dd
HCRYPTPROV       equ dd

LINE_BREAK       equ (10)
CARRIAGE_RETURN  equ (13)

.data
public_key \
db 006h,002h,000h,000h,000h,024h,000h,000h,052h,053h,041h,031h,000h,004h,000h,000h
db 001h,000h,001h,000h,0EBh,091h,0ECh,049h,00Bh,044h,038h,074h,022h,053h,0ADh,007h
db 031h,0A7h,0BBh,0E2h,0D5h,0F3h,05Fh,02Ah,0B5h,0EDh,0D5h,05Ch,076h,018h,09Ah,0B1h
db 008h,04Eh,00Fh,0C1h,01Dh,009h,0D2h,082h,022h,007h,0DDh,049h,08Eh,0F2h,041h,0D2h
db 06Fh,092h,007h,0CCh,025h,002h,080h,0FDh,072h,0D9h,07Dh,031h,08Bh,021h,05Dh,080h
db 0ACh,04Bh,013h,055h,00Dh,08Bh,0F8h,038h,0B9h,0D5h,078h,004h,0D9h,058h,073h,03Eh
db 006h,03Bh,09Ch,0C5h,0D5h,08Eh,015h,03Bh,0A1h,072h,009h,0B2h,01Ch,025h,044h,018h
db 0FCh,066h,000h,09Ch,0A6h,0B5h,040h,091h,0ACh,030h,0A6h,05Bh,05Eh,0CDh,065h,017h
db 047h,098h,092h,0ABh,095h,0BCh,0E7h,017h,049h,023h,0C9h,0E7h,0C8h,02Fh,07Ah,034h
db 051h,005h,03Bh,0FFh

private_key \
db 007h,002h,000h,000h,000h,024h,000h,000h,052h,053h,041h,032h,000h,004h,000h,000h
db 001h,000h,001h,000h,0EBh,091h,0ECh,049h,00Bh,044h,038h,074h,022h,053h,0ADh,007h
db 031h,0A7h,0BBh,0E2h,0D5h,0F3h,05Fh,02Ah,0B5h,0EDh,0D5h,05Ch,076h,018h,09Ah,0B1h
db 008h,04Eh,00Fh,0C1h,01Dh,009h,0D2h,082h,022h,007h,0DDh,049h,08Eh,0F2h,041h,0D2h
db 06Fh,092h,007h,0CCh,025h,002h,080h,0FDh,072h,0D9h,07Dh,031h,08Bh,021h,05Dh,080h
db 0ACh,04Bh,013h,055h,00Dh,08Bh,0F8h,038h,0B9h,0D5h,078h,004h,0D9h,058h,073h,03Eh
db 006h,03Bh,09Ch,0C5h,0D5h,08Eh,015h,03Bh,0A1h,072h,009h,0B2h,01Ch,025h,044h,018h
db 0FCh,066h,000h,09Ch,0A6h,0B5h,040h,091h,0ACh,030h,0A6h,05Bh,05Eh,0CDh,065h,017h
db 047h,098h,092h,0ABh,095h,0BCh,0E7h,017h,049h,023h,0C9h,0E7h,0C8h,02Fh,07Ah,034h
db 051h,005h,03Bh,0FFh,0A7h,064h,046h,037h,0F7h,01Ch,08Bh,014h,01Bh,082h,0EAh,0CAh
db 01Ch,054h,0EAh,06Ch,07Fh,0D1h,0D2h,0DFh,0FAh,050h,04Eh,087h,0BEh,041h,0F8h,0C1h
db 0A7h,0B6h,048h,0A4h,005h,075h,0C3h,07Ch,05Ah,056h,002h,0DDh,0C0h,03Bh,087h,024h
db 0FFh,0E2h,0FBh,0B4h,0B4h,0BEh,08Ch,0F8h,070h,075h,070h,0BCh,06Ah,096h,031h,072h
db 08Eh,0CCh,0B8h,0FFh,01Dh,0DDh,059h,01Ch,051h,082h,0CCh,00Dh,002h,0FBh,05Bh,013h
db 02Bh,08Ch,053h,0D8h,049h,0EDh,0F3h,0FFh,031h,0F3h,09Fh,07Bh,0F2h,0F3h,072h,0FCh
db 0AAh,0A6h,0A9h,06Ah,0EDh,0CBh,02Dh,061h,071h,024h,05Ah,0D3h,06Bh,072h,0B9h,04Fh
db 0C3h,0E3h,0CEh,09Fh,03Dh,029h,0B7h,0DEh,02Dh,09Dh,032h,0E9h,098h,0ACh,050h,07Ch
db 0BDh,015h,082h,0FFh,025h,010h,050h,0A2h,07Eh,0F3h,061h,035h,0FBh,0A8h,06Ch,067h
db 03Ah,085h,0DDh,00Ch,028h,0CBh,07Ch,053h,04Eh,0CCh,0EDh,08Ch,01Ch,011h,071h,07Eh
db 096h,0A2h,00Dh,003h,0C6h,0DEh,028h,05Ch,0ACh,031h,07Ch,062h,091h,05Dh,09Eh,04Ch
db 02Ch,0F4h,0BAh,03Dh,091h,0FAh,0F8h,063h,061h,08Eh,093h,090h,0E8h,021h,057h,068h
db 0D7h,0CFh,055h,039h,0E9h,06Fh,019h,09Dh,0F7h,0F1h,0BAh,06Eh,002h,074h,01Ch,0ABh
db 0D2h,095h,0DCh,03Ah,095h,092h,051h,0E6h,034h,040h,0AEh,0EDh,0F7h,059h,0C5h,06Fh
db 0ACh,0DDh,048h,02Bh,08Bh,05Ah,051h,013h,003h,06Eh,0A8h,059h,0AEh,010h,0BBh,081h
db 0E7h,0CCh,0D4h,076h,034h,066h,047h,04Ah,02Fh,0D4h,053h,07Eh,081h,0CCh,064h,04Bh
db 064h,0E4h,0FBh,074h,0DFh,083h,066h,077h,0F9h,039h,03Ch,013h,0E5h,086h,01Ah,01Dh
db 015h,00Ah,0C8h,018h,036h,004h,032h,00Fh,0DAh,092h,0CAh,0C0h,028h,0A8h,023h,07Ch
db 0D6h,09Bh,0EEh,0F1h,0ADh,08Ch,0E6h,0B4h,0D6h,046h,0F5h,053h,026h,0B9h,039h,089h
db 004h,0D4h,007h,021h,074h,0FFh,00Ch,0DEh,0DEh,08Ah,080h,07Bh,08Dh,0AAh,0BBh,06Ah
db 064h,078h,0DEh,075h,0A1h,05Eh,0DBh,0D1h,0C5h,06Fh,001h,07Eh,0C5h,05Ch,038h,0E6h
db 0D1h,0D3h,011h,0EBh,0A5h,06Dh,08Bh,023h,0C7h,0C4h,029h,0F0h,0A5h,0B0h,049h,014h
db 036h,072h,036h,0C6h,044h,07Dh,0E4h,009h,046h,0E6h,0C5h,0D4h,083h,01Fh,019h,053h
db 0E3h,0A0h,009h,076h,014h,0E6h,0C2h,0E9h,000h,0DFh,00Eh,03Fh,02Ah,0F5h,0DAh,0C9h
db 0C6h,01Ah,06Eh,0C6h,070h,0EEh,0FDh,0E3h,02Eh,033h,07Ah,089h,05Ah,0DEh,046h,033h
db 0ECh,054h,0D3h,08Ch,0F2h,0F8h,01Eh,059h,07Ah,0E0h,0BDh,0F9h,0FDh,032h,019h,0EFh
db 002h,073h,0EAh,023h,025h,06Ah,084h,00Fh,013h,0EBh,06Ah,092h,031h,00Ch,0C3h,00Ah
db 071h,034h,0E6h,020h,008h,062h,01Ch,0D2h,0D0h,09Ah,069h,048h,053h,0A4h,024h,05Bh
db 0B5h,02Ah,079h,060h

comment /
P = FFB8CC8E7231966ABC707570F88CBEB4B4FBE2FF24873BC0DD02565A7CC37505A448B6A7C1F841BE874E50FADFD2D17F6CEA541CCAEA821B148B1CF7374664A7
Q = FF8215BD7C50AC98E9329D2DDEB7293D9FCEE3C34FB9726BD35A2471612DCBED6AA9A6AAFC72F3F27B9FF331FFF3ED49D8538C2B135BFB020DCC82511C59DD1D
E (Public Exponent) = 10001
N (Public Modulus) = FF3B0551347A2FC8E7C9234917E7BC95AB9298471765CD5E5BA630AC9140B5A69C0066FC1844251CB20972A13B158ED5C59C3B063E7358D90478D5B938F88B0D55134BAC805D218B317DD972FD800225CC07926FD241F28E49DD072282D2091DC10F4E08B19A18765CD5EDB52A5FF3D5E2BBA73107AD53227438440B49EC91EB
D (Private Exponent) = 60792AB55B24A45348699AD0D21C620820E634710AC30C31926AEB130F846A2523EA7302EF1932FDF9BDE07A591EF8F28CD354EC3346DE5A897A332EE3FDEE70C66E1AC6C9DAF52A3F0EDF00E9C2E6147609A0E353191F83D4C5E64609E47D44C63672361449B0A5F029C4C7238B6DA5EB11D3D1E6385CC57E016FC5D1DB5EA1
*/

DataToSign            db "Hello World",0
szDesc                db "test",0   
hkey                  dd 0

;Keypair gen:
szFileNamePrivate     db "Private.key",0
szFileNamePublic      db "Public.key",0
dwBlobLen             dd 0
hfile                 dd 0

hexadecimal_digits    db "0123456789ABCDEF",0

message_sign          db "[INFO] Trying to sign a message...", 13, 10, 0
message_quit          db "[INFO] Quitting...", 13, 10, 0
message_save          db "[INFO] Saving Public.key and Private.key", 13, 10, 0
message_rsa_signature db "[INFO] RSA signature: ", 0

message_rsa_gen_priv  db "[INFO] Private key: ", 0
message_rsa_gen_pub   db "[INFO] Public key: ", 0

error_001             db "[ERROR] CryptAcquireContext - NTE_BAD_KEYSET", 13, 10, 0

.data?
hInstance             dd ? ;dd can be written as dword
hHash HCRYPTHASH      ?
hProv HCRYPTPROV      ?

console_handle        HANDLE ?
text_length           dd ?
general_buffer        db 4096 dup (?)

szSignature           db SIGNATURE_SIZE dup (?) ;signature output should have the 80h (128) fixed lenght.
bKeyBlobPriv          db PRIVATE_KEY_SIZE dup (?)
bKeyBlobPub           db PUBLIC_KEY_SIZE dup (?)
NumOfBytesWritten     DWORD ?
 
.code
start:

    invoke GetStdHandle,STD_OUTPUT_HANDLE
    mov console_handle,eax

    invoke GetModuleHandle,NULL
    mov hInstance, eax
    invoke DialogBoxParam,hInstance,101,0,addr DlgProc,0
    invoke ExitProcess,eax
DlgProc proc hWin :DWORD,
        uMsg      :DWORD,
        wParam    :DWORD,
        lParam    :DWORD

    .if uMsg == WM_COMMAND
        .if wParam == IDC_SIGN
            ;reference: https://docs.microsoft.com/en-us/windows/win32/seccrypto/example-c-program-signing-a-hash-and-verifying-the-hash-signature
            invoke lstrlen,addr message_sign
            mov [text_length],eax
            invoke WriteConsoleA,console_handle,addr message_sign,text_length,NULL,NULL

            ;get the csp and import the key
            invoke CryptAcquireContext,offset hProv,addr szDesc,NULL,PROV_RSA_FULL,NULL
               .if eax == 0
                   invoke GetLastError
                      .if eax == NTE_BAD_KEYSET
                          invoke lstrlen,addr error_001
                          mov [text_length],eax
                          invoke WriteConsoleA,console_handle,addr error_001,text_length,NULL,NULL
                          invoke CryptAcquireContext,offset hProv,addr szDesc,NULL,PROV_RSA_FULL,CRYPT_NEWKEYSET
                      .endif
               .endif
            invoke CryptImportKey,hProv,addr private_key,PRIVATE_KEY_SIZE,0,0,addr hkey

            ;hash
            invoke CryptCreateHash,hProv,CALG_MD5,0,0,offset hHash
            invoke lstrlen,offset DataToSign
            invoke CryptHashData,hHash,offset DataToSign,eax,0
            
            ;sign
            mov dwBlobLen,PRIVATE_KEY_SIZE
            invoke CryptSignHash,hHash,AT_SIGNATURE,offset szDesc,0,offset szSignature,addr dwBlobLen

            ;output to console
            invoke lstrlen,addr message_rsa_signature
            mov [text_length],eax
            invoke WriteConsoleA,console_handle,addr message_rsa_signature,text_length,NULL,NULL
            invoke WriteHexadecimal,addr szSignature,SIGNATURE_SIZE

            ;releasing handles
            invoke CryptDestroyHash,hHash
            invoke CryptReleaseContext,hProv,0
            
        .elseif wParam == IDC_GENKEY
            ;reference: https://docs.microsoft.com/en-us/windows/win32/seccrypto/example-c-program-creating-a-key-container-and-generating-keys
            invoke CryptAcquireContext,offset hProv,addr szDesc,NULL,PROV_RSA_FULL,NULL
            invoke GetLastError
            
            ;Get the priv key
            invoke CryptGenKey,hProv,AT_SIGNATURE,CRYPT_EXPORTABLE,addr hkey
            mov dwBlobLen,PRIVATE_KEY_SIZE
            invoke CryptExportKey,hkey,0,PRIVATEKEYBLOB,0,addr bKeyBlobPriv,addr dwBlobLen
            invoke lstrlen,addr message_rsa_gen_priv
            mov [text_length],eax
            invoke WriteConsoleA,console_handle,addr message_rsa_gen_priv,text_length,NULL,NULL
            invoke WriteHexadecimal,addr bKeyBlobPriv,PRIVATE_KEY_SIZE
            invoke CreateFile,addr szFileNamePrivate,GENERIC_READ or GENERIC_WRITE,FILE_SHARE_READ or FILE_SHARE_WRITE,0,OPEN_ALWAYS,FILE_ATTRIBUTE_NORMAL,NULL
            mov hfile,eax
            invoke WriteFile,hfile,offset bKeyBlobPriv,PRIVATE_KEY_SIZE,offset NumOfBytesWritten,NULL ;
            invoke GetLastError
            invoke CloseHandle,hfile
            
            ;Get the pub key
            invoke CryptGenKey,hProv,AT_SIGNATURE,CRYPT_EXPORTABLE,addr hkey
            mov dwBlobLen,PUBLIC_KEY_SIZE
            invoke CryptExportKey,hkey,0,PUBLICKEYBLOB,0,addr bKeyBlobPub,addr dwBlobLen
            invoke lstrlen,addr message_rsa_gen_pub
            mov [text_length],eax
            invoke WriteConsoleA,console_handle,addr message_rsa_gen_pub,text_length,NULL,NULL
            invoke WriteHexadecimal,addr bKeyBlobPub,PUBLIC_KEY_SIZE
            invoke CreateFile,addr szFileNamePublic,GENERIC_READ or GENERIC_WRITE,FILE_SHARE_READ or FILE_SHARE_WRITE,0,OPEN_ALWAYS,FILE_ATTRIBUTE_NORMAL,NULL
            mov hfile,eax
            invoke WriteFile,hfile,offset bKeyBlobPub,PUBLIC_KEY_SIZE,offset NumOfBytesWritten,NULL ;
            invoke GetLastError
            invoke CloseHandle,hfile
            
            invoke lstrlen,addr message_save
            mov [text_length],eax
            invoke WriteConsoleA,console_handle,addr message_save,text_length,NULL,NULL
            
            ;releasing
            invoke CryptReleaseContext,hProv,0
            invoke RtlZeroMemory,addr bKeyBlobPub,sizeof bKeyBlobPub
            invoke RtlZeroMemory,addr bKeyBlobPriv,sizeof bKeyBlobPriv
        .elseif wParam == IDC_QUIT
            invoke EndDialog,hWin,0
        .endif
    .elseif uMsg == WM_CLOSE
        invoke EndDialog,hWin,0
    .endif
    xor eax,eax
    ret
DlgProc endp

WriteHexadecimal proc source_buffer:DWORD,
                      source_length:DWORD
    local output_buffer:DWORD

    mov eax,offset general_buffer
    mov output_buffer,eax

WriteHexadecimal_Loop:

    mov eax,source_length
    cmp eax,0
    jz WriteHexadecimal_End

    sub eax,1
    mov [source_length],eax
    mov eax,source_buffer
    mov dl,[eax]
    mov dh,dl
    add eax,1
    mov source_buffer,eax

    shr dh,4
    and dl,0Fh

    xor eax,eax
    mov al,dh
    mov ecx,offset hexadecimal_digits
    add ecx,eax
    mov dh,[ecx]

    mov eax, output_buffer
    mov [eax],dh
    add eax, 1
    mov output_buffer,eax

    xor eax,eax
    mov al,dl
    mov ecx,offset hexadecimal_digits
    add ecx,eax
    mov dl,[ecx]

    mov eax, output_buffer
    mov [eax],dl
    add eax,1
    mov output_buffer,eax
    
    jmp WriteHexadecimal_Loop

WriteHexadecimal_End:

    mov eax,output_buffer

    mov dl,CARRIAGE_RETURN
    mov [eax],dl
    add eax,1

    mov dl,LINE_BREAK
    mov [eax],dl
    add eax,1

    xor dl,dl
    mov [eax],dl

    invoke lstrlen,addr general_buffer
    mov [text_length],eax
    invoke WriteConsoleA,console_handle,addr general_buffer,text_length,NULL,NULL

    xor eax,eax
    ret

WriteHexadecimal endp

end start
