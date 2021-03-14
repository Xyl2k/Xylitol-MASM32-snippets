.486
.model	flat, stdcall
option	casemap :none   ; case sensitive

include	base.inc
include standardfunctions.asm

.code
start:
    push @@handler ; <- standardfunctions.asm is needed
   ; call UnhandledExceptionFilter
	invoke GetModuleHandle,NULL
	mov    hInstance,eax
	invoke GetCommandLine
	mov  CommandLine,eax
	invoke InitCommonControls
	invoke WinMain,hInstance,NULL,CommandLine,SW_SHOWDEFAULT
	invoke ExitProcess,eax

WinMain proc hInst:HINSTANCE,hPrevInst:HINSTANCE,CmdLine:LPSTR,CmdShow:DWORD
	LOCAL	wc:WNDCLASSEX
	LOCAL	msg:MSG

	mov		wc.cbSize,SIZEOF WNDCLASSEX
	mov		wc.style,CS_HREDRAW or CS_VREDRAW
	mov		wc.lpfnWndProc,OFFSET DlgProc
	mov		wc.cbClsExtra,NULL
	mov		wc.cbWndExtra,DLGWINDOWEXTRA
	push	hInst
	pop		wc.hInstance
	;mov	c.hbrBackground,COLOR_BTNFACE+1
	mov		wc.hbrBackground, COLOR_WINDOW+0  ; ici, on px mettre la couleur, regardez dans windows.inc pour voir les couleurs.
	mov		wc.lpszMenuName,NULL
	mov		wc.lpszClassName,OFFSET ClassName
	invoke LoadIcon,NULL,IDI_APPLICATION
	mov		wc.hIcon,eax
	mov		wc.hIconSm,eax
	invoke LoadCursor,NULL,IDC_ARROW
	mov		wc.hCursor,eax
	invoke RegisterClassEx,addr wc
	invoke CreateDialogParam,hInstance,IDD_DIALOG,NULL,addr DlgProc,NULL
	invoke ShowWindow,hWnd,SW_SHOWNORMAL
	invoke UpdateWindow,hWnd
	.while TRUE
	    invoke GetMessage,addr msg,NULL,0,0
	  .BREAK .if !eax
	    invoke TranslateMessage, ADDR msg
	    invoke DispatchMessage, ADDR msg
	.endw
	mov		eax,msg.wParam
	ret

WinMain endp

DlgProc proc hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
    pushad 
	mov		eax,uMsg
    .if eax==WM_INITDIALOG
	push	hWin
	pop		hWnd

	.elseif eax==WM_COMMAND
	mov		eax,wParam
	and		eax,0FFFFh
	.if ax==IDC_PATH
	invoke TerminateProcess,pinfo.hProcess,0
	invoke TerminateThread,SerialThtreadID,0
	invoke CreateTheProcess,SADD("CrackMe1.exe")
	invoke FullHook,403979h
	mov eax, offset SerialThtread
	invoke CreateThread,0,0,eax,0,0,offset SerialThtreadID

	.elseif ax==IDC_QUIT
	invoke PostQuitMessage,0
	.endif	
    .elseif eax==WM_CLOSE
    invoke 	DestroyWindow,hWin
	.elseif uMsg==WM_DESTROY
	invoke PostQuitMessage,NULL
	.else
	invoke DefWindowProc,hWin,uMsg,wParam,lParam
    ret
	.endif
	popad 
	xor eax,eax
	ret

SerialThtread:
invoke FullHook,4038EBh
;004038E6    > /B8 30024200     MOV EAX,CrackMe1.00420230    ;  ASCII "8640-48735208654Dyn"
;004038EB    .^|EB DB           JMP SHORT CrackMe1.004038C8  ; Serial in EAX.
mov tcont.ContextFlags,CONTEXT_FULL
invoke GetThreadContext,pinfo.hThread, offset tcont; Context of running thread so we can get the value in eax
mov eax,tcont.regEax
invoke ReadProcessMemory,pinfo.hProcess,eax, offset serial,30h,0 ; Read out our serial
invoke SetDlgItemText, hWnd,IDC_SERIAL, offset serial ; send it back
invoke TerminateProcess,pinfo.hProcess,0 ; crackme is killed after getting the Serial
invoke ExitThread,0

DlgProc endp

end start
