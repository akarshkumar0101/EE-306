; ID Card Data Parser
; Author: Jerry Yang
; Date: 11/24/2018
; Continuously reads from x8000 making sure its not reading duplicate
; symbols. Checks if string has access code.
; Testcases:
; 	1. No access code - helloworldimcode
; 	2. String at beginning - 1610016105161101
; 	3. String at end - ireadstring16105
;	4. String in middle - 1615016110161351
;	5. String following 1s - 1111116115111111


.ORIG x3000
LEA R0, HEADER
PUTS

; set up ISR
LD R6,SP
LD R1,KBISR
LD R2,KBISRV
STR R1,R2,#0
LD R1, INTEN
LD R2, KBSR
STR R1,R2,#0

; start of actual program


INIT
JSR GETNEXTCHAR	; Get next char
OUT
JSR COUNTCHECK
ADD R2,R2,#0
BRp NO
LD R1,ASCII0	; Check if char = 1
ADD R1,R1,#1
NOT R1,R1
ADD R1,R1,#1
ADD R1,R0,R1 ; r0-r1
BRz STATE1	; Yes - go to next state
BRnp INIT	; No - stay in same state


STATE1		; Check for 6
JSR GETNEXTCHAR
OUT
JSR COUNTCHECK
ADD R2,R2,#0
BRp NO
LD R1,ASCII0
ADD R1,R1,#6
NOT R1,R1
ADD R1,R1,#1
ADD R1,R0,R1 ; r0-r1
BRz STATE6
LD R1,ASCII0 ; Account for if repeating 1s
ADD R1,R1,#1
NOT R1,R1
ADD R1,R1,#1
ADD R1,R0,R1 ; r0-r1
BRz STATE1
BRnp INIT

STATE6		; Check for 1
JSR GETNEXTCHAR
OUT
JSR COUNTCHECK
ADD R2,R2,#0
BRp NO
LD R1,ASCII0
ADD R1,R1,#1
NOT R1,R1
ADD R1,R1,#1
ADD R1,R0,R1 ; r0-r1
BRz STATE12
BRnp INIT

STATE12		; Check for 0/1
JSR GETNEXTCHAR
OUT
JSR COUNTCHECK
ADD R2,R2,#0
BRp NO
LD R1,ASCII0
ADD R1,R1,#1
NOT R1,R1
ADD R1,R1,#1
ADD R1,R0,R1 ; r0-r1
BRz STATE01
LD R1,ASCII0
NOT R1,R1
ADD R1,R1,#1
ADD R1,R0,R1 ; r0-r1
BRz STATE01
BRnp INIT

STATE01
JSR GETNEXTCHAR
OUT
LD R1,ASCII0
ADD R1,R1,#5
NOT R1,R1
ADD R1,R1,#1
ADD R1,R0,R1 ; r0-r1
BRz STATE05
LD R1,ASCII0
NOT R1,R1
ADD R1,R1,#1
ADD R1,R0,R1 ; r0-r1
BRz STATE05
JSR COUNTCHECK
ADD R2,R2,#0
BRp NO
BRnp INIT

STATE05
LEA R0,GRANTED
PUTS
WAIT JSR COUNTCHECK
ADD R2,R2,#0
BRz WAIT
AND R0,R0,#0
STI R0,count
STI R0,char
BRnzp INIT

NO
LEA R0,DENIED
PUTS
AND R0,R0,#0
STI R0,count
BRnzp INIT

HALT

; Subroutine to get next character
GETNEXTCHAR
ST R1, SaveR1
LDI R0, char
BRz GETNEXTCHAR
AND R1,R1,#0
STI R1, char
LD R1, SaveR1
RET
SaveR1 .FILL 0


; Subroutine that checks if the count exceeds limit - 1 if yes, 0 if no
COUNTCHECK
LDI R2,count
ADD R2,R2,#-16
BRn NOTOVER
AND R2,R2,#0
ADD R2,R2,#1
RET
NOTOVER AND R2,R2,#0
RET

; Main program data
SP .FILL xF000
KBISR .FILL xA000
KBISRV .FILL x0180
KBSR .FILL xFE00
KBDR .FILL xFE02
INTEN .FILL x4000
char .FILL x8000
count .FILL x8001
ASCII0 .FILL x30
DENIED .STRINGZ "\nAccess Denied!\n\n"
GRANTED .STRINGZ "\nAccess Granted!\n\n"
HEADER .STRINGZ "Name: Jerry Yang\nEID: Insert EID Here\nDate: 11/24/2018\nTitle: ID Card Data Parser\n\n"
		.END
