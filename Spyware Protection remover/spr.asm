.386 ;Spyware Protection remover, only 17kb :D thanks to my mate [x]sp!d3r for the help !
.MODEL FLAT, STDCALL 
OPTION CASEMAP :NONE

		INCLUDE 	\masm32\include\WINDOWS.INC 
		INCLUDE 	\masm32\include\USER32.INC 
		INCLUDE 	\masm32\include\KERNEL32.INC 
		INCLUDE 	\masm32\include\ADVAPI32.INC 
		INCLUDE 	CRYPTOHASH.INC
		INCLUDELIB 	\masm32\lib\USER32.LIB 
		INCLUDELIB 	\masm32\lib\KERNEL32.LIB 
		INCLUDELIB 	\masm32\lib\ADVAPI32.LIB 
		INCLUDELIB 	CRYPTOHASH.LIB
		include     \masm32\include\gdi32.inc
include             \masm32\macros\macros.asm
include         WaveObject.asm
includelib          \masm32\lib\gdi32.lib
include		WaveObject.asm
includelib 		\masm32\lib\winmm.lib
include			ufmod.inc
includelib			ufmod.lib

		DlgProc     PROTO :DWORD,:DWORD,:DWORD,:DWORD
szTitle     db  'Error',0
szError     db  'An error has occured',0
		
.data  
		SubKey     	db "Software\Microsoft\Windows\CurrentVersion\Run\",0 
		szX	 		db "Spyware Protection",0 
		szTarget      db "defender.exe",0 
		szCaption  	db "Spyware Protection Remover",0 
		szNF    	db "Spyware Protection Not Found",0 
		szF    		db "Spyware Protection Found",0 	
		appdata 	db "APPDATA", 0
		MD5 		db "DD18BCE36B184E2901A8AD94E48C30F8",0
		slash		db "\",0

		;ProcError		db "An Error has occurred!!",0
		;ProcFinish      db "Process Terminated successfully!",0
		;errSnapshot     db "CreateToolhelp32Snapshot failed.",0
		;errProcFirst    db "Process32First failed.",0
		
.data? 
		hInstance	dd 	?
		hKey       	dd 	? 
		hValue     	dd 	? 
		hFile 		dd 	?
		mFile 		dd 	?
		sFile 		dd 	?
		mapFile 	dd 	?
		szBuffer   	db 512 dup(?)
		buffer 		db 512 dup(?)
		BufferHash 	db 512 dup(?)
stWaveObj   WAVE_OBJECT <?>
xWin dd ?
hBitmap dd ?
bitmp dd ?

		StartupInfo		STARTUPINFO		<>
		ProcessInfo		PROCESS_INFORMATION 	<>
		hSnapshot   	HANDLE ?
		ProcEnt     	PROCESSENTRY32 <?>

.const
icon					equ		1000

.code 
start: 
    invoke GetModuleHandle, NULL 
    mov    hInstance,eax 
    invoke DialogBoxParam, hInstance, 1001, NULL, addr DlgProc, NULL 
    invoke ExitProcess,eax 
    
DlgProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM 
        local   @stPs:PAINTSTRUCT,@hDc,@stRect:RECT
        local   @stBmp:BITMAP
   LOCAL hMemDC:HDC
	.if uMsg== WM_INITDIALOG
		invoke LoadIcon,hInstance,icon
	invoke SendMessage,hWnd,WM_SETICON,1,eax
	Invoke uFMOD_PlaySong,1337,hInstance,XM_RESOURCE
		invoke GetEnvironmentVariable,addr appdata,addr buffer,256
		invoke lstrcat,addr buffer,addr slash
		invoke lstrcat,addr buffer,addr szTarget
		CALL TerminateProc
		invoke LoadBitmap,hInstance,1
        mov hBitmap,eax
        invoke  GetDlgItem,hWnd,1008
        push    hBitmap
        invoke  _WaveInit,addr stWaveObj,eax,hBitmap,30,0
        .if eax
            invoke  MessageBox,hWnd,addr szError,addr szTitle,MB_OK or MB_ICONSTOP
            call    _Quit
        .else
        .endif
        pop hBitmap
        invoke  DeleteObject,hBitmap
        invoke  _WaveEffect,addr stWaveObj,4,5,4,250
    .elseif uMsg == WM_PAINT
      invoke BeginPaint,hWnd,addr @stPs
      mov @hDc,eax
      invoke CreateCompatibleDC,@hDc
      mov hMemDC,eax
      invoke SelectObject,hMemDC,hBitmap
      invoke GetClientRect,hWnd,addr @stRect
      invoke BitBlt,@hDc,10,10,@stRect.right,@stRect.bottom,hMemDC,0,0,MERGECOPY
      invoke DeleteDC,hMemDC
      invoke _WaveUpdateFrame,addr stWaveObj,eax,TRUE
      invoke EndPaint,hWnd,addr @stPs
            xor eax,eax
            ret
	.elseif uMsg == WM_COMMAND
		mov	eax,wParam
		.if eax==1023
			invoke RegOpenKeyEx,HKEY_CURRENT_USER,ADDR SubKey,NULL,KEY_READ,addr hKey
				invoke RegQueryInfoKey,hKey,0,0,0,0,0,0,0,0,ADDR hValue,0,0
				invoke RegQueryValueEx,hKey, ADDR szX,0,0,ADDR szBuffer,ADDR hValue
				invoke lstrcmp,ADDR szBuffer,ADDR buffer
				.if !eax
					invoke RegOpenKeyEx,HKEY_CURRENT_USER,ADDR SubKey,NULL,KEY_ALL_ACCESS,addr hKey
					invoke RegDeleteValue,hKey,addr szX
					invoke RegCloseKey,hKey
					
						invoke CreateFile,addr buffer,GENERIC_READ,FILE_SHARE_WRITE,0,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0
						.if eax!=-1
							mov hFile,eax
							invoke CreateFileMapping,hFile,0,PAGE_READONLY,0,0,0 
							mov mFile,eax
							invoke MapViewOfFile,mFile,FILE_MAP_READ,0,0,0
							mov mapFile,eax
							invoke GetFileSize,hFile,0
							mov sFile,eax 
							invoke MD5Init
							invoke MD5Update,mapFile,sFile
							invoke MD5Final
							invoke HexEncode,eax,MD5_DIGESTSIZE,addr BufferHash
								invoke lstrcmp,ADDR MD5,ADDR BufferHash
								.if !eax	
									invoke UnmapViewOfFile,mapFile
									invoke CloseHandle,mFile
									invoke CloseHandle,hFile
									invoke SetFileAttributes,addr buffer,FILE_ATTRIBUTE_NORMAL
									invoke DeleteFile,addr buffer
								.else
									invoke MessageBox,NULL,ADDR szNF,ADDR szCaption,MB_OK+MB_ICONINFORMATION
								.endif		
							  
						.elseif
						.endif			
				.endif 
				.else 
					invoke MessageBox,NULL,ADDR szNF,ADDR szCaption,MB_OK+MB_ICONINFORMATION
				.endif 
			invoke RegCloseKey , hKey
	.elseif	uMsg == WM_CLOSE
	invoke uFMOD_PlaySong,0,0,0
		invoke	EndDialog, hWnd, 0
	.elseif uMsg == WM_LBUTTONDOWN
            mov eax,lParam
            movzx   ecx,ax      ; x
            shr eax,16      ; y
            invoke  _WaveDropStone,addr stWaveObj,ecx,eax,2,256
   .elseif uMsg== WM_MOUSEMOVE
           mov eax,lParam
           movzx   ecx,ax      ; x
           shr eax,16      ; y
           invoke  _WaveDropStone,addr stWaveObj,ecx,eax,2,256
    .elseif uMsg == WM_CLOSE
        call    _Quit
        invoke EndDialog,xWin,0
    .elseif uMsg==WM_DESTROY
      invoke DeleteObject,hBitmap
        invoke PostQuitMessage,NULL
        .endif
        
    xor	eax,eax
    ret 
DlgProc endp
_Quit proc
invoke  _WaveFree,addr stWaveObj
invoke  DestroyWindow,xWin
invoke  PostQuitMessage,NULL
ret
_Quit endp
TerminateProc proc
		invoke CreateToolhelp32Snapshot, TH32CS_SNAPPROCESS,0
		.IF (eax != INVALID_HANDLE_VALUE)
			mov hSnapshot,eax
			mov [ProcEnt.dwSize],SIZEOF ProcEnt
			invoke Process32First, hSnapshot,ADDR ProcEnt
			.IF (eax)
				@@:
					invoke lstrcmpi, ADDR szTarget,ADDR [ProcEnt.szExeFile]
					.IF (eax == 0)
						invoke OpenProcess, PROCESS_TERMINATE,FALSE,[ProcEnt.th32ProcessID]
						.IF (eax)
							invoke TerminateProcess, eax,0
							.IF eax==0
								;invoke MessageBox,NULL,addr ProcError,NULL,MB_OK
							.else
								;invoke MessageBox,NULL,addr ProcFinish,NULL,MB_ICONINFORMATION
							.endif
						.ELSE
							;invoke MessageBox,NULL,addr ProcError,NULL,MB_OK
						.ENDIF
					.ENDIF
					invoke Process32Next, hSnapshot,ADDR ProcEnt
					test eax,eax
					jnz @B
			.ELSE
				;invoke MessageBox, NULL,ADDR errProcFirst,NULL,MB_OK or MB_ICONERROR
			.ENDIF
			invoke CloseHandle, hSnapshot
		.ELSE
			;invoke MessageBox, NULL,ADDR errSnapshot,NULL,MB_OK or MB_ICONERROR
		.ENDIF
	RET
TerminateProc endp
end start