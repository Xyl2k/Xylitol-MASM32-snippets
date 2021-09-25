;::::::::::::::::::::::::::::::::::::::::: b i g l i b ::::::::::::::::::::::::::::::::::::::::::
; biglib v. 0.01e
; bignumber library
; roy|fleur · http://www.effervescence.com

_BigCreate		proto	:dword				; dtValue
_BigDestroy		proto	:dword				; pBig
_BigCopy		proto	:dword,:dword			; pBig1,pBig2
_BigCompare		proto	:dword,:dword			; pBig1,pBig2
_BigCompare32		proto	:dword,:dword			; pBig,dtValue
_BigInB256		proto	:dword,:dword,:dword		; ptData,dtLen,pBig
_BigIn32		proto	:dword,:dword			; dtValue,pBig
_BigIn			proto	:dword,:dword,:dword		; ptString,dtBase,pBig
_BigInBytes		proto	:dword,:dword,:dword,:dword	; ptString,dtLen,dtBase,pBig
_BigOutB256		proto	:dword,:dword			; pBig,ptBuffer
_BigOutB16		proto	:dword,:dword			; pBig,ptBuffer
_BigOut			proto	:dword,:dword,:dword		; pBig,dtBase,ptBuffer
_BigOutBytes		proto	:dword,:dword,:dword		; pBig,dtBase,ptBuffer
_BigAdd32		proto	:dword,:dword,:dword		; pBigx,dtValue,pBigy
_BigAdd			proto	:dword,:dword,:dword		; pBigx,pBigy,pBigz
_BigSub32		proto	:dword,:dword,:dword		; pBigx,dtValue,pBigy
_BigSub			proto	:dword,:dword,:dword		; pBigx,pBigy,pBigz
_BigShr			proto	:dword,:dword			; pBigx,pBigy
_BigShl			proto	:dword,:dword			; pBigx,pBigy
_BigMul32		proto	:dword,:dword,:dword		; pBigx,dtValue,pBigy
_BigMul			proto	:dword,:dword,:dword		; pBigx,pBigy,pBigz
_BigDiv32		proto	:dword,:dword,:dword,:dword	; pBigx,dtValue,pBigy,pBigr
_BigDiv			proto	:dword,:dword,:dword,:dword	; pBigx,pBigy,pBigz,pBigr
_BigMod			proto	:dword,:dword,:dword		; pBigx,pBigy,pBigz
_BigMulMod		proto	:dword,:dword,:dword,:dword	; pBigx,pBigy,pBign,pBigz
_BigPowMod32		proto	:dword,:dword,:dword,:dword	; pBigx,e,pBign,pBigz
_BigPowMod		proto	:dword,:dword,:dword,:dword	; pBigx,pBigy,pBign,pBigz
_BigGcd			proto	:dword,:dword,:dword		; pBigx,pBigy,pBigz
