; Pow2
; 
; Find if a given number N is a power of 2.
; If yes, write its exponent to R0. Else, write -1 to R0.


.ORIG x3000   ; First line says where the program must load to

AND R1,R1,#0
ADD R1,R1,#15 ; Set R1 to bit tested
AND R2,R2,#0  ; Set R2 as temp storage
ADD R0,R0,#0  ; Test MSB[R0] for 0/1
BRz NO	      ; If R0=0, not power of 2

LOOP BRn ONE  ; If MSB[R0] = 1
ADD R0,R0,#0  ; Set CC
BRz YES
ADD R1,R1,#-1
ADD R0,R0,R0
BRnzp LOOP

ONE ADD R2, R2,#0 ; Checks if R0 is empty
BRnp NO		  ; If it isn't, not pow 2 - DONE.
ADD R2,R1,#0	  ; If it is, record the bit position at which one was detected
ADD R1,R1,#-1
ADD R0,R0,R0	  ; Shift R0 to next bit
BRnzp LOOP	  ; Test next bit

NO AND R0,R0,#0
ADD R0,R0,#-1
HALT

YES ADD R0,R2,#0
HALT    ; Halt machine
.END