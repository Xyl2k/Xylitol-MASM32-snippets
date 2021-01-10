; include file by eNeRGy/dAWN

V2M_V15_Replay equ 1
V2M_V15_NonReplay equ 0


;void __stdcall V2M_V15_Init (const void *a_v2mptr,sU32 a_tickspersec=1000, sU32 a_samplerate=44100, sU32 replay=sTRUE)
V2M_V15_Init PROTO :DWORD ,:DWORD,:DWORD,:DWORD,:DWORD
;void __stdcall V2M_V15_Play(sU32 a_time=0)
V2M_V15_Play PROTO :DWORD
;void __stdcall V2M_V15_Stop(sU32 a_fadetime=0)
V2M_V15_Stop PROTO :DWORD
;void __stdcall V2M_V15_Close(void)
V2M_V15_Close PROTO 
;void __stdcall V2M_V15_GetMainVU(sF32 *l, sF32 *r)
V2M_V15_GetMainVU PROTO :DWORD,:DWORD
;void __stdcall V2M_V15_GetChannelVU(sInt channel,sF32 *l, sF32 *r)
V2M_V15_GetChannelVU PROTO:DWORD,:DWORD,:DWORD
;void __stdcall V2M_V15_SetVUMode(sInt mode)
V2M_V15_SetVUMode PROTO:DWORD
;void __stdcall V2M_V15_SetVolume(sUInt Volume=100)
V2M_V15_SetVolume PROTO :DWORD
