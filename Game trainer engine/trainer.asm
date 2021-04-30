.486
.model	flat, stdcall
option	casemap :none   ; case sensitive
; Trainer template by Xylitol
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
include \masm32\include\comctl32.inc

includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib
includelib \masm32\lib\comctl32.lib

DlgProc       PROTO :DWORD,:DWORD,:DWORD,:DWORD
TrainerEngine PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD

.const
IDD_DIALOG      equ 1000
IDB_HEALTH      equ 1001
IDB_AMMO        equ 1002
IDB_KILL        equ 1003
IDB_MONEY       equ 1004
IDB_NODES       equ 1005
IDB_SHIPLIFE    equ 1006
IDC_STATIC1005  equ 1007
IDC_STATIC1006  equ 1008
IDC_STATIC1007  equ 1009
IDC_STATIC1008  equ 1010
IDC_STATIC1009  equ 1011
IDC_STATIC1010  equ 1012
IDC_STATIC1011  equ 1013

.data
;Dialog details
szTitle         db "Dead Space v1.0.0.222 Trainer +6",0 ;works with Dead.Space-RELOADED
szIDBCheatON    db "[ENABLE]",0
szIDBCheatOFF   db "[DISABLE]",0
szErrorCaption  db "ERROR", 0
szErrorMessage  db "Game is not Running",0ah 
                db "You need to run the game",0ah
                db "So You can Use the trainer",0
szHotkeyHelp    db "Hotkeys", 0
szHotkeyF12     db "F12 - Unlimited health/oxygen/stasis", 0
szHotkeyF11     db "F11 - Unlimited Ammo", 0
szHotkeyF10     db "F10 - One Hit Kill", 0
szHotkeyF9      db "F9   - Unlimited credits", 0
szHotkeyF8      db "F8   - Unlimited nodes", 0
szHotkeyF7      db "F7   - Unlimited Ship health", 0

;Game patching details
GameCaption     db "Dead Space",0 ; The window name of game

Offset1         dd 4F9101h	 ; Unlimited AMMO
bytes2write1    db 0E9h,017h,0D2h,0CFh,000h,090h ; JMP 011F631D
bytes2Restore1  db 08Bh,088h,084h,006h,000h,000h ; MOV ECX,DWORD PTR DS:[EAX+684]
Offset2         dd 011F631Dh ; Unlimited AMMO (codecave)
bytes2write2    db 0C7h,080h,084h,006h,000h,000h,0E7h,003h,000h,000h, ;MOV DWORD PTR DS:[EAX+684],3E7 | put 999
                   089h,00Dh,019h,000h,040h,000h,                     ;MOV DWORD PTR DS:[400019],ECX
                   08Bh,088h,084h,006h,000h,000h,                     ;MOV ECX,DWORD PTR DS:[EAX+684]
                   0E9h,0CFh,02Dh,030h,0FFh                           ;JMP 004F9107
bytes2Restore2  db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h

Offset3         dd 526FE9h	 ; Unlimited Healt/Oxygen/Stasis
bytes2write3    db 0E9h,04Ah,0F3h,0CCh,000h,090h,090h ; JMP 011F6338
bytes2Restore3  db 00Fh,02Fh,080h,020h,001h,000h,000h ; COMISS XMM0,DWORD PTR DS:[EAX+120]
Offset4         dd 011F6338h ; Unlimited Healt/Oxygen/Stasis (codecave)
Offset5         dd 011F634Bh
Offset6         dd 011F6361h
Offset7         dd 011F6374h
Offset8         dd 011F638Ah
bytes2write4    db 09Ch,                                              ;PUSHFD
                   060h,                                              ;PUSHAD
                   083h,03Dh,0CDh,001h,040h,000h,001h,                ;CMP DWORD PTR DS:[4001CD],1
                   0C7h,005h,0CDh,001h,040h,000h,001h,000h,000h,000h  ;MOV DWORD PTR DS:[4001CD],1
bytes2write5    db 075h,014h,                                         ;JNZ SHORT 011F6361
                   0C7h,080h,020h,001h,000h,000h,000h,080h,03Bh,045h, ;MOV DWORD PTR DS:[EAX+120],453B8000 (float 3000.000)
                   0C7h,080h,01Ch,001h,000h,000h,000h,080h,03Bh,045h  ;MOV DWORD PTR DS:[EAX+11C],453B8000 (float 3000.000)
bytes2write6    db 083h,03Dh,0AEh,001h,040h,000h,001h,                ;CMP DWORD PTR DS:[4001AE],1
                   0C7h,005h,0AEh,001h,040h,000h,001h,000h,000h,000h, ;MOV DWORD PTR DS:[4001AE],1
                   075h,014h                                          ;JNZ SHORT 011F6388
bytes2write7    db 0C7h,080h,028h,001h,000h,000h,000h,000h,0C8h,042h, ;MOV DWORD PTR DS:[EAX+128],42C80000
                   0C7h,080h,02Ch,001h,000h,000h,000h,000h,0C8h,042h, ;MOV DWORD PTR DS:[EAX+12C],42C80000
                   061h,                                              ;POPAD 
                   09Dh                                               ;POPFD
bytes2write8    db 00Fh,02Fh,080h,020h,001h,000h,000h,                ;COMISS XMM0,DWORD PTR DS:[EAX+120]
                   0E9h,05Ah,00Ch,033h,0FFh                           ;JMP 00526FF0

Offset9         dd 004518DEh ; one hit kill
bytes2write9    db 0E9h,0B3h,04Ah,0DAh,000h,090h,090h,090h ; JMP 011F6396
bytes2Restore9  db 0F3h,00Fh,010h,087h,020h,001h,000h,000h ; MOVSS XMM0,DWORD PTR DS:[EDI+120]
Offset10        dd 011F6396h ; one hit kill (codecave)
bytes2write10   db 0C7h,087h,020h,001h,000h,000h,000h,000h,000h,000h, ;MOV DWORD PTR DS:[EDI+120],0
                   0F3h,00Fh,010h,087h,020h,001h,000h,000h,           ;MOVSS XMM0,DWORD PTR DS:[EDI+120]
                   0E9h,039h,0B5h,025h,0FFh                           ;JMP 004518E6

Offset11        dd 005808E7h ; Unlimited credits
bytes2write11   db 0E9h,0C1h,05Ah,0C7h,000h,090h ; JMP 011F63AD)
bytes2Restore11 db 08Bh,082h,0E4h,00Ch,000h,000h ; MOV EAX,DWORD PTR DS:[EDX+CE4]
Offset12        dd 011F63ADh ; Unlimited credits (codecave)       
bytes2write12   db 0C7h,082h,0E4h,00Ch,000h,000h,07Fh,096h,098h,000h, ;MOV DWORD PTR DS:[EDX+CE4],98967F | put 9999999
                   089h,005h,0E5h,001h,040h,000h,                     ;MOV DWORD PTR DS:[4001E5],EAX
                   08Bh,082h,0E4h,00Ch,000h,000h,                     ;MOV EAX,DWORD PTR DS:[EDX+CE4]
                   0E9h,025h,0A5h,038h,0FFh                           ;JMP 005808ED

Offset13        dd 00521610h ; Unlimited nodes
bytes2write13   db 0E9h,0B3h,04Dh,0CDh,000h,090h ; JMP 011F63C8
bytes2Restore13 db 08Bh,081h,094h,005h,000h,000h ; MOV EAX,DWORD PTR DS:[ECX+594]
Offset14        dd 011F63C8h ; Unlimited nodes (codecave)
bytes2write14   db 0C7h,081h,094h,005h,000h,000h,07Fh,096h,098h,000h, ;MOV DWORD PTR DS:[ECX+594],98967F | put 9999999
                   089h,005h,00Ch,001h,040h,000h,                     ;MOV DWORD PTR DS:[40010C],EAX
                   08Bh,081h,094h,005h,000h,000h,                     ;MOV EAX,DWORD PTR DS:[ECX+594]
                   0E9h,033h,0B2h,032h,0FFh                           ;JMP 00521616

; Used only in Chapter 4 with the Asteroid Defense System cannon shooting/minigame
Offset15        dd 005BE9ACh ; Unlimited Ship health
Offset16        dd 005BE9F6h ; Unlimited Ship health (offset2)
bytes2write1516   db 090h,090h,090h,090h,090h,090h,090h,090h ; NOPS
bytes2Restore1516 db 0F3h,00Fh,011h,083h,094h,007h,000h,000h ; MOVSS DWORD PTR DS:[EBX+794],XMM0

.data?
hInstance       dd ?
windhand        dd ? ; Window handle
hwnddlg         dd ? ; Window handle
phandle         dd ? ; Process handle of game
pid             dd ? ; Process id of game
status1		    dd ? ; on/off
status2		    dd ? ; on/off
status3		    dd ? ; on/off
status4		    dd ? ; on/off
status5		    dd ? ; on/off
status6		    dd ? ; on/off

.code
start:
    invoke GetModuleHandle, NULL
    invoke DialogBoxParam, hInstance, IDD_DIALOG, 0, ADDR DlgProc, 0
    invoke ExitProcess, eax
; -----------------------------------------------------------------------
DlgProc	proc    hWin    :DWORD,
        uMsg    :DWORD,
        wParam  :DWORD,
        lParam  :DWORD

	.if uMsg == WM_INITDIALOG ; When our program is executed
        pushad ; Saving registry is needed... the program will crash if you omit this
        ; Set the dialog controls texts. Done here in the code instead of resource
        ; file to reduce the required bytes (strings in the rc file are UNICODE not ANSI)
        invoke SetWindowText,hWin,ADDR szTitle ; Set the window title text
        invoke SetDlgItemText,hWin,IDB_HEALTH,ADDR szIDBCheatON
        invoke SetDlgItemText,hWin,IDB_AMMO,ADDR szIDBCheatON
        invoke SetDlgItemText,hWin,IDB_KILL,ADDR szIDBCheatON
        invoke SetDlgItemText,hWin,IDB_MONEY,ADDR szIDBCheatON
        invoke SetDlgItemText,hWin,IDB_NODES,ADDR szIDBCheatON
        invoke SetDlgItemText,hWin,IDB_SHIPLIFE,ADDR szIDBCheatON
        invoke SetDlgItemText,hWin,IDC_STATIC1005,ADDR szHotkeyHelp
        invoke SetDlgItemText,hWin,IDC_STATIC1006,ADDR szHotkeyF12
        invoke SetDlgItemText,hWin,IDC_STATIC1007,ADDR szHotkeyF11
        invoke SetDlgItemText,hWin,IDC_STATIC1008,ADDR szHotkeyF10
        invoke SetDlgItemText,hWin,IDC_STATIC1009,ADDR szHotkeyF9        
        invoke SetDlgItemText,hWin,IDC_STATIC1010,ADDR szHotkeyF8        
        invoke SetDlgItemText,hWin,IDC_STATIC1011,ADDR szHotkeyF7      
        mov hwnddlg, eax
        invoke SetTimer,hWin,0,90, 0 ;set the timer for monitoring action keystrokes
        mov status1,0
        mov status2,0
        mov status3,0
        mov status4,0
        mov status5,0
        mov status6,0
	.elseif	uMsg == WM_COMMAND ; Did the user press a button
        .if wParam == IDB_HEALTH
            @HEALTH:
            ; Find the game window
            invoke FindWindow, NULL, addr GameCaption
            ; The game is running
            .if eax != NULL
                .if status1 == 1
                  mov status1,0 ; Disable
                  invoke TrainerEngine, offset GameCaption, Offset3, offset bytes2Restore3, NULL, NULL,7
                  invoke SetDlgItemText,hWin,IDB_HEALTH,ADDR szIDBCheatON
                  invoke Beep,1000,30
                .else
                  mov status1,1 ; Enable
                  invoke TrainerEngine, offset GameCaption, Offset3, offset bytes2write3, NULL, NULL,7
                  invoke TrainerEngine, offset GameCaption, Offset4, offset bytes2write4, NULL, NULL,19
                  invoke TrainerEngine, offset GameCaption, Offset5, offset bytes2write5, NULL, NULL,22
                  invoke TrainerEngine, offset GameCaption, Offset6, offset bytes2write6, NULL, NULL,19
                  invoke TrainerEngine, offset GameCaption, Offset7, offset bytes2write7, NULL, NULL,22
                  invoke TrainerEngine, offset GameCaption, Offset8, offset bytes2write8, NULL, NULL,12
                  invoke SetDlgItemText,hWin,IDB_HEALTH,ADDR szIDBCheatOFF
                  invoke Beep,5000,30
                .endif
            ;If game is not running
            .else
                invoke Beep,100,30
                ; Show the error message
                invoke MessageBox,hWin,addr szErrorMessage,addr szErrorCaption,MB_ICONERROR
            .endif
        .endif
        .if wParam == IDB_AMMO
            @AMMO:
            ; Find the game window
            invoke FindWindow, NULL, addr GameCaption
            ; The game is running
            .if eax != NULL
                .if status2 == 1
                  mov status2,0 ; Disable
                  invoke TrainerEngine, offset GameCaption, Offset1, offset bytes2Restore1, NULL, NULL,6
                  invoke TrainerEngine, offset GameCaption, Offset2, offset bytes2Restore2, NULL, NULL,27
                  invoke Beep,1000,30
                  invoke SetDlgItemText,hWin,IDB_AMMO,ADDR szIDBCheatON
                .else
                  mov status2,1 ; Enable
                  invoke TrainerEngine, offset GameCaption, Offset1, offset bytes2write1, NULL, NULL,6
                  invoke TrainerEngine, offset GameCaption, Offset2, offset bytes2write2, NULL, NULL,28
                  invoke SetDlgItemText,hWin,IDB_AMMO,ADDR szIDBCheatOFF
                  invoke Beep,5000,30
                .endif
            ;If game is not running
            .else
                invoke Beep,100,30
                ; Show the error message
                invoke MessageBox,hWin,addr szErrorMessage,addr szErrorCaption,MB_ICONERROR
            .endif
        .endif
        .if wParam == IDB_KILL
            @KILL:
            ; Find the game window
            invoke FindWindow, NULL, addr GameCaption
            ; The game is running
            .if eax != NULL
                .if status3 == 1
                  mov status3,0 ; Disable
                  invoke TrainerEngine, offset GameCaption, Offset9, offset bytes2Restore9, NULL, NULL,8
                  invoke SetDlgItemText,hWin,IDB_KILL,ADDR szIDBCheatON
                  invoke Beep,1000,30
                .else
                  mov status3,1 ; Enable
                  invoke TrainerEngine, offset GameCaption, Offset9, offset bytes2write9, NULL, NULL,8
                  invoke TrainerEngine, offset GameCaption, Offset10, offset bytes2write10, NULL, NULL,23
                  invoke SetDlgItemText,hWin,IDB_KILL,ADDR szIDBCheatOFF
                  invoke Beep,5000,30
                .endif
            ;If game is not running
            .else
                invoke Beep,100,30
                ; Show the error message
                invoke MessageBox,hWin,addr szErrorMessage,addr szErrorCaption,MB_ICONERROR
            .endif
        .endif
        .if wParam == IDB_MONEY
            @MONEY:
            ; Find the game window
            invoke FindWindow, NULL, addr GameCaption
            ; The game is running
            .if eax != NULL
                .if status4 == 1
                  mov status4,0 ; Disable
                  invoke TrainerEngine, offset GameCaption, Offset11, offset bytes2Restore11, NULL, NULL,6
                  invoke SetDlgItemText,hWin,IDB_MONEY,ADDR szIDBCheatON
                  invoke Beep,1000,30
                .else
                  mov status4,1 ; Enable
                  invoke TrainerEngine, offset GameCaption, Offset11, offset bytes2write11, NULL, NULL,6
                  invoke TrainerEngine, offset GameCaption, Offset12, offset bytes2write12, NULL, NULL,27
                  invoke SetDlgItemText,hWin,IDB_MONEY,ADDR szIDBCheatOFF
                  invoke Beep,5000,30
                .endif
            ;If game is not running
            .else
                invoke Beep,100,30
                ; Show the error message
                invoke MessageBox,hWin,addr szErrorMessage,addr szErrorCaption,MB_ICONERROR
            .endif
        .endif
        .if wParam == IDB_NODES
            @NODES:
            ; Find the game window
            invoke FindWindow, NULL, addr GameCaption
            ; The game is running
            .if eax != NULL
                .if status5 == 1
                  mov status5,0 ; Disable
                  invoke TrainerEngine, offset GameCaption, Offset13, offset bytes2Restore13, NULL, NULL,6
                  invoke SetDlgItemText,hWin,IDB_NODES,ADDR szIDBCheatON
                  invoke Beep,1000,30
                .else
                  mov status5,1 ; Enable
                  invoke TrainerEngine, offset GameCaption, Offset13, offset bytes2write13, NULL, NULL,6
                  invoke TrainerEngine, offset GameCaption, Offset14, offset bytes2write14, NULL, NULL,27
                  invoke SetDlgItemText,hWin,IDB_NODES,ADDR szIDBCheatOFF
                  invoke Beep,5000,30
                .endif
            ;If game is not running
            .else
                invoke Beep,100,30
                ; Show the error message
                invoke MessageBox,hWin,addr szErrorMessage,addr szErrorCaption,MB_ICONERROR
            .endif
        .endif
        .if wParam == IDB_SHIPLIFE
            @SHIPLIFE:
            ; Find the game window
            invoke FindWindow, NULL, addr GameCaption
            ; The game is running
            .if eax != NULL
                .if status6 == 1
                  mov status6,0 ; Disable
                  invoke TrainerEngine, offset GameCaption, Offset15, offset bytes2Restore1516, NULL, NULL,8
                  invoke TrainerEngine, offset GameCaption, Offset16, offset bytes2Restore1516, NULL, NULL,8
                  invoke SetDlgItemText,hWin,IDB_SHIPLIFE,ADDR szIDBCheatON
                  invoke Beep,1000,30
                .else
                  mov status6,1 ; Enable
                  invoke TrainerEngine, offset GameCaption, Offset15, offset bytes2write1516, NULL, NULL,8
                  invoke TrainerEngine, offset GameCaption, Offset16, offset bytes2write1516, NULL, NULL,8
                  invoke SetDlgItemText,hWin,IDB_SHIPLIFE,ADDR szIDBCheatOFF
                  invoke Beep,5000,30
                .endif
            ;If game is not running
            .else
                invoke Beep,100,30
                ; Show the error message
                invoke MessageBox,hWin,addr szErrorMessage,addr szErrorCaption,MB_ICONERROR
            .endif
        .endif
	.elseif uMsg == WM_TIMER
    invoke GetAsyncKeyState, VK_F12 ; Was F12 pressed?
      .if eax != 0 ; If yes
         jmp @HEALTH
      .endif
     invoke GetAsyncKeyState, VK_F11 ; Was F11 pressed?
      .if eax != 0 ; If yes
         jmp @AMMO
      .endif
     invoke GetAsyncKeyState, VK_F10 ; Was F10 pressed?
      .if eax != 0 ; If yes
         jmp @KILL
      .endif
     invoke GetAsyncKeyState, VK_F9 ; Was F9 pressed?
      .if eax != 0 ; If yes
         jmp @MONEY
      .endif
     invoke GetAsyncKeyState, VK_F8 ; Was F8 pressed?
      .if eax != 0 ; If yes
         jmp @NODES
      .endif
     invoke GetAsyncKeyState, VK_F7 ; Was F7 pressed?
      .if eax != 0 ; If yes
         jmp @SHIPLIFE
      .endif
	.elseif	uMsg == WM_CLOSE
        invoke AnimateWindow,hWin,300,AW_BLEND+AW_HIDE 
        invoke EndDialog,hWin,0
	.endif
	xor	eax,eax
	ret
DlgProc	endp

TrainerEngine PROC lpWindCap:DWORD, lpAdress:DWORD, lpNewValue:DWORD, nAdd:DWORD, lpBuffer:DWORD, _byteSize:DWORD
       ; Find the game window (again)
       invoke FindWindow, NULL, lpWindCap
       ; The game is running
       .if eax != NULL
           ; Move the handle to windhand
           mov windhand, eax
           ; Get the process ID and save it to pid
           invoke GetWindowThreadProcessId, windhand, offset pid
           ; Open the process
           invoke OpenProcess, PROCESS_ALL_ACCESS,NULL, pid
           ; Move our process handle to phandle
           mov phandle, eax
           ; Prepare the ground for writing
           invoke VirtualProtectEx, phandle, lpAdress, _byteSize, PAGE_EXECUTE_READWRITE, 00
           ; Write the new value
           invoke WriteProcessMemory,phandle, lpAdress, lpNewValue, _byteSize, NULL
           ; Close handle
           invoke CloseHandle, phandle
       ; If game is not running
       .else
           invoke Beep,100,30
           ; Show the error message
           invoke MessageBox,hwnddlg,addr szErrorMessage,addr szErrorCaption,MB_ICONERROR
       .endif
ret ; Return
TrainerEngine ENDP

end start