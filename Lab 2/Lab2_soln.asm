; EE 306: Introduction to Computing
; Fall 2018 - Cuevas
; 
; Title: Quadratic Equation Solver
; Author: Jerry Yang
; Created on: 9/23/2018
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

; Determine # solutions
;	1. Calculate b^2
;	2. Calculate 4ac
;	3. Calculate b^2-4ac

; Calculate b^2
LDI R0, B
BRz NEXT 	; 0^2 = 0
BRp POS
NOT R0,R0	; If b negative, make positive since (-b)^2=b^2.
ADD R0,R0,#1
POS ADD R1,R0,#0; Copy b as counter and addend
ADD R2,R0,#-1	
BRz NEXT	; 1^2 = 1
SQUARE
ADD R2,R2,#-1	; R1 - b; R2 - Counter
ADD R0,R0,R1	
ADD R2,R2,#0
BRp SQUARE
ST R0, BSQ	; Store b^2 in local variable
BRnzp NEXT
BSQ .FILL 0

; Calculate 4ac
NEXT
AND R7,R7,#0 	; R7 - Holds sign
LDI R0, A	
BRp #3		; Check if a is negative
ADD R7,R7,#-1	; Note if a is negative
NOT R0,R0	; Convert to positive number
ADD R0,R0,#1
LDI R1, C	
BRz DISC	; Check if c=0
BRp #3
ADD R7,R7,#1	; Note if c is negative
NOT R1,R1	; Convert to positive number
ADD R1,R1,#1	

ADD R2,R0,#0	; Start multiplying
ADD R1,R1,#-1
BRz #3
MULT
ADD R0,R2,R0
ADD R1,R1,#-1
BRp MULT

ADD R0,R0,R0	; Multiply by 4 = left-shift 2
ADD R0,R0,R0	
ADD R7,R7,#0	; If c=0, number is positive. If c!=0, number is negative.
BRz VALUE	
NOT R0,R0	; Convert positive result into negative result
ADD R0,R0,#1
VALUE ST R0,AC
BRnzp DISC
AC .FILL 0

; Calculate discriminant
DISC
LD R0,BSQ
LD R1,AC	; Negate 4ac
NOT R1,R1
ADD R1,R1,#1
ADD R0,R1,R0	; b^2-4ac
BRn NOSOLN
ST R0, DISCRIMINANT
BRzp SOLN
DISCRIMINANT .FILL 0

NOSOLN		; If no solutions, store 0 into x4000 and halt.
AND R0,R0,#0
STI R0,A
HALT

; Calculate denominator 2a
SOLN
LDI R0,A
ADD R0,R0,R0
ST R0,TWOA
LD R0, DISCRIMINANT
BRz ONESOLN	; Test if one solution or two solutions
BRp TWOSOLN
TWOA .FILL 0

ONESOLN 	; Occurs when discriminant is 0 aka no sqrt needed
AND R7,R7,#0	; Sign register
LDI R0, B	; R0 = b; R1 = 2a
BRz STORE
BRp #3
NOT R0,R0	; Take |b| and record sign
ADD R0,R0,#1
ADD R7,R7,#-1
LD R1, TWOA
BRp #3		; Take |2a| and record sign
NOT R1,R1
ADD R1,R1,#1
ADD R7,R7,#1
		
AND R2,R2,#0	; Divide routine
NOT R1,R1
ADD R1,R1,#1	; Set |2a| as subtractor/divisor
DIV ADD R2,R2,#1
ADD R0,R0,R1
BRp DIV
ADD R0,R2,#0

AND R5,R5,#0	; Store # solutions
ADD R5,R5,#1
STI R5, A	
ADD R7,R7,#0	; Check solution sign and change if necessary
BRz #2
NOT R0,R0
ADD R0,R0,#1
STORE
NOT R0,R0
ADD R0,R0,#1
STI R0, B	; Store solution
HALT

SQRTVAL .FILL 0
TWOSOLN
AND R0,R0,#0	; Store # solutions
ADD R0,R0,#2
STI R0,A
LD R0, DISCRIMINANT
ADD R1,R0,#-1	; Check if discriminant is 1
ST R0,SQRTVAL
ADD R1,R1,#0
BRz SOLN1
AND R1,R1,#0	; SQRT routine
ADD R1,R1,#1	; Start checking sqrt at 2 - R1 holds current # being squared

SQRT
ADD R1,R1,#1
ADD R2,R1,#0	; Initialize squared value of R1
ADD R3,R1,#-1	; Initialize counter
SQU		; Square routine
ADD R2,R1,R2	; Do addition
ADD R3,R3,#-1	; Set CCs
BRp SQU

NOT R2,R2	; Check if result equals discriminant
ADD R2,R2,#1
ADD R4,R0,R2
BRp SQRT
ADD R0,R1,#0	; sqrt(b^2-4ac) in R0.
ST R0, SQRTVAL	; Store sqrt value

; Compute first solution - R0 = (-b-sqrt(b^2-4ac))/2a
SOLN1
LDI R1, B
ADD R0,R1,R0	; b+sqrt(b^2-4ac)
NOT R0,R0
ADD R0,R0,#1	; R0 = -b-sqrt(b^2-4ac)

AND R2,R2,#0
AND R7,R7,#0	; Sign register
ADD R0,R0,#0	; R1 = 2a
BRz SOLZERO
BRp #3
NOT R0,R0	; Take |b| and record sign
ADD R0,R0,#1
ADD R7,R7,#-1
LD R1, TWOA
BRp #3		; Take |2a| and record sign
NOT R1,R1
ADD R1,R1,#1
ADD R7,R7,#1
		
AND R2,R2,#0	; Divide routine
NOT R1,R1
ADD R1,R1,#1	; Set |2a| as subtractor/divisor
DIVIDE ADD R2,R2,#1
ADD R0,R0,R1
BRp DIVIDE
ADD R7,R7,#0
BRz #2
NOT R2,R2
ADD R2,R2,#1
SOLZERO ADD R6,R2,#0 	; Store first solution

; Compute second solution - R1
SOLN2
LD R0,SQRTVAL
LDI R1,B
NOT R1,R1	; -b
ADD R1,R1,#1	
ADD R0,R1,R0	; -b+sqrt(b^2-4ac)

AND R2,R2,#0
AND R7,R7,#0	; Sign register
ADD R0,R0,#0	; R1 = 2a
BRz SOL0
BRp #3
NOT R0,R0	; Take |b| and record sign
ADD R0,R0,#1
ADD R7,R7,#-1
LD R1, TWOA
BRp #3		; Take |2a| and record sign
NOT R1,R1
ADD R1,R1,#1
ADD R7,R7,#1
		
AND R2,R2,#0	; Divide routine
NOT R1,R1
ADD R1,R1,#1	; Set |2a| as subtractor/divisor
DIV1 ADD R2,R2,#1
ADD R0,R0,R1
BRp DIV1
ADD R7,R7,#0
BRz #2
NOT R2,R2
ADD R2,R2,#1

SOL0
NOT R3,R6	; Check first < second
ADD R3,R3,#1
ADD R4,R2,R3
BRp #3
STI R2, B
STI R6, C
HALT
STI R6, B	; Store first solution
STI R2, C	; Store second solution
HALT

A .FILL x4000
B .FILL x4001
C .FILL x4002

.END
