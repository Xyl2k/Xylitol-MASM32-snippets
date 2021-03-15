;===================================================================
; TitchySID v1.1 by StatMat - August 2008
;
; Based on TinySID by Tammo Hinrichs (kb) and Rainer Sinsch
;
; Caveat: This library has been stripped down to the bare essentials
; required for SID playback. This means that the code is pretty
; horrible in places, but the idea is to make the thing as small as
; possible. Everything is hard-coded to run at 44100Hz.
;
; Visit the TinySID homepage at: http://www.rsinsch.de
;===================================================================

;.CONST

SID_RESOURCE       equ 0   ; Load SID file from a resource
SID_MEMORY         equ 1   ; Load SID file from provided memory

; Options used in SIDOpen()
SID_DEFAULT        equ 1   ; Play default sub song, as found in the PSID header
SID_NON_DEFAULT    equ 2   ; Play specified sub song

;===================================================================
; SIDOpen()
;  
; Purpose: Open the SID library
;
; Call with *either* a resource ID for the
; SID music or a pointer to a memory block
; e.g.:
;
; To load a resource within the executable:
; invoke StartSID, res_id, 0, SID_RESOURCE, SID_DEFAULT, subsong
;
; To load from a memory block:
; invoke StartSID, mem, mem_len, SID_MEMORY, SID_DEFAULT, subsong
;
; Last parameter is subsong (many PSID files contain several subsongs
; or sound effects). This is ignored if the options parameter has the
; SID_DEFAULT flag set. If you wish to specify which sub song to play,
; then you should use the SID_NON_DEFAULT flag instead.
;
; Returns non-zero on success
;===================================================================

SIDOpen PROTO stdcall :DWORD, :DWORD, :BYTE, :BYTE, :BYTE

;===================================================================
;  SIDClose()
;
;  Purpose : Close the SID library
;
;  Call this in your WM_CLOSE handler
;===================================================================

SIDClose PROTO stdcall

;=================================================
; The functions below are only available if the
; library was built with SID_EXTRAS enabled
;=================================================

;===================================================================
; SIDPlay()
;
; Purpose : Start the SID playback
;===================================================================

SIDPlay PROTO stdcall

;===================================================================
; SIDStop()
;
; Purpose : Stop the SID playback
;===================================================================

SIDStop PROTO stdcall

;===================================================================
; SIDPause()
;
; Purpose : Pause the currently playing SID song
;===================================================================

SIDPause PROTO stdcall

;===================================================================
; SIDResume()
;
; Purpose : Resume playing the SID song after a pause
;===================================================================

SIDResume PROTO stdcall

;===================================================================
; SIDChangeSong()
;
; Purpose : Change to another sub song in the currently playing SID
;		        file
;
;  Parameter : New subsong ID
;===================================================================

SIDChangeSong PROTO stdcall :BYTE

; Needs to be 4 byte aligned for C etc
props STRUCT 4

    ; The address where the SID data should be placed in the C64's memory
    load_addr WORD ?
    
    ; The address in the C64's memory where the initialise routine for the
    ; SID songs is located (accepts a subsong ID in the accumulator)
    init_addr WORD ?
    
    ; The address in the C64's memory where the play routine is located. This
    ; is called frequently to produce continuous sound.
    play_addr WORD ?

    ; The total number of subsongs contained in the SID file
    num_songs BYTE ?
    
    ; The default subsong to be played
    default_song BYTE ?

    ; The total size of the SID data (in bytes)
    data_size WORD ?

    ; The name of the SID file
    sid_name BYTE 32 dup (?)
    
    ; The author's name
    author BYTE 32 dup (?)

    ; The copyright string
    copyright BYTE 32 dup (?)

props ENDS

; This structure holds all of the SID file info after a successful call
; to StartSID(). It contains the members defined in props above.

EXTERNDEF sid_props :props
