.486                      
.model flat, stdcall      
option casemap :none      

include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
include \masm32\include\wininet.inc
include \masm32\include\advapi32.inc
include \masm32\macros\macros.asm

includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\wininet.lib
includelib \masm32\lib\advapi32.lib


bufSize=MAX_COMPUTERNAME_LENGTH + 1

.data
format1     db 'computername=%s&username=%s',0
capt        db 'Hello',0
postdata    db 256 dup(?)
bSize dd bufSize
computer_name db bufSize dup(?)
user_name db bufSize dup(?)

szData db 1024 dup(0)
host db "localhost",0
;postdata db "postString=sample+POST",0
headers db 13,10,"Keep-Alive: 115",
13,10,"Connection: keep-alive",
13,10,"Content-Type: application/x-www-form-urlencoded",0

.data?
hInternet dd ?
hConnect dd ?
hRequest dd ?
dwBytesRead dd ?

.code


main PROC

invoke  GetComputerName,addr computer_name,addr bSize
invoke 	GetUserName,addr user_name,addr bSize
invoke  wsprintf,ADDR postdata,ADDR format1,ADDR computer_name,addr user_name

;invoke  MessageBox,0,ADDR postdata,ADDR capt,MB_OK

call SendReq
invoke ExitProcess,0
main ENDP

SendReq PROC
mov hInternet,FUNC(InternetOpen,chr$("WinInet Test"),INTERNET_OPEN_TYPE_PRECONFIG,NULL,NULL,0)
    .if    hInternet==NULL
        invoke MessageBox,0,chr$("InternetOpen error"),0,0
        exit
    .endif
    
invoke InternetConnect,hInternet,offset host,INTERNET_DEFAULT_HTTP_PORT,NULL,NULL,INTERNET_SERVICE_HTTP,0,0
mov hConnect,eax
    .if hConnect == NULL
        invoke MessageBox,0,chr$("InternetConnect error"),0,0
        exit
    .endif
        
mov hRequest,FUNC(HttpOpenRequest,hConnect,chr$("POST"),chr$("/post.php"),NULL,chr$("localhost/post.php"),0,INTERNET_FLAG_KEEP_CONNECTION,1)
    .if hRequest == NULL
        invoke MessageBox,0,chr$("HttpOpenRequest error"),0,0
        exit
    .endif        

invoke HttpSendRequest,hRequest,offset headers,sizeof headers-1,offset postdata,sizeof postdata-1
.if eax == 0
        invoke MessageBox,0,chr$("HttpSendRequest error"),0,0
        exit
.endif    

invoke InternetReadFile,hRequest,offset szData,sizeof szData-1,offset dwBytesRead
    test eax,eax ;if (bRead == FALSE)
    jz @exit
   .if dwBytesRead==0
        jmp @exit
    .endif

@exit:                        
invoke InternetCloseHandle,hRequest
invoke InternetCloseHandle,hConnect
invoke InternetCloseHandle,hInternet
ret
SendReq ENDP
end main