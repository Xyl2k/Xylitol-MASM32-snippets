;;
;;  LibV2 v1.5 simplified header file for MASM by drizz
;;
V2MInit proto stdcall ptune:ptr byte, hwnd:dword
V2MIsPlaying proto stdcall ;; :returns BOOL
V2MPlay proto stdcall 
V2MStop proto stdcall fadetime:dword
V2MClose proto stdcall 
