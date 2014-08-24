mfmPlay		PROTO :DWORD
;procka bazujaca na libie minifmod v1.60 sluzacym do odgrywania XM'ow
;player dziala pod 9x/me/nt/w2k/xp :))))))))
;NIE KORZYSTA Z MSVCRT.DLL :)))
;
;UZYCIE:	invoke mfmPlay,dword
;
;wejscie:	jesli dword jest offsetem do struktury z danymi xma
;                  to init&play module,
;		jesli dword = 0 to stop&unload module
;
;	modka najlepiej podlaczyc w sekcji .data np. tak:
;
;	muzax		dd offset muzax_end - offset muzax - 4
;	include 	music.inc	;dane modka w postaci db xx,xx,xx...
;	muzax_end	equ $
;
;wyjscie:	eax = 0 jesli blad

mfmGetPos	PROTO
;procka zwraca w eax numer odgrywanego paternu a w edx pozycje w paternie

mfmPause	PROTO
;procka wstrzymuje lub wznawia odgrywanie modka czyli zwykla pauza :)
;wyjscie:	eax = 1 - pause on
;		eax = 0 - pause off
