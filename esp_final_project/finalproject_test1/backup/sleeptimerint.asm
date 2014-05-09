;;*****************************************************************************
;;*****************************************************************************
;;  FILENAME:   SleepTimerINT.asm
;;  Version: 1.0, Updated on 2012/3/2 at 9:15:13
;;  Generated by PSoC Designer 5.2.2551
;;
;;  DESCRIPTION:  SleepTimer Interrupt Service Routine.
;;-----------------------------------------------------------------------------
;;  Copyright (c) Cypress Semiconductor 2012. All Rights Reserved.
;;*****************************************************************************
;;*****************************************************************************

include "SleepTimer.inc"
include "memory.inc"
include "m8c.inc"

;-----------------------------------------------
;  Global Symbols
;-----------------------------------------------
export  _SleepTimer_ISR


export  SleepTimer_fTick
export _SleepTimer_fTick
export  SleepTimer_bTimerValue
export _SleepTimer_bTimerValue
export  SleepTimer_bCountDown
export _SleepTimer_bCountDown
export  SleepTimer_TickCount
export _SleepTimer_TickCount

;-----------------------------------------------
; Variable Allocation
;-----------------------------------------------
AREA InterruptRAM (RAM, REL, CON)

 SleepTimer_fTick:
_SleepTimer_fTick:        BLK  1

 SleepTimer_bTimerValue:
_SleepTimer_bTimerValue:  BLK  1

 SleepTimer_bCountDown:
_SleepTimer_bCountDown:   BLK  1

 SleepTimer_TickCount:
_SleepTimer_TickCount:    BLK  SleepTimer_TICK_CNTR_SIZE



;@PSoC_UserCode_INIT@ (Do not change this line.)
;---------------------------------------------------
; Insert your custom declarations below this banner
;---------------------------------------------------

;------------------------
;  Includes
;------------------------


;------------------------
;  Constant Definitions
;------------------------


;------------------------
; Variable Allocation
;------------------------


;---------------------------------------------------
; Insert your custom declarations above this banner
;---------------------------------------------------
;@PSoC_UserCode_END@ (Do not change this line.)


AREA UserModules (ROM, REL, CON)

;-----------------------------------------------------------------------------
;  FUNCTION NAME: _SleepTimer_ISR
;
;  DESCRIPTION:
;      interrupt handler for instance SleepTimer.
;
;     This is a place holder function.  If the user requires use of an interrupt
;     handler for this function, then place code where specified.
;-----------------------------------------------------------------------------

_SleepTimer_ISR:

   or   [SleepTimer_fTick],0x01           ; Set tick flag
 
                                                ; Decrement CountDown (Sync counter)
   tst  [SleepTimer_bCountDown],0xFF
   jz   .DoTimer
   dec  [SleepTimer_bCountDown]

.DoTimer:                                       ; Decrement TimerValue, if required
   tst  [SleepTimer_bTimerValue],0xFF
   jz   .IncBigCounter
   dec  [SleepTimer_bTimerValue]

.IncBigCounter:                                 ; Increment big tick counter
IF (SleepTimer_TICK_CNTR_SIZE & 0x04)
   inc  [SleepTimer_TickCount+3]
   jnc  SleepTimer_SLEEP_ISR_END

   inc  [SleepTimer_TickCount+2]
   jnc  SleepTimer_SLEEP_ISR_END
ENDIF

IF (SleepTimer_TICK_CNTR_SIZE & (0x04|0x02))
   inc  [SleepTimer_TickCount+1]
   jnc  SleepTimer_SLEEP_ISR_END
ENDIF

   inc  [SleepTimer_TickCount+0]

SleepTimer_SLEEP_ISR_END:

   ;@PSoC_UserCode_BODY_1@ (Do not change this line.)
   ;---------------------------------------------------
   ; Insert your custom assembly code below this banner
   ;---------------------------------------------------
   ;   NOTE: interrupt service routines must preserve
   ;   the values of the A and X CPU registers.
   
   ;---------------------------------------------------
   ; Insert your custom assembly code above this banner
   ;---------------------------------------------------
   
   ;---------------------------------------------------
   ; Insert a lcall to a C function below this banner
   ; and un-comment the lines between these banners
   ;---------------------------------------------------
   
   ;PRESERVE_CPU_CONTEXT
   ;lcall _My_C_Function
   ;RESTORE_CPU_CONTEXT
   
   ;---------------------------------------------------
   ; Insert a lcall to a C function above this banner
   ; and un-comment the lines between these banners
   ;---------------------------------------------------
   ;@PSoC_UserCode_END@ (Do not change this line.)

   reti

; end of file SleepTimerINT.asm

