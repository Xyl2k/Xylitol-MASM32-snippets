.386
.model flat, stdcall
option casemap :none

include			\masm32\include\windows.inc
include			\masm32\include\kernel32.inc
includelib		\masm32\lib\kernel32.lib
include			\masm32\include\user32.inc
includelib		\masm32\lib\user32.lib
include			\masm32\include\winmm.inc
includelib		\masm32\lib\winmm.lib
include			\masm32\include\msvcrt.inc
includelib		\masm32\lib\msvcrt.lib
include			bassmod.inc
includelib		bassmod.lib
include			\masm32\macros\macros.asm

DlgProc			PROTO	:HWND,:UINT,:WPARAM,:LPARAM

.const
	IDD_MAIN		equ		1000
	IDC_OK1002 		equ		1002
	IDC_CANCEL1004 	equ		1004

.data
	include			Chiptune.inc

.data?
	hInstance		dd		?

.data
status 		   dd ?

.code
start:
	invoke GetModuleHandle,NULL
	mov	hInstance,eax
	invoke DialogBoxParam,hInstance,IDD_MAIN,NULL,addr DlgProc,NULL
	invoke ExitProcess,0

DlgProc proc hWnd:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM

	.if	uMsg == WM_INITDIALOG
    mov status,1 
	.elseif	uMsg == WM_COMMAND
		.if wParam == IDC_OK1002
			.if status == 1
				mov status,0
				invoke BASSMOD_DllMain, hInstance,DLL_PROCESS_ATTACH,NULL
				invoke BASSMOD_Init, -1, 44100, 0
				invoke BASSMOD_MusicLoad, TRUE, addr Chiptune, 0, 0, BASS_MUSIC_LOOP OR BASS_MUSIC_POSRESET OR BASS_MUSIC_RAMPS
				invoke BASSMOD_MusicPlay
				invoke SetDlgItemText,hWnd,IDC_OK1002,chr$("Stop")
			.else
				invoke BASSMOD_Free
				invoke BASSMOD_DllMain, hInstance, DLL_PROCESS_DETACH, NULL
				invoke SetDlgItemText,hWnd,IDC_OK1002,chr$("Play")
				mov status,1
		.endif
        .elseif	wParam == IDC_CANCEL1004

		invoke	SendMessage,hWnd, WM_CLOSE, 0, 0
		.endif
	.elseif	uMsg == WM_CLOSE
		invoke EndDialog,hWnd,0
	.endif
	xor	eax,eax
	ret
DlgProc endp

end start