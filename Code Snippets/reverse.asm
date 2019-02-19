; EE 306: Introduction to Computing
; Fall 2018 - Cuevas
; 
; Title: Word Reverse
; Author: Jerry Yang
; Created on: 9/6/2018
;
; This program reverses the 16-bit word in R0.
; Inputs: 
; 	R0 - Data to reverse
;
; Outputs:
; 	R0 - Reversed data
;  

.ORIG x3000
AND R3,R3,#0; Result register

AND R1,R1,#0; 1. Set R1=1
ADD R1,R1,#1

LOOP AND R2,R0,R1; 2. Mask R0 with R1, store in R2. If R2=1, add 1 to R3, then left-shift. If R2=0, just left-shift.
BRz ZERO
ADD R3,R3,#1
ZERO ADD R1,R1,R1; 3. Left-shift R1

BRz DONE; 4. Check if R1=0. If yes, halt. If no, go to step 2.
ADD R3,R3,R3
BRnp LOOP

DONE ADD R0,R3,#0

; HALT routine that preserves R0 - We give students this.
Halt
.END
