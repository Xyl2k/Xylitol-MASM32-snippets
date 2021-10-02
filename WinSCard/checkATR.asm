.386
.model flat, stdcall
option casemap :none

include        \masm32\include\windows.inc ; Win32 API
include        \masm32\include\user32.inc
include        \masm32\include\kernel32.inc
include        \masm32\include\winscard.inc ; SmartCard API

includelib     \masm32\lib\winscard.lib
includelib     \masm32\lib\user32.lib
includelib     \masm32\lib\kernel32.lib
include        \masm32\macros\macros.asm ; need that one too as i use chr$()

DlgProc        PROTO :DWORD,:DWORD,:DWORD,:DWORD
List           PROTO :DWORD,:DWORD

.const
ATR            equ 20h
IDC_ATR        equ 1001
IDC_GROUPBOX   equ 1002
BTN_OK         equ 1003
BTN_IDCANCEL   equ 1004
IDC_LISTBOX    equ 1005

.data

szSUCCESS_context   db "[iNFO] Etablished context successfully !",0
szFAIL_context      db "[ERR] Failed to get context",0
szRemovedcard       db "[iNFO] No smart card, please insert one to the reader!",0
szUnrecongReader    db "[ERR] The specified reader name is not recognized/not found.",0
szConnectedToReader db "[iNFO] Connected !",0
szOtherError        db "[ERR] looks like there is some debug to do!",0
szActiveProtocolT0  db "[iNFO] Current Active protocol: T0",0
szActiveProtocolT1  db "[iNFO] Current Active protocol: T1",0
szUNkwnProtocol     db "[ERR] Active protocol unnegotiated or unknown",0
szsuccessATR        db "[iNFO] Sucessfully grabbed ATR",0
szfailATR           db "[ERR] Failed to get ATR from card",0
szDisconnected      db "[iNFO] Disconnected from SmartCard Reader",0
szScan              db "[iNFO] Scanning against local ATR DB...",0

SzReader            db "HID Global OMNIKEY 3x21 Smart Card Reader 0",0    
dwBlobLen           dd 0
SzpbAtrSTR          dd ATR dup (0)

.data?
hInstance           dd ?    ;dd can be written as dword
SzphContext         DWORD ?
SzComActiveProtocol DWORD ?

SzCardHandle        DWORD ?
chReaderLen         DWORD ?
atrlen              DWORD ?
SzpdwState          DWORD ?
SzpdwProtocol       DWORD ?
SzpbAtr             DWORD 32 dup(?)
SzpbAtrlen          DWORD 32 dup(?)
SzReaderlen         DWORD 32 dup(?)

include	ATRDB.asm

.code
start:
    invoke GetModuleHandle,NULL
    mov hInstance,eax
    invoke DialogBoxParam,hInstance,101,0,ADDR DlgProc,0
    invoke ExitProcess,eax
    
HexToChar Proc    HexValue    :DWORD,
                  CharValue   :DWORD,
                  HexLength   :DWORD
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

DlgProc proc hWin   :DWORD,
             uMsg   :DWORD,
             wParam :DWORD,
             lParam :DWORD

    .if uMsg == WM_COMMAND
        .if wParam == BTN_OK
            invoke SCardEstablishContext,SCARD_SCOPE_USER,NULL,NULL,addr SzphContext
        .if eax == SCARD_S_SUCCESS
            invoke List,hWin,addr szSUCCESS_context
        .else
            invoke List,hWin,addr szFAIL_context
            ret
        .endif
        
        invoke SCardConnect,SzphContext,addr SzReader,SCARD_SHARE_SHARED,SCARD_PROTOCOL_T0 or SCARD_PROTOCOL_T1,addr SzCardHandle,addr SzComActiveProtocol
        .if eax == SCARD_W_REMOVED_CARD
            invoke List,hWin,addr szRemovedcard
           ret
        .elseif eax == SCARD_E_UNKNOWN_READER
            invoke List,hWin,addr szUnrecongReader
            ret
        .elseif eax == SCARD_S_SUCCESS
            invoke List,hWin,addr szConnectedToReader
        .else
            invoke List,hWin,addr szOtherError
         ret
        .endif
        
        .if SzComActiveProtocol == SCARD_PROTOCOL_T0
            invoke List,hWin,addr szActiveProtocolT0 
        .elseif SzComActiveProtocol == SCARD_PROTOCOL_T1
            invoke List,hWin,addr szActiveProtocolT1
        .elseif
            invoke List,hWin,addr szUNkwnProtocol
        .endif
        push ebx    
        mov ebx,SzCardHandle

        mov dwBlobLen,ATR
        invoke SCardStatus,SzCardHandle,addr SzReader,addr SzReaderlen,addr SzpdwState,addr SzpdwProtocol,addr SzpbAtr,addr dwBlobLen
        invoke GetLastError
        .if eax == SCARD_S_SUCCESS
            invoke List,hWin,addr szsuccessATR
        .else
            invoke List,hWin,addr szfailATR
        .endif
        invoke HexToChar,addr SzpbAtr,addr SzpbAtrSTR,dwBlobLen
        invoke SetDlgItemText,hWin,IDC_ATR,addr SzpbAtrSTR
        invoke SCardDisconnect,SzCardHandle,SCARD_LEAVE_CARD
        invoke SCardReleaseContext,SzphContext
        invoke List,hWin,addr szDisconnected
        invoke List,hWin,addr szScan
        invoke infoATRcheck,hWin
        call clean
        invoke GetDlgItem,hWin,BTN_OK
        invoke EnableWindow,eax,FALSE

        .elseif wParam == BTN_IDCANCEL
            invoke EndDialog,hWin,0
        .endif
    .elseif uMsg == WM_CLOSE
        invoke EndDialog,hWin,0
    .endif

    xor eax,eax
    ret
DlgProc endp

List proc hWin:HWND, pMsg:DWORD
    invoke SendDlgItemMessage,hWin,IDC_LISTBOX,LB_ADDSTRING,0,pMsg 
    invoke SendDlgItemMessage,hWin,IDC_LISTBOX,WM_VSCROLL,SB_BOTTOM,0
    Ret
List endp

clean proc
    invoke RtlZeroMemory,addr SzpbAtr,sizeof SzpbAtr
    invoke RtlZeroMemory,addr SzphContext,sizeof SzphContext
    invoke RtlZeroMemory,addr SzCardHandle,sizeof SzCardHandle
    invoke RtlZeroMemory,addr SzComActiveProtocol,sizeof SzComActiveProtocol
    invoke RtlZeroMemory,addr SzpbAtrSTR,sizeof SzpbAtrSTR
    ret
clean endp

end start
