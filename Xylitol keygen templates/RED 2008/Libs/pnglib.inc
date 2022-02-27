;==============================================================================;
;                      +--\ |\  | +----   |    | +---\                         ;
;                      |  | | \ | | __    |    | |___/                         ;
;                      +--/ |  \| |   \   |    | |   \                         ;
;                      |    |   | +---/   +--- ' +---/                         ;
;==============================================================================;
; PNGLIB v1.0                                                                  ;    
;
; Include file for use with MASM32
;                                                                              ;
; Written by Thomas Bleeker. (C) 2002.                                         ;
; Thomas@MadWizard.org                                                         ;
; www.MadWizard.org                                                            ;
;------------------------------------------------------------------------------;

PNG_Init			PROTO	STDCALL :DWORD
PNG_Cleanup			PROTO	STDCALL :DWORD

PNG_LoadFile		PROTO 	STDCALL :DWORD, :DWORD
PNG_LoadResource 	PROTO	STDCALL :DWORD, :DWORD, :DWORD
PNG_LoadCustom	 	PROTO	STDCALL :DWORD, :DWORD, :DWORD

PNG_CreateBitmap 	PROTO	STDCALL :DWORD, :DWORD, :DWORD, :DWORD
PNG_OutputRaw		PROTO	STDCALL :DWORD, :DWORD, :DWORD

PNG_Decode			PROTO	STDCALL :DWORD
PNG_GetPalette		PROTO	STDCALL :DWORD, :DWORD, :DWORD

PNGCP_X_X			  	equ		0 
PNGCP_16_16		  		equ		1 
PNGCP_16_16_BGR	  		equ		2 
PNGCP_16_16_BGR_SA	  	equ		3 
PNGCP_16_16_BGRA	  	equ		4 
PNGCP_16_16_SA		  	equ		5 
PNGCP_16_8			  	equ		6 
PNGCP_16_8_BGR		  	equ		7 
PNGCP_16_8_BGR_SA    	equ		8 
PNGCP_16_8_BGRA      	equ		9 
PNGCP_16_8_SA        	equ		10
PNGCP_2_4            	equ		11
PNGCP_8_8_BGR        	equ		12
PNGCP_8_8_BGR_SA     	equ		13
PNGCP_8_8_BGRA       	equ		14
PNGCP_8_8_SA         	equ		PNGCP_16_8	;same proc

PNG_OUTF_AUTO					equ		-1


PNG_OUTF_G1_G1				   equ		(00010100h+PNGCP_X_X)			;DIB default
PNG_OUTF_G2_G2                 equ		(00020000h+PNGCP_X_X)			
PNG_OUTF_G2_G4                 equ		(00020100h+PNGCP_2_4)			;DIB default
PNG_OUTF_G4_G4                 equ		(00040100h+PNGCP_X_X)			;DIB default
PNG_OUTF_G8_G8                 equ		(00080100h+PNGCP_X_X)			;DIB default
PNG_OUTF_G16_G16               equ		(00100000h+PNGCP_16_16)			
PNG_OUTF_G16_G8                equ		(00100100h+PNGCP_16_8)			;DIB default
                                                
PNG_OUTF_T8_T8_BGR             equ		(02080100h+PNGCP_8_8_BGR)		;DIB default
PNG_OUTF_T16_T16_BGR           equ		(02100000h+PNGCP_16_16_BGR)		
PNG_OUTF_T16_T8_BGR            equ		(02100100h+PNGCP_16_8_BGR)		;DIB default
                                                
PNG_OUTF_P1_P1                 equ		(03010100h+PNGCP_X_X)			;DIB default
PNG_OUTF_P2_P2                 equ		(03020000h+PNGCP_X_X)			
PNG_OUTF_P2_P4                 equ		(03020100h+PNGCP_2_4)			;DIB default
PNG_OUTF_P4_P4                 equ		(03040100h+PNGCP_X_X)			;DIB default
PNG_OUTF_P8_P8				   equ		(03080100h+PNGCP_X_X)			;DIB default
                                                
PNG_OUTF_GA8_GA8               equ		(04080000h+PNGCP_X_X)			
PNG_OUTF_GA8_G8                equ		(04080100h+PNGCP_8_8_SA)		;DIB default
PNG_OUTF_GA16_GA16             equ		(04100000h+PNGCP_16_16)			
PNG_OUTF_GA16_G16              equ		(04100000h+PNGCP_16_16_SA)		
PNG_OUTF_GA16_GA8              equ		(04100000h+PNGCP_16_8)			
PNG_OUTF_GA16_G8               equ		(04100100h+PNGCP_16_8_SA)		;DIB default
                                                
PNG_OUTF_TA8_TA8_BGRA          equ		(06080100h+PNGCP_8_8_BGRA)		;DIB default
PNG_OUTF_TA8_T8_BGR            equ		(06080100h+PNGCP_8_8_BGR_SA)	;DIB optional
PNG_OUTF_TA16_TA16_BGRA        equ		(06100000h+PNGCP_16_16_BGRA)		
PNG_OUTF_TA16_T16_BGR          equ		(06100000h+PNGCP_16_16_BGR_SA)	
PNG_OUTF_TA16_TA8_BGRA         equ		(06100100h+PNGCP_16_8_BGRA)		;DIB default
PNG_OUTF_TA16_T8_BGR           equ		(06100100h+PNGCP_16_8_BGR_SA)	;DIB optional
                                        
PNGLIB_ERR_NOERROR			equ		0			;No error has occurred                                        
PNGLIB_ERR_OPENFILE			equ		1000h		;Couldn't open file
PNGLIB_ERR_MEMALLOC			equ		1001h		;Couldn't allocate memory
PNGLIB_ERR_ALREADY_LOADED	equ		1002h		;Other data has already been loaded
                                        
PNGLIB_ERR_INVALIDPNG		equ		2000h		;Corrupt or invalid PNG
PNGLIB_ERR_UNSUPPORTED		equ		2001h		;PNG format not supported
PNGLIB_ERR_INVALIDFORMAT	equ		2002h		;User error (!): Invalid format specified
PNGLIB_ERR_WRONGSTATE		equ		2003h		;User error (!): Function call at the wrong time
												;(e.g. decoding before loading data)
PNGLIB_ERR_NOPALETTE		equ		2004h		;Palette requested for a non-paletted image
PNGLIB_ERR_INVALIDPARAMETER equ		2005h		;Invalid parameter used for function
PNGLIB_ERR_CREATEBITMAP		equ		2006h		;Couldn't create bitmap

PNGLIB_ERR_FINDRESOURCE		equ		3001h		;Couldn't find resource
PNGLIB_ERR_LOADRESOURCE		equ		3002h		;Couldn't load resource


PNG_CT_GRAYSCALE			equ		0
PNG_CT_RGB_TRIPLES			equ		2
PNG_CT_PALETTE_INDEX		equ		3
PNG_CT_GRAYSCALE_ALPHA		equ		4
PNG_CT_RGB_ALPHA_QUADS		equ		6

PNG_IM_NONE		equ 		0
PNG_IM_ADAM7	equ			1

PNG_PF_RGB		equ			0	;output: red byte, green byte, blue byte
PNG_PF_BGRX		equ			1	;output: blue byte, green byte, red byte, zero byte


; note: total size of PNGINFO structure has to be a multiple of 4 bytes
PNGINFO STRUCT
	iWidth		  dword	?			; width of image
	iHeight		  dword	?			; height of image
	dwLastError	  dword	?			; last error code (PNGLIB_ERR_*)
	nColors		  dword	?			; number of palette entries, if present	
	PNGColorType  byte	?			; Original PNG color type (PNG_CT_*)
	PNGBitDepth	  byte  ?			; Original PNG bit depth (bits/sample)
	PNGInterlaced byte	?			; Interlace method (PNG_IM_*)
	; Internal members:	
	lpPNGData	  dword	?			; pointer to data in PNG file
	lnPNGData	  dword	?			; length of data pointed to by lpPNGData
	lpCurrent	  dword	?			; 'current pointer', used internally 
	lpOutput	  dword	?			; pointer to decompressed (unfiltered) output data, used internally
	lnOutput	  dword	?			; size of output data pointed to by lpOutput
	pPNGPalette   dword	?			; pointer to data in PLTE chunk
	dwLoadType	  dword	?			; type of data currently loaded (PNGI_LT_*)
	pHeader		  dword	?			; pointer to raw IHDR chunk *data* (&chunk+8)
	pIDAT		  dword	?			; pointer to start of first IDAT chunk
	curState	  dword ?			; PNGI_STATE_*
PNGINFO ENDS

