.686
.model flat, stdcall
option casemap :none
include     \masm32\include\windows.inc
include     \masm32\include\kernel32.inc
include     \masm32\include\user32.inc
include     \masm32\include\comctl32.inc
include     \masm32\include\gdi32.inc
include     \masm32\macros\macros.asm

includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib
includelib \masm32\lib\comctl32.lib
includelib \masm32\lib\gdi32.lib
includelib \masm32\lib\winmm.lib

include    WaveObject.asm

include    cryptohash.inc
includelib cryptohash.lib
include    ufmod.inc
includelib ufmod.lib

DlgProc     PROTO :DWORD,:DWORD,:DWORD,:DWORD
MakeDialogTransparent	PROTO :DWORD,:DWORD
FadeIn 				PROTO :DWORD
FadeOut 				PROTO :DWORD

szTitle     db  'Error',0
szError     db  'An error has occured',0

.const
IDD_DIALOG1						equ 100
IDC_EDT1						equ 101
IDC_EDT3						equ 102
APPICON 						equ 2000
TRANSPARENT_VALUE				equ 200 ;Opacity Value ( max value is 254 )
DELAY_VALUE						equ 10

.data
nothing         db "input must be atleast 1 char.. so put it :)",0

.data?
Handle dd ?
hInstance dd ?
buff db 200h dup(?)
buf2 db ((sizeof buff)*3) dup(?)
stWaveObj   WAVE_OBJECT <?>
xWin dd ?
hBitmap dd ?
bitmp dd ?
Transparency	dd		?

.code
DlgProc proc hWnd:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
        local   @stPs:PAINTSTRUCT,@hDc,@stRect:RECT
        local   @stBmp:BITMAP
           LOCAL hMemDC:HDC
	mov eax,uMsg
	.if eax==WM_INITDIALOG
	invoke	LoadIcon,hInstance,APPICON
	invoke SendMessage,hWnd,WM_SETICON,1,eax
		mov edx,hWnd
		mov Handle,edx
		invoke uFMOD_PlaySong,1337,hInstance,XM_RESOURCE
		invoke LoadBitmap,hInstance,2
        mov hBitmap,eax
        invoke  GetDlgItem,hWnd,1008
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
        invoke FadeIn,hWnd
        invoke MakeDialogTransparent,hWnd,TRANSPARENT_VALUE
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
	.elseif eax==WM_COMMAND
		mov eax,wParam
		mov edx,eax
		shr edx,16
		and eax,0FFFFh
	.if edx == EN_CHANGE
			.if eax == IDC_EDT1
				invoke GetDlgItemText,hWnd,IDC_EDT1,addr buff,sizeof buff -1
				cmp eax,1
				jnl @starten
				invoke SetDlgItemText,hWnd,IDC_EDT3,addr nothing
				ret
				@starten:
				mov [buf2],al
					.if eax
						invoke Base64Encode,addr buff,eax,addr buf2
		                  		 .endif
				invoke SetDlgItemText,hWnd,IDC_EDT3,addr buf2
			.endif
		.endif
	.endif
	    .if uMsg == WM_LBUTTONDOWN
            mov eax,lParam
            movzx   ecx,ax      ; x
            shr eax,16      ; y
            invoke  _WaveDropStone,addr stWaveObj,ecx,eax,2,256
;   .if uMsg== WM_MOUSEMOVE
;           mov eax,lParam
;           movzx   ecx,ax      ; x
;           shr eax,16      ; y
;           invoke  _WaveDropStone,addr stWaveObj,ecx,eax,2,256
.endif
    .if uMsg == WM_CLOSE
    invoke FadeOut,hWnd
    invoke uFMOD_PlaySong,0,0,0
        call    _Quit
        invoke EndDialog,xWin,0
    .elseif uMsg==WM_DESTROY
      invoke DeleteObject,hBitmap
        invoke PostQuitMessage,NULL
        .endif
    xor eax,eax
    ret
DlgProc endp

_Quit proc
invoke  _WaveFree,addr stWaveObj
invoke  DestroyWindow,xWin
invoke  PostQuitMessage,NULL
ret
_Quit endp

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

WinMain:
	invoke GetModuleHandle,0
	mov hInstance,eax
	invoke DialogBoxParam,hInstance,IDD_DIALOG1,0,addr DlgProc,0
         invoke InitCommonControls
	invoke ExitProcess,eax
end WinMain