; EE 306: Introduction to Computing
; Fall 2018 - Cuevas
; 
; Name:
; EID:
; Recitation Section:
;
; This program computes the solutions to
; the quadratic equation y=ax^2+bx+c (a is non-zero).
;
; Inputs: 
; 	A - Stored in x4000
; 	B - Stored in x4001
;	C - Stored in x4002
;
; Outputs:
; 	Number of solutions - Stored in x4000
;	Solution 1 - Stored in x4001
; 	Solution 2 - Stored in x4002
;
;  Note: If there are two solutions, Solution 1 < Solution 2.
; 
;  Three main routines to solve: how to multiply, how to sqrt, how to divide.

.ORIG x3000

HALT
A .FILL x4000
B .FILL x4001
C .FILL x4002

.END
