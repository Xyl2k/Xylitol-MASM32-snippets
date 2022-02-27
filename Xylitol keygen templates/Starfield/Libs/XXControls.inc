;   XXControls & NTS
;   
;e-mail:     "Chib" <XXControls@bk.ru>
;            "Alexm" <amdtm@mail.ru>

;-----------------------------------------------
;-----------------------------------------------
; menu function

SetMenuItemIcon PROTO :HMENU,:DWORD, :HICON
RedrawMenu      PROTO :HWND, :HMENU, :DWORD
GetStyleMenu    PROTO :HMENU
SetDisableSelect PROTO :BYTE
SetMenuIcon     PROTO :HMENU, :HIMAGELIST, :DWORD, :DWORD
AddLeftBorder   PROTO :HMENU, :DWORD, :BOOLEAN
RemoveLeftBorder PROTO :HMENU

STYLE_DEFAULT       equ 0
STYLE_OFFICE_2000   equ 1
STYLE_OFFICE_XP     equ 2
STYLE_XNET          equ 3


MNUBUTTON STRUCT
  idItem            DWORD      ?
  nIcon             DWORD      ?
MNUBUTTON ENDS

XXBUTTON STRUCT
  hIcon_normal      HICON      ?
  hIcon_hover       HICON      ?
  hBitmap_normal    HBITMAP    ?
  hBitmap_hover     HBITMAP    ?
  hBitmap_push      HBITMAP    ?
  hBitmap_gray      HBITMAP    ?
  hover_clr         COLORREF   ?
  push_clr          COLORREF   ?
  normal_clr        COLORREF   ?
  hFont_normal      HFONT      ?
  hFont_hover       HFONT      ?
  hCursor_hover     HCURSOR    ?
  Sound_hover       HGLOBAL    ?
  hMenu             HMENU      ?
  lpToolTip         LPCSTR     ?
  btn_prop          DWORD      ?
XXBUTTON ENDS

;-----------------------------------------------
;-----------------------------------------------
; button function

RedrawButton      PROTO :HWND, :DWORD
CreateFillBmp     PROTO :DWORD, :DWORD, :DWORD, :BYTE, :BYTE, :COLORREF
FILL_NULL         equ 0
FILL_NOISE        equ 1
FILL_SOFTBUMP     equ 2
FILL_VBUMP        equ 3
FILL_HBUMP        equ 4
FILL_HSHADE       equ 5
FILL_VSHADE       equ 6
FILL_DIAGSHADE    equ 7
FILL_HARDBUMP     equ 8
FILL_METAL        equ 9  

;-----------------------------------------------
;-----------------------------------------------
; LinkButton function

;RedrawButton      PROTO :HWND

;-----------------------------------------------
;-----------------------------------------------
; color function

DarkenColor         PROTO   :DWORD, :COLORREF
GrayColor           PROTO   :COLORREF
MixedColor          PROTO   :COLORREF, :COLORREF
LightenColor        PROTO   :DWORD, :COLORREF
MidColor            PROTO   :COLORREF, :COLORREF
GetXpHighlightColor PROTO
NumColorBits        PROTO
Gradient_Fill       PROTO   :HDC, :DWORD, :COLORREF, :COLORREF, :BOOLEAN
DrawIcn             PROTO   :DWORD, :DWORD, :DWORD, :BYTE, :BYTE
DrawIcnRect         PROTO   :DWORD, :DWORD, :DWORD, :BYTE, :BYTE
DrawDDB             PROTO   :HDC, :DWORD, :HBITMAP

RECT_H  equ 0
RECT_V  equ 1