.const
TEXT_ MACRO your_text:VARARG
    LOCAL text_string
    .data
     text_string db your_text,0
    .code
    EXITM <addr text_string>
ENDM

.code

Print proc lpszText:DWORD
    LOCAL hOutPut  :DWORD
    LOCAL bWritten :DWORD

    invoke  GetStdHandle,STD_OUTPUT_HANDLE
    mov     hOutPut, eax

    invoke  lstrlen,lpszText
    mov     ecx,eax
    invoke  WriteFile,hOutPut,lpszText,ecx,ADDR bWritten,NULL

    mov     eax,bWritten
    ret
Print endp

Wait_Key proc
    LOCAL hInPut  :DWORD
    LOCAL bRead   :DWORD
    LOCAL hBuffer :DWORD

    invoke  Print,TEXT_(13,10,"Press any key to continue...")
    
    invoke  GetStdHandle,STD_INPUT_HANDLE
    mov     hInPut,eax
    invoke  SetConsoleMode,hInPut,ENABLE_WINDOW_INPUT

    invoke  ReadFile,hInPut,addr hBuffer,1,addr bRead,NULL
    ret
Wait_Key endp