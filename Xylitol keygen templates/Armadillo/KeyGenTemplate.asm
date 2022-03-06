.386 
.model flat,stdcall 
option casemap:none 

include           \masm32\include\windows.inc
include           \masm32\include\kernel32.inc
include           \masm32\include\user32.inc
include           \masm32\include\gdi32.inc
include           \masm32\include\comctl32.inc
include           \masm32\include\winmm.inc
include           \masm32\include\masm32.inc
include           \masm32\macros\macros.asm
include           \masm32\include\ole32.inc
include           \masm32\include\oleaut32.inc
include           \masm32\include\advapi32.inc

includelib        \masm32\lib\kernel32.lib
includelib        \masm32\lib\user32.lib
includelib        \masm32\lib\gdi32.lib
includelib        \masm32\lib\comctl32.lib
includelib        \masm32\lib\winmm.lib
includelib        \masm32\lib\ole32.lib
includelib        \masm32\lib\oleaut32.lib
includelib        \masm32\lib\masm32.lib
includelib        \masm32\lib\msvcrt.lib
includelib        \masm32\lib\advapi32.lib 

include           libs\btnt.inc
include           libs\\AhxPlayerLib.inc
includelib        libs\\AhxPlayerLib.lib

AllowSingleInstance MACRO lpTitle
        invoke FindWindow,NULL,lpTitle
        cmp eax, 0
        je @F
          push eax
          invoke ShowWindow,eax,SW_RESTORE
          pop eax
          invoke SetForegroundWindow,eax
          mov eax, 0
          ret
        @@:
      ENDM

Main              PROTO  :DWORD,:DWORD,:DWORD,:DWORD 
SerialCalc        PROTO  :DWORD
TypewritingAnim   PROTO  :DWORD
Copytxt           PROTO  :DWORD,:DWORD,:DWORD

.const
IDD_KEYGEN        equ    1000
IDC_HWID          equ    1017
IDC_NAME          equ    1002
IDC_SERIAL        equ    1003

IDM_MSX           equ    1005
IDB_IDGENERATE    equ    1006
IDB_IDEXIT        equ    1007
IDB_IDSOUND       equ    1008
IDB_IDABOUT       equ    1009

ICON              equ    2001
LAYER             equ    80000h

bufSize = MAX_COMPUTERNAME_LENGTH + 1

.data
; Fews things like hInstance are already initialized from libs\btnt.inc !

;Bitmap background 
hBgColor          HBRUSH ?

;App text
WindowTitle       db "Keygen template Armadillo",0
TooLong           db "Your name is too long !",0
TooShort          db "Your name is too short !",0
sZpressGenerate   db "pRESS gENERATE!",0
szDialogTitle     db "aBOUT...",0
szMessageText     db "==================",13,10
                  db "cODE: Xylitol",13,10
                  db "gFX: Santa",13,10
                  db "sFX: Jazzcat - Electric City",13,10
                  db "==================",0

;GetUserName stuff
getName           db bufSize dup(?)
bufferName        db 100 dup(?)
bSize             dd bufSize
status            dd ?

.data? 
;hInstance HINSTANCE ?
hCursor           dd ?
hFont             dd ?
;Related to algo
NameBuffer        db 100 dup(?)
FinalSerial       db 100 dup(?)
NameLen           dd ?

;Region stuff
ResInf            dd ?
ResDat            dd ?
ResSize           dd ?
RGNRes            dd ?
Brush             dd ?

;Brush for editbox
hName             db ?

;AHX player
hRes              dd ?
lenRes            dd ?

.code 
start: 
    invoke GetModuleHandle, NULL 
    mov hInstance,eax
    AllowSingleInstance addr WindowTitle
    invoke LoadCursor,hInstance,2000
    mov hCursor,eax
    invoke LoadBitmap,hInstance,2002
    invoke CreatePatternBrush,eax
    mov hBgColor,eax
    invoke DialogBoxParam,hInstance,IDD_KEYGEN,NULL,addr Main,NULL 
    invoke ExitProcess,eax 

DoKey    proc    hWnd:DWORD
    ; algo here !
    mov ecx,NameLen
    lea ebx,NameBuffer
    xor edx,edx
    lea edx,FinalSerial
    xor ecx,ecx

    @@:
    mov cl,byte ptr ds:[eax+ebx-1]
    mov byte ptr ds:[edx],cl
    inc edx
    dec eax
    jnz @b

    invoke SetDlgItemText,hWnd,IDC_SERIAL,addr FinalSerial
    invoke RtlZeroMemory,addr NameBuffer,sizeof NameBuffer
    invoke RtlZeroMemory,addr FinalSerial,sizeof FinalSerial
    Ret
DoKey EndP

Main proc hWnd:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM 
local TypeThread:DWORD

      .if uMsg == WM_INITDIALOG
         invoke GetWindowLong,hWnd,GWL_EXSTYLE 
         or eax,LAYER 
         invoke SetWindowLong,hWnd,GWL_EXSTYLE,eax 
         invoke SetWindowPos,hWnd,HWND_TOPMOST,0,0,0,0,SWP_NOMOVE+SWP_NOSIZE
         invoke SetWindowText,hWnd,addr WindowTitle
         ;Load the background and region file
         invoke LoadBitmap,hInstance,2002          
         invoke CreatePatternBrush,eax
         mov Brush,eax
         invoke FindResource,hInstance,2003,RT_RCDATA
         mov ResInf,eax
         invoke LoadResource,hInstance,ResInf
         mov ResDat,eax
         invoke SizeofResource,hInstance,ResInf
         mov ResSize,eax
         invoke LockResource,ResDat
         mov RGNRes,eax
         invoke ExtCreateRegion,NULL,ResSize,RGNRes
         invoke SetWindowRgn,hWnd,eax,TRUE
         ;Load icon
         invoke LoadIcon,hInstance,ICON         
         invoke SendMessage,hWnd,WM_SETICON,1,eax
         ;Load music
         mov status,1 
         invoke AHX_Init
         call music
         ;Load the buttons
         invoke ImageButton,hWnd,115,218,701,703,702,IDB_IDEXIT       
         mov hExit,eax
         invoke ImageButton,hWnd,183,183,601,603,602,IDB_IDSOUND        
         mov hSound,eax
         invoke ImageButton,hWnd,550,201,501,503,502,IDB_IDABOUT    
         mov hAbout,eax
         invoke ImageButton,hWnd,245,112,401,403,402,IDB_IDGENERATE
         mov hGenerate,eax
         ;Fade in
         invoke AnimateWindow,hWnd,600,AW_ACTIVATE or AW_BLEND   
         ;Animation on IDC_SERIAL
         invoke CloseHandle,FUNC(CreateThread,NULL,0,addr TypewritingAnim,hWnd,0,addr TypeThread)
         ;Load pc name into IDC_NAME
         invoke GetUserName,ADDR getName,ADDR bSize
         invoke wsprintf,ADDR bufferName,chr$("%s"),ADDR getName
         invoke SetDlgItemText,hWnd,IDC_NAME,addr bufferName
         ;Set focus on IDC_NAME
         invoke GetDlgItem,hWnd,IDC_NAME
         invoke SetFocus,eax
         invoke GetDlgItem,hWnd,IDC_NAME
         invoke SendMessage,eax,WM_SETFONT,hFont,1
         invoke GetDlgItem,hWnd,IDC_HWID
         invoke SendMessage,eax,WM_SETFONT,hFont,1
      .elseif uMsg==WM_LBUTTONDOWN 
         invoke SendMessage,hWnd,WM_NCLBUTTONDOWN,HTCAPTION,0
      .elseif uMsg==WM_CTLCOLORDLG
         mov eax, Brush
         return hBgColor
         ret        
      .elseif uMsg == WM_CTLCOLOREDIT || uMsg == WM_CTLCOLORSTATIC
         invoke GetDlgCtrlID,lParam
            .if eax == IDC_SERIAL
                invoke SetBkMode,wParam,TRANSPARENT
                invoke SetTextColor,wParam,Black
                invoke SetBrushOrgEx,wParam,-161,175,0    
                mov eax,hBgColor
                ret
            .endif
            .if eax == IDC_NAME
                invoke SetBkMode,wParam,TRANSPARENT
                invoke SetTextColor,wParam,Black
                invoke SetBrushOrgEx,wParam,-250,258,0    
                mov eax,hBgColor
                ret
            .endif
            .if eax == IDC_HWID
                invoke SetBkMode,wParam,TRANSPARENT
                invoke SetTextColor,wParam,Black
                invoke SetBrushOrgEx,wParam,373,221,0    
                mov eax,hBgColor
                ret
            .endif
      .elseif uMsg == WM_COMMAND
        ; shr edx,16
      .endif
      .if wParam == IDB_IDEXIT
         invoke SendMessage,hWnd,WM_CLOSE,0,0
      .elseif wParam == IDB_IDSOUND
         call music    
      .elseif wParam == IDB_IDABOUT
           invoke MessageBox,hWnd,ADDR szMessageText,ADDR szDialogTitle,MB_OK
      .elseif wParam == IDB_IDGENERATE
           ;Keygen procedure start here
           invoke GetDlgItemText,hWnd,IDC_NAME,addr NameBuffer,sizeof NameBuffer
            .if eax > 40
                invoke SetDlgItemText,hWnd,IDC_SERIAL,addr TooLong
            .elseif eax < 1
                invoke SetDlgItemText,hWnd,IDC_SERIAL,addr TooShort
            .else
                mov NameLen,eax
                invoke DoKey,hWnd
            .endif
      .endif
      .if uMsg == WM_RBUTTONDOWN
         invoke SetCursor,hCursor
      .elseif uMsg == WM_LBUTTONDOWN
         invoke SetCursor,hCursor
      .elseif uMsg == WM_MOUSEMOVE
         invoke SetCursor,hCursor
      .elseif uMsg == WM_LBUTTONUP
         invoke SetCursor,hCursor
      .elseif uMsg == WM_LBUTTONDBLCLK
         invoke SetCursor,hCursor
      .elseif uMsg == WM_RBUTTONDBLCLK
         invoke SetCursor,hCursor
      .elseif uMsg == WM_RBUTTONUP
         invoke SetCursor,hCursor
      .elseif uMsg == WM_MBUTTONDBLCLK
         invoke SetCursor,hCursor
      .elseif uMsg == WM_MBUTTONDOWN
         invoke SetCursor,hCursor
      .elseif uMsg == WM_MBUTTONUP
         invoke SetCursor,hCursor
      .elseif uMsg == WM_CLOSE
         invoke DeleteObject,Brush
         invoke AHX_Stop
         invoke AHX_Free
         invoke EndDialog,hWnd,0         
      .endif
xor eax,eax
ret 

Main endp 

TypewritingAnim proc hWnd:DWORD ; <-- this effect is token from Crisanar's keygen template so thx to him for that.
    LOCAL Charbuff[255]:TCHAR    
    LOCAL Newlen:DWORD
    mov Newlen,FUNC(StrLen,addr sZpressGenerate)
    inc Newlen
    shr Newlen,1                            
    mov ecx,1    
    ;  initialize text animation
    .while(ecx <= Newlen)
        invoke Copytxt,addr Charbuff,addr sZpressGenerate,ecx
        invoke Copytxt,ADDR Charbuff[ecx],ADDR sZpressGenerate[ecx],ecx
        mov Charbuff[ecx*2],0      
        inc ecx
        push ecx
        invoke SetDlgItemText,hWnd,IDC_SERIAL,addr Charbuff
        invoke Sleep,14 ;<-- typewriting speed
        pop ecx
    .endw
    invoke ExitThread,NULL    
TypewritingAnim endp

Copytxt proc uses ecx esi edi aDest:DWORD,aSrc:DWORD,aLen:DWORD
    mov ecx,aLen
    mov esi,aSrc
    mov edi,aDest
    rep movsb
    ret
Copytxt endp

music proc
    .if status == 1
        mov status,0
        ; Load from resources
        invoke FindResource, hInstance, IDM_MSX, RT_RCDATA
           .if eax
                mov hRes, eax
                invoke SizeofResource,hInstance,eax
                mov lenRes, eax
                invoke LoadResource,hInstance,hRes
                   .if eax
                       invoke LockResource,eax
                          .if eax
                               invoke AHX_LoadBuffer,eax,lenRes
                          .endif
                   .endif
           .endif
           .if eax
                invoke AHX_Play
           .endif
        ;stop
    .else
        invoke AHX_Stop
        
        ;play
        mov status,1
    .endif
    ret
music endp

end start 
