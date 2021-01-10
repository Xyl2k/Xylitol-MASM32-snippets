;======================= MagicV2mEngine.lib by: Magic_h2001 ======
; magic_h2001@yahoo.com
; http://magic.shabgard.org
;=================================================================

MAGICV2MENGINE_DllMain PROTO STDCALL :DWORD,:DWORD,:DWORD
V2mPlayFile PROTO STDCALL :DWORD,:DWORD
V2mPlayStream PROTO STDCALL :DWORD,:DWORD
V2mPlayResource PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
V2mStop PROTO STDCALL
V2mSetAutoRepeat PROTO STDCALL :DWORD
V2mGetTime PROTO STDCALL
V2mTotalTime PROTO STDCALL
V2mIsPlay PROTO STDCALL
