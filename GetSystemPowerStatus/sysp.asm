.386
.model flat, stdcall  ;32 bit memory model
option casemap :none  ;case sensitive

include		\masm32\include\windows.inc
include		\masm32\include\user32.inc
include		\masm32\include\kernel32.inc
includelib	\masm32\lib\user32.lib
includelib	\masm32\lib\kernel32.lib
include 	\masm32\macros\macros.asm

.data
szACLine db "GetSystemPowerStatus: ACLineStatus",0	
szBatteryFlag db "GetSystemPowerStatus: BatteryFlag",0	
szBatteryLifePercent db "GetSystemPowerStatus: BatteryLifePercent",0

.data?
sysp		SYSTEM_POWER_STATUS <?>

; typedef struct _SYSTEM_POWER_STATUS {
;    BYTE  ACLineStatus;
;    BYTE  BatteryFlag;
;    BYTE  BatteryLifePercent;
;    BYTE  SystemStatusFlag;
;    DWORD BatteryLifeTime;
;    DWORD BatteryFullLifeTime;
; } SYSTEM_POWER_STATUS, *LPSYSTEM_POWER_STATUS;

.code
start:
invoke GetSystemPowerStatus,addr sysp
	.if sysp.ACLineStatus == 1
			invoke MessageBox,NULL,chr$("AC power status: Online"),addr szACLine,MB_ICONINFORMATION
		.else
	.if sysp.ACLineStatus == 0
			invoke MessageBox,NULL,chr$("AC power status: Offline"),addr szACLine,MB_ICONINFORMATION
		.endif
.endif
	.if sysp.BatteryFlag == 128
		invoke MessageBox,NULL,chr$("No system battery"),addr szBatteryFlag,MB_ICONINFORMATION
	ret
	.else
		.if	sysp.BatteryLifePercent == 100
			invoke MessageBox,NULL,chr$("Battery is full"),addr szBatteryLifePercent,MB_ICONINFORMATION
			ret
		.endif
			invoke MessageBox,NULL,chr$("Battery is not full"),addr szBatteryLifePercent,MB_ICONINFORMATION
			ret
	.endif
end start
