.386
.model flat, stdcall
option casemap :none

	include			windows.inc
	include			kernel32.inc
	includelib		kernel32.lib
	include			user32.inc
	includelib		user32.lib
	include			winmm.inc
	includelib		winmm.lib
	include			msvcrt.inc
	includelib		msvcrt.lib
	include			bassmod.inc
	includelib		bassmod.lib

	DlgProc			PROTO	:HWND,:UINT,:WPARAM,:LPARAM

.const
	IDD_MAIN		equ		1000
	IDC_OK 			equ		1002
	IDC_IDCANCEL 	equ		1004

.data
	include			Chiptune.inc

.data?
	hInstance		dd		?

.code
start:
	invoke GetModuleHandle,NULL
	mov	hInstance,eax
	invoke DialogBoxParam,hInstance,IDD_MAIN,NULL,addr DlgProc,NULL
	invoke ExitProcess,0

DlgProc proc hWnd:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM

	.if uMsg==WM_INITDIALOG

	.elseif	uMsg == WM_COMMAND
		.if	wParam == IDC_OK
; -----------------------------------------------------------------------
			invoke BASSMOD_DllMain, hInstance,DLL_PROCESS_ATTACH,NULL
			invoke BASSMOD_Init, -1, 44100, 0
			invoke BASSMOD_MusicLoad, TRUE, addr Chiptune, 0, 0, BASS_MUSIC_LOOP OR BASS_MUSIC_POSRESET OR BASS_MUSIC_RAMPS
			invoke BASSMOD_MusicPlay
; -----------------------------------------------------------------------
        .elseif	wParam == IDC_IDCANCEL
			invoke BASSMOD_Free
			invoke BASSMOD_DllMain, hInstance, DLL_PROCESS_DETACH, NULL
		.endif

	.elseif uMsg==WM_CLOSE
		invoke EndDialog,hWnd,0
	.else
		mov eax,FALSE
		ret
	.endif
	mov eax,TRUE
	ret

DlgProc endp

end start