 ; #########################################
 ; #       Crackme compiled with Masm32    #
 ; #         and half-made by Arecibo      #
 ; #          as I'm a newbie in ASM       #
 ; #########################################

.386
.model flat, stdcall
option casemap:none
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib

.data
Msg1Caption      db "Unregistered program",0
Msg1BoxText      db "Please register me !",0
Msg2Caption      db "Registered program",0
Msg2BoxText      db "Congratulations you've cracked me !",0

.code
start:
    mov eax,01
    test eax,eax
    je Msg2
	invoke MessageBox, NULL,addr Msg1BoxText, addr Msg1Caption, MB_OK
	invoke ExitProcess,NULL
    jmp Fin

Msg2:
      invoke MessageBox, NULL,addr Msg2BoxText, addr Msg2Caption, MB_OK
	invoke ExitProcess,NULL

Fin:
end start


