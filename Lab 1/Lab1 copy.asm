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

.ORIG x3000 		; This is where your code is loaded into LC3.
			; x3000 is the "standard" place.

; Start writing your code here


HALT 			; Halts the machine
			; LC3 will jump to an odd location and fill
			; your registers with weird values. To prevent
			; this, place a breakpoint before the HALT
			; instruction and observe R0.


.END			; This pseudo-op tells the assembler that this
			; is the end of the file.
