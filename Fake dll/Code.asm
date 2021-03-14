; ---- skeleton -----------------------------------------------------------
.486
option	casemap :none ; case sensitive

; ---- Include ------------------------------------------------------------
    include \masm32\include\masm32rt.inc
    include \masm32\include\windows.inc

;fake dll to communicate with ATM malwares that expects this kind of DLL

_DllMainCRTStartup PROTO :DWORD,:DWORD,:DWORD
CscCngStatusRead PROTO :DWORD,:DWORD
CscCngBim PROTO :DWORD,:DWORD
CscCngCasRefInit PROTO :DWORD,:DWORD
CscCngClose PROTO :DWORD,:DWORD
CscCngConfigure PROTO :DWORD,:DWORD
CscCngControl PROTO :DWORD,:DWORD
CscCngDispense PROTO :DWORD,:DWORD
CscCngEco PROTO :DWORD,:DWORD
CscCngEncryption PROTO :DWORD,:DWORD
CscCngGetRelease PROTO :DWORD,:DWORD
CscCngGetTrace PROTO :DWORD,:DWORD
CscCngInit PROTO :DWORD,:DWORD
CscCngLock PROTO :DWORD,:DWORD
CscCngOpen PROTO :DWORD,:DWORD
CscCngOptimization PROTO :DWORD,:DWORD
CscCngPowerOff PROTO :DWORD,:DWORD
CscCngPsm PROTO :DWORD,:DWORD
CscCngReset PROTO :DWORD,:DWORD
CscCngSelStatus PROTO :DWORD,:DWORD
CscCngSelftest PROTO :DWORD,:DWORD
CscCngService PROTO :DWORD,:DWORD
CscCngShutter PROTO :DWORD,:DWORD
CscCngStatistics PROTO :DWORD,:DWORD
CscCngTransport PROTO :DWORD,:DWORD
CscCngUnlock PROTO :DWORD,:DWORD

; #########################################################################

.code

_DllMainCRTStartup proc instance:DWORD,reason:DWORD,unused:DWORD
	mov	eax,1
	ret
_DllMainCRTStartup endp

CscCngStatusRead proc q:DWORD,w:DWORD
	mov	eax,0
	ret
CscCngStatusRead endp

CscCngBim proc q:DWORD,w:DWORD
	mov	eax,0
	ret
CscCngBim endp

CscCngCasRefInit proc q:DWORD,w:DWORD
	mov	eax,0
	ret
CscCngCasRefInit endp

CscCngClose proc q:DWORD,w:DWORD
	mov	eax,0
	ret
CscCngClose endp

CscCngConfigure proc q:DWORD,w:DWORD
	mov	eax,0
	ret
CscCngConfigure endp

CscCngControl proc q:DWORD,w:DWORD
	mov	eax,0
	ret
CscCngControl endp

CscCngDispense proc q:DWORD,w:DWORD
	mov	eax,0
	ret
CscCngDispense endp

CscCngEco proc q:DWORD,w:DWORD
	mov	eax,0
	ret
CscCngEco endp

CscCngEncryption proc q:DWORD,w:DWORD
	mov	eax,0
	ret
CscCngEncryption endp

CscCngGetRelease proc q:DWORD,w:DWORD
	mov	eax,0
	ret
CscCngGetRelease endp

CscCngGetTrace proc q:DWORD,w:DWORD
	mov	eax,0
	ret
CscCngGetTrace endp

CscCngInit proc q:DWORD,w:DWORD
	mov	eax,0
	ret
CscCngInit endp

CscCngLock proc q:DWORD,w:DWORD
	mov	eax,0
	ret
CscCngLock endp

CscCngOpen proc q:DWORD,w:DWORD
	mov	eax,0
	ret
CscCngOpen endp

CscCngOptimization proc q:DWORD,w:DWORD
	mov	eax,0
	ret
CscCngOptimization endp

CscCngPowerOff proc q:DWORD,w:DWORD
	mov	eax,0
	ret
CscCngPowerOff endp

CscCngPsm proc q:DWORD,w:DWORD
	mov	eax,0
	ret
CscCngPsm endp

CscCngReset proc q:DWORD,w:DWORD
	mov	eax,0
	ret
CscCngReset endp

CscCngSelStatus proc q:DWORD,w:DWORD
	mov	eax,0
	ret
CscCngSelStatus endp

CscCngSelftest proc q:DWORD,w:DWORD
	mov	eax,0
	ret
CscCngSelftest endp

CscCngService proc q:DWORD,w:DWORD
	mov	eax,0
	ret
CscCngService endp

CscCngShutter proc q:DWORD,w:DWORD
	mov	eax,0
	ret
CscCngShutter endp

CscCngStatistics proc q:DWORD,w:DWORD
	mov	eax,0
	ret
CscCngStatistics endp

CscCngTransport proc q:DWORD,w:DWORD
	mov	eax,0
	ret
CscCngTransport endp

CscCngUnlock proc q:DWORD,w:DWORD
	mov	eax,0
	ret
CscCngUnlock endp

end