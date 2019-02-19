; EE 306: Introduction to Computing
; Fall 2018 - Cuevas
; 
; Title: Rotate Register
; Author: Akarsh Kumar
; EID: ak39969
; Discussion Time: F 11 AM
; Created on: 10/13/2018
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


ADD R1, R1, #0		;Put R1 in NZP registers


BRzp STARTLOOP		;If R1 is zero or positive, start loop to rotate now

ADD R1, R1, #15		;Else, add 16 to make right rotates into (positive) left rotates
ADD R1, R1, #1

STARTLOOP		;Loop to start rotating

ADD R1, R1, #-1		;Increment R1 down by 1 (every cycle)
BRn DONE		;If R1 negative, done with rotating

AND R2, R2, #0		;R2=0 (Assume MSb of R0 is 0)

ADD R0, R0, #0		
BRzp SKIP		;If R0 is zero or positive, assumption is correct

ADD R2, R2, #1		;Else R2=1 (MSb of R0 is 1)

SKIP			

ADD R0, R0, R0		;Double R0 (leftshift 1)
ADD R0, R0, R2		;Add 0 or 1 based on what MSb was


BRnzp STARTLOOP		;Start loop no matter what


DONE			;End of program reached


HALT 			; Halts the machine
			; LC3 will jump to an odd location and fill
			; your registers with weird values. To prevent
			; this, place a breakpoint before the HALT
			; instruction and observe R0.


.END			; This pseudo-op tells the assembler that this
			; is the end of the file.
