; Xyl2k!
.486
.model	flat, stdcall
option	casemap :none   ; case sensitive

; API functions
; ------------------------------------------------------------------------------
include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
include mfmplayer\mfmplayer.inc   ;Musique
include		\masm32\macros\macros.asm

includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
includelib mfmplayer\mfmplayer.lib   ;Musique
; ------------------------------------------------------------------------------

; Functions
; ------------------------------------------------------------------------------
DlgProc			PROTO :DWORD,:DWORD,:DWORD,:DWORD

IDC_OK 			equ	1003
IDC_IDCANCEL 	equ	1004
IDM_MUSIK		=	500
; ------------------------------------------------------------------------------
.data?
hInstance		dd		?	;dd can be written as dword
nMusicSize		DWORD	?
pMusic			LPVOID	?

.data
status 		   dd ?

.code
start:
	invoke	GetModuleHandle, NULL
	mov	hInstance, eax
	invoke	DialogBoxParam, hInstance, 101, 0, ADDR DlgProc, 0
	invoke	ExitProcess, eax
; -----------------------------------------------------------------------
DlgProc	proc	hWin	:DWORD,
		uMsg	:DWORD,
		wParam	:DWORD,
		lParam	:DWORD
	.if	uMsg == WM_INITDIALOG
    mov status,1 
	.elseif	uMsg == WM_COMMAND
		.if wParam == IDC_OK
			.if status == 1
				mov status,0
				push esi
				invoke FindResource, hInstance, IDM_MUSIK, RT_RCDATA
				push eax
				invoke SizeofResource, hInstance, eax
				mov nMusicSize, eax
				pop eax
				invoke LoadResource, hInstance, eax
				invoke LockResource, eax
				mov esi, eax
				mov eax, nMusicSize
				add eax, SIZEOF nMusicSize
				invoke GlobalAlloc, GPTR, eax
				mov pMusic, eax
				mov ecx, nMusicSize
				mov dword ptr [eax], ecx
				add eax, SIZEOF nMusicSize
				mov edi, eax
				rep movsb
				pop esi
				invoke mfmPlay, pMusic
				invoke SetDlgItemText,hWin,IDC_OK,chr$("Stop")
			.else
				invoke mfmPlay, 0			;Stop music
				invoke GlobalFree, pMusic
				invoke SetDlgItemText,hWin,IDC_OK,chr$("Play")
				mov status,1

		.endif
        .elseif	wParam == IDC_IDCANCEL
		invoke	SendMessage, hWin, WM_CLOSE, 0, 0
		.endif
	.elseif	uMsg == WM_CLOSE
		invoke EndDialog,hWin,0
	.endif

	xor	eax,eax
	ret
DlgProc	endp
end start