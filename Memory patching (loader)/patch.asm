.486
.model flat,stdcall
option casemap:none
; Braviax Multi-rogue patcher by Xylitol
include windows.inc

uselib  MACRO   libname
    include     libname.inc
    includelib  libname.lib
ENDM

uselib  user32
uselib  kernel32

rogue PROTO :DWORD,:DWORD,:DWORD,:DWORD

.data
Titre           db "Braviax multi-rogue generic patch", 0
PasTrouver  db "Thread not found",0
Trouver     db "Patched successfully",13,10,"Enter anything in the serial field for activate",0

szFileName1  db "XP Anti-Virus - Unregistred Version",0
szFileName2  db "XP Anti-Virus 2011 - Unregistred Version",0
szFileName3  db "XP Anti-Spyware - Unregistred Version",0
szFileName4  db "XP Anti-Spyware 2011 - Unregistred Version",0
szFileName5  db "XP Home Security - Unregistred Version",0
szFileName6  db "XP Home Security 2011 - Unregistred Version",0
szFileName7  db "XP Total Security - Unregistred Version",0
szFileName8  db "XP Total Security 2011 - Unregistred Version",0
szFileName9  db "XP Security - Unregistred Version",0
szFileName10  db "XP Security 2011 - Unregistred Version",0
szFileName11  db "XP Internet Security - Unregistred Version",0
szFileName12  db "XP Internet Security 2011 - Unregistred Version",0
szFileName13  db "Win 7 Anti-Virus - Unregistred Version",0
szFileName14  db "Win 7 Anti-Virus 2011 - Unregistred Version",0
szFileName15  db "Win 7 Anti-Spyware - Unregistred Version",0
szFileName16  db "Win 7 Anti-Spyware 2011 - Unregistred Version",0
szFileName17  db "Win 7 Home Security - Unregistred Version",0
szFileName18  db "Win 7 Home Security 2011 - Unregistred Version",0
szFileName19  db "Win 7 Total Security - Unregistred Version",0
szFileName20  db "Win 7 Total Security 2011 - Unregistred Version",0
szFileName21  db "Win 7 Security - Unregistred Version",0
szFileName22  db "Win 7 Security 2011 - Unregistred Version",0
szFileName23  db "Win 7 Internet Security - Unregistred Version",0
szFileName24  db "Win 7 Internet Security 2011 - Unregistred Version",0
szFileName25  db "Vista Anti-Virus - Unregistred Version",0
szFileName26  db "Vista Anti-Virus 2011 - Unregistred Version",0
szFileName27  db "Vista Anti-Spyware - Unregistred Version",0
szFileName28  db "Vista Anti-Spyware 2011 - Unregistred Version",0
szFileName29  db "Vista Home Security - Unregistred Version",0
szFileName30  db "Vista Home Security 2011 - Unregistred Version",0
szFileName31  db "Vista Total Security - Unregistred Version",0
szFileName32  db "Vista Total Security 2011 - Unregistred Version",0
szFileName33  db "Vista Security - Unregistred Version",0
szFileName34  db "Vista Security 2011 - Unregistred Version",0
szFileName35  db "Vista Internet Security - Unregistred Version",0
szFileName36  db "Vista Internet Security 2011 - Unregistred Version",0

AddressToPatch1 dd 0675356h ;0x0675356 (0x10, 16 digits check)
ReplaceBy1 db 090h,090h ;75 47 JNE SHORT 00675391 -> To NOP's
ReplaceSize1 dd 2 ;2 bytes changed
AddressToPatch2 dd 0675389h ;0x0675389 (badboy jump)k
ReplaceBy2 db 090h,090h,090h,090h,090h,090h ;0F85 F0010000   JNE 0067557F
ReplaceSize2 dd 6 ;6 bytes changed

.data?
PID         dd ?

.code
  start:
rogue proc hWin:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
            invoke FindWindow, NULL, offset szFileName1
            cmp eax,0
            jnz @patch
            invoke FindWindow, NULL, offset szFileName2
            cmp eax,0
            jnz @patch  
            invoke FindWindow, NULL, offset szFileName3
            cmp eax,0
            jnz @patch
            invoke FindWindow, NULL, offset szFileName4
            cmp eax,0
            jnz @patch    
            invoke FindWindow, NULL, offset szFileName5
            cmp eax,0
            jnz @patch
            invoke FindWindow, NULL, offset szFileName6
            cmp eax,0
            jnz @patch
            invoke FindWindow, NULL, offset szFileName7
            cmp eax,0
            jnz @patch
            invoke FindWindow, NULL, offset szFileName8
            cmp eax,0
            jnz @patch
            invoke FindWindow, NULL, offset szFileName9
            cmp eax,0
            jnz @patch
            invoke FindWindow, NULL, offset szFileName10
            cmp eax,0
            jnz @patch
            invoke FindWindow, NULL, offset szFileName11
            cmp eax,0
            jnz @patch
            invoke FindWindow, NULL, offset szFileName12
            cmp eax,0
            jnz @patch
            invoke FindWindow, NULL, offset szFileName13
            cmp eax,0
            jnz @patch
            invoke FindWindow, NULL, offset szFileName14
            cmp eax,0
            jnz @patch
            invoke FindWindow, NULL, offset szFileName15
            cmp eax,0
            jnz @patch
            invoke FindWindow, NULL, offset szFileName16
            cmp eax,0
            jnz @patch
            invoke FindWindow, NULL, offset szFileName17
            cmp eax,0
            jnz @patch
            invoke FindWindow, NULL, offset szFileName18
            cmp eax,0
            jnz @patch
            invoke FindWindow, NULL, offset szFileName19
            cmp eax,0
            jnz @patch
            invoke FindWindow, NULL, offset szFileName20
            cmp eax,0
            jnz @patch
            invoke FindWindow, NULL, offset szFileName21
            cmp eax,0
            jnz @patch
            invoke FindWindow, NULL, offset szFileName22
            cmp eax,0
            jnz @patch
            invoke FindWindow, NULL, offset szFileName23
            cmp eax,0
            jnz @patch
            invoke FindWindow, NULL, offset szFileName24
            cmp eax,0
            jnz @patch
            invoke FindWindow, NULL, offset szFileName25
            cmp eax,0
            jnz @patch
            invoke FindWindow, NULL, offset szFileName26
            cmp eax,0
            jnz @patch
            invoke FindWindow, NULL, offset szFileName27
            cmp eax,0
            jnz @patch
            invoke FindWindow, NULL, offset szFileName28
            cmp eax,0
            jnz @patch
            invoke FindWindow, NULL, offset szFileName29
            cmp eax,0
            jnz @patch
            invoke FindWindow, NULL, offset szFileName30
            cmp eax,0
            jnz @patch
            invoke FindWindow, NULL, offset szFileName31
            cmp eax,0
            jnz @patch
            invoke FindWindow, NULL, offset szFileName32
            cmp eax,0
            jnz @patch
            invoke FindWindow, NULL, offset szFileName33
            cmp eax,0
            jnz @patch
            invoke FindWindow, NULL, offset szFileName34
            cmp eax,0
            jnz @patch
            invoke FindWindow, NULL, offset szFileName35
            cmp eax,0
            jnz @patch
            invoke FindWindow, NULL, offset szFileName36
            cmp eax,0
            jnz @patch
                invoke Beep,100,30 ;lol :þ
                invoke MessageBox, NULL, addr PasTrouver, addr Titre, MB_ICONEXCLAMATION
                invoke ExitProcess,0
                @patch: call patch
                        invoke ExitProcess,0
rogue endp

patch proc
    mov ebx, eax
    Invoke GetWindowThreadProcessId, ebx, offset PID
    Invoke OpenProcess, PROCESS_ALL_ACCESS,NULL, PID
    mov ebx, eax
    Invoke VirtualProtectEx, ebx, AddressToPatch1, 2, PAGE_EXECUTE_READWRITE, 00
    Invoke WriteProcessMemory, ebx, AddressToPatch1, offset ReplaceBy1, ReplaceSize1, NULL
    Invoke VirtualProtectEx, ebx, AddressToPatch2, 2, PAGE_EXECUTE_READWRITE, 00
    Invoke WriteProcessMemory, ebx, AddressToPatch2, offset ReplaceBy2, ReplaceSize2, NULL
    Invoke CloseHandle, ebx
    invoke MessageBox, NULL, addr Trouver, addr Titre, MB_ICONINFORMATION
patch EndP

  end start 