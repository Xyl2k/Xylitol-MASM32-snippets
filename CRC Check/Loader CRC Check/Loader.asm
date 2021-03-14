.486
.model flat,stdcall
option casemap:none

include	\masm32\include\windows.inc

uselib	MACRO	libname
	include		\masm32\include\libname.inc
	includelib	\masm32\lib\libname.lib
ENDM
;Loader by RED CREW
uselib	user32
uselib	kernel32
uselib	comctl32
uselib	masm32
uselib	gdi32
uselib	ole32
uselib	oleaut32
uselib	advapi32
uselib	comdlg32
uselib	shell32

include \masm32\macros\macros.asm
include crc32.inc

crc32check PROTO :DWORD,:DWORD,:DWORD,:DWORD

.data
  Process db "Whatever.exe",0
  Error db "Whatever Patch",0
  ErrorMessage db "Process not loaded, please add Whatever.exe on the same folder of this loader",0
  CRCMessage db "CRC32 not match",0
  szFileName db "Whatever.exe",0
TargetCRC32  dd 82E2FCD0h ; 82E2FCD0
                                           
WriteError		db			"Error writing to target process",0
filenfound	db "Process not loaded, please add Whatever.exe on the same folder of this loader",0
    ;Patch the error message
AddressToPatch1 dd 05010D1h
ReplaceBy1 db 0EBh,03Fh,090h,090h,090h
ReplaceSize1 dd 5

AddressToPatch2 dd 0501F80h
ReplaceBy2 db 090h,090h
ReplaceSize2 dd 2
 
AddressToPatch3 dd 0401F86h
ReplaceBy3 db 090h,090h
ReplaceSize3 dd 2

  Startup STARTUPINFO <>
  processinfo PROCESS_INFORMATION <>

.data?
byteswritten dd ?
	
.code
  start:
crc32check proc hWin:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
LOCAL pFileMem:DWORD
LOCAL ff32:WIN32_FIND_DATA
				invoke FindFirstFile,ADDR szFileName,ADDR ff32
				call InitCRC32Table
				mov pFileMem,InputFile(ADDR szFileName)
				.if eax==0
					push 0
					push offset Error
					push offset filenfound
					push 0
					call MessageBox
					push 0
					call ExitProcess
				.else
					invoke CRC32,pFileMem,ff32.nFileSizeLow
					mov edx,TargetCRC32
					.if eax != edx
						push 0
						push offset Error
						push offset CRCMessage
						push 0
						call MessageBox
						push 0
						call ExitProcess
					.else	
						invoke CreateProcess, ADDR Process, NULL, NULL, NULL, NULL, NULL, NULL, NULL, ADDR Startup, ADDR processinfo
						.if eax==0
							push 0
							push offset Error
							push offset ErrorMessage
							push 0
							call MessageBox
							push 0
							call ExitProcess
						.else			
							invoke Sleep,1000 ; waiting 1sec for target initialisation
							invoke WriteProcessMemory, processinfo.hProcess, AddressToPatch1, ADDR ReplaceBy1, ReplaceSize1, byteswritten
							invoke WriteProcessMemory, processinfo.hProcess, AddressToPatch2, ADDR ReplaceBy2, ReplaceSize2, byteswritten
							invoke WriteProcessMemory, processinfo.hProcess, AddressToPatch3, ADDR ReplaceBy3, ReplaceSize3, byteswritten
							push 0
							call ExitProcess																		
						.endif	
					.endif
				.endif	
crc32check endp
  end start 