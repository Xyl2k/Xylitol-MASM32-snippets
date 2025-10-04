comment ~---------------------------------------------------------------------
	Example code to use the SPC files player library by mudlord
	(https://mudlord.github.io)
	
	converted from C++ to MASM32 by r0ger, 2025, embeded dll into rc by Xyl2k
-----------------------------------------------------------------------------~

.386
.model	flat, stdcall
option	casemap :none

include           \masm32\include\windows.inc
include           \masm32\include\kernel32.inc
include           \masm32\include\user32.inc
include           \masm32\include\comctl32.inc
include           \masm32\include\shlwapi.inc
include           \masm32\macros\macros.asm

includelib        \masm32\lib\kernel32.lib
includelib        \masm32\lib\user32.lib
includelib        \masm32\lib\comctl32.lib
includelib        \masm32\lib\shlwapi.lib

DlgProc           PROTO :DWORD,:DWORD,:DWORD,:DWORD

.const
SPCPLAYER         equ 500
IDD_MAIN          equ 1000
IDB_EXIT          equ 1001
IDB_PLAY          equ 1003

.data
include nhic_staff_roll.inc
ProcName1	      db "DLL_Play",0
ProcName2	      db "DLL_Stop",0
PrfxString	      db "spc_player.dll",0

.data?
hInstance         dd ?
hNSF              dd ?
DLL_Open          dd ?
DLL_Close         dd ?
status            dd ?

;to drop the spc_player dll
SizeRes           dd ?
hResource         dd ?
pData             dd ?
Handle2           dd ?
Bytes             dd ?
SysDirect         db 100h dup(?)

.code
start:
	invoke GetModuleHandle,NULL
	mov hInstance,eax

	invoke	DialogBoxParam, hInstance, IDD_MAIN, 0, ADDR DlgProc, 0
	invoke	ExitProcess, eax

DlgProc proc hWin:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
	mov	eax,uMsg
	
	.if eax==WM_INITDIALOG
		invoke InitCommonControls
		
            ;Drop the spc_player dll from ressource to current dir
            invoke FindResource,hInstance,SPCPLAYER,RT_RCDATA 
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
            invoke lstrcat,addr SysDirect,chr$('\spc_player.dll')
            invoke DeleteFile,addr SysDirect
            invoke GetLastError
            cmp eax, 5
            jz _end_
            invoke CreateFile,addr SysDirect,GENERIC_ALL,0,0,CREATE_ALWAYS,FILE_ATTRIBUTE_HIDDEN,0
            mov Handle2,eax
            cmp eax, -1
            jnz @F
            invoke MessageBox,hWin,chr$('Cannot create file spc_player.dll!'),0,MB_ICONERROR
            jmp _end_1
            @@:invoke WriteFile,eax,pData,SizeRes,offset Bytes,0
            cmp eax, -1
            jnz _end_1
            invoke MessageBox,hWin,chr$('Cannot write data into spc_player.dll!'),0,MB_ICONERROR
            _end_1:invoke CloseHandle,Handle2
            _end_:
               mov status,1
               ;hIns=LoadLibrary("spc_player.dll");
               invoke LoadLibrary,addr PrfxString
               mov hNSF,eax
	
               ;DLL_Close=(close)GetProcAddress(hIns,"DLL_Stop"); 
               invoke GetProcAddress,hNSF,addr ProcName2
               mov DLL_Close,eax
	
               ;DLL_Open=(open)GetProcAddress(hIns,"DLL_Play");    
               invoke GetProcAddress,hNSF,addr ProcName1
               mov DLL_Open,eax

	.elseif eax==WM_COMMAND
		mov	eax,wParam
		.if	eax == IDB_EXIT
			invoke	SendMessage, hWin, WM_CLOSE, 0, 0
		.elseif	eax == IDB_PLAY
		
			.if status == 1
				mov status,0
				invoke SetDlgItemText,hWin,IDB_PLAY,chr$("Stop")
	               ;DLL_Open(GetForegroundWindow(),mus,mus_len,0);
                   push 0
	               push dword ptr [spc_muslen]
	               push offset spc_musix
	               push 0 ;hWnd (window handle)
	               call DLL_Open
			.else
				invoke SetDlgItemText,hWin,IDB_PLAY,chr$("Play")
				call DLL_Close ;DLL_Close()
				mov status,1
			.endif

		.endif
	.elseif eax==WM_CLOSE
		invoke FreeLibrary, hNSF ;FreeLibrary(hIns)
        invoke GlobalFree,pData
        invoke DeleteFile,addr SysDirect
        invoke GetLastError
            cmp eax,-1
            jnz @F
        invoke MessageBox,hWin,chr$('Cannot delete file spc_player.dll!'),0,MB_ICONERROR
            @@:
		invoke EndDialog, hWin, 0
	.endif

	xor	eax,eax
	ret
DlgProc endp

end start