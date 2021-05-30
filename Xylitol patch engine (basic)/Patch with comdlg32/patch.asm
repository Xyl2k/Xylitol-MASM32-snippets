.486
.model	flat, stdcall
option	casemap :none

include      \masm32\include\windows.inc 
include      \masm32\include\user32.inc 
include      \masm32\include\kernel32.inc
include      \masm32\include\masm32.inc
include      \masm32\include\comdlg32.inc
include      \masm32\macros\macros.asm

includelib   \masm32\lib\user32.lib 
includelib   \masm32\lib\kernel32.lib
includelib   \masm32\lib\masm32.lib
includelib   \masm32\lib\comdlg32.lib 

include crc32.inc

DlgProc             PROTO :DWORD,:DWORD,:DWORD,:DWORD
List                PROTO :DWORD,:DWORD
Patch               PROTO :DWORD

patch MACRO offsetAdr,_bytes,_byteSize
 invoke SetFilePointer,hTarget,offsetAdr,NULL,FILE_BEGIN
   .if eax==0FFFFFFFFh
     invoke CloseHandle,hTarget
     invoke List,hWin,addr szFileBusy
     ret
   .endif
 invoke WriteFile,hTarget,addr _bytes,_byteSize,addr BytesWritten,FALSE
ENDM

.const
IDC_LISTBOX         equ     1002
IDB_APPLY           equ     1003
IDB_ABOUT           equ     1004
IDB_EXIT            equ     1005
IDC_CHECKBOX        equ     1006
MAXSIZE             equ     261

.data
; App details
szTargetName db "My_Crackme.exe",0
BackupExt    db ".backup",0
TargetCRC32  dd 07AF169FCh ; CRC32 of My_Crackme.exe
TargetSize   dd 2560 ; File size of My_Crackme.exe

; Patches (Bytes and RAW offsets)
PatchOpcode1 db  0EBh ; JMP SHORT 00401025
PatchOffset1 dd  00000407h ; 00401007

PatchOpcode2 db  04Fh,010h ; PUSH 0040104F
PatchOffset2 dd  00000428h ; 00401027

PatchOpcode3 db  052h,065h,067h,069h,073h,074h,065h,072h,065h,064h,020h,074h,06Fh,03Ah,020h,058h,079h,06Ch ; ASCII: Registered to: Xyl
PatchOffset3 dd  0000044Fh ; 0040104F

; Open file dialog stuff
szOpenTitle  db "cHOOSE TARGET FiLE",0
FiltFormat   db "%s%c%s%c%c",0
FiltString   db MAXSIZE dup(0)
FileName     db MAXSIZE dup(0)
ofn          OPENFILENAME <>

; Patch texts
szTitle      db "Arecibo easy crackme 1 *Patch*",0
sziNFO1      db "[1] Click pATCH, select target and Apply.",0
sziNFO2      db "[2] N-j0y full version ;)",0
sziNFO3      db "[$] If u like this software, BUY IT!!",0
szAbout      db "pATCH by Xyl! 2021!",0
szIDBPatch   db "pATCH",0
szIDBExit    db "eXIT",0
szIDBAbt     db "aBOUT",0
szIDBBck     db "bCK",0
szNotFound   db "My_Crackme.exe not found",0
szWrongSize  db "Wrong file size",0
szSizeOK     db "File size: OK!",0
szOKCRC32    db "CRC32: OK!",0
szBadCRC32   db "Wrong CRC32!",0
szFileBusy   db "File is busy",0
szBckOK      db "Backup: OK!",0
szNoBck      db "No backup!",0
szSucess     db "PATCHED, NJOY!",0

.data?
hInstance    dd  ? ;dd can be written as dword
hTarget      HINSTANCE ?
BackupName   db ?

.code
start:
	invoke GetModuleHandle, NULL
	mov hInstance, eax
	invoke DialogBoxParam, hInstance, 101, 0, ADDR DlgProc, 0
	invoke ExitProcess, eax

DlgProc	proc hWin:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
    LOCAL hFile:HFILE
    LOCAL BytesWritten:DWORD
    LOCAL hFind:HANDLE
    LOCAL ff32:WIN32_FIND_DATA
    LOCAL buffer[512]:byte
    LOCAL off_set:DWORD
    LOCAL pFileMem:DWORD  
    
    .if uMsg==WM_INITDIALOG
        ; Set the dialog controls texts. Done here in the code instead of resource
        ; file to reduce the required bytes (strings in the rc file are UNICODE not ANSI)
        invoke SetWindowText,hWin,ADDR szTitle ; Set the window title text
        invoke SetDlgItemText,hWin,IDB_APPLY,ADDR szIDBPatch
        invoke SetDlgItemText,hWin,IDB_EXIT,ADDR szIDBExit
        invoke SetDlgItemText,hWin,IDB_ABOUT,ADDR szIDBAbt
        invoke SetDlgItemText,hWin,IDC_CHECKBOX,ADDR szIDBBck
        invoke SendDlgItemMessage, hWin, IDC_CHECKBOX, BM_SETCHECK, 1, 0
        invoke List,hWin,addr sziNFO1
        invoke List,hWin,addr sziNFO2
        invoke List,hWin,addr sziNFO3
        ; Init CRC32 table
        call InitCRC32Table
        ; Setup the filter string for the open file dialog
        invoke wsprintf,ADDR FiltString,ADDR FiltFormat,ADDR szTargetName,0,ADDR szTargetName,0,0
    .elseif	uMsg==WM_COMMAND
        mov eax,wParam
        .if eax==IDB_APPLY
            ; File has not yet been selected
            .if dword ptr [FileName] == 0
                    mov ofn.lStructSize,SIZEOF ofn 
                    mov eax,hWin 
                    mov ofn.hwndOwner,eax
                    mov ofn.lpstrFilter, OFFSET FiltString
                    mov ofn.lpstrFile, OFFSET FileName
                    mov ofn.nMaxFile,MAXSIZE-1
                    mov ofn.Flags, OFN_FILEMUSTEXIST or OFN_NONETWORKBUTTON or \ 
                        OFN_PATHMUSTEXIST or OFN_LONGNAMES or \ 
                        OFN_EXPLORER or OFN_HIDEREADONLY
                    mov ofn.lpstrTitle, OFFSET szOpenTitle
                    invoke GetOpenFileName, ADDR ofn
            .endif
            invoke FindFirstFile,ADDR FileName,ADDR ff32
            .if eax != INVALID_HANDLE_VALUE
                mov eax,TargetSize
            .if ff32.nFileSizeLow != eax
                ; File size is incorrect
                invoke List,hWin,addr szWrongSize
            .else
                ; Filesize is correct
                invoke List,hWin,addr szSizeOK
                mov pFileMem,InputFile(ADDR FileName) ; load the file into memory
                invoke CRC32,pFileMem,ff32.nFileSizeLow
                mov edx,TargetCRC32
            .if eax != edx
                ; File is wrong in some way
                invoke List,hWin,addr szBadCRC32
            .else
                invoke List,hWin,addr szOKCRC32
                invoke GetFileAttributes,addr FileName
                ; The file is read-only, so let's try to set it to read/write
            .if eax!=FILE_ATTRIBUTE_NORMAL
                invoke SetFileAttributes,addr szTargetName,FILE_ATTRIBUTE_NORMAL
            .endif
            ; Everything's okay, so let's patch the file, defind file access first, needed also for backuping the file.
            invoke CreateFile,addr FileName,GENERIC_READ+GENERIC_WRITE,FILE_SHARE_READ+FILE_SHARE_WRITE,\
                                            NULL,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,NULL
            .if eax!=INVALID_HANDLE_VALUE
                mov hTarget,eax
                ; Before patching check if user want a backup
                invoke SendDlgItemMessage,hWin,IDC_CHECKBOX,BM_GETCHECK,0,0
                   .if eax==BST_CHECKED
                         invoke lstrlenA,ADDR FileName
                         invoke RtlMoveMemory,ADDR BackupName,ADDR FileName,eax
                         invoke lstrcat,ADDR BackupName,ADDR BackupExt
                         invoke CopyFile, addr FileName, addr BackupName, TRUE
                         invoke List,hWin,addr szBckOK
                   .else
                         invoke List,hWin,addr szNoBck
                   .endif
                ; Start patches to the file
                patch PatchOffset1,PatchOpcode1,1
                patch PatchOffset2,PatchOpcode2,2
                patch PatchOffset3,PatchOpcode3,18
                invoke SetFileTime,hTarget,ADDR (ff32.ftLastWriteTime),\
                                           ADDR (ff32.ftLastWriteTime),\
                                           ADDR (ff32.ftLastWriteTime)
                invoke CloseHandle,hTarget
                invoke List,hWin,addr szSucess
                ; Disable the patch button
                invoke GetDlgItem,hWin,IDB_APPLY
                invoke EnableWindow, eax, FALSE             
                ; Free up the in-memory file used for CRC32 calc
                free pFileMem
                jmp @end
            .endif
                ;File seem to be open
                invoke List,hWin,addr szFileBusy
                jmp @end
            .endif
                ; Wrong CRC32 'if'
            .endif
                ; Wrong file size 'if'
            .endif
        .elseif eax==IDB_ABOUT 
            invoke List,hWin,addr szAbout
        .elseif eax==IDB_EXIT 
            invoke SendMessage,hWin,WM_CLOSE,0,0
        .endif		
    .elseif	uMsg == WM_CLOSE
        invoke	EndDialog,hWin,0
    .elseif uMsg==WM_DESTROY
        invoke PostQuitMessage,NULL
        .endif
        @end:
        xor	eax,eax
        ret
DlgProc	endp

List proc hWnd:HWND, pMsg:DWORD
	invoke SendDlgItemMessage,hWnd,IDC_LISTBOX,LB_ADDSTRING,0,pMsg 
	invoke SendDlgItemMessage,hWnd,IDC_LISTBOX,WM_VSCROLL,SB_BOTTOM,0
	Ret
List EndP

Patch proc hWnd:HWND
	local status:DWORD
Patch EndP

end start