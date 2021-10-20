.486
.model flat, stdcall
option casemap :none ; case sensitive

include         \masm32\include\windows.inc
include         \masm32\include\kernel32.inc
include         \masm32\include\user32.inc

includelib      \masm32\lib\kernel32.lib
includelib      \masm32\lib\user32.lib
include         \masm32\macros\macros.asm

; SendMessageA example by Xyl
; Shoutout to /u/zid for the notepad concept. https://www.reddit.com/r/programming/comments/gnazif/ray_tracing_in_notepadexe_at_30_fps/fr8uy2l/
; FTP Rush for the doc. https://www.wftpserver.com/help/ftpclient/index.html?ftprushobject.htm

DlgProc            PROTO :DWORD,:DWORD,:DWORD,:DWORD

IDB_LOGiN          equ 1003
IDB_DOWNLOAD_LOCAL equ 1004
IDB_DOWNLOAD_FXP   equ 1005
IDB_RAW_COMMAND    equ 1006
IDB_NOTEPAD        equ 1007
IDB_NOTEPADTITLE   equ 1008
IDB_QUiT           equ 1009
IDC_GROUPBOX1010   equ 1010
IDC_GROUPBOX1011   equ 1011

.data
; Apps detail
szFTPrushClass     db "TfmRush",0
szNotepadTitle_FRA db "Sans titre - Bloc-notes",0 ; for US version, replace by: Untitled - Notepad

; Dialog details
szTitle            db "SendMessageA example",0
szIDB_LOGiN        db "Login FTP1",0
szIDB_DiSCONECT    db "Disconect FTP1",0
szIDB_DL_LOCAL     db "FTP1 -> Local",0
szIDB_DL_FXP       db "FTP1 -> FTP2",0
szIDB_RAW          db "site dayup",0
szIDB_NotePadEdit  db "Send text inside notepad",0
szIDB_NotePadtitle db "Change windows title",0
szIDB_QUiT         db "Quit",0
szIDC_GroupBoxrush db "FTP Rush v2.2.0",0
szIDC_GroupBoxpad  db "Notepad (french version)",0

;notepad details
szWriteTextInPad   db "Hello World ",13,10,0
szNewTitleNotepad  db "New title!",0

;Rush details
szLogin            db "RushApp.FTP.Login('FTP1','',0);",0
szDisconect        db "RushApp.FTP.Logout('FTP1', 0);",0

szRawCommand       db "RushApp.FTP.RAW('FTP1','site dayup',RS_LOGIN);",0

szDownloadFXP      db "RushApp.FTP.Transfer(0,'FTP1','/GAMES/Inscryption-Razor1911/'"
                   db ",'','FTP2','/GAMES/Inscryption-Razor1911/',''"
                   db ",RS_DIRDES or RS_DIRSRC or RS_APPEND, '','','','',"
                   db "'([^\w]*100%[^\w]*)|([^\w]*-\sCOMPLETE\s\)[^\w]*)|([^\w]*-\sCOMPLETE\s-[^\w]*)'"
                   db ",4,0,0,RS_SORTSIZE or RS_SORTDES,0,2,0);",0

szDownloadLocal    db "RushApp.FTP.Transfer(0,'FTP1','/GAMES/Ace.Combat.7.Skies.Unknown.Deluxe.Edition-CODEX/'"
                   db ",'','','M:\GAMES\Ace.Combat.7.Skies.Unknown.Deluxe.Edition-CODEX\',''"
                   db ",RS_DOWN or RS_DIRDES or RS_DIRSRC or RS_APPEND, '','','','',"
                   db "'([^\w]*100%[^\w]*)|([^\w]*-\sCOMPLETE\s\)[^\w]*)|([^\w]*-\sCOMPLETE\s-[^\w]*)'"
                   db ",4,0,0,RS_SORTSIZE or RS_SORTDES,0,2,0);",0

.data?
hInstance          dd ? ; dd can be written as dword
hWndRush           dd ? ; Window handle of ftprush
hWndPad            dd ? ; Window handle of notepad
hWndEdit           dd ? ; Handle of edit control
status             dd ? ; Login/Logout status
msg                COPYDATASTRUCT <>

.code
start:
    invoke GetModuleHandle,NULL
    mov hInstance,eax
    invoke DialogBoxParam,hInstance,101,0,ADDR DlgProc,0
    invoke ExitProcess,eax

DlgProc	proc hWin   :DWORD,
             uMsg   :DWORD,
             wParam :DWORD,
             lParam :DWORD
    .if uMsg == WM_INITDIALOG
    ; Set the dialog controls texts. Done here in the code instead of resource
    ; file to reduce the required bytes (strings in the rc file are UNICODE not ANSI)
    invoke SetWindowText,hWin,ADDR szTitle ; Set the window title text
    invoke SetDlgItemText,hWin,IDB_LOGiN,ADDR szIDB_LOGiN
    invoke SetDlgItemText,hWin,IDB_DOWNLOAD_LOCAL,ADDR szIDB_DL_LOCAL
    invoke SetDlgItemText,hWin,IDB_DOWNLOAD_FXP,ADDR szIDB_DL_FXP
    invoke SetDlgItemText,hWin,IDB_RAW_COMMAND,ADDR szIDB_RAW
    invoke SetDlgItemText,hWin,IDB_NOTEPAD,ADDR szIDB_NotePadEdit
    invoke SetDlgItemText,hWin,IDB_NOTEPADTITLE,ADDR szIDB_NotePadtitle
    invoke SetDlgItemText,hWin,IDB_QUiT,ADDR szIDB_QUiT
    invoke SetDlgItemText,hWin,IDC_GROUPBOX1010,ADDR szIDC_GroupBoxrush
    invoke SetDlgItemText,hWin,IDC_GROUPBOX1011,ADDR szIDC_GroupBoxpad
    mov status,0
    .elseif uMsg == WM_COMMAND
        .if wParam == IDB_LOGiN
                ; Find ftprush
                invoke FindWindow, addr szFTPrushClass,NULL
                  .if eax
                  mov hWndRush, eax
                      .if status == 1
                          mov status,0
                          invoke SetDlgItemText,hWin,IDB_LOGiN,addr szIDB_LOGiN
                          invoke lstrlen,addr szDisconect
                          add eax,1
                          mov msg.dwData,03E8h
                          mov msg.cbData,eax
                          mov msg.lpData,offset szDisconect
                          invoke SendMessage,hWndRush,WM_COPYDATA,NULL,addr msg
                      .else
                          invoke SetDlgItemText,hWin,IDB_LOGiN,addr szIDB_DiSCONECT
                          invoke lstrlen,addr szLogin
                          add eax,1
                          mov msg.dwData,03E8h
                          mov msg.cbData,eax
                          mov msg.lpData,offset szLogin
                          invoke SendMessage,hWndRush,WM_COPYDATA,NULL,addr msg
                          mov status,1
                      .endif
                  .endif
        .elseif	wParam == IDB_DOWNLOAD_LOCAL
                invoke FindWindow, addr szFTPrushClass,NULL
                  .if eax
                      mov hWndRush, eax
                      invoke lstrlen,addr szDownloadLocal
                      add eax,1
                      mov msg.dwData,03E8h
                      mov msg.cbData,eax
                      mov msg.lpData,offset szDownloadLocal
                      invoke SendMessage,hWndRush,WM_COPYDATA,NULL,addr msg
                  .endif

        .elseif	wParam == IDB_DOWNLOAD_FXP
                invoke FindWindow, addr szFTPrushClass,NULL
                  .if eax
                      mov hWndRush, eax
                      invoke lstrlen,addr szDownloadFXP
                      add eax,1      
                      mov msg.dwData,03E8h
                      mov msg.cbData,eax
                      mov msg.lpData,offset szDownloadFXP
                      invoke SendMessage,hWndRush,WM_COPYDATA,NULL,addr msg
                  .endif
        .elseif	wParam == IDB_RAW_COMMAND
                invoke FindWindow, addr szFTPrushClass,NULL
                  .if eax
                      mov hWndRush, eax
                      invoke lstrlen,addr szRawCommand
                      add eax,1         
                      mov msg.dwData,03E8h
                      mov msg.cbData,eax
                      mov msg.lpData,offset szRawCommand	
                      invoke SendMessage,hWndRush,WM_COPYDATA,NULL,addr msg
                  .endif
        .elseif	wParam == IDB_NOTEPAD
                invoke FindWindow,NULL,addr szNotepadTitle_FRA
                  .if eax
                      mov hWndPad, eax
                      invoke FindWindowEx,hWndPad,NULL,chr$('EDIT'),NULL
                      mov hWndEdit, eax
                      invoke SendMessage,hWndEdit,EM_REPLACESEL,TRUE,addr szWriteTextInPad
                  .endif
        .elseif	wParam == IDB_NOTEPADTITLE
                invoke FindWindow,NULL,addr szNotepadTitle_FRA
                  .if eax
                      mov hWndPad, eax
                      invoke SendMessage,hWndPad,WM_SETTEXT,NULL,addr szNewTitleNotepad
                      invoke GetDlgItem,hWin,IDB_NOTEPAD ; szNotepadTitle_FRA can't be found anymore!
                      invoke EnableWindow, eax, FALSE
                  .endif
        .elseif	wParam == IDB_QUiT
                invoke EndDialog,hWin,0
        .endif
    .elseif uMsg ==WM_CLOSE
        invoke EndDialog,hWin,0
    .endif
    xor eax,eax
    ret
DlgProc endp

end start