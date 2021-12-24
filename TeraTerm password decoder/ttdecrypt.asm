.486
.model flat, stdcall
option casemap :none ; case sensitive

include    \masm32\include\windows.inc

uselib MACRO libname
    include       \masm32\include\libname.inc
    includelib    \masm32\lib\libname.lib
ENDM

uselib    user32
uselib    kernel32
uselib    comdlg32
uselib    shell32

DlgProc            PROTO :DWORD,:DWORD,:DWORD,:DWORD
GetFileDialog      PROTO

.const
IDC_PLAIN          equ 1001
IDC_CODED          equ 1002
IDB_DECODE         equ 1003
IDB_QUIT           equ 1004
IDB_BROWSE         equ 1005
IDC_GROUPBOX_PWD   equ 1006
IDC_GROUPBOX_BTN   equ 1007
IDC_GROUPBOX_BRW   equ 1008
IDC_PATH           equ 1009
IDC_TITLE          equ 1010

.data
; Browse file stuff
szFilterString       db "password.dat",0,"password.dat",0h,0h
szSectionName        db "Password",0
szkeyNamez           db "mypassword",0
szkeynotfound        db "Aborted",0

; dialog texts
szTitle            db "Password Recovery utility for TeraTerm v4.x",0
szIDBdecode        db "dECODE!",0
szIDBExit          db "eXiT!",0
szIDBBrowse        db "bROWSE!",0
szIDCbrowse        db "passord.dat",0
szOurTitle         db "TeraTerm v2.x - v4.x Password Decrypter - from x! Red crew",0
szIDCGRPBOXbrowse  db "[Filename]",0
szIDCGRPBOXbtn     db "[Control]",0
szIDCGRPBOXresult  db "Browse file or copy/past",0
szIDCCoded         db ",@x`;F,XCnb<$7vx1F",0

.data?
hInstance          dd ? ;dd can be written as dword

; main buffers for passord fields
szCoded            db 100h dup(?)
szPlain            db 100h dup(?)

; Browse stuff
ofn                OPENFILENAME <?>

szPathBuffer       db 1024 dup(?)
szBrowseResult     db 100 dup(?)
szSize             dd ?

; Decoding routine
___security_cookie db 100h dup(?)
ReturnedString=    byte ptr -108h

comment /
Decrypt Passwords used in TeraTerm Macro TTL files

@9}(%;BlIy|DPA}w32  -> 123456
,@x`;F,XCnb<$7vx1F  -> azerty
/

.code
start:
    invoke GetModuleHandle,NULL
    mov hInstance,eax
    invoke DialogBoxParam,hInstance,101,0,addr DlgProc,0
    invoke ExitProcess,eax

DlgProc proc hWin   :DWORD,
             uMsg   :DWORD,
             wParam :DWORD,
             lParam :DWORD

      .if uMsg == WM_INITDIALOG
        invoke SendMessage,hWin,WM_SETTEXT,0,addr szTitle ; Set the window title text
        invoke SetDlgItemText,hWin,IDB_DECODE,addr szIDBdecode
        invoke SetDlgItemText,hWin,IDB_QUIT,addr szIDBExit
        invoke SetDlgItemText,hWin,IDB_BROWSE,addr szIDBBrowse
        invoke SetDlgItemText,hWin,IDC_PATH,addr szIDCbrowse
        invoke SetDlgItemText,hWin,IDC_TITLE,addr szOurTitle   
        invoke SetDlgItemText,hWin,IDC_GROUPBOX_PWD,addr szIDCGRPBOXresult
        invoke SetDlgItemText,hWin,IDC_GROUPBOX_BTN,addr szIDCGRPBOXbtn
        invoke SetDlgItemText,hWin,IDC_GROUPBOX_BRW,addr szIDCGRPBOXbrowse  
        invoke SetDlgItemText,hWin,IDC_CODED,addr szIDCCoded
        
      .elseif uMsg == WM_DROPFILES
        invoke DragQueryFile,wParam,NULL,addr szPathBuffer,1024
        invoke SetDlgItemText,hWin,IDC_PATH,addr szPathBuffer

      .elseif uMsg == WM_COMMAND
        .if wParam == IDB_DECODE
            invoke GetDlgItemText,hWin,IDC_CODED,addr szCoded,sizeof szCoded
            mov eax,offset szPlain
            push eax
            lea ecx, offset szCoded
            push ecx
            call sub_419040
            invoke SetDlgItemText,hWin,IDC_PLAIN,addr szPlain

        .elseif wParam == IDB_BROWSE
            invoke GetFileDialog
            invoke SetDlgItemText,hWin,IDC_PATH,addr szPathBuffer
            invoke GetPrivateProfileString,addr szSectionName,addr szkeyNamez,addr szkeynotfound,addr szBrowseResult,ADDR szSize,addr szPathBuffer
            invoke SetDlgItemText,hWin,IDC_CODED,addr szBrowseResult
        .elseif wParam == IDB_QUIT
            invoke EndDialog,hWin,0
        .endif

      .elseif uMsg == WM_CLOSE
        invoke EndDialog,hWin,0
      .endif

    xor eax,eax
    ret
DlgProc endp

GetFileDialog proc
    pushad
    
    mov ofn.lStructSize,sizeof ofn
    mov ofn.lpstrFilter,offset szFilterString
    mov ofn.lpstrFile,offset szPathBuffer
    mov ofn.nMaxFile,1024
    mov ofn.Flags, OFN_FILEMUSTEXIST or OFN_PATHMUSTEXIST or OFN_LONGNAMES or OFN_EXPLORER or OFN_HIDEREADONLY
    mov ofn.lpstrTitle,offset szOurTitle
    invoke GetOpenFileName,addr ofn

    popad
    ret
GetFileDialog endp

sub_419040 proc near

var_20D= byte ptr -20Dh
var_20C= dword ptr -20Ch
var_208= dword ptr -208h
var_204= byte ptr -204h
var_203= byte ptr -203h
var_4= dword ptr -4
arg_0= dword ptr  4
arg_4= dword ptr  8

sub     esp, 210h
;mov     eax, ___security_cookie
xor     eax, esp
mov     [esp+210h+var_4], eax
mov     eax, [esp+210h+arg_4]
push    ebx
push    ebp
mov     ebp, [esp+218h+arg_0]
mov     [esp+218h+var_208], eax
mov     byte ptr [eax], 0
mov     eax, ebp
lea     edx, [eax+1]

loc_419070:
mov     cl, [eax]
add     eax, 1
test    cl, cl
jnz     short loc_419070
sub     eax, edx
mov     ebx, eax
jz      short loc_4190FC
push    esi
xor     esi, esi
test    ebx, ebx
push    edi
mov     [esp+220h+var_20D], 21h ; '!'
jle     short loc_4190B1
lea     eax, [esp+220h+var_204]
sub     ebp, eax

loc_419092:
lea     edi, [esp+esi+220h+var_204]
movzx   edx, byte ptr [edi+ebp]
lea     ecx, [esp+220h+var_20D]
push    ecx
push    edx
call    sub_418FF0
add     esi, 1
add     esp, 8
cmp     esi, ebx
mov     [edi], al
jl      short loc_419092

loc_4190B1:
mov     al, byte ptr [esp+ebx+220h+var_208+3]
xor     al, [esp+220h+var_204]
cmp     al, 3Fh ; '?'
jnz     short loc_4190FA
mov     esi, 1
lea     edi, [ebx-2]
cmp     edi, esi
mov     [esp+220h+var_20C], 0
jle     short loc_4190FA

loc_4190D1:
movzx   eax, [esp+esi+220h+var_204]
sub     al, [esp+esi+220h+var_203]
mov     edx, [esp+220h+var_208]
and     al, 3Fh
lea     ecx, [esp+220h+var_20C]
mov     [esp+esi+220h+var_204], al
push    eax
push    ecx
push    edx
call    sub_418F90
add     esi, 2
add     esp, 0Ch
cmp     esi, edi
jl      short loc_4190D1

loc_4190FA:
pop     edi
pop     esi

loc_4190FC:
mov     ecx, [esp+218h+var_4]
pop     ebp
pop     ebx
xor     ecx, esp        ; StackCookie
;call    @__security_check_cookie@4 ; __security_check_cookie(x)
add     esp, 210h
retn
sub_419040 endp

align 10h



sub_418F90 proc near

arg_0= dword ptr  4
arg_4= dword ptr  8
arg_8= byte ptr  0Ch

push    esi
push    edi
mov     edi, [esp+8+arg_4]
mov     ecx, [edi]
mov     eax, ecx
cdq
and     edx, 7
add     eax, edx
mov     edx, ecx
sar     eax, 3
and     edx, 80000007h
jns     short loc_418FB2
dec     edx
or      edx, 0FFFFFFF8h
inc     edx

loc_418FB2:
mov     esi, [esp+8+arg_0]
jnz     short loc_418FBC
mov     byte ptr [eax+esi], 0

loc_418FBC:
mov     ecx, 0Ah
sub     ecx, edx
movzx   edx, [esp+8+arg_8]
shl     edx, cl
xor     ecx, ecx
mov     ch, [eax+esi]
or      edx, ecx
mov     ecx, edx
shr     ecx, 8
mov     [eax+esi], cl
mov     [eax+esi+1], dl
add     dword ptr [edi], 6
pop     edi
pop     esi
retn
sub_418F90 endp

align 10h



sub_418FF0 proc near

arg_0= byte ptr  4
arg_4= dword ptr  8

mov     edx, [esp+arg_4]
mov     cl, [edx]
mov     al, [esp+arg_0]
cmp     al, cl
jnb     short loc_419004
sub     al, cl
add     al, 5Eh ; '^'
jmp     short loc_419006

loc_419004:
sub     al, cl

loc_419006:
and     al, 3Fh
cmp     cl, 30h ; '0'
jnb     short loc_419011
mov     byte ptr [edx], 30h ; '0'
retn

loc_419011:
cmp     cl, 40h ; '@'
jnb     short loc_41901A
mov     byte ptr [edx], 40h ; '@'
retn

loc_41901A:
cmp     cl, 50h ; 'P'
jnb     short loc_419023
mov     byte ptr [edx], 50h ; 'P'
retn

loc_419023:
cmp     cl, 60h ; '`'
jnb     short loc_41902C
mov     byte ptr [edx], 60h ; '`'
retn

loc_41902C:
cmp     cl, 70h ; 'p'
sbb     cl, cl
and     cl, 4Fh
add     cl, 21h ; '!'
mov     [edx], cl
retn
sub_418FF0 endp

align 10h

end start