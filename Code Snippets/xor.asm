; XOR
;
; This program implements an XOR gate on the LSB.

.ORIG x3000

ADD R0,R0,R1
AND R0,R0,#1

HALT    ; Halt machine
.END