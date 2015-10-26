; ---- skeleton -----------------------------------------------------------
.486
.model	flat, stdcall
option	casemap :none ; case sensitive

; ---- Include ------------------------------------------------------------
include				\masm32\include\windows.inc
include				\masm32\include\user32.inc
include				\masm32\include\kernel32.inc
include				\masm32\include\masm32.inc
include				\masm32\include\comdlg32.inc
include				\masm32\include\gdi32.inc
include				\masm32\macros\macros.asm

includelib			\masm32\lib\winmm.lib
includelib			\masm32\lib\comdlg32.lib
includelib			\masm32\lib\user32.lib
includelib			\masm32\lib\kernel32.lib
includelib			\masm32\lib\masm32.lib
includelib			\masm32\lib\gdi32.lib

; Text Scroll Effects
include				Libs\TextScroller.inc
includelib			Libs\TextScroller.lib
; Music
include				Libs\ufmod.inc
includelib			Libs\ufmod.lib
; Lib for buttons
include				Libs\pnglib.inc
includelib			Libs\pnglib.lib
include				Libs\btnt.inc

; CRC Check
include 			Libs\crc32.inc

DlgProc				PROTO:DWORD,:DWORD,:DWORD,:DWORD
Aboutproc			PROTO:DWORD,:DWORD,:DWORD,:DWORD
List				PROTO:DWORD,:DWORD
Patch				PROTO:DWORD

icon				equ	1002
IDC_OK 				equ	1003
IDC_IDCANCEL 		equ	1004
IDC_SERIAL			equ 1007
IDC_MUSIC			equ 1008
SCROLLER_BG			equ 1009
ID_FONT				equ	2000
IDC_GENZ			equ 1300
IDC_ABOUT			equ 1301
IDC_EXIT			equ 1302
IDC_LISTBOX			equ	1002
IDC_CHECKBOX		equ	1006
TRANSPARENT_VALUE	equ 210 ;Scroller Text Transparency

; ---- Initialized data ---------------------------------------------------
.data
szWinTitle		db	"RED Patch",0
TargetName		db		"Crackme.exe",0
BackupName		db		"Crackme.exe.RED",0

WBuffer1		db		0EBh,008h
PatchOffset1	dd		00036445h

WBuffer2		db		090h,090h
PatchOffset2	dd		00036ABFh 

TargetCRC32  	dd 		262A849Ch ;CRC of the file

StartNfo1		db		"Patch for: XXXXX v1.0",0
StartNfo2		db		"Place in same folder as target and click PATCH",0
Backup			db		"Backup made",0
szTitle			db		'Error',0
szError			db		'An error has occured',0


nFont			dd	1
MoveDlg			BOOL		?
OldPos			POINT		<>
NewPos			POINT		<>
Rect			RECT		<>
rect			RECT		<>
rect2			RECT		<>
lfFont			LOGFONT	<8,0,0,0,FW_DONTCARE,0,0,0,DEFAULT_CHARSET,OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,\
				DEFAULT_QUALITY	,DEFAULT_PITCH or FF_DONTCARE,'ACKNOWLEDGE -BRK-'>

; ---- About Settings -----------------------------------------------------
String			db '[. Team RED proudly presents .]',0Ah
				db 'another quality release...',0Ah
				db 0Ah
				db 0Ah
				db 0Ah
				db 0Ah
				db '. . .',0Ah
				db 0Ah
				db 0Ah
				db 0Ah
				db 0Ah
				db 'pATCH, cODE, gFX by: ****/RED',0Ah
				db 'pROTECTION: XXXXX',0Ah
				db 'sFX: DNA-Groove',0Ah
				db 0Ah
				db 0Ah
				db 0Ah
				db 0Ah
				db 0Ah
				db 0Ah
				db 0Ah
				db 0Ah
				db 0Ah
				db 0Ah
				db 0Ah
				db 0Ah
				db 0Ah
				db 'I would like to thank all my friends',0Ah
				db 'in RED crew for the good times',0Ah
				db 'and all the ppl in the scene who',0Ah
				db 'bring quality release...!',0Ah
				db 0Ah
				db 0Ah
				db 0Ah
				db 0Ah
				db 0Ah
				db 0Ah
				db 0Ah
				db 0Ah
				db 0Ah
				db 0Ah
				db 0Ah
				db 0Ah
				db 0Ah
				db 'Once upon a time',0Ah
				db 'in a world of insects,',0Ah
				db 0Ah
				db 0Ah
				db 'A particular species rose from',0Ah
				db 'the dark.',0Ah
				db 0Ah
				db 0Ah
				db 'Everyday developing better',0Ah
				db 'knowledge to rule the society,',0Ah
				db 0Ah
				db 0Ah
				db "Expressing all it's mediocrity",0Ah
				db 'in this filthy world.',0Ah
				db 0Ah
				db 0Ah
				db "Reigning at the peak of it's",0Ah
				db 'society putrefacted art,',0Ah
				db 0Ah
				db 'Left humanity in a desert of sorrow',0Ah
				db 0Ah
				db 0Ah
				db 0Ah
				db 0Ah
				db '. . .',0Ah
				db 0Ah
				db 0Ah
				db 0Ah
				db 'What insect are you ?',0Ah
				db 0Ah
				db 0Ah
				db 0Ah
				db 0Ah
				db 0Ah
				db 0Ah
				db 0Ah
				db 0Ah
				db 0Ah
				db 0Ah
				db 0Ah
				db 0Ah
				db 0Ah
				db '.IF you are reading this crap,',0Ah
				db 'then i can say',0Ah
				db '* Welcome to my world! *',0Ah
				db 0Ah
				db 'SEE YOU AT TOP #1... :p',0Ah
				db 0Ah
				db 0Ah
				db 0Ah
				db 0Ah
				db 0Ah
				db 0Ah
				db 0Ah
				db 0Ah
				db 0Ah
				db 0Ah
				db 0Ah
				db 0Ah
				db 0Ah
				db "Temari, you're my soul",0Ah
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

; ---- Uninitialized data -------------------------------------------------
.data?
hCursor			dd	?
scr				SCROLLER_STRUCT <>
lf				LOGFONT<>
hFontRes		dd		?
ptrFont			dd		?
; ---- About Settings -----------------------------------------------------
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
; -------------------------------------------------------------------------

hTarget			HINSTANCE	?
BytesWritten	db		?

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

; ---- Code ---------------------------------------------------------------
.code
start:
	invoke	GetModuleHandle, NULL
	mov	hInstance, eax
	AllowSingleInstance addr szWinTitle ;dont allow make multiple window
	invoke LoadCursor,hInstance,200
	mov hCursor,eax
	invoke	DialogBoxParam, hInstance, 101, 0, ADDR DlgProc, 0
	invoke	ExitProcess, eax

DlgProc	proc hWnd:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
local hdc:HDC

local hPen:DWORD
local hBrush:DWORD
local hOldpen:DWORD
local hOldbrush:DWORD
local hSolidbrush:DWORD
local hOldSolidbrush:DWORD
local ps:PAINTSTRUCT
LOCAL pFileMem:DWORD
LOCAL ff32:WIN32_FIND_DATA
	.IF uMsg == WM_INITDIALOG
	invoke SendDlgItemMessage, hWnd, IDC_CHECKBOX, BM_SETCHECK, 1, 0
	invoke SetWindowText,hWnd,addr szWinTitle
invoke uFMOD_PlaySong,IDC_MUSIC,hInstance,XM_RESOURCE
invoke List,hWnd,addr StartNfo1
invoke List,hWnd,addr StartNfo2
invoke AnimateWindow,hWnd,800,AW_CENTER	
	invoke ImageButton,hWnd,20,180,300,301,302,IDC_GENZ	;custom image button (JPG,BMP,PNG) Left,Up,DownID,UpID,OverID
	mov hGen,eax
	invoke ImageButton,hWnd,120,180,400,401,402,IDC_ABOUT ;custom image button (JPG,BMP,PNG) Left,Up,DownID,UpID,OverID
	mov hAbout,eax
	invoke ImageButton,hWnd,220,180,500,501,502,IDC_EXIT ;custom image button (JPG,BMP,PNG) Left,Up,DownID,UpID,OverID
	mov hExit,eax

	invoke LoadIcon,hInstance,icon
	invoke SendMessage,hWnd,WM_SETICON,1,eax

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

; ---- Text Scroller ------------------------------------------------------
        m2m scr.scroll_hwnd,hWnd
		mov scr.scroll_text,chr$("¤ CrackMe 1.0 *Patch* ¤ by Team RED                                         Thx fly out to all my spiritual family and to all my friends out there!                                         See you around, have phun!")
								  
		mov scr.scroll_x,5
		mov scr.scroll_y,1
		mov scr.scroll_width,300
		mov scr.scroll_alpha,TRANSPARENT_VALUE
		mov scr.scroll_textcolor,0FCDC7Ch
		invoke CreateScroller,addr scr
; -------------------------------------------------------------------------
.elseIf uMsg == WM_CTLCOLORDLG
		mov eax,wParam
		invoke SetBkColor,eax,Black
		invoke GetStockObject,BLACK_BRUSH
		ret
.elseIf uMsg == WM_CTLCOLORLISTBOX
		mov eax,wParam
		invoke SetBkColor,wParam,Black
		invoke SetTextColor,wParam,0FCDC7Ch
		invoke GetStockObject,BLACK_BRUSH
		ret
.elseIf uMsg==WM_CTLCOLOREDIT || uMsg==WM_CTLCOLORSTATIC
		invoke SetBkMode,wParam,OPAQUE
		invoke SetBkColor,wParam,000000h
		invoke SetTextColor,wParam,0FCDC7Ch
		invoke GetStockObject,BLACK_BRUSH
		ret
	
.elseIf uMsg == WM_CTLCOLORBTN
      invoke CreateSolidBrush, 000000FFh
      ret
      .elseIf uMsg == IDC_SERIAL
invoke SetCursor,hCursor
.elseIf uMsg==WM_LBUTTONDOWN
		invoke SetCursor,hCursor
		mov MoveDlg,TRUE
		invoke SetCapture,hWnd
		invoke GetCursorPos,addr OldPos	
.elseIf uMsg==WM_MOUSEMOVE
invoke SetCursor,hCursor
	.if MoveDlg==TRUE
		invoke GetWindowRect,hWnd,addr Rect
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
		invoke MoveWindow,hWnd,eax,ebx,ecx,edx,TRUE
	.endif
.elseIf uMsg==WM_LBUTTONUP
		invoke SetCursor,hCursor
		mov MoveDlg,FALSE
		invoke ReleaseCapture
.elseIf	uMsg == WM_COMMAND
	.if	wParam == IDC_GENZ
		invoke FindFirstFile,ADDR TargetName,ADDR ff32
		.if eax == INVALID_HANDLE_VALUE
			invoke List,hWnd,chr$("File not found")
		.else
			call InitCRC32Table
			mov pFileMem,InputFile(ADDR TargetName)
			invoke CRC32,pFileMem,ff32.nFileSizeLow
			mov edx,TargetCRC32
			.if eax != edx
				invoke List,hWnd,chr$("Checksum fail")
			.else
				invoke GetFileAttributes,addr TargetName
				.if eax!=FILE_ATTRIBUTE_NORMAL
					invoke SetFileAttributes,addr TargetName,FILE_ATTRIBUTE_NORMAL
				.endif
				invoke CreateFile,addr TargetName,GENERIC_READ+GENERIC_WRITE,FILE_SHARE_READ+FILE_SHARE_WRITE,\
													NULL,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,NULL
				.if eax!=INVALID_HANDLE_VALUE
					mov hTarget,eax
		invoke SendDlgItemMessage,hWnd,IDC_CHECKBOX,BM_GETCHECK,0,0
        .if eax==BST_CHECKED
            invoke CopyFile, addr TargetName, addr BackupName, TRUE
            invoke List,hWnd,addr Backup
        .endif
					patch MACRO offsetAdr,_bytes,_byteSize
					invoke SetFilePointer,hTarget,offsetAdr,NULL,FILE_BEGIN
						.if eax==0FFFFFFFFh
							invoke CloseHandle,hTarget
							invoke List,hWnd,chr$("File not ready!")
							ret
						.endif
						invoke WriteFile,hTarget,addr _bytes,_byteSize,addr BytesWritten,FALSE
					ENDM
				patch PatchOffset1,WBuffer1,2
				patch PatchOffset2,WBuffer2,2
				invoke List,hWnd,chr$("File patched.")
				invoke CloseHandle,hTarget
			.endif
		.endif
	.endif
.elseIf	wParam == IDC_EXIT
			invoke EndDialog,hWnd,0
.elseIf	wParam == IDC_ABOUT
			invoke DialogBoxParam, hInstance, 102, hWnd, addr Aboutproc, NULL 
		.endif
.elseIf uMsg == WM_LBUTTONDBLCLK
invoke SetCursor,hCursor
.elseIf uMsg == WM_LBUTTONUP
invoke SetCursor,hCursor
.elseIf uMsg == WM_RBUTTONDBLCLK
invoke SetCursor,hCursor
.elseIf uMsg == WM_RBUTTONDOWN
invoke SetCursor,hCursor
.elseIf uMsg == WM_RBUTTONUP
invoke SetCursor,hCursor
.elseIf uMsg == WM_MOUSEMOVE
invoke SetCursor,hCursor
.elseIf uMsg == WM_MBUTTONDBLCLK
invoke SetCursor,hCursor
.elseIf uMsg == WM_MBUTTONDOWN
invoke SetCursor,hCursor
.elseIf uMsg == WM_MBUTTONUP
invoke SetCursor,hCursor
.elseIf	uMsg == WM_CLOSE
		invoke uFMOD_PlaySong,0,0,0
    	invoke DeleteObject,hPen
		invoke DeleteObject,hBrush
		invoke DeleteObject,hSolidbrush
		invoke EndDialog,hWnd,0
		invoke	EndDialog,hWnd,0
	.endif
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

Aboutproc proc hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
	mov	eax,uMsg
	push hWnd
	pop handle
.if	eax == WM_INITDIALOG
		invoke SendDlgItemMessage, hWnd, IDC_CHECKBOX, BM_SETCHECK, 1, 0
        push esi
		call InitScroller
.elseIf eax==WM_RBUTTONUP
		invoke KillTimer,hWnd,7Bh
		invoke KillTimer,hWnd,141h
		invoke DeleteObject,ScrollMainDC
		invoke DeleteObject,ScrollBackDC
		invoke SendMessage,hWnd,WM_CLOSE,0,0
	    invoke ShowWindow,hWnd, SW_HIDE
.elseIf eax==WM_TIMER
		call	SetupScroll
		call	DrawStars
		call	ScrollMain
		call	UpdateScroll
.elseIf eax==WM_LBUTTONDOWN
		invoke SetCursor,hCursor
		invoke SendMessage,hWnd,WM_NCLBUTTONDOWN,HTCAPTION,0
.elseIf eax==WM_LBUTTONDBLCLK
invoke SetCursor,hCursor
.elseIf eax==WM_LBUTTONUP
invoke SetCursor,hCursor
.elseIf eax==WM_RBUTTONDBLCLK
invoke SetCursor,hCursor
.elseIf eax==WM_RBUTTONDOWN
invoke SetCursor,hCursor
.elseIf eax==WM_RBUTTONUP
invoke SetCursor,hCursor
.elseIf eax==WM_MOUSEMOVE
invoke SetCursor,hCursor
.elseIf eax==WM_MBUTTONDBLCLK
invoke SetCursor,hCursor
.elseIf eax==WM_MBUTTONDOWN
invoke SetCursor,hCursor
.elseIf eax==WM_MBUTTONUP
invoke SetCursor,hCursor
.elseIf	eax == WM_CLOSE
		invoke	EndDialog, hWnd, 0
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
	
	invoke SetTimer,handle,123,16,0 ;scroller speed
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

end start