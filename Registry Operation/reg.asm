.386 
.MODEL FLAT, STDCALL 
OPTION CASEMAP :NONE

INCLUDE 	WINDOWS.INC
INCLUDE 	USER32.INC
INCLUDE 	KERNEL32.INC
INCLUDE 	ADVAPI32.INC
INCLUDELIB 	USER32.LIB 
INCLUDELIB 	KERNEL32.LIB
INCLUDELIB 	ADVAPI32.LIB 
	
DlgProc			PROTO		:DWORD,:DWORD,:DWORD,:DWORD 


		
.DATA 
szCaption		db "Reg Exemple",0 

SubKey2			db "Software\rEd CrEw\",0
SubKey			db "Software\rEd CrEw\Members\",0
szCVal			db "Xylitol",0
szVal			db "Site Operator/Reverse Engineer",0



szHasRun		db "Thank you for running this program more then once.",0 

szNoRun			db "It seems you have never run this program before!",13,10 
				db "I will now add a item to the registry since you have ran this program",0 
				
szDeleted		db "Registry Deleted Successfully",0			
.DATA? 
hInstance	dd 	?
hKey       	dd 	? 
hValue     	dd 	? 
szBuffer   	db 	4 dup (?) 
szInput 	db 	256 dup(?)

.CODE 
start: 
    invoke GetModuleHandle, NULL 
    mov    hInstance,eax 
    invoke DialogBoxParam, hInstance, 1001, NULL, addr DlgProc, NULL 
    invoke ExitProcess,eax 
    
DlgProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM 

	.if uMsg == WM_COMMAND
		mov	eax,wParam
		.if eax==1023
			invoke RegOpenKeyEx,HKEY_LOCAL_MACHINE,ADDR SubKey,NULL,KEY_QUERY_VALUE,ADDR hKey ; OPEN OUR KEY 
			.if !eax 	; IF IT IS THERE WE MORE THEN LIKLEY WROTE IT 
				invoke RegQueryInfoKey, hKey,0,0,0,0,0,0,0,0,ADDR hValue,0,0 ; GET THE SIZE OF THE ENTRY 
				invoke RegQueryValueEx, hKey, ADDR szCVal,0,0,ADDR szBuffer,ADDR hValue ; GET THE VALUE AND KEEP IT IN THE BUFFER 
				invoke lstrcmp,ADDR szBuffer,ADDR szVal ; COMPARE IT OUR RAN STRING 
				.if !eax ; IF THEY ARE THE SAME IT MEANS THE USER HAS NOT MODIFIED IT 
					invoke MessageBox,NULL,ADDR szHasRun,ADDR szCaption,MB_ICONINFORMATION ; ALERT THEM
				.endif 
			.else 
				invoke MessageBox,NULL,ADDR szNoRun,ADDR szCaption,MB_ICONINFORMATION ; ALERT THE FACT WE HAVE NEVER BEEN RAN ON THIS MACHINE 
				invoke RegCreateKey,HKEY_LOCAL_MACHINE, ADDR SubKey,ADDR hKey ; CREATE THE KEY 
				.if !eax ; MAKE SURE IT DOES NOT FAIL 
					invoke RegSetValueEx,hKey,ADDR szCVal,0,REG_SZ,ADDR szVal,30 ; SET THE SZRAN STRING IN THE REGISTRY 
				.endif 
			.endif 
			invoke RegCloseKey , hKey ; CLOSE THE REGISTRY KEY
		.elseif eax==1025
			invoke RegOpenKeyEx,HKEY_LOCAL_MACHINE,ADDR SubKey,NULL,KEY_QUERY_VALUE,ADDR hKey ; OPEN OUR KEY
			invoke RegDeleteKey,HKEY_LOCAL_MACHINE,ADDR SubKey ; DELETE KEY --> Software\rEd CrEw\Members\
			invoke RegDeleteKey,HKEY_LOCAL_MACHINE,ADDR SubKey2 ; DELETE KEY --> Software\rEd CrEw
			invoke RegCloseKey,hKey ; CLOSE THE REGISTRY KEY
			invoke MessageBox,NULL,ADDR szDeleted,ADDR szCaption,MB_ICONINFORMATION
		.endif
	.elseif	uMsg == WM_CLOSE
		invoke	EndDialog, hWnd, 0
	.endif
        
    xor	eax,eax
    ret 
DlgProc endp

end start