.486
.model	flat, stdcall
option	casemap :none   ; case sensitive

include      \masm32\include\windows.inc
include      \masm32\include\user32.inc
include      \masm32\include\kernel32.inc
include      \masm32\include\masm32.inc
include      \masm32\macros\macros.asm

includelib   \masm32\lib\user32.lib
includelib   \masm32\lib\kernel32.lib
includelib   \masm32\lib\masm32.lib
include crc32.inc

DlgProc     PROTO :DWORD,:DWORD,:DWORD,:DWORD
Patch       PROTO :DWORD
List        PROTO :DWORD,:DWORD

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
IDC_LISTBOX  equ 1002
IDB_PATCH    equ 1003
IDB_CANCEL   equ 1004
IDC_CHECKBOX equ 1005

.data
; Patch texts
szTitle      db "Arecibo easy crackme 1 *Patch*",0
sziNFO       db "Place in same folder as target and click pATCH!",0
szIDBPatch   db "pATCH",0
szIDBExit    db "eXIT",0
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

; App details
TargetName   db "My_Crackme.exe",0
BackupName   db "My_Crackme.exe.backup",0
TargetCRC32  dd 07AF169FCh ; CRC32 of My_Crackme.exe
TargetSize   dd 2560 ; File size of My_Crackme.exe

; Patches (Bytes and RAW offsets)
PatchOpcode1 db  0EBh ; JMP SHORT 00401025
PatchOffset1 dd  00000407h ; 00401007

PatchOpcode2 db  04Fh,010h ; PUSH 0040104F
PatchOffset2 dd  00000428h ; 00401027

PatchOpcode3 db  052h,065h,067h,069h,073h,074h,065h,072h,065h,064h,020h,074h,06Fh,03Ah,020h,058h,079h,06Ch ; ASCII: Registered to: Xyl
PatchOffset3 dd  0000044Fh ; 0040104F

.data?
hInstance    dd  ? ;dd can be written as dword
hTarget      HINSTANCE ?
BytesWritten db  ?

.code
start:
	invoke	GetModuleHandle, NULL
	mov	hInstance, eax
	invoke	DialogBoxParam, hInstance, 101, 0, ADDR DlgProc, 0
    invoke ExitProcess,eax
DlgProc	proc hWin :DWORD,
       uMsg  :DWORD,
       wParam  :DWORD,
       lParam  :DWORD
LOCAL ff32:WIN32_FIND_DATA
LOCAL pFileMem:DWORD
.if uMsg == WM_INITDIALOG
    ; Set the dialog controls texts. Done here in the code instead of resource
    ; file to reduce the required bytes (strings in the rc file are UNICODE not ANSI)
    invoke SetWindowText,hWin,ADDR szTitle ; Set the window title text
    invoke SetDlgItemText,hWin,IDB_PATCH,ADDR szIDBPatch
    invoke SetDlgItemText,hWin,IDB_CANCEL,ADDR szIDBExit
    invoke SetDlgItemText,hWin,IDC_CHECKBOX,ADDR szIDBBck
    ; Display patch info in IDC_LISTBOX
    invoke List,hWin,addr sziNFO
    ; Init CRC32 table
   	call InitCRC32Table
   	; Check IDC_CHECKBOX for file backup
   	invoke SendDlgItemMessage,hWin,IDC_CHECKBOX,BM_SETCHECK,1,0
.elseif	uMsg == WM_COMMAND
    ; Crack button
.if wParam == IDB_PATCH
        invoke FindFirstFile,ADDR TargetName,ADDR ff32
        ; File to patch is not in same dir
        .if eax == INVALID_HANDLE_VALUE
           invoke List,hWin,addr szNotFound
        .else
        mov eax,TargetSize
            ; File size is incorrect
            .if ff32.nFileSizeLow != eax
                invoke List,hWin,addr szWrongSize
            ; Filesize is correct
            .else
            invoke List,hWin,addr szSizeOK
            mov pFileMem,InputFile(ADDR TargetName)
            invoke CRC32,pFileMem,ff32.nFileSizeLow
            mov edx,TargetCRC32
            ; Calculated CRC32 does not match
            .if eax != edx
               invoke List,hWin,addr szBadCRC32
            .else
            invoke List,hWin,addr szOKCRC32
            invoke GetFileAttributes,addr TargetName
            ; The file is read-only, so let's try to set it to read/write
                .if eax!=FILE_ATTRIBUTE_NORMAL
                    invoke SetFileAttributes,addr TargetName,FILE_ATTRIBUTE_NORMAL
                .endif
              ; Everything's okay, so let's patch the file
              invoke CreateFile,addr TargetName,GENERIC_READ+GENERIC_WRITE,FILE_SHARE_READ+FILE_SHARE_WRITE,\
                                                NULL,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,NULL
             .if eax!=INVALID_HANDLE_VALUE
                    mov hTarget,eax
            ;Before patching check if backup
        invoke SendDlgItemMessage,hWin,IDC_CHECKBOX,BM_GETCHECK,0,0
        .if eax==BST_CHECKED
            invoke CopyFile, addr TargetName, addr BackupName, TRUE
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
        invoke GetDlgItem,hWin,IDB_PATCH
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
.elseif	wParam == IDB_CANCEL
            ; Exit button, so send a close message
            invoke EndDialog,hWin,0
        .endif
.elseif	uMsg == WM_CLOSE
        invoke EndDialog,hWin,0
    .endif
    @end:
    xor	eax,eax
    ret
DlgProc	endp
        
List proc hWin:HWND, pMsg:DWORD
	invoke SendDlgItemMessage,hWin,IDC_LISTBOX,LB_ADDSTRING,0,pMsg 
	invoke SendDlgItemMessage,hWin,IDC_LISTBOX,WM_VSCROLL,SB_BOTTOM,0
	Ret
List EndP

Patch proc hWnd:HWND
	local status:DWORD
Patch EndP

end start