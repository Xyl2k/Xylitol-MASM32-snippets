.486
.model	flat, stdcall
option	casemap :none   ; case sensitive

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
IDB_VELOCITY    equ 1007
IDC_STATIC1005  equ 1008
IDC_STATIC1006  equ 1009
IDC_STATIC1007  equ 1010
IDC_STATIC1008  equ 1011
IDC_STATIC1009  equ 1012
IDC_STATIC1010  equ 1013
IDC_STATIC1011  equ 1014
IDC_STATIC1012  equ 1015
.data
;Dialog details
szTitle         db "Dead Space v1.0.0.222 Trainer +7",0 
szIDBCheatON    db "[ENABLE]",0
szIDBCheatOFF   db "[DISABLE]",0
szErrorCaption  db "ERROR", 0
szErrorMessage  db "Game is not Running",0ah 
                db "You need to run the game",0ah
                db "So You can Use the trainer",0
szHotkeyHelp    db "Hotkeys", 0
szHotkeyF12     db "F12 - Unlimited health and stasis", 0
szHotkeyF11     db "F11 - Unlimited Ammo", 0
szHotkeyF10     db "F10 - One Hit Kill", 0
szHotkeyF9      db "F9   - Unlimited credits", 0
szHotkeyF8      db "F8   - Unlimited nodes", 0
szHotkeyF7      db "F7   - Unlimited Ship health", 0
szHotkeyF6      db "F6   - Super speed", 0

;Game patching details
;Tested with Dead.Space-RELOADED
GameCaption     db "Dead Space",0 ; The window name of game
GameClass       db "DeadSpaceWndClass",0 ;game class

Offset1         dd 4F9101h ; Unlimited ammunition
bytes2write1    db 0E9h,017h,0D2h,0CFh,000h,090h ; JMP 011F631D
bytes2Restore1  db 08Bh,088h,084h,006h,000h,000h ; MOV ECX,DWORD PTR DS:[EAX+684]
Offset2         dd 011F631Dh ; Unlimited ammunition (codecave)
bytes2write2    db 0C7h,080h,084h,006h,000h,000h,039h,005h,000h,000h, ;MOV DWORD PTR DS:[EAX+684],539
                   08Bh,088h,084h,006h,000h,000h,                     ;MOV ECX,DWORD PTR DS:[EAX+684]
                   0E9h,0D5h,02Dh,030h,0FFh                           ;JMP 004F9107

Offset3         dd 526FE9h ; Unlimited health
bytes2write3    db 0E9h,044h,0F3h,0CCh,000h,090h,090h ; JMP 011F6332
bytes2Restore3  db 00Fh,02Fh,080h,020h,001h,000h,000h ; COMISS XMM0,DWORD PTR DS:[EAX+120]
Offset4         dd 011F6332h ; Unlimited health (codecave)
bytes2write4    db 0C7h,080h,020h,001h,000h,000h,000h,020h,0A7h,044h, ;MOV DWORD PTR DS:[EAX+120],44A72000
                   00Fh,02Fh,080h,020h,001h,000h,000h,                ;COMISS XMM0,DWORD PTR DS:[EAX+120]
                   0E9h,0A8h,00Ch,033h,0FFh                           ;JMP 00526FF0

Offset5         dd 005808E7h ; Unlimited credits
bytes2write5    db 0E9h,05Ch,05Ah,0C7h,000h,090h ; JMP 011F6348
bytes2Restore5  db 08Bh,082h,0E4h,00Ch,000h,000h ; MOV EAX,DWORD PTR DS:[EDX+CE4]
Offset6         dd 011F6348h ; Unlimited credits (codecave)       
bytes2write6    db 0C7h,082h,0E4h,00Ch,000h,000h,0F9h,0C7h,004h,000h, ;MOV DWORD PTR DS:[EDX+CE4],4C7F9
                   08Bh,082h,0E4h,00Ch,000h,000h,                     ;MOV EAX,DWORD PTR DS:[EDX+CE4]
                   0E9h,090h,0A5h,038h,0FFh                           ;JMP 005808ED

Offset7         dd 00521610h ; Unlimited nodes
bytes2write7    db 0E9h,048h,04Dh,0CDh,000h,090h ; JMP 011F635D
bytes2Restore7  db 08Bh,081h,094h,005h,000h,000h ; MOV EAX,DWORD PTR DS:[ECX+594]
Offset8         dd 011F635Dh ; Unlimited nodes (codecave)
bytes2write8    db 0C7h,081h,094h,005h,000h,000h,0F9h,0C7h,004h,000h, ;MOV DWORD PTR DS:[ECX+594],04C7F9
                   08Bh,081h,094h,005h,000h,000h,                     ;MOV EAX,DWORD PTR DS:[ECX+594]
                   0E9h,0A4h,0B2h,032h,0FFh                           ;JMP 00521616

; Used only in Chapter 4 with the Asteroid Defense System cannon shooting/minigame
; No codecave here, just a dumb patch.
Offset9           dd 005BE9ACh ; Unlimited Ship health
Offset10          dd 005BE9F6h ; Unlimited Ship health (offset2)
bytes2write0910   db 090h,090h,090h,090h,090h,090h,090h,090h ; NOPS
bytes2Restore0910 db 0F3h,00Fh,011h,083h,094h,007h,000h,000h ; MOVSS DWORD PTR DS:[EBX+794],XMM0

Offset11          dd 004518DEh ; one hit kill
bytes2write11     db 0E9h,07Ah,04Ah,0DAh,000h,090h,090h,090h ; JMP 011F635D
bytes2Restore11   db 0F3h,00Fh,010h,087h,020h,001h,000h,000h ; MOVSS XMM0,DWORD PTR DS:[EDI+120]
Offset12          dd 011F6389h ; one hit kill (codecave)
bytes2write12     db 0C7h,087h,020h,001h,000h,000h,000h,000h,000h,000h, ;MOV DWORD PTR DS:[EDI+120],0
                     0F3h,00Fh,010h,087h,020h,001h,000h,000h,           ;MOVSS XMM0,DWORD PTR DS:[EDI+120]
                     0E9h,072h,0B5h,025h,0FFh                           ;JMP 004518E6

Offset13          dd 005471C4h ; Unlimited Stasis
bytes2write13     db 0E9h,0A9h,0F1h,0CAh,000h,090h,090h,090h ; JMP 011F6372
bytes2Restore13   db 0F3h,00Fh,010h,089h,028h,001h,000h,000h ; MOVSS XMM1,DWORD PTR DS:[ECX+128]
Offset14          dd 011F6372h ; Unlimited Stasis (codecave)
bytes2write14     db 0C7h,081h,028h,001h,000h,000h,000h,000h,0C8h,042h, ;MOV DWORD PTR DS:[ECX+128],42C80000
                     0F3h,00Fh,010h,089h,028h,001h,000h,000h,           ;MOVSS XMM1,DWORD PTR DS:[ECX+128]
                     0E9h,043h,00Eh,035h,0FFh                           ;JMP 005471CC
                     
Offset15          dd 004644A0h ; Super speed
bytes2write15     db 0E9h,0FBh,01Eh,0D9h,000h,090h ; JMP 011F63A0
Offset16          dd 011F63A0h ; Super speed (codecave)
bytes2write16     db 0C7h,081h,080h,000h,000h,000h,000h,000h,000h,040h, ;MOV DWORD PTR DS:[ECX+80],50000000
                     0D9h,081h,080h,000h,000h,000h,                     ;FLD DWORD PTR DS:[ECX+80]
                     0E9h,0F1h,0E0h,026h,0FFh                           ;JMP 004644A6
;Normal speed is bytes2write17
bytes2write17     db 0C7h,081h,080h,000h,000h,000h,000h,000h,080h,03Fh, ;MOV DWORD PTR DS:[ECX+80],3F800000
                     0D9h,081h,080h,000h,000h,000h,                     ;FLD DWORD PTR DS:[ECX+80]
                     0E9h,0F1h,0E0h,026h,0FFh                           ;JMP 004644A6

.data?
hInstance       dd ?
windhand        dd ? ; Window handle
hwnddlg         dd ? ; Window handle
phandle         dd ? ; Process handle of game
pid             dd ? ; Process id of game
status1         dd ? ; on/off
status2         dd ? ; on/off
status3         dd ? ; on/off
status4         dd ? ; on/off
status5         dd ? ; on/off
status6         dd ? ; on/off
status7         dd ? ; on/off

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

	.if uMsg == WM_INITDIALOG
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
        invoke SetDlgItemText,hWin,IDB_VELOCITY,ADDR szIDBCheatON
        invoke SetDlgItemText,hWin,IDC_STATIC1005,ADDR szHotkeyHelp
        invoke SetDlgItemText,hWin,IDC_STATIC1006,ADDR szHotkeyF12
        invoke SetDlgItemText,hWin,IDC_STATIC1007,ADDR szHotkeyF11
        invoke SetDlgItemText,hWin,IDC_STATIC1008,ADDR szHotkeyF10
        invoke SetDlgItemText,hWin,IDC_STATIC1009,ADDR szHotkeyF9        
        invoke SetDlgItemText,hWin,IDC_STATIC1010,ADDR szHotkeyF8        
        invoke SetDlgItemText,hWin,IDC_STATIC1011,ADDR szHotkeyF7      
        invoke SetDlgItemText,hWin,IDC_STATIC1012,ADDR szHotkeyF6 
        mov hwnddlg, eax
        invoke SetTimer,hWin,0,90, 0 ;set the timer for monitoring action keystrokes
        mov status1,0
        mov status2,0
        mov status3,0
        mov status4,0
        mov status5,0
        mov status6,0
        mov status7,0
	.elseif	uMsg == WM_COMMAND ; Did the user press a button
        .if wParam == IDB_HEALTH
            @HEALTH:
            ; Find the game window
            invoke FindWindow,addr GameClass,addr GameCaption
            ; The game is running
            .if eax != NULL
                .if status1 == 1
                  mov status1,0 ; Disable
                  invoke TrainerEngine,offset GameCaption,Offset3,offset bytes2Restore3,NULL,NULL,7
                  ;stasis:
                  invoke TrainerEngine,offset GameCaption,Offset13,offset bytes2Restore13,NULL,NULL,8
                  invoke SetDlgItemText,hWin,IDB_HEALTH,ADDR szIDBCheatON
                  invoke Beep,1000,30
                .else
                  mov status1,1 ; Enable
                  invoke TrainerEngine,offset GameCaption,Offset3,offset bytes2write3,NULL,NULL,7
                  invoke TrainerEngine,offset GameCaption,Offset4,offset bytes2write4,NULL,NULL,22
                  ;stasis!
                  invoke TrainerEngine,offset GameCaption,Offset13,offset bytes2write13,NULL,NULL,8
                  invoke TrainerEngine,offset GameCaption,Offset14,offset bytes2write14,NULL,NULL,23
                  
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
            invoke FindWindow,addr GameClass,addr GameCaption
            ; The game is running
            .if eax != NULL
                .if status2 == 1
                  mov status2,0 ; Disable
                  invoke TrainerEngine,offset GameCaption,Offset1,offset bytes2Restore1,NULL,NULL,6
                  invoke Beep,1000,30
                  invoke SetDlgItemText,hWin,IDB_AMMO,ADDR szIDBCheatON
                .else
                  mov status2,1 ; Enable
                  invoke TrainerEngine,offset GameCaption,Offset1,offset bytes2write1,NULL,NULL,6
                  invoke TrainerEngine,offset GameCaption,Offset2,offset bytes2write2,NULL,NULL,21
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
            invoke FindWindow,addr GameClass,addr GameCaption
            ; The game is running
            .if eax != NULL
                .if status3 == 1
                  mov status3,0 ; Disable
                  invoke TrainerEngine, offset GameCaption, Offset11, offset bytes2Restore11, NULL, NULL,8
                  invoke SetDlgItemText,hWin,IDB_KILL,ADDR szIDBCheatON
                  invoke Beep,1000,30
                .else
                  mov status3,1 ; Enable
                  invoke TrainerEngine, offset GameCaption, Offset11, offset bytes2write11, NULL, NULL,8
                  invoke TrainerEngine, offset GameCaption, Offset12, offset bytes2write12, NULL, NULL,23
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
            invoke FindWindow,addr GameClass,addr GameCaption
            ; The game is running
            .if eax != NULL
                .if status4 == 1
                  mov status4,0 ; Disable
                  invoke TrainerEngine,offset GameCaption,Offset5,offset bytes2Restore5,NULL,NULL,6
                  invoke SetDlgItemText,hWin,IDB_MONEY,ADDR szIDBCheatON
                  invoke Beep,1000,30
                .else
                  mov status4,1 ; Enable
                  invoke TrainerEngine,offset GameCaption,Offset5,offset bytes2write5,NULL,NULL,6
                  invoke TrainerEngine,offset GameCaption,Offset6,offset bytes2write6,NULL,NULL,21
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
            invoke FindWindow,addr GameClass,addr GameCaption
            ; The game is running
            .if eax != NULL
                .if status5 == 1
                  mov status5,0 ; Disable
                  invoke TrainerEngine,offset GameCaption,Offset7,offset bytes2Restore7,NULL,NULL,6
                  invoke SetDlgItemText,hWin,IDB_NODES,ADDR szIDBCheatON
                  invoke Beep,1000,30
                .else
                  mov status5,1 ; Enable
                  invoke TrainerEngine,offset GameCaption,Offset7,offset bytes2write7,NULL,NULL,6
                  invoke TrainerEngine,offset GameCaption,Offset8,offset bytes2write8,NULL,NULL,21
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
            invoke FindWindow,addr GameClass,addr GameCaption
            ; The game is running
            .if eax != NULL
                .if status6 == 1
                  mov status6,0 ; Disable
                  invoke TrainerEngine,offset GameCaption,Offset9,offset bytes2Restore0910,NULL,NULL,8
                  invoke TrainerEngine,offset GameCaption,Offset10,offset bytes2Restore0910,NULL,NULL,8
                  invoke SetDlgItemText,hWin,IDB_SHIPLIFE,ADDR szIDBCheatON
                  invoke Beep,1000,30
                .else
                  mov status6,1 ; Enable
                  invoke TrainerEngine,offset GameCaption,Offset9,offset bytes2write0910,NULL,NULL,8
                  invoke TrainerEngine,offset GameCaption,Offset10,offset bytes2write0910,NULL,NULL,8
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
        .if wParam == IDB_VELOCITY
            @VELOCITY:
            ; Find the game window
            invoke FindWindow,addr GameClass,addr GameCaption
            ; The game is running
            .if eax != NULL
                .if status7 == 1
                  mov status7,0 ; Disable
                  invoke TrainerEngine,offset GameCaption,Offset16,offset bytes2write17,NULL,NULL,21
                  invoke SetDlgItemText,hWin,IDB_VELOCITY,ADDR szIDBCheatON
                  invoke Beep,1000,30
                .else
                  mov status7,1 ; Enable
                  invoke TrainerEngine,offset GameCaption,Offset15,offset bytes2write15,NULL,NULL,6
                  invoke TrainerEngine,offset GameCaption,Offset16,offset bytes2write16,NULL,NULL,21
                  invoke SetDlgItemText,hWin,IDB_VELOCITY,ADDR szIDBCheatOFF
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
     invoke GetAsyncKeyState, VK_F6 ; Was F6 pressed?
      .if eax != 0 ; If yes
         jmp @VELOCITY
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
       invoke FindWindow,addr GameClass,lpWindCap
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
