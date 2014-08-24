; #########################################################################

;     include files
;     ~~~~~~~~~~~~~
      include \masm32\include\windows.inc
      include \masm32\include\masm32.inc
      include \masm32\include\gdi32.inc
      include \masm32\include\user32.inc
      include \masm32\include\kernel32.inc
      include \masm32\include\Comctl32.inc
      include \masm32\include\comdlg32.inc
      include \masm32\include\shell32.inc
      include \masm32\include\oleaut32.inc

;     libraries
;     ~~~~~~~~~
      includelib \masm32\lib\masm32.lib
      includelib \masm32\lib\gdi32.lib
      includelib \masm32\lib\user32.lib
      includelib \masm32\lib\kernel32.lib
      includelib \masm32\lib\Comctl32.lib
      includelib \masm32\lib\comdlg32.lib
      includelib \masm32\lib\shell32.lib
      includelib \masm32\lib\oleaut32.lib

; #########################################################################

      ;=============
      ; Local macros
      ;=============

      szText MACRO Name, Text:VARARG
        LOCAL lbl
          jmp lbl
            Name db Text,0
          lbl:
        ENDM

      m2m MACRO M1, M2
        push M2
        pop  M1
      ENDM

      return MACRO arg
        mov eax, arg
        ret
      ENDM

      stralloc MACRO ln
        invoke SysAllocStringByteLen,0,ln
      ENDM

      strfree MACRO strhandle
        invoke SysFreeString,strhandle
      ENDM

      QUAD MACRO name,value
        .data
          name QWORD value
        .code
      ENDM

; --------------------------------------------------
; Macro for placing an assembler instruction either
; within another or within a procedure call
; --------------------------------------------------

    ASM MACRO parameter1,source
      LOCAL mnemonic
      LOCAL dest
      LOCAL poz

      % poz INSTR 1,<parameter1>,< >             ;; get the space position
      mnemonic SUBSTR <parameter1>, 1, poz-1     ;; get the mnemonic
      dest SUBSTR <parameter1>, poz+1            ;; get the first argument

      mnemonic dest, source

      EXITM <dest>
    ENDM

; ------------------------------------------------------------
; Macro for nesting function calls in other invoke statements
; ------------------------------------------------------------

      FUNC MACRO parameters:VARARG
        invoke parameters
        EXITM <eax>
      ENDM

;  -----------------------------------------------------
;   Macros for declaring named floating point variables
;  -----------------------------------------------------

      FLOAT4 MACRO name,value
        .data
          name REAL4 value
        .code
      ENDM

      FLOAT8 MACRO name,value
        .data
          name REAL8 value
        .code
      ENDM

      FLOAT10 MACRO name,value
        .data
          name REAL10 value
        .code
      ENDM

;  -----------------------------------------------------
;   Macros for directly inserting floating point values
;   into floating point instructions and as parameters
;  -----------------------------------------------------

      FP4 MACRO value
        LOCAL vname
        .data
          vname REAL4 value
        .code
        EXITM <vname>
      ENDM

      FP8 MACRO value
        LOCAL vname
        .data
          vname REAL8 value
        .code
        EXITM <vname>
      ENDM

      FP10 MACRO value
        LOCAL vname
        .data
          vname REAL10 value
        .code
        EXITM <vname>
      ENDM

    ; -------------------------
    ; initialised GLOBAL value
    ; -------------------------
      IGLOBAL MACRO variable:VARARG
      .data
        variable
      .code
      ENDM

    ; --------------------------------
    ; initialised GLOBAL string value
    ; --------------------------------
      STRING MACRO variable:REQ,args:VARARG
      .data
        variable db args,0
      .code
      ENDM

    ; ---------------------
    ; literal string MACRO
    ; ---------------------
      literal MACRO quoted_text:VARARG
        LOCAL local_text
        .data
          local_text db quoted_text,0
        .code
        EXITM <local_text>
      ENDM
    ; --------------------------------
    ; string address in INVOKE format
    ; --------------------------------
      SADD MACRO quoted_text:VARARG
        EXITM <ADDR literal(quoted_text)>
      ENDM
    ; --------------------------------
    ; string OFFSET for manual coding
    ; --------------------------------
      CTXT MACRO quoted_text:VARARG
        EXITM <offset literal(quoted_text)>
      ENDM

      ShellAboutBox MACRO handle,IconHandle,quoted_Text_1,quoted_Text_2:VARARG
        LOCAL AboutTitle,AboutMsg,buffer
          .data
            AboutTitle db quoted_Text_1,0
            AboutMsg   db quoted_Text_2,0
            buffer db 128 dup (0)
          .code
        mov esi, offset AboutTitle
        mov edi, offset buffer
        mov ecx, lengthof AboutTitle
        rep movsb
        invoke ShellAbout,handle,ADDR buffer,ADDR AboutMsg,IconHandle
      ENDM

      AppModel MACRO Processor
        Processor             ;; Processor type
        .model flat, stdcall  ;; 32 bit memory model
        option casemap :none  ;; case sensitive
      ENDM

      DisplayMenu MACRO handl, IDnum
        invoke LoadMenu,hInstance,IDnum
        invoke SetMenu,handl,eax
      ENDM

      DisplayWindow MACRO handl, ShowStyle
        invoke ShowWindow,handl, ShowStyle
        invoke UpdateWindow,handl
      ENDM

      AutoScale MACRO swidth, sheight
        invoke GetPercent,sWid,swidth
        mov Wwd, eax
        invoke GetPercent,sHgt,sheight
        mov Wht, eax

        invoke TopXY,Wwd,sWid
        mov Wtx, eax

        invoke TopXY,Wht,sHgt
        mov Wty, eax
      ENDM

      SingleInstanceOnly MACRO lpClassName
        invoke FindWindow,lpClassName,NULL
        cmp eax, 0
        je @F
          push eax
          invoke ShowWindow,eax,SW_RESTORE
          pop eax
          invoke SetForegroundWindow,eax
          mov eax, 0
          ret
        @@:
      ENDM

      GLOBAL MACRO var1,var2,var3,var4,var5,var6,var7,var8,var9,var0,
                   varA,varB,varC,varD,varE,varF,varG,varH,varI,varJ
        .data?
          var1
          var2
          var3
          var4
          var5
          var6
          var7
          var8
          var9
          var0
          varA
          varB
          varC
          varD
          varE
          varF
          varG
          varH
          varI
          varJ
        .code
      ENDM

    .data?
        hInstance dd ?
        hIcon dd ?

