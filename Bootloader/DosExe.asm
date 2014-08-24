; Converted from a FASM code by Xyl2k!
code segment use16
assume cs:code
org 7c00h

start:
; Main program
main:        ; Label for the start of the main program

 mov ax,0000h    ; Setup the Data Segment register
        ; Location of data is DS:Offset
 mov ds,ax    ; This can not be loaded directly it has to be in two steps.
        ; 'mov ds, 0000h' will NOT work due to limitations on the CPU

 mov si,offset HelloWorld    ; Load the string into position for the procedure.
 call PutStr    ; Call/start the procedure

jmp $        ; Never ending loop

; Procedures
PutStr:        ; Procedure label/start
 ; Set up the registers for the interrupt call
 mov ah,0Eh    ; The function to display a chacter (teletype)
 mov bh,00h    ; Page number
 mov bl,07h    ; Normal text attribute

nextchar:    ; Internal label (needed to loop round for the next character)
 lodsb        ; I think of this as LOaD String Block
        ; (Not sure if thats the real meaning though)
        ; Loads [SI] into AL and increases SI by one
 ; Check for end of string '0'
 or al,al    ; Sets the zero flag if al = 0
        ; (OR outputs 0's where there is a zero bit in the register)
 jz return    ; If the zero flag has been set go to the end of the procedure.
        ; Zero flag gets set when an instruction returns 0 as the answer.
 int 10h    ; Run the BIOS video interrupt
 jmp nextchar    ; Loop back round to the top
return:        ; Label at the end to jump to when complete
 ret        ; Return to main program

; Data
HelloWorld db 'Hello World',13,10,0

db 510-($-start) dup(0)  ; Fill the rest of the sector with zero's
dw 0AA55h ; Add the boot loader signature to the end

code ends
end start