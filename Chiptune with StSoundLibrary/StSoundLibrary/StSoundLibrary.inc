comment ~---------------------------------------------------------------------

	ST-Sound ( YM files player library )

	Copyright (C) 1995-1999 Arnaud Carre ( http://leonard.oxg.free.fr )

	Main header to use the StSound "C" like API in your production.

-----------------------------------------------------------------------------~

comment ~---------------------------------------------------------------------

	This file is part of ST-Sound

	ST-Sound is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation; either version 2 of the License, or
	(at your option) any later version.

	ST-Sound is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with ST-Sound; if not, write to the Free Software
	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

-----------------------------------------------------------------------------~

YMMUSIC struct
  pSongName      dd ?
  pSongAuthor    dd ?
  pSongComment   dd ?
  pSongType      dd ?
  pSongPlayer    dd ?
  musicTimeInSec dd ? ; keep for compatibility
  musicTimeInMs  dd ?
YMMUSIC ends

; Create object
ymMusicCreate              PROTO C ; returns PTR to YMMUSIC object

; Release object
ymMusicDestroy             PROTO C pMusic:PTR 

; Global settings
ymMusicSetLowpassFiler     PROTO C pMusic:PTR, bActive:BOOL

; Functions
; Method 1 : Load file using stdio library (fopen/fread, etc..)
ymMusicLoad                PROTO C pMusic:PTR, fName:PTR ; returns BOOL
; Method 2 : Load file from a memory block
ymMusicLoadMemory          PROTO C pMusic:PTR, pBlock:PTR, len:DWORD ; returns BOOL

; Render nbSample samples of current YM tune into pBuffer PCM 16bits mono sample buffer.
ymMusicCompute             PROTO C pMusic:PTR, pBuffer:PTR, nbSample:DWORD ; returns BOOL

ymMusicSetLoopMode         PROTO C pMusic:PTR, bLoop:BOOL
ymMusicGetLastError        PROTO C pMusic:PTR ; returns PTR to error string
ymMusicGetRegister         PROTO C pMusic:PTR, reg:DWORD ; returns DWORD
ymMusicGetInfo             PROTO C pMusic:PTR, pInfo:PTR
ymMusicPlay                PROTO C pMusic:PTR
ymMusicPause               PROTO C pMusic:PTR
ymMusicStop                PROTO C pMusic:PTR

ymMusicRestart             PROTO C pMusic:PTR

ymMusicIsSeekable          PROTO C pMusic:PTR ; returns BOOL
ymMusicGetPos              PROTO C pMusic:PTR ; returns DWORD
ymMusicSeek                PROTO C pMusic:PTR, timeInMs:DWORD

comment ~---------------------------------------------------------------------
	Header conversion, builds and additional exports by UFO-Pu55y[SnD] 2012 
-----------------------------------------------------------------------------~

; some additionally exposed code taken from "SmallYmPlayer" to make things easier
ymMusicSoundServerStart    PROTO C pMusic:PTR ; return BOOL
ymMusicSoundServerStop     PROTO C pMusic:PTR

IF TRUE
	includelib StSoundLibrary\StSoundLibrary_static.lib
	includelib StSoundLibrary\msvcrt_vc60.lib
	;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	; add these linker options when linking against the static lib:
	;/NODEFAULTLIB:libc /NODEFAULTLIB:oldnames /NODEFAULTLIB:uuid
	;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
ELSE
	includelib StSoundLibrary\StSoundLibrary.lib
ENDIF
