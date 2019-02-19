; Average
;
; This program takes the average of 4 numbers, in R0-R3.

.ORIG x3000

ADD R0,R1,R0; Sum
ADD R0,R2,R0
ADD R0,R3,R0

AND R1,R1,#0; Prepare to right-shift
AND R2,R2,#0
ADD R2,R2,#13
ADD R0,R0,#0; Set CCs
BRz DONE
BRp LOOP
ADD R1,R1,#6

LOOP ADD R0,R0,#0 ; Right-shift
BRn INSERT
RETURN ADD R0,R0,R0
ADD R1,R1,R1
ADD R2,R2,#-1
BRz DONE
BRnp LOOP

INSERT ADD R1,R1,#1
BRnzp RETURN

DONE ADD R0,R1,#0
HALT    ; Halt machine
.END