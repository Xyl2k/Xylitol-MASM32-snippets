.data?
MD5HashBuf db 64 dup(?)
MD5Digest dd 4 dup(?)
MD5Len dd ?
MD5Index dd ? 
  
.code
MD5FF macro dwA, dwB, dwC, dwD, locX, rolS, constAC
	mov	edi,dwC
	xor	edi,dwD
	and	edi,dwB
	xor	edi,dwD
	add	dwA,[locX]
	lea	dwA,[edi+dwA+constAC]
	rol	dwA,rolS
	add	dwA,dwB
endm

MD5GG macro dwA, dwB, dwC, dwD, locX, rolS, constAC
	mov	edi,dwC
	xor	edi,dwB
	and	edi,dwD
	xor	edi,dwC
	add dwA,[locX]
	lea	dwA,[edi+dwA+constAC]
	rol	dwA,rolS
	add	dwA,dwB
endm

MD5HH macro dwA, dwB, dwC, dwD, locX, rolS, constAC
	mov	edi,dwC
	xor	edi,dwD
	xor	edi,dwB
	add dwA,[locX]
	lea	dwA,[dwA+edi+constAC]
	rol	dwA,rolS
	add	dwA,dwB
endm

MD5II macro dwA, dwB, dwC, dwD, locX, rolS, constAC
	mov edi,dwD
	xor edi,-1
	or edi,dwB
	xor edi,dwC
	add dwA,[locX]
	lea dwA,[edi+dwA+constAC]
	rol dwA,rolS
	add dwA,dwB
endm

align dword
MD5Transform proc
	pushad
	mov esi,offset MD5Digest
	mov edi,offset MD5HashBuf	
	mov eax,[esi+0*4]
	mov ebx,[esi+1*4]
	mov ecx,[esi+2*4]
	mov ebp,edi
	mov edx,[esi+3*4]
	;==============================================================
	MD5FF eax, ebx, ecx, edx, dword ptr [ebp+ 0*4],  7, 0D76AA478H
	MD5FF edx, eax, ebx, ecx, dword ptr [ebp+ 1*4], 12, 0E8C7B756H
	MD5FF ecx, edx, eax, ebx, dword ptr [ebp+ 2*4], 17, 0242070DBH
	MD5FF ebx, ecx, edx, eax, dword ptr [ebp+ 3*4], 22, 0C1BDCEEEH
	MD5FF eax, ebx, ecx, edx, dword ptr [ebp+ 4*4],  7, 0F57C0FAFH
	MD5FF edx, eax, ebx, ecx, dword ptr [ebp+ 5*4], 12, 04787C62AH
	MD5FF ecx, edx, eax, ebx, dword ptr [ebp+ 6*4], 17, 0A8304613H
	MD5FF ebx, ecx, edx, eax, dword ptr [ebp+ 7*4], 22, 0FD469501H
	MD5FF eax, ebx, ecx, edx, dword ptr [ebp+ 8*4],  7, 0698098D8H
	MD5FF edx, eax, ebx, ecx, dword ptr [ebp+ 9*4], 12, 08B44F7AFH
	MD5FF ecx, edx, eax, ebx, dword ptr [ebp+10*4], 17, 0FFFF5BB1H
	MD5FF ebx, ecx, edx, eax, dword ptr [ebp+11*4], 22, 0895CD7BEH
	MD5FF eax, ebx, ecx, edx, dword ptr [ebp+12*4],  7, 06B901122H
	MD5FF edx, eax, ebx, ecx, dword ptr [ebp+13*4], 12, 0FD987193H
	MD5FF ecx, edx, eax, ebx, dword ptr [ebp+14*4], 17, 0A679438EH
	MD5FF ebx, ecx, edx, eax, dword ptr [ebp+15*4], 22, 049B40821H
	;==============================================================
	MD5GG eax, ebx, ecx, edx, dword ptr [ebp+ 1*4],  5, 0F61E2562H
	MD5GG edx, eax, ebx, ecx, dword ptr [ebp+ 6*4],  9, 0C040B340H
	MD5GG ecx, edx, eax, ebx, dword ptr [ebp+11*4], 14, 0265E5A51H
	MD5GG ebx, ecx, edx, eax, dword ptr [ebp+ 0*4], 20, 0E9B6C7AAH
	MD5GG eax, ebx, ecx, edx, dword ptr [ebp+ 5*4],  5, 0D62F105DH
	MD5GG edx, eax, ebx, ecx, dword ptr [ebp+10*4],  9, 002441453H
	MD5GG ecx, edx, eax, ebx, dword ptr [ebp+15*4], 14, 0D8A1E681H
	MD5GG ebx, ecx, edx, eax, dword ptr [ebp+ 4*4], 20, 0E7D3FBC8H
	MD5GG eax, ebx, ecx, edx, dword ptr [ebp+ 9*4],  5, 021E1CDE6H
	MD5GG edx, eax, ebx, ecx, dword ptr [ebp+14*4],  9, 0C33707D6H
	MD5GG ecx, edx, eax, ebx, dword ptr [ebp+ 3*4], 14, 0F4D50D87H
	MD5GG ebx, ecx, edx, eax, dword ptr [ebp+ 8*4], 20, 0455A14EDH
	MD5GG eax, ebx, ecx, edx, dword ptr [ebp+13*4],  5, 0A9E3E905H
	MD5GG edx, eax, ebx, ecx, dword ptr [ebp+ 2*4],  9, 0FCEFA3F8H
	MD5GG ecx, edx, eax, ebx, dword ptr [ebp+ 7*4], 14, 0676F02D9H
	MD5GG ebx, ecx, edx, eax, dword ptr [ebp+12*4], 20, 08D2A4C8AH
	;==============================================================
	MD5HH eax, ebx, ecx, edx, dword ptr [ebp+ 5*4],  4, 0FFFA3942H
	MD5HH edx, eax, ebx, ecx, dword ptr [ebp+ 8*4], 11, 08771F681H
	MD5HH ecx, edx, eax, ebx, dword ptr [ebp+11*4], 16, 06D9D6122H
	MD5HH ebx, ecx, edx, eax, dword ptr [ebp+14*4], 23, 0FDE5380CH
	MD5HH eax, ebx, ecx, edx, dword ptr [ebp+ 1*4],  4, 0A4BEEA44H
	MD5HH edx, eax, ebx, ecx, dword ptr [ebp+ 4*4], 11, 04BDECFA9H
	MD5HH ecx, edx, eax, ebx, dword ptr [ebp+ 7*4], 16, 0F6BB4B60H
	MD5HH ebx, ecx, edx, eax, dword ptr [ebp+10*4], 23, 0BEBFBC70H
	MD5HH eax, ebx, ecx, edx, dword ptr [ebp+13*4],  4, 0289B7EC6H
	MD5HH edx, eax, ebx, ecx, dword ptr [ebp+ 0*4], 11, 0EAA127FAH
	MD5HH ecx, edx, eax, ebx, dword ptr [ebp+ 3*4], 16, 0D4EF3085H
	MD5HH ebx, ecx, edx, eax, dword ptr [ebp+ 6*4], 23, 004881D05H
	MD5HH eax, ebx, ecx, edx, dword ptr [ebp+ 9*4],  4, 0D9D4D039H
	MD5HH edx, eax, ebx, ecx, dword ptr [ebp+12*4], 11, 0E6DB99E5H
	MD5HH ecx, edx, eax, ebx, dword ptr [ebp+15*4], 16, 01FA27CF8H
	MD5HH ebx, ecx, edx, eax, dword ptr [ebp+ 2*4], 23, 0C4AC5665H
	;==============================================================
	MD5II eax, ebx, ecx, edx, dword ptr [ebp+ 0*4],  6, 0F4292244H
	MD5II edx, eax, ebx, ecx, dword ptr [ebp+ 7*4], 10, 0432AFF97H
	MD5II ecx, edx, eax, ebx, dword ptr [ebp+14*4], 15, 0AB9423A7H
	MD5II ebx, ecx, edx, eax, dword ptr [ebp+ 5*4], 21, 0FC93A039H
	MD5II eax, ebx, ecx, edx, dword ptr [ebp+12*4],  6, 0655B59C3H
	MD5II edx, eax, ebx, ecx, dword ptr [ebp+ 3*4], 10, 08F0CCC92H
	MD5II ecx, edx, eax, ebx, dword ptr [ebp+10*4], 15, 0FFEFF47DH
	MD5II ebx, ecx, edx, eax, dword ptr [ebp+ 1*4], 21, 085845DD1H
	MD5II eax, ebx, ecx, edx, dword ptr [ebp+ 8*4],  6, 06FA87E4FH
	MD5II edx, eax, ebx, ecx, dword ptr [ebp+15*4], 10, 0FE2CE6E0H
	MD5II ecx, edx, eax, ebx, dword ptr [ebp+ 6*4], 15, 0A3014314H
	MD5II ebx, ecx, edx, eax, dword ptr [ebp+13*4], 21, 04E0811A1H
	MD5II eax, ebx, ecx, edx, dword ptr [ebp+ 4*4],  6, 0F7537E82H
	MD5II edx, eax, ebx, ecx, dword ptr [ebp+11*4], 10, 0BD3AF235H
	MD5II ecx, edx, eax, ebx, dword ptr [ebp+ 2*4], 15, 02AD7D2BBH
	MD5II ebx, ecx, edx, eax, dword ptr [ebp+ 9*4], 21, 0EB86D391H
	;==============================================================
	add [esi+0*4],eax	; update digest
	add [esi+1*4],ebx
	add [esi+2*4],ecx
	add [esi+3*4],edx
	popad
	retn
MD5Transform endp

MD5BURN macro
	xor eax,eax
	mov MD5Index,eax
	mov edi,Offset MD5HashBuf
	mov ecx,(sizeof MD5HashBuf)/4
	rep stosd
endm

align dword
MD5Init proc uses edi
	xor eax, eax
	mov MD5Len,eax
	MD5BURN
	mov eax,offset MD5Digest
	mov dword ptr [eax+0*4],067452301h
	mov dword ptr [eax+1*4],0EFCDAB89h
	mov dword ptr [eax+2*4],098BADCFEh
	mov dword ptr [eax+3*4],010325476h
	ret
MD5Init endp

align dword
MD5Update proc uses esi edi ebx lpBuffer:dword, dwBufLen:dword
	mov ebx,dwBufLen
	mov esi,lpBuffer
	add MD5Len,ebx
	.while ebx
		mov eax,MD5Index
		mov ecx,64
		sub ecx,eax
		lea edi,[MD5HashBuf+eax]	
		.if ecx <= ebx
			sub ebx,ecx
			rep movsb
			call MD5Transform
			MD5BURN
		.else
			mov ecx,ebx
			rep movsb
			add MD5Index,ebx
			.break
		.endif
	.endw
	ret
MD5Update endp

align dword
MD5Final proc uses esi edi
	mov ecx, MD5Index
	mov byte ptr [MD5HashBuf+ecx],80h
	.if ecx >= 56
		call MD5Transform
		MD5BURN
	.endif
	mov eax,MD5Len
	xor edx,edx
	shld edx,eax,3
	shl eax,3
	mov dword ptr [MD5HashBuf+56],eax
	mov dword ptr [MD5HashBuf+60],edx
	call MD5Transform
	mov eax,offset MD5Digest	
	ret
MD5Final endp