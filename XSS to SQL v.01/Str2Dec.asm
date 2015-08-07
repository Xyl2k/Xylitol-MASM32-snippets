; ---- skeleton -----------------------------------------------------------
.686
.model flat, stdcall
option casemap :none

; ---- Include ------------------------------------------------------------
include 		\masm32\include\windows.inc
include 		\masm32\include\kernel32.inc
include 		\masm32\include\comctl32.inc
include 		\masm32\include\user32.inc
include 		\masm32\macros\macros.asm

includelib		\masm32\lib\kernel32.lib
includelib 		\masm32\lib\user32.lib
includelib 		\masm32\lib\comctl32.lib

DlgProc 		PROTO 	:DWORD,:DWORD,:DWORD,:DWORD
AddComma		PROTO 	:DWORD,:DWORD
SetClipboard	PROTO 	:DWORD

; #########################################################################

.const
IDD_DIALOG1		equ 100
IDC_EDT1		equ 101
IDC_EDT2		equ 102

.data
szBuffer		db 256 dup(?)

.data?
hInstance 		dd ?
szInput 		db 512 dup(?)
szOutput1 		db 512 dup(?)
szOutput2 		db 512 dup(?)
szOutputF 		db 512 dup(?)
szinputLen 		dd ?

.code
WinMain:
	invoke GetModuleHandle,0
	mov hInstance,eax
	invoke DialogBoxParam,hInstance,IDD_DIALOG1,0,addr DlgProc,0
         invoke InitCommonControls
	invoke ExitProcess,eax

DlgProc proc hWnd:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
		mov eax,uMsg
		.if eax==WM_INITDIALOG
		.elseif eax == WM_COMMAND
			mov eax,wParam
			mov edx,eax
			shr edx,16
			and eax,0ffffh
			.if edx==BN_CLICKED
				.if eax==1090
					invoke GetDlgItemText,hWnd,IDC_EDT1,addr szInput,sizeof szInput
					.if eax > 50
						invoke SetDlgItemText,hWnd,102,chr$("Input is too big")
					.else
					test eax,eax
					jz nothing
					mov szinputLen,eax
					PUSH ESI
					PUSH EDX
					PUSH ECX
					MOV EBX,szinputLen
					CMP EBX,0
					JBE @End
					MOV DWORD PTR SS:[EBP-3],EBX
					lea esi,offset szInput
					lea edi,offset szOutput1
					@std:
						MOVZX EAX,BYTE PTR DS:[ESI]
						MOV ECX,0Ah
						XOR EDX,EDX
						IDIV ECX
						ADD DL,030h
						MOV BYTE PTR DS:[EDI+2],DL
						XOR EDX,EDX
						IDIV ECX
						ADD DL,030h
						MOV BYTE PTR DS:[EDI+1],DL
						ADD AL,030h
						MOV BYTE PTR DS:[EDI],','
						MOV BYTE PTR DS:[EDI],AL
						ADD EDI,3
						INC ESI
						DEC DWORD PTR SS:[EBP-3]
						JNZ @std
					@End:
						PUSH DWORD PTR SS:[EBP+0Ch]
						CALL lstrlen
						XOR EDX,EDX
						MOV ECX,3
						IDIV ECX
						POP ECX
						POP EDX
						POP ESI
					invoke AddComma,addr szOutput1,addr szOutput2
					iNvOkE lstrlen,addr szOutput2
					MOV BYTE PTR [EAX+offset szOutput2-1],0
					invoke lstrcat,addr szOutputF,chr$("char",28h)
					invoke lstrcat,addr szOutputF,addr szOutput2
					invoke lstrcat,addr szOutputF,chr$(29h)
					invoke SetDlgItemText,hWnd,102,addr szOutputF			
					invoke RtlZeroMemory,addr szInput, sizeof szInput ;Clear buffers
					invoke RtlZeroMemory,addr szOutput1, sizeof szOutput1	
					invoke RtlZeroMemory,addr szOutput2, sizeof szOutput2	
					invoke RtlZeroMemory,addr szOutputF, sizeof szOutputF
					RET		
				.endif
				.endif
				.if eax==1097
					invoke GetDlgItemText,hWnd,102,addr szBuffer,sizeof szBuffer
					test eax,eax
					jz nothing
					invoke SetClipboard,addr szBuffer
					ret
					nothing:
					invoke SetDlgItemText,hWnd,102,chr$("Click Convert first.")
					ret
					.endif
				.if eax==1098
					invoke EndDialog,hWnd,0
				.endif
			.endif
		.endif
	.if eax==WM_CLOSE
		invoke EndDialog,hWnd,0
	.else
		xor eax,eax
		ret
	.endif
	mov eax,TRUE
	ret
DlgProc endp

AddComma proc uMsg:DWORD,wParam:DWORD
	XOR EAX,EAX
	XOR EDX,EDX
	XOR EBX,EBX
	XOR ESI,ESI
	XOR EDI,EDI
	MOV EBX,uMsg
	MOV EDX,wParam
	JMP foo_20
	foo_10:
		MOV BYTE PTR [EDX],','
		INC EDX
	foo_20:
		MOV ECX,DWORD PTR [EBX]
		ADD EBX,3
		TEST ECX,ECX
		JZ foo_30
		MOV DWORD PTR [EDX],ECX
		ADD EDX,3
		JMP foo_10
	foo_30:  
		XOR ECX,ECX
		MOV DWORD PTR [EDX],ECX
		ret
AddComma endp

SetClipboard	proc	txt:DWORD
local	sLen:DWORD
local	hMem:DWORD
local	pMem:DWORD
	
invoke lstrlen, txt
inc eax
mov sLen, eax
invoke OpenClipboard, 0
invoke GlobalAlloc, GHND, sLen
mov hMem, eax
invoke GlobalLock, eax
mov pMem, eax
mov esi, txt
mov edi, eax
mov ecx, sLen
rep movsb
invoke EmptyClipboard
invoke GlobalUnlock, hMem
invoke SetClipboardData, CF_TEXT, hMem
invoke CloseClipboard
ret
SetClipboard endp

end WinMain