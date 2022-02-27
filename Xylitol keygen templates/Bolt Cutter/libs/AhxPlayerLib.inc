comment ~----------------------------------------------------------------------

	Static AHX Player Library
      -all main library code and thus copyright by Bartman/Abyss
      -simplified interface code with C/ASM friendly exports by UFO-Pu55y[SnD]

	;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	; add these options for the linker:
	; /NODEFAULTLIB:libcmt /NODEFAULTLIB:oldnames /NODEFAULTLIB:uuid
	;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

------------------------------------------------------------------------------~

includelib libs\\AhxPlayerLib.lib
includelib libs\msvcrt_vc60.lib

AHX_Init       PROTO C
AHX_LoadFile   PROTO C Filename:PTR
AHX_LoadBuffer PROTO C Buffer:PTR, Len:DWORD
AHX_Play       PROTO C
AHX_Pause      PROTO C
AHX_Resume     PROTO C
AHX_Stop       PROTO C
AHX_Free       PROTO C
AHX_SetVolume  PROTO C Volume:DWORD ; Max = 64
