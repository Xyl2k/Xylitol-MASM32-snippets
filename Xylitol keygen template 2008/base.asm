; Date: 19/08/2014
; Desc: Il s'agit d'un modèle de keygenerator que vous pouvez librement réutiliser, par exemple pour vos solutions de crackmes...
; Aucune routine de génération pour une application commerciale quelconque n'a été incluse.
; Cette source est une donnation du groupe RED CReW.
; Le code inclut un exemple d'implémentation de player de modules XM, d'utilisation de la PNGLib et également d'un scroller horizontal/vertical.

.486
.model	flat, stdcall
option	casemap :none ; case sensitive

; Include files
include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
include \masm32\include\comdlg32.inc
include \masm32\include\gdi32.inc
include \masm32\macros\macros.asm

includelib \masm32\lib\winmm.lib
includelib \masm32\lib\comdlg32.lib
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\gdi32.lib

; Text Scroll Effects
include			Libs\TextScroller.inc
includelib		Libs\TextScroller.lib
; Music
include			Libs\ufmod.inc
includelib		Libs\ufmod.lib
; Lib for buttons
include			Libs\pnglib.inc
includelib		Libs\pnglib.lib

include Libs\btnt.inc

DlgProc			PROTO :DWORD,:DWORD,:DWORD,:DWORD
Aboutproc		PROTO :DWORD,:DWORD,:DWORD,:DWORD
DoKey			PROTO :DWORD
SetClipboard	PROTO :DWORD
EditCustomCursor   proto:DWORD,:DWORD,:DWORD,:DWORD
EditCustomCursor2  proto:DWORD,:DWORD,:DWORD,:DWORD

icon			equ	1002
IDC_OK 			equ	1003
IDC_IDCANCEL 	equ	1004
IDC_GEN			equ 1005
IDC_NAME		equ 1006
IDC_SERIAL		equ 1007
IDC_MUSIC		equ 1008
SCROLLER_BG		equ 1009
ID_FONT			equ	2000
IDC_GENZ		equ 1300
IDC_ABOUT		equ 1301
IDC_EXIT		equ 1302
;Scroller Text Transparency
TRANSPARENT_VALUE	 equ 210

.data
Format			db	"%u",0
TooLong			db	"Your name is too long !",0
TooShort		db	"Your name is too short !",0
nFont			dd	1
lfFont			LOGFONT	<8,0,0,0,FW_DONTCARE,0,0,0,DEFAULT_CHARSET,OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,\
				DEFAULT_QUALITY	,DEFAULT_PITCH or FF_DONTCARE,'ACKNOWLEDGE -BRK-'>
MoveDlg				BOOL		?
OldPos				POINT		<>
NewPos				POINT		<>
Rect				RECT		<>
rect				RECT		<>
rect2				RECT		<>
szWinTitle	db	"RED Key Generator",0

;About Settings ###########################################################
String   	db 'RED CReW',0Ah
		db 'Proudly presents',0Ah
		db 0Ah		
		db 'SomeApp v1.0',0Ah
		db '*Keygen*',0Ah
		db 0Ah
		db '100% pur Win32 ASM :]',0Ah
		db 'GFX: xsp!d3r // RED',0Ah
		db 'SFX: Logic World by Kyze',0Ah
		db '----------------------------',0Ah
		db '-=[Greetz fly 2]=-',0Ah
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
; #########################################################################

.data?
hCursor			dd	?
scr				SCROLLER_STRUCT <>
lf				LOGFONT<>
hFontRes		dd		?
ptrFont			dd		?
;About Settings ###########################################################
handle			dd		?
serBuffer		db 		512 dup(?)
hBrushBack		HWND ?
ScrollMainDC	HDC	?
ScrollBackDC	HDC	?
Tick	        dd	?
ScrollBitmap	HBITMAP	?
dword_40CD18	dd	?
Paint			PAINTSTRUCT	<>
dword_40E498	dd	?
TextLen	      	dd	?
dword_40E508	dd	?
dword_40E50C	dd	?
GoDown	  		db	?
dword_40E504	dd	?
; #########################################################################
NameBuffer		db	100 dup(?)
FinalSerial		db	100 dup(?)
NameLen			dd	?
OldWndProc	dd	?
OldWndProc2	dd	?

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
      
.code
start:
	invoke	GetModuleHandle, NULL
	mov	hInstance, eax
	AllowSingleInstance addr szWinTitle			;dont allow make multiple window
	invoke LoadCursor,hInstance,200
	mov hCursor,eax
	invoke	DialogBoxParam, hInstance, 101, 0, ADDR DlgProc, 0
	invoke	ExitProcess, eax
; -----------------------------------------------------------------------

DlgProc	proc hWin:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
local hdc:HDC

local hPen:DWORD
local hBrush:DWORD
local hOldpen:DWORD
local hOldbrush:DWORD
local hSolidbrush:DWORD
local hOldSolidbrush:DWORD
local ps:PAINTSTRUCT

	.IF uMsg == WM_INITDIALOG
	invoke SetWindowText,hWin,addr szWinTitle
invoke uFMOD_PlaySong,IDC_MUSIC,hInstance,XM_RESOURCE

invoke AnimateWindow,hWin,800,AW_CENTER	
	invoke ImageButton,hWin,20,180,300,301,302,IDC_GENZ	;custom image button (JPG,BMP,PNG) Left,Up,DownID,UpID,OverID
	mov hGen,eax
	invoke ImageButton,hWin,120,180,400,401,402,IDC_ABOUT ;custom image button (JPG,BMP,PNG) Left,Up,DownID,UpID,OverID
	mov hAbout,eax
	invoke ImageButton,hWin,220,180,500,501,502,IDC_EXIT ;custom image button (JPG,BMP,PNG) Left,Up,DownID,UpID,OverID
	mov hExit,eax

	invoke LoadIcon,hInstance,icon
	invoke SendMessage,hWin,WM_SETICON,1,eax

			; Load font from resources
		invoke FindResource,NULL,ID_FONT,RT_RCDATA
		mov hFontRes,eax
		invoke LoadResource,NULL,eax
		.if eax
			invoke LockResource,eax
			mov ptrFont,eax
			invoke SizeofResource,NULL,hFontRes
			invoke AddFontMemResourceEx,ptrFont,eax,0,addr nFont
		.endif
		invoke CreateFontIndirect,addr lfFont
		mov scr.scroll_hFont,eax

; Text Scroller ###########################################################
        m2m scr.scroll_hwnd,hWin
		mov scr.scroll_text,chr$("RED CREW is PROUD 2 PRESENTS another fine release for - SomeApp v1.0 - keygenned by Someone, GFX: xsp!d3r, SFX: Logic World by Kyze - gr8tz fly to qpt^J, xsp!d3r, KKR, Encrypto, BytePlayeR, and to my spiritual family... :]          Xyl2k signing out !")
		mov scr.scroll_x,5
		mov scr.scroll_y,1
		mov scr.scroll_width,300
		mov scr.scroll_alpha,TRANSPARENT_VALUE
		mov scr.scroll_textcolor,0FCDC7Ch
		invoke CreateScroller,addr scr
; #########################################################################
.elseIF uMsg == WM_CTLCOLORDLG
		mov eax,wParam
		invoke SetBkColor,eax,Black
		invoke GetStockObject,BLACK_BRUSH
		ret
.elseif uMsg==WM_CTLCOLOREDIT || uMsg==WM_CTLCOLORSTATIC
		invoke SetBkMode,wParam,OPAQUE
		invoke SetBkColor,wParam,000000h
		invoke SetTextColor,wParam,0FCDC7Ch
		invoke GetStockObject,BLACK_BRUSH
		ret
.elseif uMsg == WM_CTLCOLORBTN
      invoke CreateSolidBrush, 000000FFh
      ret
      .elseif uMsg == IDC_SERIAL
invoke SetCursor,hCursor
.elseif uMsg==WM_LBUTTONDOWN
		invoke SetCursor,hCursor
		mov MoveDlg,TRUE
		invoke SetCapture,hWin
		invoke GetCursorPos,addr OldPos	
.elseif uMsg==WM_MOUSEMOVE
invoke SetCursor,hCursor
	.if MoveDlg==TRUE
		invoke GetWindowRect,hWin,addr Rect
		invoke GetCursorPos,addr NewPos
		mov eax,NewPos.x
		mov ecx,eax
		sub eax,OldPos.x
		mov OldPos.x,ecx
		add eax,Rect.left
		mov ebx,NewPos.y
		mov ecx,ebx
		sub ebx,OldPos.y
		mov OldPos.y,ecx
		add ebx,Rect.top
		mov ecx,Rect.right
		sub ecx,Rect.left
		mov edx,Rect.bottom
		sub edx,Rect.top
		invoke MoveWindow,hWin,eax,ebx,ecx,edx,TRUE
	.endif
.elseif uMsg==WM_LBUTTONUP
		invoke SetCursor,hCursor
		mov MoveDlg,FALSE
		invoke ReleaseCapture
.elseif	uMsg == WM_COMMAND
	.if	wParam == IDC_GENZ
		invoke GetDlgItemText,hWin,IDC_NAME,addr NameBuffer,sizeof NameBuffer
	.if eax > 20
		invoke SetDlgItemText,hWin,IDC_SERIAL,addr TooLong
.elseif eax < 4
		invoke SetDlgItemText,hWin,IDC_SERIAL,addr TooShort
	.else
		mov NameLen,eax
		invoke DoKey,hWin
	.endif
.elseif	wParam == IDC_EXIT
			invoke EndDialog,hWin,0
.elseif	wParam == IDC_ABOUT
			invoke DialogBoxParam, hInstance, 102, hWin, addr Aboutproc, NULL 
		.endif
.elseif uMsg == WM_LBUTTONDBLCLK
invoke SetCursor,hCursor

.elseif uMsg == WM_LBUTTONUP
invoke SetCursor,hCursor

.elseif uMsg == WM_RBUTTONDBLCLK
invoke SetCursor,hCursor

.elseif uMsg == WM_RBUTTONDOWN
invoke SetCursor,hCursor

.elseif uMsg == WM_RBUTTONUP
invoke SetCursor,hCursor

.elseif uMsg == WM_MOUSEMOVE
invoke SetCursor,hCursor

.elseif uMsg == WM_MBUTTONDBLCLK
invoke SetCursor,hCursor

.elseif uMsg == WM_MBUTTONDOWN
invoke SetCursor,hCursor

.elseif uMsg == WM_MBUTTONUP
invoke SetCursor,hCursor

.elseif	uMsg == WM_CLOSE
		invoke uFMOD_PlaySong,0,0,0
    	invoke DeleteObject,hPen
		invoke DeleteObject,hBrush
		invoke DeleteObject,hSolidbrush
		invoke EndDialog,hWin,0
		invoke	EndDialog,hWin,0
	.endif
		xor	eax,eax
		ret
DlgProc	endp

EditCustomCursor	proc	hWin:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
	
.if uMsg==WM_SETCURSOR
invoke SetCursor,hCursor
.else
invoke CallWindowProc,OldWndProc,hWin,uMsg,wParam,lParam
ret
.endif
	
xor eax,eax
ret
	
	Ret
EditCustomCursor EndP

EditCustomCursor2	proc	hWin:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
	
.if uMsg==WM_SETCURSOR
invoke SetCursor,hCursor
.else
invoke CallWindowProc,OldWndProc2,hWin,uMsg,wParam,lParam
ret
.endif
	
xor eax,eax
ret
	
	Ret
EditCustomCursor2 EndP

DoKey	proc	hWnd:DWORD
; #########################################################################
; ################ (¯`·._.·[ Put your algo here ! ]·._.·´¯) ###############
; #########################################################################

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
invoke SetClipboard,addr FinalSerial
invoke RtlZeroMemory,addr NameBuffer,sizeof NameBuffer
invoke RtlZeroMemory,addr FinalSerial,sizeof FinalSerial

	Ret
DoKey EndP

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
		invoke SetCursor,hCursor
		invoke SendMessage,hWin,WM_NCLBUTTONDOWN,HTCAPTION,0
.elseif eax==WM_LBUTTONDBLCLK
invoke SetCursor,hCursor
.elseif eax==WM_LBUTTONUP
invoke SetCursor,hCursor
.elseif eax==WM_RBUTTONDBLCLK
invoke SetCursor,hCursor
.elseif eax==WM_RBUTTONDOWN
invoke SetCursor,hCursor
.elseif eax==WM_RBUTTONUP
invoke SetCursor,hCursor
.elseif eax==WM_MOUSEMOVE
invoke SetCursor,hCursor
.elseif eax==WM_MBUTTONDBLCLK
invoke SetCursor,hCursor
.elseif eax==WM_MBUTTONDOWN
invoke SetCursor,hCursor
.elseif eax==WM_MBUTTONUP
invoke SetCursor,hCursor
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
		invoke SetTextColor,ScrollBackDC,0FCFC7Ch   ;Colour of Scroller text in About
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
	invoke DeleteObject,ScrollMainDC ;gdi leak fix
	ret
UpdateScroll	endp
align dword

SetClipboard	proc	txtSerial:DWORD
local	sLen:DWORD
local	hMem:DWORD
local	pMem:DWORD
	
invoke lstrlen, txtSerial
inc eax
mov sLen, eax
invoke OpenClipboard, 0
invoke GlobalAlloc, GHND, sLen
mov hMem, eax
invoke GlobalLock, eax
mov pMem, eax
mov esi, txtSerial
mov edi, eax
mov ecx, sLen
rep movsb
invoke EmptyClipboard
invoke GlobalUnlock, hMem
invoke SetClipboardData, CF_TEXT, hMem
invoke CloseClipboard
	
ret

SetClipboard endp

end start
