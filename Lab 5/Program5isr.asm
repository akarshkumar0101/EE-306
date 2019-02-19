; ISR.asm
; Name:
; UTEid: 
; Keyboard ISR runs when a key is struck
; Counts number of keys struck
; Stores typed character into x8000


.ORIG xA000
ST R0, SaveR0
LDI R0, KBDR
STI R0, char
LDI R0, count
ADD R0,R0,#1
STI R0, count
LD R0, SaveR0
RTI
SaveR0 .FILL 0
KBDR .FILL xFE02
char .FILL x8000
count .FILL x8001

.END
