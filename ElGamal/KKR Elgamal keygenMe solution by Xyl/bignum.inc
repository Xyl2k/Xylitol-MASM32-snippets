;;
;; BNlib Version 1.0
;;

BN struct DWORD
	dwSize DWORD ?
	bSigned DWORD ?
	dwArray DWORD ?;,?,?,?,?,? ;BN_MAX_DWORD back to 1based array
BN ends
pBN typedef ptr BN


bnCreateX macro args:VARARG
	for arg,<args>
		invoke bnCreate
		mov &arg,eax
	endm
	bnDestroyX macro; args:VARARG
		for arg,<args>
			invoke bnDestroy,&arg
		endm
	endm 
endm

if 0
bnSCreateX equ bnCreateX
bnSDestroyX equ bnDestroyX
else

; use in recursion :P
; you must not abuse EBP! 
bnSCreateX macro args_locals:VARARG
	mov edx,BN_ALLOC_BYTES
	xor ecx,ecx
	for arg,<args_locals>
		sub esp,edx
		add ecx,edx
		mov &arg,esp
	endm
	mov edx,esp
	push edi
	xor eax,eax
	mov edi,edx
	shr ecx,2
	rep stosd
	pop edi
	inc eax
	for arg,<args_locals>
		mov edx,&arg
		mov [edx],eax
	endm
	bnSDestroyX macro
	LOCAL ii
		mov ecx,BN_ALLOC_BYTES
		ii = 0
		for arg,<args_locals>
			ii = ii + 1
		endm
		imul ecx,ii
		add esp,ecx
	endm
endm
endif

BN_IS_ZERO macro bnreg:req
	exitm <(([bnreg].BN.dwSize == 1) && ([bnreg].BN.dwArray[0] == 0))>
endm 

BN_IS_ONE macro bnreg:req
	exitm <(([bnreg].BN.dwSize == 1) && ([bnreg].BN.dwArray[0] == 1) && ([bnreg].BN.bSigned == 0))>
endm 

;ABSolute
ABS_BN_IS_ONE macro bnreg:req
	exitm <(([bnreg].BN.dwSize == 1) && ([bnreg].BN.dwArray[0] == 1))>
endm 

BN_IS_EVEN macro bnreg:req
	exitm <(!([bnreg].BN.dwArray[0] & 1))>
endm

BN_IS_ODD macro bnreg:req
	exitm <([bnreg].BN.dwArray[0] & 1)>
endm

bnAdd PROTO :DWORD,:DWORD
bnAddDw PROTO :DWORD,:DWORD
bnBits PROTO :DWORD
bnClear PROTO :DWORD
bnCmp PROTO :DWORD,:DWORD
bnCmpAbs PROTO :DWORD,:DWORD
bnCreate PROTO 
bnCreateDw PROTO :DWORD
bnCreatei PROTO :SDWORD
bnDec PROTO :DWORD
bnDestroy PROTO :DWORD
bnDiv PROTO :DWORD,:DWORD,:DWORD,:DWORD
bnDivDw PROTO :DWORD,:DWORD,:DWORD
bnFinish PROTO 
bnInc PROTO :DWORD
bnInit PROTO :DWORD
bnMod PROTO :DWORD,:DWORD,:DWORD
bnModDw PROTO :DWORD,:DWORD
bnMov PROTO :DWORD,:DWORD
bnMovsx PROTO :DWORD,:SDWORD
bnMovzx PROTO :DWORD,:DWORD
bnMul PROTO :DWORD,:DWORD,:DWORD
bnMulDw PROTO :DWORD,:DWORD
bnShl1 PROTO :DWORD
bnShl PROTO :DWORD,:DWORD
bnShr1 PROTO :DWORD
bnShr PROTO :DWORD,:DWORD
bnSquare PROTO :DWORD
bnSub PROTO :DWORD,:DWORD
bnSubDw PROTO :DWORD,:DWORD
bnXchg PROTO :DWORD,:DWORD
bnToHex PROTO :DWORD,:DWORD
bnFromBytes PROTO :DWORD,:DWORD,:DWORD,:DWORD
bnToBytes PROTO :DWORD,:DWORD
bnFromBytesEx PROTO :DWORD,:DWORD,:DWORD,:DWORD
bnToBytesEx PROTO :DWORD,:DWORD
bnFromStr PROTO :DWORD,:DWORD
bnToStr PROTO :DWORD,:DWORD
bnFromHex PROTO :DWORD,:DWORD
bnGCD PROTO :DWORD,:DWORD,:DWORD
bnLCM PROTO :DWORD,:DWORD,:DWORD
bnModExp PROTO :DWORD,:DWORD,:DWORD,:DWORD
bnMulpow2 PROTO :DWORD,:DWORD,:DWORD
bnDivpow2 PROTO :DWORD,:DWORD,:DWORD
bnModInv PROTO :DWORD,:DWORD,:DWORD
bnBinGCD PROTO :DWORD,:DWORD,:DWORD
bnModpow2 PROTO :DWORD,:DWORD,:DWORD
bnMontyModExp PROTO :DWORD,:DWORD,:DWORD,:DWORD
bnRandom PROTO :DWORD,:DWORD
bnRabinMillerpt PROTO :DWORD,:DWORD
bnFermatpt PROTO :DWORD
phase1 PROTO :DWORD
bnTrialDivpt PROTO :DWORD
bnIsPrime PROTO :DWORD
bnRsaGenPrime PROTO :DWORD,:DWORD
