.486
.model	flat, stdcall
option	casemap :none

include			windows.inc
include			user32.inc
include			kernel32.inc
include			shell32.inc
include			advapi32.inc
include			gdi32.inc
include			comctl32.inc
include			comdlg32.inc
include			masm32.inc
include			C:\masm32\macros\macros.asm
includelib			user32.lib
includelib			kernel32.lib
includelib			shell32.lib
includelib			advapi32.lib
includelib			gdi32.lib
includelib			comctl32.lib
includelib			comdlg32.lib
includelib			masm32.lib
includelib 		winmm.lib

include		WaveObject.asm

include			ufmod.inc
includelib			ufmod.lib

DlgProc				PROTO :DWORD,:DWORD,:DWORD,:DWORD
Aboutproc				PROTO :DWORD,:DWORD,:DWORD,:DWORD
Patch				PROTO :DWORD
List					PROTO :DWORD,:DWORD
MakeDialogTransparent	PROTO :DWORD,:DWORD
FadeIn 				PROTO :DWORD
FadeOut 				PROTO :DWORD

.data 
;About Settings:--------------------------------------------------------\
String   	db 'RED CReW',0Ah
		db 'Proudly presents',0Ah
		db 0Ah		
		db 'SomeApp v1.0 *Patch*',0Ah
		db 0Ah
		db 'GFX: [x]sp!d3r',0Ah
		db 'SFX: Carter/Outbreak - Dead Feelings',0Ah
		db '----------------------------',0Ah
		db 'Greetz',0Ah
		db 0Ah
		db 'BytePlayeR',0Ah
		db 'xsp!d3r',0Ah
		db 'Encrypto',0Ah
		db 'Hyperlisk',0Ah
		db 'Hack_ThE_PaRaDiSe',0Ah
		db 'MiSSiNG iN ByTES',0Ah
		db 'DonGkeY',0Ah
		db 'KKR_WE_RULE',0Ah
		db 'qpt^J',0Ah
		db 'Rizero',0Ah
		db 'blackpirate',0Ah
		db 0Ah
		db 'LnDL - lz0 - SnD - TSRh - FFF',0Ah
		db 0Ah
		db 0Ah
		db 'and all who keeps the scene alive!',0Ah
		db 0Ah
		db 0Ah
		db 0Ah
		db 0Ah
		db 'http://redcrew.astalavista.ms',0Ah
		db 0Ah	
		db 'N-j0y !',0Ah
		db 0Ah,0
aTahoma	db 'Lucida Console',0

hFont			dd 0
dword_40E510	dd 0
number			dd 0 
dword_40CCA0	dd 0
dword_40CCA4	dd 0
dword_40CCB8	dd 0
dword_40CD24	dd 0
				dd 1F2h	dup(0)
dword_40DCC4	dd 0
				dd 1F3h	dup(0)
dword_40D4F0	dd 0
dword_40D4F4	dd 0
				dd 1F3h	dup(0)
									
;================================================================================
TargetName	db		"crackme.exe",0
BackupName	db		"crackme.exe.RED",0
Sequence	db		01h,00h
WBuffer		db		00h,00h
PatchOffset	dd		01296h
StartNfo		db		"Place in same folder as target and click APPLY",0
Backup		db		"Backup made",0
Success		db		"Target patched successfully",0
Already		db		"Target already patched!",0
OpenError	db		"Unable to open target file: crackme.exe",0
ReadError	db		"Error reading from target file",0
WriteError		db		"Error writing to target file",0
Version		db		"Incorrect target file version",0
szTitle		db		'Error',0
szError		db		'An error has occured',0
include chiptune.inc
xmSize equ $ - table

.data?
hInstance  				dd ?
xWin 					dd ?
hBitmap 					dd ?
bitmp					dd ?
stWaveObj   WAVE_OBJECT	 <?>

hTarget	HINSTANCE	?
RBuffer		dd		?
BytesRead	db		?
BytesWritten	db		?
Transparency	dd		?
handle		dd		?
serBuffer		db 		512 dup(?)
	
hBrushBack	 HWND ?

ScrollMainDC	HDC	?
ScrollBackDC	HDC	?
Tick	        dd	?
ScrollBitmap	HBITMAP	?
dword_40CD18	dd	?
Rect		RECT	<>
Paint	PAINTSTRUCT	<>

dword_40E498	dd	?
TextLen	      		dd	?
dword_40E508	dd	?
dword_40E50C	dd	?
GoDown	  		db	?
dword_40E504	dd	?

.const
IDC_LISTBOX			equ		1002
IDC_APPLY			equ		1003
IDC_ABOUT			equ		1004
IDC_EXIT				equ		1005
IDC_CHECKBOX		equ		1006
icon					equ		1000
TRANSPARENT_VALUE	equ 		200							;Opacity Value ( max value is 254 )
DELAY_VALUE			equ		10

.code
start:
	invoke	GetModuleHandle, NULL
	mov	hInstance, eax
	invoke	DialogBoxParam, hInstance, 101, 0, ADDR DlgProc, 0
	invoke	ExitProcess, eax

DlgProc	proc hWin:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
		local	@stPs:PAINTSTRUCT,@hDc,@stRect:RECT
		local	@stBmp:BITMAP
   LOCAL hMemDC:HDC
	.if uMsg==WM_INITDIALOG
	invoke SendDlgItemMessage, hWin, IDC_CHECKBOX, BM_SETCHECK, 1, 0
	invoke LoadIcon,hInstance,icon
	invoke SendMessage,hWin,WM_SETICON,1,eax
		invoke uFMOD_PlaySong,addr table,xmSize,XM_MEMORY
		invoke List,hWin,addr StartNfo

invoke LoadBitmap,hInstance,1
		mov hBitmap,eax
		invoke	GetDlgItem,hWin,1008
		push    hBitmap
		invoke  _WaveInit,addr stWaveObj,eax,hBitmap,30,0
		.if eax
			invoke  MessageBox,hWin,addr szError,addr szTitle,MB_OK or MB_ICONSTOP
			call    _Quit
		.else
		.endif
		pop hBitmap
		invoke  DeleteObject,hBitmap
		invoke  _WaveEffect,addr stWaveObj,4,5,4,250
		
			invoke MakeDialogTransparent,hWin,TRANSPARENT_VALUE
			
    .elseif uMsg == WM_PAINT
      invoke BeginPaint,hWin,addr @stPs
      mov @hDc,eax
      invoke CreateCompatibleDC,@hDc
      mov hMemDC,eax
      invoke SelectObject,hMemDC,hBitmap
      invoke GetClientRect,hWin,addr @stRect
      invoke BitBlt,@hDc,10,10,@stRect.right,@stRect.bottom,hMemDC,0,0,MERGECOPY
      invoke DeleteDC,hMemDC
      invoke _WaveUpdateFrame,addr stWaveObj,eax,TRUE
      invoke EndPaint,hWin,addr @stPs
            xor eax,eax
            ret
	.elseif	uMsg==WM_COMMAND
		mov	eax,wParam
		.if eax==IDC_APPLY
			invoke Patch,hWin
		.elseif eax==IDC_ABOUT 
			invoke DialogBoxParam, hInstance, 102, hWin, addr Aboutproc, NULL 
		.elseif eax==IDC_EXIT 
			invoke SendMessage,hWin,WM_CLOSE,0,0
		.endif		
	.elseif	uMsg ==	WM_LBUTTONDOWN
			mov	eax,lParam
			movzx	ecx,ax		; x
			shr	eax,16		; y
			invoke	_WaveDropStone,addr stWaveObj,ecx,eax,2,256
	.elseif uMsg== WM_MOUSEMOVE
			mov	eax,lParam
			movzx	ecx,ax		; x
			shr	eax,16		; y
			invoke	_WaveDropStone,addr stWaveObj,ecx,eax,2,256
	.elseif	uMsg == WM_CLOSE
		call	_Quit
		invoke	EndDialog,xWin,0
	.elseif uMsg==WM_DESTROY
      invoke DeleteObject,hBitmap
		invoke PostQuitMessage,NULL
		.endif
		xor	eax,eax
		ret
DlgProc	endp
_Quit proc
invoke	_WaveFree,addr stWaveObj
invoke	DestroyWindow,xWin
invoke	PostQuitMessage,NULL
ret
_Quit endp

List proc hWnd:HWND, pMsg:DWORD
	invoke SendDlgItemMessage,hWnd,IDC_LISTBOX,LB_ADDSTRING,0,pMsg 
	invoke SendDlgItemMessage,hWnd,IDC_LISTBOX,WM_VSCROLL,SB_BOTTOM,0
	Ret
List EndP

Patch proc hWnd:HWND
	invoke GetFileAttributes,addr TargetName
	.if eax!=FILE_ATTRIBUTE_NORMAL
		invoke SetFileAttributes,addr TargetName,FILE_ATTRIBUTE_NORMAL
	.endif
	invoke CreateFile,addr TargetName,\
					GENERIC_READ+GENERIC_WRITE,\
					FILE_SHARE_READ+FILE_SHARE_WRITE,\
					NULL,\
					OPEN_EXISTING,\
					FILE_ATTRIBUTE_NORMAL,\
					NULL
	.if eax!=INVALID_HANDLE_VALUE
		mov hTarget,eax
		invoke SendDlgItemMessage, hWnd, IDC_CHECKBOX, BM_GETCHECK, 0, 0
		.if eax==BST_CHECKED
			invoke CopyFile, addr TargetName, addr BackupName, TRUE
			invoke List,hWnd,addr Backup
		.endif
		invoke SetFilePointer,hTarget,PatchOffset,NULL,FILE_BEGIN
		invoke ReadFile,hTarget,addr RBuffer,4,addr BytesRead,NULL
		.if BytesRead==4
			mov eax,dword ptr [RBuffer]
			.if eax==dword ptr [Sequence]
				invoke SetFilePointer,hTarget,PatchOffset,NULL,FILE_BEGIN
				invoke WriteFile,hTarget,addr WBuffer,1,addr BytesWritten,NULL
				.if BytesWritten==1
					invoke List,hWnd,addr Success
				.else
					invoke List,hWnd,addr WriteError
				.endif
			.elseif eax==dword ptr [WBuffer]
				invoke List,hWnd,addr Already
			.else
				invoke List,hWnd,addr Version
			.endif
		.else
			invoke List,hWnd,addr ReadError
		.endif
	.else
		invoke List,hWnd,addr OpenError
	.endif
	invoke CloseHandle,hTarget
	Ret
Patch EndP

MakeDialogTransparent proc _handle:dword,_transvalue:dword
	
	pushad
	invoke GetModuleHandle,chr$("user32.dll")
	invoke GetProcAddress,eax,chr$("SetLayeredWindowAttributes")
	.if eax!=0
		invoke GetWindowLong,_handle,GWL_EXSTYLE	;get EXSTYLE
		
		.if _transvalue==255
			xor eax,WS_EX_LAYERED	;remove WS_EX_LAYERED
		.else
			or eax,WS_EX_LAYERED	;eax = oldstlye + new style(WS_EX_LAYERED)
		.endif
		
		invoke SetWindowLong,_handle,GWL_EXSTYLE,eax
		
		.if _transvalue<255
			invoke SetLayeredWindowAttributes,_handle,0,_transvalue,LWA_ALPHA
		.endif	
	.endif
	popad
	ret
MakeDialogTransparent endp

FadeOut	proc hWin:HWND
mov Transparency,250
@@:
invoke SetLayeredWindowAttributes,hWin,0,Transparency,LWA_ALPHA
invoke Sleep,DELAY_VALUE
sub Transparency,5
cmp Transparency,0
jne @b
ret
FadeOut EndP

FadeIn	proc hWin:HWND
invoke ShowWindow,hWin,SW_SHOW
mov Transparency,250
@@:
invoke SetLayeredWindowAttributes,hWin,0,Transparency,LWA_ALPHA
invoke Sleep,DELAY_VALUE
add Transparency,5
cmp Transparency,255
jne @b
ret
FadeIn EndP

Aboutproc proc hWin:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD

	mov	eax,uMsg
	push hWin
	pop handle
	.if	eax == WM_INITDIALOG
                     push esi
		call InitScroller
	.elseif eax==WM_RBUTTONUP
		invoke KillTimer,hWin,7Bh
		invoke KillTimer,hWin,141h
		invoke DeleteObject,ScrollMainDC
		invoke DeleteObject,ScrollBackDC
		invoke SendMessage,hWin,WM_CLOSE,0,0
	    invoke ShowWindow,hWin, SW_HIDE

	.elseif eax==WM_TIMER
		call	SetupScroll
		call	DrawStars
		call	ScrollMain
		call	UpdateScroll
	.elseif eax==WM_LBUTTONDOWN
		invoke SendMessage,hWin,WM_NCLBUTTONDOWN,HTCAPTION,0
		
	.elseif	eax == WM_CLOSE
	invoke	EndDialog, hWin, 0
	.endif
	xor	eax,eax
	ret
Aboutproc endp

align dword
_rand proc
	mov eax,Tick
	imul eax,eax,0A999h
	add eax,0269EC3h
	mov Tick,eax
	sar eax,010h
	and eax,0FFFFh
	Ret
_rand EndP
align dword
InitScroller Proc
	mov	edi, offset String
	or	ecx, 0FFFFFFFFh
	xor	eax, eax
	xor	edx, edx
	mov	esi, 1
	repne scasb
	not	ecx
	dec	ecx
	mov	TextLen, esi
	jz	short loc_401C7C

loc_401C58:
	cmp	byte ptr String[edx], 0Ah
	jnz	short loc_401C62
	inc	esi

loc_401C62:
	mov	edi, offset String
	or	ecx, 0FFFFFFFFh
	xor	eax, eax
	inc	edx
	repne scasb
	not	ecx
	dec	ecx
	cmp	edx, ecx
	jb	short loc_401C58
	mov	TextLen, esi

loc_401C7C:
	mov	dword_40E508, 0FFFFFFD8h
	mov	dword_40E50C, 0A0h
	mov	GoDown, 0
	mov	dword_40E504, 0
	
	call	FirstSetup
	xor	esi, esi

loc_401CA8:
	call	_rand
	cdq
	mov	ecx, 15Eh
	idiv	ecx
	mov	edi, edx
	call	_rand
	cdq
	mov	ecx, 0AFh
	idiv	ecx
	lea	edx, [edi+edx-15Eh]
	mov	dword_40CD24[esi*4], edx
	call	_rand
	cdq
	mov	ecx, 0A0h
	idiv	ecx
	mov	edi, edx
	call	_rand
	cdq
	mov	ecx, 50h
	idiv	ecx
	lea	eax, [esi+4Bh]
	mov	dword_40DCC4[esi*4], eax
	inc	esi
	cmp	esi, 1F4h
	lea	edx, [edi+edx-0A0h]
	mov	dword_40D4F0[esi*4], edx
	jl	short loc_401CA8
	
	invoke SetTimer,handle,123,5,0
	invoke SetTimer,handle,321,143000,0
InitScroller EndP
align dword
FirstSetup	proc
	invoke GetDC,handle
	mov ScrollMainDC,eax
	invoke GetWindowRect,handle,addr Rect
	invoke CreateCompatibleDC,ScrollMainDC
	mov ScrollBackDC,eax		
	invoke CreateCompatibleBitmap,ScrollMainDC,Rect.left,Rect.top
	mov	ScrollBitmap, eax
	invoke SelectObject,ScrollBackDC,ScrollBitmap
	invoke DeleteObject,ScrollBitmap
	invoke DeleteObject,addr Rect
	ret
	
FirstSetup	endp
align dword
DrawStars	proc	
		push ebx
		mov	ebx, SetPixelV
		push	 esi
		push	 edi
		xor	edi, edi

loc_40141B:
		mov	eax, dword_40CD24[edi*4]
		mov	esi, dword_40DCC4[edi*4]
		push 	0h		; COLORREF
		lea	eax, [eax+eax*2]
		lea	eax, [eax+eax*4]
		lea	eax, [eax+eax*4]
		shl	eax, 1
		cdq
		idiv	esi
		mov	ecx, eax
		mov	eax, dword_40D4F4[edi*4]
		imul	eax, 64h
		cdq
		idiv	esi
		add	ecx, 0AFh
		mov	dword_40CCA0, ecx
		add	eax, 50h
		mov	dword_40CCA4, eax
		push	eax		; int
		mov	eax, ScrollBackDC
		push	ecx		; int
		push	eax		; HDC
		call	ebx ; SetPixelV
		mov	eax, dword_40DCC4[edi*4]
		lea	ecx, [eax-1]
		mov	eax, dword_40CD24[edi*4]
		mov	dword_40DCC4[edi*4], ecx
		lea	eax, [eax+eax*2]
		lea	eax, [eax+eax*4]
		lea	eax, [eax+eax*4]
		shl	eax, 1
		cdq
		idiv	ecx
		mov	esi, eax
		mov	eax, dword_40D4F4[edi*4]
		imul	eax, 70h
		cdq
		idiv	ecx
		add	esi, 0AFh
		mov	dword_40CCA0, esi
		add	eax, 65h
		cmp	ecx, 0FFh
		mov	dword_40CCA4, eax
		jl	short loc_4014BE
		mov	edx, 50h
		jmp	short loc_4014C5

loc_4014BE:
		mov	edx, 0FFFh
		sub	edx, ecx

loc_4014C5:
		mov	ecx, edx
		mov	dword_40CCB8, edx
		and	ecx, 0FFh
		mov	edx, ecx
		shl	edx, 5
		or	edx, ecx
		shl	edx, 5
		or	edx, ecx
		push	edx		; COLORREF
		push	eax		; int
		mov	eax, ScrollBackDC
		push	esi		; int
		push	eax		; HDC
		call	ebx ; SetPixelV
		cmp	dword_40DCC4[edi*4], 1
		jg	short loc_401552
		call	_rand
		cdq
		mov	ecx, 15Eh
		idiv	ecx
		mov	esi, edx
		call	_rand
		cdq
		mov	ecx, 0AFh
		idiv	ecx
		lea	edx, [esi+edx-15Eh]
		mov	dword_40CD24[edi*4], edx
		call	_rand
		cdq
		mov	ecx, 0A0h
		idiv	ecx
		mov	esi, edx
		call	_rand
		cdq
		mov	ecx, 50h
		idiv	ecx
		lea	eax, [edi+4Bh]
		mov	dword_40DCC4[edi*4], eax
		lea	edx, [esi+edx-0A0h]
		mov	dword_40D4F4[edi*4], edx

loc_401552:
		inc	edi
		cmp	edi, 1F4h
		jl	loc_40141B
		pop	edi
		pop	esi
		pop	ebx
		ret
DrawStars	endp
align dword
SetupScroll proc
	invoke GetWindowRect,handle,addr Rect
	invoke BeginPaint,handle,addr Paint
	invoke BitBlt,ScrollBackDC,0,0,Rect.right,Rect.bottom,0,0,0,BLACKNESS
	invoke EndPaint,handle,addr Paint
	invoke DeleteObject,addr Paint
	invoke DeleteObject,addr Rect
	ret

SetupScroll	endp
align dword
ScrollMain	proc
		mov	ecx, dword_40E510
		mov	edx, dword_40E508
		mov	eax, dword_40E50C
		add	ecx, edx
		mov	dl, GoDown
		mov	Rect.left, ecx
		mov	ecx, TextLen
		mov	Rect.top, eax
		test	dl, dl
		lea	ecx, [ecx+ecx*4+28h]
		mov	Rect.right, 15Eh
		lea	ecx, [eax+ecx*4]
		mov	Rect.bottom, ecx
		jnz	short loc_4012FC
		mov	edx, dword_40E504
		cmp	edx, 2
		jz	short loc_4012D4
		test	edx, edx
		jnz	short loc_4012E6

loc_4012D4:
		dec	eax
		mov	dword_40E504, 1
		mov	dword_40E50C, eax
		jmp	short loc_4012ED


loc_4012E6:
		inc	edx
		mov	dword_40E504, edx

loc_4012ED:
		neg	ecx
		cmp	eax, ecx
		jge	short loc_401332
		mov	GoDown, 1
		jmp	short loc_401332


loc_4012FC:
		mov	ecx, dword_40E504
		cmp	ecx, 1
		jz	short loc_40130B
		test	ecx, ecx
		jnz	short loc_40131D

loc_40130B:
		inc	eax
		mov	dword_40E504, 1
		mov	dword_40E50C, eax
		jmp	short loc_401324


loc_40131D:
		inc	ecx
		mov	dword_40E504, ecx

loc_401324:
		cmp	eax, 0A0h
		jle	short loc_401332
		mov	GoDown, 0

loc_401332:
		mov	edx, ScrollBackDC
		push	esi
		push	edi
		
		;nHeight = -MulDiv(PointSize, GetDeviceCaps(hDC, LOGPIXELSY), 72);
	
		push	48h		; nDenominator
		push	5Ah		; int
		push	edx		; HDC
		call	GetDeviceCaps
		
		invoke GetDeviceCaps,ScrollBackDC,LOGPIXELSY
		push	eax		; nNumerator
		push	8		; nNumber
		call	MulDiv
		
		push	offset aTahoma ;Tahoma
		push	0		; DWORD
		push	0		; DWORD
		push	0		; DWORD
		push	0		; DWORD
		push	0		; DWORD
		push	0		; DWORD
		push	0		; DWORD
		push	0		; DWORD
		push	2BCh	; int
		push	0		; int
		push	0		; int
		neg	eax
		push	0		; int
		push	eax		; int
		mov	number, eax
		call	CreateFontA
		mov	hFont, eax
		
		invoke SelectObject,ScrollBackDC,hFont
		invoke SetTextColor,ScrollBackDC,0000FB00h   ;Colour of Scroller text in About
		invoke SetBkColor,ScrollBackDC,0000FB00h
		invoke SetBkMode,ScrollBackDC,TRANSPARENT
		
		mov	edi, offset String
		or	ecx, 0FFFFFFFFh
		xor	eax, eax
		repne scasb
		not	ecx
		dec	ecx
		invoke DrawText,ScrollBackDC,addr String,ecx,addr Rect,DT_CENTER
		invoke DeleteObject,hFont
		invoke DeleteObject,addr Rect


		pop	edi
		pop	esi
		ret
ScrollMain	endp
align dword
UpdateScroll	proc
	invoke GetDC,handle
	mov	ScrollMainDC, eax
	invoke GetWindowRect,handle,addr Rect
	invoke BeginPaint,handle,addr Paint
	invoke BitBlt,ScrollMainDC,0,0,Rect.right,Rect.bottom,ScrollBackDC,0,0,SRCCOPY
	invoke EndPaint,handle,addr Paint
	invoke DeleteObject,addr Paint
	invoke DeleteObject,addr Rect
	ret
UpdateScroll	endp

align dword
end start