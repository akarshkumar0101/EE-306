; EE 306: Introduction to Computing
; Fall 2018 - Cuevas
; 
; Title: Rotate Register
; Author: Jerry Yang
; Created on: 9/6/2018
;
; This program implements R0 as a rotate register.
; Inputs: 
; 	R0 - Data to rotate
; 	R1 - How many times to rotate
;	 If R1<0, rotate right |R1| times
;	 If R1>0, rotate left R1 times.
;
; Outputs:
; 	R0 - Rotated data
;  

.ORIG x3000
ADD R0,R0,#0
BRz STOP
ADD R1,R1,#0; Set CC's to R1
BRz STOP
BRn RIGHT

; Left shift
LEFT ADD R0,R0,#0	; Set condition codes to refer to value
BRzp #4			; Branch if R0 starts w/ 0, continue if R0 starts with 1
ADD R0,R0,R0		; Left shifts value
ADD R0,R0,#1		; Adds 1 to left-shifted value
ADD R1,R1,#-1		; Subtracts 1 from # rotates
BRnzp END		; Branch to end of loop
ADD R0,R0,R0		; Left shifts value
ADD R1,R1,#-1		; Subtracts 1 from # rotates
END BRnp LEFT		; to first branch
BRnzp STOP

; Right shift
RIGHT AND R2,R2,#0 	; Clear R2
NOT R1,R1 		; Take |R1| when R1<0, store into R3
ADD R1,R1, #1
ADD R3,R1,#0
SET ADD R2,R2,R2	; Calculate bitmask in R2
ADD R2,R2,#1
ADD R1,R1,#-1
BRnp SET
AND R1,R2,R0		; Apply bitmask to R0 into R1
AND R2,R2,#0
ADD R2,R2,#-16		; Move R2=-16
ADD R3,R2,R3		; Set R3=16-(# times to rotate)
NOT R3,R3
ADD R3,R3,#1		
BRz STOP
SHIFT ADD R1,R1,R1	; Left-shift to create space for new bit
ADD R0,R0,#0		; Determine MSB[R0]
BRp NO
ADD R1,R1,#1		; Insert MSB[R0] into LSB[R1]
NO ADD R0,R0,R0
ADD R3,R3,#-1
BRnp SHIFT		; Loop until 16-(# times to rotate)
ADD R0,R1,#0		; Move result into R0

STOP HALT
.END
