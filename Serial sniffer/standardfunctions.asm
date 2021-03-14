StatusbarID 				equ 0
MAXSIZE						equ 100h
; lib code by MaRKuS TH-DJM
; Common
Status				PROTO :DWORD
Zero				PROTO :DWORD,:DWORD
RoundUp 			PROTO :DWORD,:DWORD
RoundDown 			PROTO :DWORD,:DWORD
SearchFile			PROTO
GetSizeOfImage		PROTO
Text2Hex			PROTO :DWORD
Hex2Text			PROTO :DWORD
SetJumpOffset		PROTO :DWORD,:DWORD
SetJumpVA			PROTO :DWORD,:DWORD

; Section
LoadSection 		PROTO :WORD
VAToOffset			PROTO :DWORD
OffsetToVA			PROTO :DWORD
SpecificOffsetToVA	PROTO :DWORD,:WORD
LoadSectionHigh		PROTO
LoadSectionLow		PROTO
AddSection			PROTO :DWORD,:DWORD

; File Operations
LoadFile			PROTO :DWORD
LoadPE				PROTO :DWORD,:DWORD
CheckCodeBase		PROTO
CheckCodeEnd		PROTO
CheckFileEnd		PROTO
SnR					PROTO :DWORD,:DWORD,:WORD,:BYTE,:DWORD,:DWORD,:DWORD
UnloadFile			PROTO
WriteFullFile		PROTO

; Hooks
SetHook				PROTO :DWORD
ClearHook			PROTO
WaitForHook			PROTO
FullHook			PROTO :DWORD
CreateTheProcess	PROTO :DWORD

.data
exceptionat		db "Exception occured @Address ",0
validpe 		db "Valid PE file!",0
invalidpe 		db "Invalid PE file!",0
empty			db 20h,0
hookbytes		dw 0FEEBh
Filter			db "Executables",0,"*.exe",0,0
ofntitle		db "Select File",0
exceptionspace		db 100h dup(0)
exception			db 30h	dup(0)
Statusbar 			db 100h dup(0)
hex2textbuffer		db 8h dup(0)
pathbuffer			db 100h dup(0)

.data?
StatusbarIDh		dd ?
peheader			dd ?
codesize			dd ?
codebase			dd ?
imagebase			dd ?
filehandle			dd ?
filesize			dd ?
filebase			dd ?
codeend				dd ?
fileend				dd ?
roffset				dd ?
rsize				dd ?
voffset				dd ?
vsize				dd ?
numofsections		dw ?
entrypoint			dd ?
temp				dd ?
backupbytes			dw ?
backupaddr			dd ?
sectionhigh			db ?
sectionalignment	dd ?
filealignment		dd ?
sizeofimage			dd ?
sectionnamepointer	dd ?

pinfo			 	PROCESS_INFORMATION <>
sinfo				STARTUPINFO <>

    ; ---------------------
    ; literal string MACRO
    ; ---------------------
      literal MACRO quoted_text:VARARG
        LOCAL local_text
        .data
          local_text db quoted_text,0
        .code
        EXITM <local_text>
      ENDM
    ; --------------------------------
    ; string address in INVOKE format
    ; --------------------------------
      SADD MACRO quoted_text:VARARG
        EXITM <OFFSET literal(quoted_text)>
      ENDM

.code

;>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; The top-level exception handler.						<
;>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
@@handler:
MOV EAX,DWORD PTR SS:[ESP+4]
MOV ESI,DWORD PTR DS:[EAX]
MOV EAX,DWORD PTR DS:[ESI+0Ch]
invoke Hex2Text,eax
invoke lstrcat,offset exceptionspace,offset exceptionat
invoke lstrcat,offset exceptionspace,offset hex2textbuffer
invoke MessageBox,0,offset exceptionspace,offset AppName,MB_OK
invoke ExitProcess,0

SetJumpOffset proc uses eax ecx edx edi sourceoffset:DWORD,destinationoffset:DWORD
LOCAL sourceVA:DWORD
LOCAL destinationVA:DWORD
invoke OffsetToVA,sourceoffset
mov sourceVA,eax
invoke OffsetToVA,destinationoffset
mov destinationVA,eax
mov eax,sourceoffset
add eax,filebase
mov sourceoffset,eax
mov eax,destinationoffset
add eax,filebase
mov destinationoffset,eax
mov eax,destinationVA
sub eax,sourceVA
sub eax,2
xor ecx,ecx
sub ecx,eax
.if eax<=7Fh
	mov edx,0EBh
.elseif ecx<=7Fh
	mov edx,0EBh
	mov eax,0FFh
	sub eax,ecx
	inc eax
.else
	mov edx,0E9h
	sub eax,3
.endif
mov edi,sourceoffset
.if dl==0E9h
	mov byte ptr [edi],0E9h
	inc edi
	mov dword ptr [edi],eax
.else
	mov byte ptr [edi],0EBh
	inc edi
	mov byte ptr [edi],al
.endif
ret
SetJumpOffset endp


SetJumpVA proc uses eax ecx edx edi sourceVA:DWORD,destinationVA:DWORD
mov eax,destinationVA
sub eax,sourceVA
sub eax,2
xor ecx,ecx
sub ecx,eax
.if eax<=7Fh
	mov edx,0EBh
.elseif ecx<=7Fh
	mov edx,0EBh
	mov eax,0FFh
	sub eax,ecx
	inc eax
.else
	mov edx,0E9h
	sub eax,3
.endif
mov edi,eax
mov eax,sourceVA
invoke VAToOffset,eax
add eax,filebase
xchg eax,edi
.if dl==0E9h
	mov byte ptr [edi],0E9h
	inc edi
	mov dword ptr [edi],eax
.else
	mov byte ptr [edi],0EBh
	inc edi
	mov byte ptr [edi],al
.endif
ret
SetJumpVA endp


Zero proc uses eax ecx edi address:DWORD,sizetozero:DWORD
xor eax,eax
mov ecx,sizetozero
mov edi,address
rep stosb
ret

Zero endp

Text2Hex proc uses ecx edi edx esi string:DWORD
	LOCAL strlen:DWORD
	LOCAL hexvalue:DWORD
	
invoke Zero,addr strlen,sizeof strlen
invoke Zero,addr hexvalue,sizeof hexvalue
xor ecx,ecx
mov edi,string
invoke lstrlen,string
mov strlen,eax
mov esi,eax
.while esi!=NULL
	mov al,byte ptr [edi]
	.if al>="1" && al<="9"
		sub al,30h
	.elseif al>="a" && al<="f"
		sub al,61h
		add al,0ah
	.else
		sub al,41h
		add al,0ah
	.endif
	movzx eax,al
	mov ecx,esi
	dec ecx
	.while ecx!=NULL
		shl eax,4h
		dec ecx
	.endw
		add hexvalue,eax
		inc edi
		dec esi
.endw
mov eax,hexvalue
ret

Text2Hex endp

Hex2Text proc uses ecx edx esi addresstoconvert:DWORD
invoke Zero,offset hex2textbuffer,sizeof hex2textbuffer
mov edx,offset hex2textbuffer-1
mov esi,addresstoconvert
mov ecx,8
.while ecx!=0
	mov eax,esi
	and al,0fh
	cmp al,0ah
	sbb al,69h
	das
	mov byte ptr [edx+ecx],al
	shr esi,4h
	dec ecx
.endw
mov eax,offset hex2textbuffer
ret
Hex2Text endp


AddSection proc uses ecx edi ebx sectionname:DWORD,sectionsize:DWORD
LOCAL newsectionpeoffset:DWORD
LOCAL newsectionva:DWORD
LOCAL newsectionoffset:DWORD
LOCAL sizeofimageadd:DWORD
LOCAL zerobytespointer:DWORD

invoke LoadSection,numofsections
mov eax,peheader
add ax,word ptr [eax+14h]
add eax,18h
movzx ecx,numofsections
.while ecx!=NULL
	add eax,28h
	dec ecx
.endw
mov newsectionpeoffset,eax
mov eax,voffset
add eax,vsize
invoke RoundUp,eax,sectionalignment
mov newsectionva,eax
mov eax,roffset
add eax,rsize
invoke RoundUp,eax,filealignment
mov newsectionoffset,eax
invoke GetSizeOfImage
mov edi,eax
invoke RoundUp,sectionsize,sectionalignment
add edi,eax
mov sizeofimage,edi
mov ecx,27h
mov edi,newsectionpeoffset
.while ecx!=0
.if byte ptr [edi+ecx]!=0
	.break
.endif
dec ecx
.endw
.if ecx!=0
	xor eax,eax
	ret
.endif
mov esi,sectionname
invoke lstrlen,esi
mov ecx,eax
mov ebx,8h
sub ebx,ecx
rep movsb
xor eax,eax
mov ecx,ebx
rep stosb
invoke RoundUp,sectionsize,sectionalignment
mov [edi],eax
add edi,4
mov eax,newsectionva
mov [edi],eax
add edi,4
invoke RoundUp,sectionsize,filealignment
mov [edi],eax
add edi,4
mov eax,newsectionoffset
mov [edi],eax
add edi,10h
mov dword ptr [edi],0E0000020h
mov eax,peheader
add eax,IMAGE_NT_HEADERS.OptionalHeader.SizeOfImage
mov ecx,sizeofimage
mov [eax],ecx
mov eax,peheader
add eax,IMAGE_NT_HEADERS.FileHeader.NumberOfSections
movzx ecx,numofsections
inc ecx
mov word ptr [eax],cx
invoke SetFilePointer,filehandle,0,0,0
invoke WriteFile,filehandle,filebase,filesize,offset temp,0
invoke RoundUp,sectionsize,filealignment
invoke VirtualAlloc,0,eax,MEM_COMMIT,PAGE_EXECUTE_READWRITE
mov zerobytespointer,eax
invoke RoundUp,sectionsize,filealignment
invoke WriteFile,filehandle,zerobytespointer,eax,offset temp,0
invoke RoundUp,sectionsize,filealignment
invoke VirtualFree,zerobytespointer,eax,MEM_DECOMMIT
ret

AddSection endp


GetSizeOfImage proc uses edi ebx
	
xor ebx,ebx
mov edi,peheader
add edi,IMAGE_NT_HEADERS.OptionalHeader.SizeOfImage
movzx ecx,numofsections
.while ecx!=NULL
	invoke LoadSection,cx
	invoke RoundUp,vsize,sectionalignment
	add ebx,eax
	dec ecx
.endw
mov edi,peheader
add edi,IMAGE_NT_HEADERS.OptionalHeader.SizeOfHeaders
add ebx,[edi]
mov eax,ebx
ret

GetSizeOfImage endp


RoundUp proc uses ecx edx number2round:dword,roundvalue:dword
mov eax,number2round
push eax
xor edx,edx
mov ecx,roundvalue
div ecx
sub ecx,edx
pop eax
.if edx!=NULL
	add eax,ecx
.endif
ret
RoundUp endp

RoundDown proc uses ecx edx number2round:dword,roundvalue:dword
	
mov eax,number2round
push eax
xor edx,edx
mov ecx,roundvalue
div ecx
sub ecx,edx
pop eax
.if edx!=NULL
	sub eax,edx
.endif
ret

RoundDown endp


SearchFile proc
LOCAL ofn:OPENFILENAME
invoke Zero,addr ofn,sizeof ofn
mov ofn.lStructSize,SIZEOF ofn 
mov eax,hWnd
mov ofn.hwndOwner,eax
push hInstance 
pop  ofn.hInstance 
mov  ofn.lpstrFilter,offset Filter
mov  ofn.lpstrFile,offset pathbuffer
mov  ofn.nMaxFile,100h 
mov  ofn.Flags, OFN_FILEMUSTEXIST or \ 
    OFN_PATHMUSTEXIST or OFN_LONGNAMES or\ 
    OFN_EXPLORER or OFN_HIDEREADONLY 
mov  ofn.lpstrTitle,offset ofntitle
invoke GetOpenFileName, addr ofn
ret

SearchFile endp


SnR proc uses edi ecx ebx esi edx bytestosearch:DWORD,bytestooverwrite:DWORD,sectiontosearch:WORD,patchtype:BYTE,baseaddr:DWORD,sizeofbase:DWORD,patchfindlength:DWORD
SnR_patch 					equ 1
SnR_search 					equ 2
;>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; Function uses 3F (?) to mark "not-to-match-bytes"		<
; Function needs "End" at the end of search-bytes.		<
;>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
LOCAL returnvalue:DWORD

.if patchfindlength==NULL
	call getpatchlength
.endif

.if bytestosearch!=NULL
	xor eax,eax
	mov ax,sectiontosearch
	.if ax!=NULL
		invoke LoadSection,sectiontosearch
		invoke LoadSectionHigh
		mov edi,roffset
		mov ecx,rsize
	.elseif baseaddr!=NULL
		mov edi,baseaddr
		mov ecx,sizeofbase
	.else
		mov edi,filebase
		mov ecx,filesize
	.endif
	sub ecx,patchfindlength
	sub ecx,1
	mov ebx,edi
	add ebx,ecx
	sub ebx,1
	mov eax,bytestosearch
	xor esi,esi
	dec edi


	SnRfind:
	cmp edi,ebx
	jge SnRfailed
	inc edi
	inc esi
	mov dl,byte ptr [edi]
	cmp byte ptr [eax],"?"
	je SnRnext
	cmp byte ptr [eax],dl
	jnz SnRreset
	SnRnext:
	inc eax
	cmp esi,patchfindlength
	jge SnRfound
	jmp SnRfind

	SnRreset:
	mov eax,bytestosearch
	xor esi,esi
	jmp SnRfind

	SnRfound:
	.if patchtype==SnR_patch
		sub edi,esi
		inc edi
		mov eax,bytestooverwrite
		.while esi!=NULL
			mov dl,byte ptr [eax]
			.if dl!="?"
				mov byte ptr [edi],dl
			.endif
			inc edi
			inc eax
			dec esi
		.endw
		mov returnvalue,1
	.else
		sub edi,esi
		inc edi
		mov returnvalue,edi
	.endif
.else 
	SnRfailed:
	mov returnvalue,NULL
.endif
mov eax,returnvalue
ret
	
getpatchlength:
mov eax,bytestosearch
xor ecx,ecx
jmp getpatchlengthloopstart
getpatchlength1:
inc ecx
inc eax
getpatchlengthloopstart:
cmp word ptr [eax],"nE"
jnz getpatchlength1
cmp byte ptr [eax+2],"d"
jnz getpatchlength1
mov patchfindlength,ecx
retn


SnR endp


;>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; code in order to get the Statusbar to work.			<
;>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

Status proc uses eax ecx pointertostring:DWORD
.if StatusbarIDh==FALSE
	invoke GetDlgItem,hWnd,StatusbarID
	mov StatusbarIDh,eax
.endif
invoke SendMessage,StatusbarIDh,LB_GETCOUNT,0,0
lea ecx,pointertostring
mov ecx,[ecx]
.if byte ptr [ecx]==20h
	.if eax!=0 && eax!=1
		@@:
		invoke SendMessage,StatusbarIDh,LB_ADDSTRING,0,pointertostring
		invoke SendMessage,StatusbarIDh,LB_GETCOUNT,0,0
		sub eax,1h
		invoke SendMessage,StatusbarIDh,LB_SETCURSEL,eax,0
	.endif
.else
	jmp @B
.endif
ret
Status endp

FullHook proc hookaddr:DWORD
LOCAL threadcontext:CONTEXT
LOCAL backup:DWORD
LOCAL backupb:WORD
mov eax,hookaddr
mov backup,eax
invoke ReadProcessMemory,pinfo.hProcess,hookaddr,addr backupb,2h,0
invoke WriteProcessMemory,pinfo.hProcess,hookaddr,offset hookbytes,2h,0
invoke Zero,addr threadcontext,sizeof threadcontext
invoke ResumeThread,pinfo.hThread
invoke Sleep,100
mov threadcontext.ContextFlags,CONTEXT_FULL
@@:
invoke GetThreadContext,pinfo.hThread,addr threadcontext
mov eax,hookaddr
cmp eax,threadcontext.regEip
jnz @B
invoke SuspendThread,pinfo.hThread
invoke WriteProcessMemory,pinfo.hProcess,backup,addr backupb,2h,0
ret

FullHook endp


WaitForHook proc
LOCAL threadcontext:CONTEXT
LOCAL waitval:DWORD
mov eax,backupaddr
mov waitval,eax
invoke Zero,addr threadcontext,sizeof threadcontext
invoke ResumeThread,pinfo.hThread
invoke Sleep,100
mov threadcontext.ContextFlags,CONTEXT_FULL
@@:
invoke GetThreadContext,pinfo.hThread,addr threadcontext
mov eax,waitval
cmp eax,threadcontext.regEip
jnz @B
invoke SuspendThread,pinfo.hThread
ret

WaitForHook endp


CreateTheProcess proc processexetocreate:DWORD

invoke CreateProcess,processexetocreate,processexetocreate,0,0,0,CREATE_SUSPENDED,0,0,offset sinfo,offset pinfo
ret

CreateTheProcess endp



SetHook proc hookaddr:DWORD
mov eax,hookaddr
mov backupaddr,eax
invoke ReadProcessMemory,pinfo.hProcess,hookaddr,offset backupbytes,2h,0
invoke WriteProcessMemory,pinfo.hProcess,hookaddr,offset hookbytes,2h,0
ret
SetHook endp

ClearHook proc
invoke WriteProcessMemory,pinfo.hProcess,backupaddr,offset backupbytes,2h,0
ret
ClearHook endp



;>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; Check the header for correct PE read & set:			<
; codebase, codesize, PE Header offset, imagebase		<
;>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
LoadPE proc uses ecx filetoload:DWORD,filebasetoload
mov eax,filebasetoload
.if word ptr [eax]==5A4Dh
	mov di,word ptr [eax+3Ch]
	add ax,di
	.if word ptr [eax]==4550h
		invoke Status,filetoload
		invoke Status,offset validpe
	.else
		invoke Status,filetoload
		invoke Status,offset invalidpe
	.endif
.else
		invoke Status,filetoload
		invoke Status,offset invalidpe
.endif
mov peheader,eax
add ax,[eax+IMAGE_NT_HEADERS.FileHeader.SizeOfOptionalHeader]
ADD EAX,28h
mov ecx,[eax]
mov codesize,ecx
add eax,4h
mov ecx,[eax]
add ecx,filebase
mov codebase,ecx
mov eax,peheader
mov eax,[eax+IMAGE_NT_HEADERS.OptionalHeader.ImageBase]
mov imagebase,eax
mov eax,codebase
add eax,codesize
mov codeend,eax
mov eax,filebase
add eax,filesize
mov fileend,eax
mov eax,peheader
add eax,IMAGE_NT_HEADERS.FileHeader.NumberOfSections
mov cx,[eax]
mov numofsections,cx
mov eax,peheader
add eax,IMAGE_NT_HEADERS.OptionalHeader.AddressOfEntryPoint
mov ecx,[eax]
mov entrypoint,ecx
mov eax,peheader
add eax,IMAGE_NT_HEADERS.OptionalHeader.SectionAlignment
mov ecx,[eax]
mov sectionalignment,ecx
mov eax,peheader
add eax,IMAGE_NT_HEADERS.OptionalHeader.FileAlignment
mov ecx,[eax]
mov filealignment,ecx
mov eax,peheader
add eax,IMAGE_NT_HEADERS.OptionalHeader.SizeOfImage
mov ecx,[eax]
mov sizeofimage,ecx
ret
LoadPE endp

	

LoadSectionLow proc uses eax
	
.if sectionhigh==TRUE
	mov eax,filebase
	sub roffset,eax
	mov eax,imagebase
	sub voffset,eax
	mov sectionhigh,FALSE
.endif
ret

LoadSectionLow endp


LoadSectionHigh proc uses eax
	
.if sectionhigh==FALSE
	mov eax,filebase
	add roffset,eax
	mov eax,imagebase
	add voffset,eax
	mov sectionhigh,TRUE
.endif
ret

LoadSectionHigh endp
	
LoadSection proc uses ecx eax sectiontoload:WORD
mov eax,peheader
movzx ecx,sectiontoload
.if cx<=numofsections
	add ax,[eax+IMAGE_NT_HEADERS.FileHeader.SizeOfOptionalHeader]
	add eax,18h
	dec ecx
	je LoadSection2
	LoadSection1:
	add eax,28h
	dec ecx
	jnz LoadSection1
	LoadSection2:
	mov sectionnamepointer,eax
	add eax,8
	mov ecx,[eax]
	mov vsize,ecx
	add eax,4
	mov ecx,[eax]
	mov voffset,ecx
	add eax,4
	mov ecx,[eax]
	mov rsize,ecx
	add eax,4
	mov ecx,[eax]
	mov roffset,ecx
.else
	xor eax,eax
.endif
ret
LoadSection endp


SpecificOffsetToVA proc uses ecx ebx offsettocalculate:DWORD,sectiontouse:WORD
	
mov eax,offsettocalculate
OffsetToVA1:
invoke LoadSection,sectiontouse
.if eax>=roffset
mov ebx,roffset
.if rsize!=FALSE
	add ebx,rsize
.else
	add ebx,vsize
.endif
.if eax<=ebx
	add eax,imagebase
	sub eax,roffset
	add eax,voffset

	.else
		dec ecx
		jnz OffsetToVA1
		xor eax,eax
	.endif
.else
	dec ecx
	jnz OffsetToVA1
	xor eax,eax
.endif
	ret

SpecificOffsetToVA endp


VAToOffset proc uses ecx ebx vatocalculate:DWORD
mov eax,vatocalculate
sub eax,imagebase
mov cx,numofsections
VAToOffset1:
invoke LoadSection,cx
.if eax>=voffset
mov ebx,voffset
add ebx,vsize
.if eax<=ebx
	sub eax,voffset
	add eax,roffset
	.else
		dec ecx
		jnz VAToOffset1
		xor eax,eax
	.endif
.else
	dec ecx
	jnz VAToOffset1
	xor eax,eax
.endif
ret

VAToOffset endp


OffsetToVA proc uses ecx ebx offsettocalculate:DWORD
mov eax,offsettocalculate
mov cx,numofsections
OffsetToVA1:
invoke LoadSection,cx
.if eax>=roffset
	mov ebx,roffset
	.if rsize!=FALSE
		add ebx,rsize
	.else
		add ebx,vsize
	.endif
	
	.if eax<=ebx
		add eax,imagebase
		sub eax,roffset
		add eax,voffset
	.else
		dec ecx
		jnz OffsetToVA1
		xor eax,eax
	.endif
.else
	dec ecx
	jnz OffsetToVA1
	xor eax,eax
.endif
ret

OffsetToVA endp

	
	
;>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; this function let you open a file and returns base	<
; you need to push filename.							<
;>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
LoadFile proc filetoload:DWORD
invoke Status,offset empty
invoke Status,offset empty
invoke GetFileAttributes,filetoload
.if eax!=INVALID_HANDLE_VALUE
invoke Status,SADD("File was found!!")
.else
	invoke Status,SADD("File was not found!!")
.endif
invoke CreateFile,filetoload,GENERIC_READ+GENERIC_WRITE,0,0,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0
.if eax!=-1
	mov filehandle,eax
	invoke GetFileSize,filehandle,0
	mov filesize,eax
	invoke VirtualAlloc,0,filesize,MEM_COMMIT,PAGE_EXECUTE_READWRITE
	mov filebase,eax
	invoke ReadFile,filehandle,filebase,filesize,offset temp,0
	invoke LoadPE,filetoload,filebase
	mov eax,filebase
	invoke Status,SADD("File was opened correctly!!")
.else
	invoke Status,SADD("File couldn't be opened!! Please close / select it!!")
	xor eax,eax
.endif
invoke Status,offset empty
ret
LoadFile endp



UnloadFile proc
invoke CloseHandle,filehandle
invoke VirtualFree,filebase,filesize,MEM_DECOMMIT
ret
UnloadFile endp


WriteFullFile proc
invoke SetFilePointer,filehandle,0,0,0
invoke WriteFile,filehandle,filebase,filesize,offset temp,0
ret
WriteFullFile endp


CheckCodeBase proc
sub eax,4
.if eax<=codebase
	add esp,4h
.endif
add eax,3
ret
CheckCodeBase endp

CheckCodeEnd proc
add eax,4
.if eax>=codeend
	add esp,4h
.endif
sub eax,3
ret
CheckCodeEnd endp

CheckFileEnd proc
add eax,4
.if eax>=fileend
	add esp,4h
.endif
sub eax,3
ret
CheckFileEnd endp
