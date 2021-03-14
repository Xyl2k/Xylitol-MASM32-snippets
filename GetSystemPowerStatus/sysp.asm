.586
.model	flat, stdcall
option	casemap :none

include		\masm32\include\windows.inc
include		\masm32\include\user32.inc
include		\masm32\include\kernel32.inc
includelib	\masm32\lib\user32.lib
includelib	\masm32\lib\kernel32.lib
include 	\masm32\macros\macros.asm

		
.data?
sysp		SYSTEM_POWER_STATUS <?>

.code
start:
invoke GetSystemPowerStatus,addr sysp
	.if sysp.ACLineStatus == 1
			invoke MessageBox,NULL,chr$("AC power status: Online"),NULL,MB_ICONINFORMATION
		.else
	.if sysp.ACLineStatus == 0
			invoke MessageBox,NULL,chr$("AC power status: Offline"),NULL,MB_ICONINFORMATION
		.endif
.endif
	.if sysp.BatteryFlag == 128
		invoke MessageBox,NULL,chr$("No system battery"),NULL,MB_ICONINFORMATION
	ret
	.else
		.if	sysp.BatteryLifePercent == 100
			invoke MessageBox,NULL,chr$("Battery is full"),NULL,MB_ICONINFORMATION
			ret
		.endif
			invoke MessageBox,NULL,chr$("Battery is not full"),NULL,MB_ICONINFORMATION
			ret
	.endif
end start