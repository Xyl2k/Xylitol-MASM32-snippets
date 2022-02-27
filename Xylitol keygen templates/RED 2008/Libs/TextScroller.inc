;******************************************************************************
;* STRUCTURE                                                                  *
;******************************************************************************

SCROLLER_STRUCT struct
	scroll_hwnd		dd ? ;handle of window where to draw
	scroll_text		dd ? ;pointer scrolltext
	scroll_x		dd ? ;x position
	scroll_y		dd ? ;y position
	scroll_width		dd ? ;width of scroller
	scroll_hFont		dd ? ;Handle of Font
	scroll_textcolor	dd ? ;example: 00F7DDCCh (00BBGGRR)
	scroll_alpha		db ? ;value for transparency (if using it on WS_EX_LAYERED window)
	scroll_wait		dd ? ;wait time (milliseconds) before draw scrolltext
	scroll_pause		db ? ;dont modify this! Use PauseScroller function!
SCROLLER_STRUCT ends



;******************************************************************************
;* PROTOTYPES                                                                 *
;******************************************************************************

;---public functions---
CreateScroller			PROTO :DWORD
PauseScroller			PROTO :DWORD