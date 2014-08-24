
PNGBTN	=	1

include			pnglib.inc
includelib		pnglib.lib

	ImageButton 		PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
	ImageButnProc 		PROTO :DWORD,:DWORD,:DWORD,:DWORD
	LoadPng			   	PROTO:DWORD,:DWORD
		
.data
sizeFrame		dd	?,?

.data?
hInstance		dd	?
hAbout		dd	?
hExit		dd	?
hWND		dd	?


		
.code
ImageButton proc hParent:DWORD,topX:DWORD,topY:DWORD,rnum1:DWORD,rnum2:DWORD,rnum3:DWORD,ID:DWORD

  ; parameters are,
  ; 1.  Parent handle
  ; 2/3 top X & Y co-ordinates
  ; 4/5/6 resource ID numbers or identifiers for UP & DOWN & MOVER bitmaps
  ; 67  ID number for control

    LOCAL hButn1  :DWORD
    LOCAL hImage  :DWORD
    LOCAL hModule :DWORD
    LOCAL wid     :DWORD
    LOCAL hgt     :DWORD
    LOCAL hBmpU   :DWORD
    LOCAL hBmpD   :DWORD
	LOCAL hBmpN   :DWORD 
    LOCAL Rct     :RECT
    LOCAL wc      :WNDCLASSEX

    invoke GetModuleHandle,NULL
    mov hModule, eax
	
	IFDEF BMPBTN
    invoke LoadBitmap,hModule,rnum1
    mov hBmpU, eax
    invoke LoadBitmap,hModule,rnum2
    mov hBmpD, eax
	invoke LoadBitmap,hModule,rnum3
	mov hBmpN,eax
	ELSEIFDEF JPGBTN
	invoke BitmapFromResource, hModule, rnum1
	mov hBmpU,eax
	invoke BitmapFromResource, hModule, rnum2
	mov hBmpD,eax
	invoke BitmapFromResource, hModule, rnum3
	mov hBmpN,eax
	ENDIF
	
	IFDEF PNGBTN
	invoke LoadPng,rnum1,addr sizeFrame
	mov hBmpU,eax
	invoke LoadPng,rnum2,addr sizeFrame
	mov hBmpD,eax
	invoke LoadPng,rnum3,addr sizeFrame
	mov hBmpN,eax
	ENDIF
	
    jmp @F
      Bmp_Button_Class db "Bmp_Button_Class_Jowy",0
    @@:

    mov wc.cbSize,         sizeof WNDCLASSEX
    mov wc.style,          CS_BYTEALIGNWINDOW
    mov wc.lpfnWndProc,    offset ImageButnProc
    mov wc.cbClsExtra,     NULL
    mov wc.cbWndExtra,     16
      push hModule
      pop wc.hInstance
    mov wc.hbrBackground,  COLOR_BTNFACE+1
    mov wc.lpszMenuName,   NULL
    mov wc.lpszClassName,  offset Bmp_Button_Class
    mov wc.hIcon,          NULL
    ;  invoke LoadCursor,hInstance,300
	;  mov hCursor,eax
    mov wc.hCursor,        NULL
    mov wc.hIconSm,        NULL

    invoke RegisterClassEx, ADDR wc

    invoke CreateWindowEx,WS_EX_TRANSPARENT,
            ADDR Bmp_Button_Class,NULL,
            WS_CHILD or WS_VISIBLE,
            topX,topY,100,100,hParent,ID,
            hModule,NULL

    mov hButn1, eax

    invoke SetWindowLong,hButn1,0,hBmpU
    invoke SetWindowLong,hButn1,4,hBmpD
	invoke SetWindowLong,hButn1,8,hBmpN

    jmp @F
    ButnImageClass db "STATIC",0
    @@:

    invoke CreateWindowEx,0,
            ADDR ButnImageClass,NULL,
            WS_CHILD or WS_VISIBLE or SS_BITMAP,
            0,0,0,0,hButn1,ID,
            hModule,NULL

    mov hImage, eax

    invoke SendMessage,hImage,STM_SETIMAGE,IMAGE_BITMAP,hBmpU

    invoke GetWindowRect,hImage,ADDR Rct
    invoke SetWindowLong,hButn1,12,hImage

    mov eax, Rct.bottom
    mov edx, Rct.top
    sub eax, edx
    mov hgt, eax

    mov eax, Rct.right
    mov edx, Rct.left
    sub eax, edx
    mov wid, eax

    invoke SetWindowPos,hButn1,HWND_TOP,0,0,wid,hgt,SWP_NOMOVE

    invoke ShowWindow,hButn1,SW_SHOW

    mov eax, hButn1

    ret

ImageButton endp
ImageButnProc proc hWin   :DWORD,uMsg   :DWORD,wParam :DWORD,lParam :DWORD

    LOCAL hBmpU  :DWORD
    LOCAL hBmpD  :DWORD
	LOCAL hBmpN	 :DWORD
    LOCAL hImage :DWORD
    LOCAL hParent:DWORD
    LOCAL ID     :DWORD
    LOCAL ptX    :DWORD
    LOCAL ptY    :DWORD
    LOCAL bWid   :DWORD
    LOCAL bHgt   :DWORD
    LOCAL Rct    :RECT
	

    .data
    cFlag dd 0      ; a GLOBAL variable for the "clicked" setting
    .code

    .if uMsg == WM_LBUTTONDOWN
        invoke GetWindowLong,hWin,4
        mov hBmpD, eax
        invoke GetWindowLong,hWin,12
        mov hImage, eax
        invoke SendMessage,hImage,STM_SETIMAGE,IMAGE_BITMAP,hBmpD
        invoke SetCapture,hWin
        mov cFlag, 1

	.elseif uMsg == 200h
	cmp cFlag,0
	jnz @Huh

		invoke GetClientRect,hWin,addr Rct
		mov eax,lParam
		mov ptX,eax
		mov ptY,eax
		and ptX,0ffffh
		shr ptY,010h
		mov ebx,ptX
		mov ecx,ptY
		cmp ecx,08ch
		ja @1
		cmp ebx,01eh
		jbe @2
@1:

		add Rct.left,0
		sub Rct.right,5
		add Rct.top,0
		sub Rct.bottom,5

@2:

		cmp ebx,Rct.left
		jb @Normal
		cmp ebx,Rct.right
		ja @Normal
		cmp ecx,Rct.top
		jb @Normal
		cmp ecx,Rct.bottom
		ja @Normal

		invoke GetWindowLong,hWin,8
        mov hBmpN, eax
        invoke GetWindowLong,hWin,12
        mov hImage, eax
        invoke SendMessage,hImage,STM_SETIMAGE,IMAGE_BITMAP,hBmpN
        invoke SetCapture,hWin
		jmp @OK

@Normal:
		invoke ReleaseCapture
		invoke GetWindowLong,hWin,0
        mov hBmpU, eax
        invoke GetWindowLong,hWin,12
        mov hImage, eax
        invoke SendMessage,hImage,STM_SETIMAGE,IMAGE_BITMAP,hBmpU
		invoke SetFocus,hWin
@OK:

    .elseif uMsg == WM_LBUTTONUP

        .if cFlag == 0
          ret
        .else
          mov cFlag, 0
        .endif
		
        invoke GetWindowLong,hWin,0
        mov hBmpU, eax
        invoke GetWindowLong,hWin,12
        mov hImage, eax
        invoke SendMessage,hImage,STM_SETIMAGE,IMAGE_BITMAP,hBmpU

        mov eax, lParam
        cwde
        mov ptX, eax
        mov eax, lParam
        rol eax, 16
        cwde
        mov ptY, eax

        invoke GetWindowRect,hWin,ADDR Rct

        mov eax, Rct.right
        mov edx, Rct.left
        sub eax, edx
        mov bWid, eax

        mov eax, Rct.bottom
        mov edx, Rct.top
        sub eax, edx
        mov bHgt, eax

      ; --------------------------------
      ; exclude button releases outside
      ; of the button rectangle from
      ; sending message back to parent
      ; --------------------------------
        cmp ptX, 0
        jle @F
        cmp ptY, 0
        jle @F
        mov eax, bWid
        cmp ptX, eax
        jge @F
        mov eax, bHgt
        cmp ptY, eax
        jge @F

        invoke GetParent,hWin
        mov hParent, eax
        invoke GetDlgCtrlID,hWin
        mov ID, eax
        invoke SendMessage,hParent,WM_COMMAND,ID,hWin

      @@:

        invoke ReleaseCapture

	.endif
	@Huh:
    invoke DefWindowProc,hWin,uMsg,wParam,lParam
    ret

ImageButnProc endp
LoadPng proc ID:DWORD,pSize:DWORD
local pngInfo:PNGINFO

invoke PNG_Init, addr pngInfo
invoke PNG_LoadResource, addr pngInfo, hInstance, ID
.if !eax
xor eax, eax
jmp @cleanup
.endif
invoke PNG_Decode, addr pngInfo
.if !eax
xor eax, eax
jmp @cleanup
.endif
invoke PNG_CreateBitmap, addr pngInfo, hWND, PNG_OUTF_AUTO, FALSE
.if	!eax
xor eax, eax
jmp @cleanup
.endif
mov edi,pSize
.if edi!=0
lea esi,pngInfo
movsd
movsd
.endif
	
@cleanup:
push eax	
invoke PNG_Cleanup, addr pngInfo
	
pop eax
ret

LoadPng endp