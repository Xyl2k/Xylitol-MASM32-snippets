CRC32            PROTO :DWORD,:DWORD

.data?
   CRCtable dd 256 DUP (?)

.code

align 4

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
; These are MASM versions of Donkey's GoAsm CRC-32 procedures,
; adapted from routines by Thomas Bleeker (MadWizard),table-
; driven and fast
; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

InitCRC32Table proc uses ebx esi edi
   mov edi, offset CRCtable  - 4
   xor ecx, ecx

   M1:
   mov eax, ecx
   mov ebx, 0EDB88320h
   add edi, 4
   mov esi, 8
   @@:
      shr eax, 1
      sbb edx, edx
      and edx, ebx
      xor eax, edx
   dec esi
   jnz @B
   inc ecx
   mov [edi], eax
   cmp ecx, 256
   jb  M1

   mov eax,offset CRCtable
   ret
InitCRC32Table endp

align 4

CRC32 proc uses ebx esi edi lpBuffer, cbBuffer

   mov esi, lpBuffer
   mov edi, offset CRCtable
   mov edx, cbBuffer

   shr edx, 1
   or ecx, -1
   xor eax, eax

   @@:
   mov al, [esi]
   xor al, cl
   shr ecx, 8
   mov ebx, [edi+4*eax]
   xor ecx, ebx

   mov al, [esi+1]
   xor al, cl
   shr ecx, 8
   mov ebx, [edi+4*eax]
   add esi,2
   xor ecx, ebx

   dec edx
   jnz @B

   test dword ptr[cbBuffer], 1
   jz @F
   mov al, [esi]
   xor al, cl
   inc esi
   shr ecx, 8
   mov ebx, [edi+4*eax]
   xor ecx, ebx
   @@:

   mov eax, ecx
   not eax
   ret

CRC32 endp
