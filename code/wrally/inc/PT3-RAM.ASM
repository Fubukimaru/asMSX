		; --- THIS FILE MUST BE COMPILED IN RAM ---

		; --- PT3 WORKAREA [self-modifying code patched] ---

PT3_SETUP:		.ds	1	;set bit0 to 1, if you want to play without looping
					;bit7 is set each time, when loop point is passed
PT3_MODADDR:		.ds	2
PT3_CrPsPtr:		.ds	2
PT3_SAMPTRS:		.ds	2
PT3_OrnPtrs:		.ds	2
PT3_PDSP:		.ds	2
PT3_CSP:		.ds	2
PT3_PSP:		.ds	2
PT3_PrNote:		.ds	1
PT3_PrSlide:		.ds	2
PT3_AdInPtA:		.ds	2
PT3_AdInPtB:		.ds	2
PT3_AdInPtC:		.ds	2
PT3_LPosPtr:		.ds	2
PT3_PatsPtr:		.ds	2
PT3_Delay:		.ds	1
PT3_AddToEn:		.ds	1
PT3_Env_Del:		.ds	1
PT3_ESldAdd:		.ds	2

VARS:

ChanA:			.ds	29			;CHNPRM_Size
ChanB:			.ds	29			;CHNPRM_Size
ChanC:			.ds	29			;CHNPRM_Size

;GlobalVars
DelyCnt:		.ds	1
CurESld:		.ds	2
CurEDel:		.ds	1
Ns_Base_AddToNs:
Ns_Base:		.ds	1
AddToNs:		.ds	1

AYREGS:
VT_:			.ds	14
EnvBase:		.ds	2
VAR0END:		.ds	240
