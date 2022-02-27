.586
.model    flat, stdcall
option    casemap :none ; case sensitive

comment /*
	Dirty template made by using a starfield scroller by cerber^tPORt took from rogerica
	Arranged by Xylitol !
/

include        \masm32\include\windows.inc

include        \masm32\include\user32.inc
include        \masm32\include\kernel32.inc
include        \masm32\include\masm32.inc
include        \masm32\include\gdi32.inc  
include        \masm32\include\comctl32.inc
include		   \masm32\include\winmm.inc
include        \masm32\macros\macros.asm
include        Libs\XXControls.inc
include        Libs\ufmod.inc

includelib     \masm32\lib\user32.lib
includelib     \masm32\lib\kernel32.lib
includelib     \masm32\lib\masm32.lib
includelib     \masm32\lib\gdi32.lib
includelib     \masm32\lib\comctl32.lib
includelib     \masm32\lib\winmm.lib
includelib     Libs\XXControls.lib
includelib     Libs\ufmod.lib


AboutProc                PROTO :DWORD,:DWORD,:DWORD,:DWORD
DrawXXControlButtons     PROTO :DWORD
DrawEffects              PROTO :HWND
DrawColorScroller        PROTO 
TypewritingAnim          PROTO :DWORD
Copytxt                  PROTO :DWORD,:DWORD,:DWORD
StrLen                   PROTO :DWORD

.const
IDD_ABOUTBOX             equ 2000
IDC_TITLEBAR             equ 2001
IDB_QUIT                 equ 2002
IDB_SMALL_QUIT           equ 2003
IDB_SOUND                equ 2004
IDC_NAME                 equ 2007
IDC_SERIAL               equ 2008
IDC_TUNE                 equ 488
EFFECTS_HEIGHT           equ 207
EFFECTS_WIDTH            equ 344
WX                       equ 476
WY                       equ 202
left                     equ 0
top                      equ 30
LEFT                     equ 7
DOWN                     equ 30


.data
TooLong                  db "Your name is too long !",0
TooShort                 db "Your name is too short !",0
ErrorTxt                 db "[ this is only a template . :m ]",0
szTitle                  db "Enjoy that rainbow wave effect on a black background :)",0
pIntroBackBufferThreadID dd 0
screenHeight             dd 0
screenWidth              dd 0
wDC1                     dd 0
wDC2                     dd 0
y                        dd 0
x                        dd 0
x1                       dd 0
R                        dd 0
G                        dd 0
B                        dd 0
B1                       dd 0
B2                       dd 0
B3                       dd 0
B4                       dd 0
B5                       dd 0
B6                       dd 0
status                   dd ?
;these should match dialog size in pixels

xStarzPos                equ 7
yStarzPos                equ 31
nWidth                   equ 344
nHeight                  equ 205

nStarzSlow               equ 100
nStarzNorm               equ 100
nStarzFast               equ 100
StarColSlow              equ 777777h
StarColNorm              equ 0AAAAAAh
StarColFast              equ 0FFFFFFh

CapBgColor               equ 000000h
CapTxtColor              equ 0FFFFFFh
FormColor                equ 000000C6h

AboutFont                db "Terminal",0
CaptionFont              db "Courier",0
AboutTextColor           equ 0FFFFFFh
FontHeight               equ 12 
FontWidth                equ 8 ; 0 for default width.
LineHeight               equ 15 ; this needs to be updated in case if you wanna change the font size.

ScrollMsg                db ' ', 0 ; <-- this one is added in order to scroll the first page when the aboutbox is clicked ( sometimes it won't show after reaches the scroller end
                        ; after clicking it the 3rd/4th time but don't worry , i've also met this kind of bug in most of tPORt's releases from 2004-2006 )
                         db '    P E R Y F E R i A H   t E A M',0Dh
                         db '    p r o u d l y   p r e s e n t',0
                        ;---------------------------------------------
                         db '           -^-     -^-',0Dh
                         db '         /     \./     \',0Dh
                         db '        /       "       \',0Dh
                         db '        |               |',0Dh
                         db '        |               |',0Dh
                         db '         \             /',0Dh
                         db '           \         /',0Dh
                         db '             \     /',0Dh
                         db '               \ /',0Dh
                         db '                .',0
                        ;---------------------------------------------
                         db '   tARGEt    : Ardamax Keylogger 2.9',0Dh
                         db '   CracKeR   : B@TRyNU',0Dh
                         db '   pr0tecti0n: custom',0Dh
                         db '   rls date  : o 1 . o 5 . 2 o 2 1',0Dh
                         db '   tune      : the radix point',0
                        ;---------------------------------------------
                         db '   Gr33tz fly out 2 Al0hA,r0ger,',0Dh
                         db '   ShTEFY,DAViiiiDDDDDDD,r0bica,',0Dh
                         db '   GRUiA,MaryNello,yMRAN,WeeGee,',0Dh
                         db '   sabYn,NoNNy,QueenAntonia,',0Dh
                         db '   7epTaru`,m3mu and otherz :)',0
                        ;---------------------------------------------
                         db '   But also to Roentgen,Cachito,',0Dh
                         db '   Xylitol,TeddyRogers,kao,HcH,',0Dh
                         db '   GioTiN,SKG-1010,Bl4ckCyb3rEnigm4',0Dh
                         db '   GlacialManDoUtDes,nuttertools,',0Dh
                         db '   Tux528,udg,TeRcO,atom0s,KesMezar,',0Dh
                         db '   Jowy,mrT4ntr4,Goppit and others ;)',0
                        ;---------------------------------------------
                         db '            sh0ut 0ut 2 :',0Dh,0Dh
                         db '   Drozerix for the CooL music',0Dh
                         db '   UfO-Pu55y for the BASSMOD lib',0Dh
                         db '   kao for helping r0ger to',0Dh
                         db '    recode this whole aboutbox :)',0Dh
                         db '   CERBER[tPORt] for coding this',0Dh
                         db '    aboutbox effect initially.',0  
                        ;---------------------------------------------
                         db '         you can find us at :',0Dh,0Dh
                         db '           yt : MC Roger',0Dh
                         db '           fb : Darius Dan',0Dh
                         db '           ig : @r0gerica',0Dh
                         db '         @peryferiah.artpack',0Dh
                         db '             @allexx_bt',0
                        ;---------------------------------------------
                         db '     or in other sites + discord :',0Dh,0Dh
                         db '         discord : r0gerica#2649',0Dh
                         db '         devArt  : r0gerica',0Dh
                         db '         furaff  : r0gerica',0Dh
                         db '         github  : r0gerica',0
                        ;---------------------------------------------
                         db '        fuck da ripperz .   :E',0
                        ;---------------------------------------------
                         db 0    
                
ScrollerSpeed            equ 15
nStarCount               equ nStarzSlow + nStarzNorm + nStarzFast

.data?
NameBuffer               db 100 dup(?)
FinalSerial              db 100 dup(?)
NameLen                  dd         ?
hInstance                dd         ?
hBlackBrush              HBRUSH     ?
hExit                    BOOL       ?
hMatrix                  DWORD      ?
hDC                      HANDLE     ?

pbmi                     BITMAPINFO <>
ppvBits                  dd         ?
randomSeed               dw         ?
randomMaxVal             dw         ?
starArrayX               dw nStarCount dup(?)
starArrayY               dw nStarCount dup(?)
scrollerCurrentY         dd         ?
freezeCounter            dd         ?
ThreadID                 dd         ?
hDlgWnd                  dd         ?
hStarsDC                 dd         ?
hTextDC                  dd         ?
hThread                  dd         ?
ptrCurrentString         dd         ?
hAboutFont               dd         ?
hCaptionFont             dd         ?
hCaption                 dd         ?

$invoke MACRO Fun:REQ, A:VARARG
  IFB <A>
    invoke Fun
  ELSE
    invoke Fun, A
  ENDIF
  EXITM <eax>
ENDM

.code

BuildMatrix    Proc
;    *****************************
;    RGB Matrix, not needed here
;    *****************************
;        mov esi,hMatrix
;        mov x,0
;        mov y,0
;        mov R,255
;        mov G,0
;        mov B,0
;        mov R1,0
;        mov G1,0
;        mov B1,0
;        .repeat
;            .repeat
;                xor eax,eax
;                mov ecx,B
;                mov edx,B1
;                sub ecx,edx
;                mov ah,cl
;                rol eax,8
;                mov ecx,G
;                mov edx,G1
;                sub ecx,edx
;                mov ah,cl
;                mov ecx,R
;                mov edx,R1
;                add ecx,edx
;                mov al,cl
;                mov [esi],eax
;                add esi,4
;                invoke SetPixel,wDC,x,y,eax
;                inc G
;                .if G >= 255
;                    inc G1
;                .endif
;                inc x
;            .until x == EFFECTS_WIDTH
;            mov x,0
;            mov G,0
;            mov G1,0
;            dec R
;            inc B
;                .if B >= 255
;                    inc B1
;                .endif
;                .if R <= 0
;                    inc R1
;                .endif
;            inc y
;        .until y == EFFECTS_HEIGHT
;    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
;
;    *****************************************************
;        HSV Matrix here, but only [344;1] vector needed
;        kinda lame implementation, but hey, it works :p
;    *****************************************************
    mov esi,hMatrix
    mov x,0
;    mov y,0
;    .repeat
        mov R,255
        mov G,0
        mov B,0
        .repeat
            xor eax,eax
            mov ecx,B
            mov ah,cl
            rol eax,8
            mov ecx,G
            mov ah,cl
            mov ecx,R
            mov al,cl
            mov [esi],eax
            add esi,4
            .if B1 != 1 && R >= 255 && B <= 0
                mov R,255
                mov B,0
                add G,5
                .if G >= 255
                    mov G,255
                    mov B1,1
                .endif
            .elseif B2 != 1 && G >= 255 && B <= 0
                mov G,255
                mov B,0
                sub R,5
                .if R == -1 ||  R == -2 ||  R == -3 || R <= 0
                    mov R,0
                    mov B2,1
                .endif
            .elseif B3 != 1 && R <= 0 && G >= 255
                mov R,0
                mov G,255
                add B,5
                .if B >= 255
                    mov B,255
                    mov B3,1
                .endif
            .elseif B4 != 1 && B >= 255 && R <= 0
                mov B,255
                mov R,0
                sub G,5
                .if  G == -1 ||  R == -2 ||  R == -3 ||  G <= 0
                    mov G,0
                    mov B4,1
                .endif
            .elseif B5 != 1 && G <= 0  && B >= 255
                mov G,0
                mov B,255
                add R,5
                .if R >= 255
                    mov R,255
                    mov B5,1
                .endif
            .elseif B6 != 1 && R >= 255 && G <= 0
                mov R,255
                mov G,0
                sub B,5
                .if  B == -1 ||  R == -2 ||  R == -3 ||  B <= 0
                    mov B,0
                    mov B6,1
                .endif
            .endif
            inc x
        .until x == EFFECTS_WIDTH
        mov x,0
        mov B1,0
        mov B2,0
        mov B3,0
        mov B4,0
        mov B5,0
        mov B6,0
;        inc y
;    .until y == EFFECTS_HEIGHT
;    mov y,0
    Ret
BuildMatrix endp

Draw proc near uses ebx edi esi lpThreadParameter:DWORD 
    invoke  GetDC, hDlgWnd
    mov     hStarsDC, eax

    invoke  CreateCompatibleDC, eax
    mov     hTextDC, eax
    mov     edi, eax

    invoke  SetBkMode, edi, TRANSPARENT

    lea     esi, pbmi
    xor     edx, edx
    mov     pbmi.bmiHeader.biSize, sizeof BITMAPINFOHEADER
    mov     pbmi.bmiHeader.biWidth, nWidth
    mov     pbmi.bmiHeader.biHeight, not nHeight
    mov     pbmi.bmiHeader.biPlanes, 1
    mov     pbmi.bmiHeader.biBitCount, 32
    mov     pbmi.bmiHeader.biCompression, 0
    mov     pbmi.bmiHeader.biSizeImage, edx
    mov     pbmi.bmiHeader.biXPelsPerMeter, edx
    mov     pbmi.bmiHeader.biYPelsPerMeter, edx
    mov     pbmi.bmiHeader.biClrUsed, edx
    mov     pbmi.bmiHeader.biClrImportant, edx
    mov     dword ptr pbmi.bmiColors.rgbBlue, edx

    invoke  CreateDIBSection, hStarsDC, esi, edx, offset ppvBits, edx, edx
    invoke  SelectObject, edi, eax

    ; generate random X coords for the stars
    mov     ecx, nStarCount
    xor     ebx, ebx
    mov     randomMaxVal, nWidth
@loopRandomStarX:
    mov     dx, randomSeed
    add     dx, 9248h
    ror     dx, 3
    mov     randomSeed, dx
    mov     ax, randomMaxVal
    mul     dx
    mov     starArrayX[ebx], dx
    add     ebx, 2
    loop    @loopRandomStarX

    ; generate random Y coords for the stars
    mov     ecx, nStarCount
    xor     ebx, ebx
    mov     randomMaxVal, nHeight
@loopRandomStarY:
    mov     dx, randomSeed
    add     dx, 9248h
    ror     dx, 3
    mov     randomSeed, dx
    mov     ax, randomMaxVal
    mul     dx
    mov     starArrayY[ebx], dx
    add     ebx, 2
    loop    @loopRandomStarY

    ; never-ending loop begins here ---------------------------
loop_draw:
    ; draw slow stars
    xor     ecx, ecx
    mov     eax, ppvBits
@loopDrawSlowStars:
    movzx   ebx, starArrayY[ecx*2]
    imul    ebx, nWidth
    movzx   edx, starArrayX[ecx*2]
    add     edx, ebx
    mov     dword ptr [eax+edx*4], StarColSlow
    inc     ecx
    cmp     ecx, nStarzSlow
    jnz     @loopDrawSlowStars

    ; draw normal stars
@loopDrawNormStars:
    movzx   ebx, starArrayY[ecx*2]
    imul    ebx, nWidth
    movzx   edx, starArrayX[ecx*2]
    add     edx, ebx
    mov     dword ptr [eax+edx*4], StarColNorm
    inc     ecx
    cmp     ecx, nStarzSlow + nStarzNorm
    jnz     @loopDrawNormStars

    ; draw fast stars
@loopDrawFastStars:
    movzx   ebx, starArrayY[ecx*2]
    imul    ebx, nWidth
    movzx   edx, starArrayX[ecx*2]
    add     edx, ebx
    mov     dword ptr [eax+edx*4], StarColFast
    inc     ecx
    cmp     ecx, nStarCount
    jnz     @loopDrawFastStars

    ; render text scroller 
    invoke  SelectObject, edi, hAboutFont
    invoke  SetTextColor, edi, AboutTextColor
    call    TextInit

    ; have we scrolled our text to the middle of window?
    mov     ecx, nHeight / 2
    sub     ecx, eax
    cmp     scrollerCurrentY, ecx
    jnz     @afterFreeze

    ; if so, freeze text for (text height*2 + 20) cycles.
    ; the more lines of text, the longer is stays frozen.
    mov     ecx, eax
    shl     ecx, 2
    add     ecx, 14h
    cmp     freezeCounter, ecx
    jnb     @enoughFreeze
    ; keep frozen a bit more
    inc     freezeCounter
    inc     scrollerCurrentY
    jmp     @afterFreeze
@enoughFreeze:
    mov     freezeCounter, 0
@afterFreeze:
    ; scroll up 1 pixel
    dec     scrollerCurrentY

    ; was all text scrolled out of the window?
    add     eax, eax
    not     eax
    cmp     scrollerCurrentY, eax
    jnz     @notScrolledToTop

    ; if so, switch to next string
    mov     edi, ptrCurrentString
    xor     eax, eax
    or      ecx, 0FFFFFFFFh
    cld
    repne   scasb
    cmp     byte ptr [edi], 0
    jz      @restartFromBeginning
    mov     ptrCurrentString, edi
    jmp     @resetScrollerY
@restartFromBeginning:
    push    offset ScrollMsg
    pop     ptrCurrentString
@resetScrollerY:
    mov     scrollerCurrentY, nHeight
@notScrolledToTop:

    ; draw the rendered scene
    xor     edx, edx
    invoke  BitBlt, hStarsDC, xStarzPos, yStarzPos, nWidth, nHeight, hTextDC, edx, edx, SRCCOPY

    ; erase old scroller text
    invoke  PatBlt, hTextDC, 0, 0, nWidth, nHeight, BLACKNESS

    ; erase old stars from star bitmap
    xor     ecx, ecx
    mov     eax, ppvBits
@loopEraseStars:
    movzx   ebx, starArrayY[ecx*2]
    imul    ebx, nWidth
    movzx   edx, starArrayX[ecx*2]
    add     edx, ebx
    mov     dword ptr [eax+edx*4], 0
    inc     ecx
    cmp     ecx, nStarCount
    jnz     @loopEraseStars

    ; move slowest stars
    xor     ebx, ebx
@loopMoveSlowStars:
    inc     starArrayX[ebx]
    cmp     starArrayX[ebx], nWidth-2
    jb      @F
    mov     starArrayX[ebx], 0
@@:
    add     ebx, 2
    cmp     ebx, nStarzSlow * 2
    jb      @loopMoveSlowStars

    ; move normal stars
@loopMoveNormStars:
    add     starArrayX[ebx], 2
    cmp     starArrayX[ebx], nWidth-2
    jb      @F
    mov     starArrayX[ebx], 0
@@:
    add     ebx, 2
    cmp     ebx, (nStarzSlow + nStarzNorm) * 2
    jb      @loopMoveNormStars

    ; move the fastest stars
@loopMoveFastStars:
    add     starArrayX[ebx], 3
    cmp     starArrayX[ebx], nWidth-2
    jb      @F
    mov     starArrayX[ebx], 0
@@:
    add     ebx, 2
    cmp     ebx, nStarCount * 2
    jb      @loopMoveFastStars

    ; sleep a bit and repeat
    invoke  Sleep, ScrollerSpeed
    jmp     loop_draw

    ; thread never returns
Draw endp

TextInit proc near uses esi edi ebx
    LOCAL localScrollerCurrentY:DWORD

    mov     esi, ptrCurrentString

    ; calculate length of the current string + trailing zero
    invoke  lstrlenA, esi
    mov     ebx, eax
    inc     ebx

    ; get current Y
    push    scrollerCurrentY
    pop     localScrollerCurrentY

    ; draw each line of the string
    mov     edi, esi
@loopFindEndOfSingleLine:
    cmp     byte ptr [esi], 0Dh
    jz      @foundEOL
    cmp     byte ptr [esi], 0
    jnz     @checkNextByte

@foundEOL:
    ; replace last char of single line with 0x0
    mov     cl, [esi]
    push    ecx
    mov     byte ptr [esi], 0

    ; draw single line of text
    invoke  lstrlenA, edi
    invoke  TextOutA, hTextDC, 0, localScrollerCurrentY, edi, eax
    add     localScrollerCurrentY, LineHeight

    ; restore last char of the line
    pop     ecx
    mov     edi, esi
    inc     edi
    mov     [esi], cl
@checkNextByte:
    lodsb
    dec     ebx
    jnz     @loopFindEndOfSingleLine

    ; return (number of Y pixels used)/2
    mov     eax, localScrollerCurrentY
    sub     eax, scrollerCurrentY
    shr     eax, 1
    ret
TextInit endp

DrawEffects    Proc hWnd:HWND
    local bmpi1:BITMAPINFO
; ---- Activate Vectors ---------------------------------------------------

            mov hDC,$invoke (GetDC,hWnd)
            invoke CreateCompatibleDC,hDC
            mov wDC1,eax
            mov wDC2,eax
            invoke CreateCompatibleBitmap,hDC,EFFECTS_WIDTH,1
            invoke SelectObject,wDC1,eax
            invoke DeleteObject,eax
            invoke CreateCompatibleBitmap,hDC,EFFECTS_WIDTH,1
            invoke SelectObject,wDC2,eax
            invoke DeleteObject,eax
            _back:
            invoke DrawColorScroller
            .if hExit != TRUE
                invoke    Sleep,20
                invoke BitBlt,hDC,LEFT,DOWN,EFFECTS_WIDTH,1,wDC1,0,0,SRCCOPY
                invoke BitBlt,hDC,LEFT,DOWN+EFFECTS_HEIGHT,EFFECTS_WIDTH,1,wDC2,0,0,SRCCOPY
                jmp _back
            .endif    
            mov x1,0
        invoke    DeleteDC,wDC1
        invoke    DeleteDC,wDC2
    Ret
DrawEffects endp

DrawColorScroller    Proc
    mov esi,hMatrix
    mov x,0
    ; Commented commands would be useful only when we build a matrix on screen, instead of 2 scrolling vectors
    ;mov y,0
    ;    .repeat
            .repeat
                mov eax,x1
                add eax,x
                mov ebx,EFFECTS_WIDTH
                xor edx,edx
                idiv ebx
                push edx
                invoke SetPixel,wDC1,edx,y,dword ptr [esi]
                mov eax,EFFECTS_HEIGHT
            ;    add eax,y
                pop edx
            ;    add esi,EFFECTS_WIDTH*4*EFFECTS_HEIGHT-EFFECTS_WIDTH*4
            ;    sub esi,20h
                invoke SetPixel,wDC2,edx,eax,dword ptr [esi]
            ;    add esi,20h
            ;    sub esi,EFFECTS_WIDTH*4*EFFECTS_HEIGHT-EFFECTS_WIDTH*4
                add esi,4
                inc x
            .until x == EFFECTS_WIDTH
            mov x,0
    ;        inc y
    ;    .until y == 1 ;EFFECTS_HEIGHT
    ;    mov y,0
        add x1,5        ;    Speed of wave
    Ret
DrawColorScroller endp

DrawXXControlButtons    Proc    hWnd:HWND
LOCAL sButtonStructure:XXBUTTON,hSmallButtonFont:HFONT,hBtn:HWND
    mov hSmallButtonFont,$invoke(CreateFont,8,0,0,0,FW_NORMAL,FALSE,FALSE,FALSE,DEFAULT_CHARSET,OUT_CHARACTER_PRECIS,CLIP_CHARACTER_PRECIS,PROOF_QUALITY,FF_DONTCARE,chr$('MS Sans Serif'))
    invoke RtlZeroMemory,addr sButtonStructure,sizeof sButtonStructure
    invoke LoadCursor,NULL,IDC_HAND
    mov sButtonStructure.hCursor_hover,eax
    mov sButtonStructure.hover_clr,White
    mov sButtonStructure.push_clr,White
    mov sButtonStructure.normal_clr,White
    mov sButtonStructure.btn_prop,08000000Fh
    mov hBtn,$invoke(GetDlgItem,hWnd,IDB_SOUND )
    invoke RedrawButton,hBtn,addr sButtonStructure
    mov hBtn,$invoke(GetDlgItem,hWnd,IDB_QUIT )
    invoke RedrawButton,hBtn,addr sButtonStructure
    mov sButtonStructure.push_clr,0B0B0B0h
    mov sButtonStructure.btn_prop,08000000Bh
    mov hBtn,$invoke(GetDlgItem,hWnd,IDB_SMALL_QUIT )
    invoke RedrawButton,hBtn,addr sButtonStructure
    invoke SetFocus,eax
    mov eax,TRUE
    Ret
DrawXXControlButtons endp

TypewritingAnim proc hWnd:DWORD ; <-- this effect is token from Crisanar's keygen template so thx to him for that.
    LOCAL Charbuff[255]:TCHAR    
    LOCAL Newlen:DWORD
    mov Newlen,FUNC(StrLen,addr ErrorTxt)
    inc Newlen
    shr Newlen,1                            
    mov ecx,1    
    ;  initialize text animation
    .while(ecx <= Newlen)
        invoke Copytxt,addr Charbuff,addr ErrorTxt,ecx
        invoke Copytxt,ADDR Charbuff[ecx],ADDR ErrorTxt[ecx],ecx
        mov Charbuff[ecx*2],0      
        inc ecx
        push ecx
        invoke SetDlgItemText,hWnd,IDC_NAME,addr Charbuff
        invoke Sleep,14 ;<-- typewriting speed
        pop ecx
    .endw
    invoke ExitThread,NULL    
TypewritingAnim endp

Copytxt proc uses ecx esi edi aDest:DWORD,aSrc:DWORD,aLen:DWORD
   mov ecx,aLen
   mov esi,aSrc
   mov edi,aDest
   rep movsb
   ret
Copytxt endp

StrLen proc uses ecx edi aString:DWORD
   mov edi,aString
   xor eax,eax
   mov ecx,-1
   repne scasb
   not ecx
   dec ecx
   mov eax,ecx
   ret
StrLen endp

DoKey	proc	hDlg:DWORD
; algo here !
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

invoke SetDlgItemText,hDlg,IDC_SERIAL,addr FinalSerial
invoke RtlZeroMemory,addr NameBuffer,sizeof NameBuffer
invoke RtlZeroMemory,addr FinalSerial,sizeof FinalSerial
Ret
DoKey EndP

AboutProc proc hDlg:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
local rect:RECT,hDrawEffects:HANDLE,TypeThread:DWORD
    .if [uMsg] == WM_INITDIALOG  
        mov eax,hDlg
        mov hDlgWnd,eax
        mov randomMaxVal,0
        mov randomSeed,0
        mov eax,offset ScrollMsg
        mov ptrCurrentString,eax
        invoke GetParent,hDlg
        mov ecx,eax
        invoke GetWindowRect,ecx,addr rect
        mov edi,rect.left
        mov esi, rect.top
        add edi,25
        add esi,100
        mov status,1
        invoke LoadIcon,hInstance,200
		invoke SendMessage,hDlg,WM_SETICON,1,eax
        invoke DrawXXControlButtons,hDlg
        mov hMatrix,$invoke(VirtualAlloc,NULL,4*EFFECTS_WIDTH+100,MEM_COMMIT,PAGE_READWRITE)
        invoke BuildMatrix
        mov hDrawEffects,$invoke(CreateThread,NULL,0,addr DrawEffects,hDlg,0,addr pIntroBackBufferThreadID)
        invoke SetThreadPriority,hDrawEffects,THREAD_PRIORITY_NORMAL
        invoke CloseHandle,FUNC(CreateThread,NULL,0,addr TypewritingAnim,hDlg,0,addr TypeThread)
        invoke CreateFont, FontHeight, FontWidth, 0, 0, FW_DONTCARE, 0, 0, 0, DEFAULT_CHARSET, OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY, 0, offset AboutFont
        mov hAboutFont,eax
        invoke CreateFont,13,0,0,0,FW_DONTCARE,0,0,0,DEFAULT_CHARSET,OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,DEFAULT_QUALITY, 0,addr CaptionFont
        mov hCaptionFont,eax
        invoke GetDlgItem,hDlg,2001
        mov hCaption,eax
        invoke SendMessage,eax,WM_SETFONT,hCaptionFont,1
        invoke uFMOD_PlaySong,IDC_TUNE,hInstance,XM_RESOURCE
        invoke CreateThread, 0, 0, offset Draw, 0, 0, offset ThreadID
        mov hThread,eax
        jmp @return1
    .elseif [uMsg] == WM_LBUTTONDOWN
        invoke ReleaseCapture
        invoke SendMessageA,hDlgWnd,WM_NCLBUTTONDOWN,HTCAPTION,0
        jmp @return1
    .elseif [uMsg] == WM_RBUTTONDOWN
        ;invoke uFMOD_PlaySong,0,0,0
        invoke TerminateThread,hThread,0
        invoke VirtualFree,hMatrix,NULL,MEM_DECOMMIT
        invoke DeleteObject,hBlackBrush
        invoke CloseHandle,hDrawEffects
        invoke EndDialog,hDlg,0
        jmp @return1
    .elseif [uMsg] ==WM_CTLCOLOREDIT || uMsg==WM_CTLCOLORSTATIC
        invoke SetBkMode,wParam,TRANSPARENT
        invoke SetBkColor,wParam,000000h
        invoke SetTextColor,wParam,White
        invoke GetStockObject,BLACK_BRUSH
        ret
    .elseif [uMsg] == WM_CTLCOLORDLG
        mov eax,wParam
        invoke SetBkColor,eax,Black
        invoke GetStockObject,BLACK_BRUSH
        ret
    .elseif [uMsg] == WM_COMMAND
        mov eax,wParam
        mov edx,eax
        shr edx,16
        and eax,0FFFFh
            .if edx == EN_CHANGE
                .if eax == IDC_NAME
                    ;Keygen procedure start here
	                invoke GetDlgItemText,hDlg,IDC_NAME,addr NameBuffer,sizeof NameBuffer
	                   .if eax > 40
                           invoke SetDlgItemText,hDlg,IDC_SERIAL,addr TooLong
                       .elseif eax < 1
                           invoke SetDlgItemText,hDlg,IDC_SERIAL,addr TooShort
                       .else
	                mov NameLen,eax
	                invoke DoKey,hDlg
                       .endif
                 .endif
            .endif
            .if eax== IDB_QUIT || eax == IDB_SMALL_QUIT
                invoke TerminateThread,hThread,0
                invoke VirtualFree,hMatrix,NULL,MEM_DECOMMIT
                ;invoke uFMOD_PlaySong,0,0,0
                invoke DeleteObject,hBlackBrush
                invoke CloseHandle,hDrawEffects
                invoke EndDialog,hDlg,0
            .elseif eax==IDB_SOUND
                .if status == 1
                    invoke SetDlgItemText,hDlg,IDB_SOUND,chr$(">")
                    invoke uFMOD_PlaySong,0,0,0
                    mov status,0
                .else
                    invoke SetDlgItemText,hDlg,IDB_SOUND,chr$("<")
                    invoke uFMOD_PlaySong,IDC_TUNE,hInstance,XM_RESOURCE
                    mov status,1
                .endif
            .endif
    .elseif [uMsg] == WM_CLOSE
        ;invoke uFMOD_PlaySong,0,0,0
        invoke TerminateThread,hThread,0
        invoke VirtualFree,hMatrix,NULL,MEM_DECOMMIT
        invoke DeleteObject,hBlackBrush
        invoke CloseHandle,hDrawEffects
        invoke EndDialog,hDlg,0
    .endif
    mov eax, 0
    ret
@return1:
    mov eax, 1
    ret
AboutProc endp

start:
    invoke InitCommonControls
    mov hBlackBrush,$invoke(CreateSolidBrush,Red)
    mov hInstance,$invoke(GetModuleHandle, NULL)

    invoke GetModuleHandle, NULL
    mov hInstance, eax
    invoke DialogBoxParam,hInstance,IDD_ABOUTBOX,0,addr AboutProc, 0
    invoke ExitProcess,eax
end start

