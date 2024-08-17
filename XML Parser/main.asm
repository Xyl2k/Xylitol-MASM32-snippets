.386
.model flat, stdcall
option casemap :none   ; case sensitive

include           \masm32\include\windows.inc
include           \masm32\include\user32.inc
include           \masm32\include\kernel32.inc
include           \masm32\include\msvcrt.inc
include           \masm32\macros\macros.asm

includelib        \masm32\lib\user32.lib
includelib        \masm32\lib\kernel32.lib
includelib        \masm32\lib\msvcrt.lib

include           mxml.inc
includelib        mxml.lib
include           Console.inc

;Thanks to fearless for the lib

szText MACRO Name, Text:VARARG
  LOCAL lbl
    jmp lbl
      Name db Text,0
    lbl:
  ENDM
  

; Local prototypes
WndProc PROTO :DWORD,:DWORD,:DWORD,:DWORD
      
.data?
 FilePointer     dd ?
 pRoot           dd ?
 XMLTag1Node     dd ?
 XMLTag2Node     dd ?
 XMLTag1         dd ?
 XMLTag2         dd ?
      
.data
hInstance        dd 0
        
szXML_to_Parse   db '<?xml version="1.0" encoding="UTF-8"?>'
                 db '<note>'
                 db '<HelloWorldTag1>Hello</HelloWorldTag1>'
                 db '<HelloWorldTag2>World</HelloWorldTag2>'
                 db '</note>',0

.const
IDB_TAG1         equ 1002
IDB_TAG2         equ 1003
IDB_GRAB         equ 1004
IDB_QUIT         equ 1005

.code
start:
invoke GetModuleHandle, NULL
mov hInstance, eax

; -------------------------------------------
; Call the dialog box stored in resource file
invoke DialogBoxParam,hInstance,101,0,ADDR WndProc,0
invoke ExitProcess,eax

WndProc proc hWin   :DWORD,
             uMsg   :DWORD,
             wParam :DWORD,
             lParam :DWORD

.if uMsg == WM_INITDIALOG
        ;output to dlg tiitle
        szText dlgTitle,"sMALL xML pARSER"
        invoke SendMessage,hWin,WM_SETTEXT,0,ADDR dlgTitle
        
    .elseif uMsg == WM_COMMAND
        .if wParam == IDB_GRAB
        ;Parse XML
        invoke mxmlLoadString,NULL,addr szXML_to_Parse,MXML_NO_CALLBACK
 
        .if (eax)
              mov pRoot, eax
              invoke mxmlFindElement,pRoot,pRoot,chr$("HelloWorldTag1"),NULL,NULL,MXML_DESCEND
              .if(eax)
                  mov   XMLTag1Node,eax
                  invoke mxmlGetText,XMLTag1Node,eax
                  mov   XMLTag1,eax
                  invoke crt_printf,chr$("HelloWorldTag1 : %s",10,13),XMLTag1
              .endif                    
              invoke mxmlFindElement,pRoot,pRoot,chr$("HelloWorldTag2"),NULL, NULL,MXML_DESCEND                                
              .if(eax)
                  mov   XMLTag2Node,eax
                  invoke mxmlGetText, XMLTag2Node,eax
                  mov   XMLTag2,eax
                  invoke crt_printf,chr$("HelloWorldTag2 : %s"),XMLTag2
              .endif         
        .endif

        ;output to dlg items
        invoke GetDlgItem,hWin,IDB_TAG1
        cmp eax,0
        je close_program        
        invoke SetWindowText,eax,XMLTag1
        
        invoke GetDlgItem,hWin,IDB_TAG2
        cmp     eax,0
        je close_program        
        invoke SetWindowText,eax,XMLTag2
        
        .elseif wParam == IDB_QUIT
          invoke SendMessage,hWin,WM_CLOSE,0,0
        .endif
   .elseif uMsg == WM_CLOSE
         invoke EndDialog,hWin,0

.endif

xor eax, eax    
ret    
close_program:
    invoke  MessageBox,NULL ,NULL, NULL,MB_ICONERROR
    ret

WndProc endp
end start
















