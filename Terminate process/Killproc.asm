.386
.model flat, stdcall
option casemap:none

include			\masm32\include\windows.inc
include			\masm32\include\user32.inc
include			\masm32\include\kernel32.inc

includelib		\masm32\lib\user32.lib
includelib		\masm32\lib\kernel32.lib


.data
TargetName         db "calc.exe",0
ProcError        db "An Error Finding has occurred!!",0
ProcFinish      db "Process Terminated successfully!",0
errSnapshot     db "CreateToolhelp32Snapshot failed.",0
errProcFirst    db "Process32First failed.",0
        
.data?
StartupInfo        STARTUPINFO        <>
ProcessInfo        PROCESS_INFORMATION     <>
hSnapshot       HANDLE ?
ProcEnt         PROCESSENTRY32 <?>

      
.code
start:
        invoke CreateToolhelp32Snapshot, TH32CS_SNAPPROCESS,0
        .IF (eax != INVALID_HANDLE_VALUE)
            mov hSnapshot,eax
            mov [ProcEnt.dwSize],SIZEOF ProcEnt
            invoke Process32First, hSnapshot,ADDR ProcEnt
            .IF (eax)
                @@:
                    invoke lstrcmpi, ADDR TargetName ,ADDR [ProcEnt.szExeFile]
                    .IF (eax == 0)
                        invoke OpenProcess, PROCESS_TERMINATE,FALSE,[ProcEnt.th32ProcessID]
                        .IF (eax)
                            invoke TerminateProcess, eax,0
                            .IF eax==0
                                invoke MessageBox,NULL,addr ProcError,NULL,MB_OK
                            .else
                                invoke MessageBox,NULL,addr ProcFinish,NULL,MB_ICONINFORMATION
                            .endif
                        .ELSE
                            invoke MessageBox,NULL,addr ProcError,NULL,MB_OK
                        .ENDIF
                    .ENDIF
                    invoke Process32Next, hSnapshot,ADDR ProcEnt
                    test eax,eax
                    jnz @B
            .ELSE
                invoke MessageBox, NULL,ADDR errProcFirst,NULL,MB_OK or MB_ICONERROR
            .ENDIF
            invoke CloseHandle, hSnapshot
        .ELSE
            invoke MessageBox, NULL,ADDR errSnapshot,NULL,MB_OK or MB_ICONERROR
        .ENDIF
invoke ExitProcess,1
end start