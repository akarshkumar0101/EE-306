; EE 306: Introduction to Computing
; Fall 2018 - Cuevas
; 
; Name: Akarsh Kumar
; EID: ak39969
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
	LDI R0, B
	ADD R1, R0, #0
	
	
	LEA R7, b2ret
	ST R7, mRetTo
	LEA R7, mulP
	JMP R7
b2ret
	;have b^2 in R0,
	ST R0, B2
	
	LDI R0, A
	LDI R1, C
	
	LEA R7, acret
	ST R7, mRetTo
	LEA R7, mulP
	JMP R7
acret	
	;have ac in R0
	AND R1, R1, #0
	ADD R1, R1, #-4
	
	LEA R7, ac4ret
	ST R7, mRetTo
	LEA R7, mulP
	JMP R7
ac4ret
	;have 4ac in R0
	ST R0, AC4
	
	LD R0, B2
	LD R1, AC4
	
	ADD R2, R0, R1
	ST R2, DISC
	
	AND R3, R3, #0
	ST R3, NUMSOL
	
	LDI R0, B
	NOT R0, R0
	ADD R0, R0, #1
	ST R0, NEGB

	LDI R0, A
	ADD R0, R0, R0
	ST R0, A2

	ADD R2, R2, #0
	BRn numSol0

	ADD R3, R3, #1
	ST R3, NUMSOL
	ADD R2, R2, #0
	BRz numSol1

	ADD R3, R3, #1
	ST R3, NUMSOL
	ADD R2, R2, #0
	BRp numSol2
	

numSol2
	LD R0, DISC

	LEA R7, sqrtret
	ST R7, rtRetTo
	LEA R7, rtP
	JMP R7
sqrtret
	;have sqrt in R0
	ST R0, SQRT

	LD R0, NEGB
	LD R1, A2
	LD R2, SQRT
	
	ADD R0, R0, R2
	
	LEA R7, d1ret
	ST R7, dRetTo
	LEA R7, divP
	JMP R7
d1ret	
	;first solution in R0
	ST R0, SOL1

	LD R0, NEGB
	LD R1, A2
	LD R2, SQRT
	
	NOT R2, R2
	ADD R2, R2, #1
	
	ADD R0, R0, R2
	
	LEA R7, d2ret
	ST R7, dRetTo
	LEA R7, divP
	JMP R7
d2ret	
	;second solution in R0
	ST R0, SOL2
	

	LD R0, SOL1
	LD R1, SOL2
	
	NOT R2, R1
	ADD R2, R2, #1
	
	ADD R3, R0, R2	;R3 = R0-R1
	BRnz done
		
	;code to switch solutions
	ST R0, SOL2
	ST R1, SOL1

	BRnzp done

numSol1
	
	LD R0, NEGB
	LD R1, A2
	
	LEA R7, d3ret
	ST R7, dRetTo
	LEA R7, divP
	JMP R7
d3ret	
	;solution in R0
	ST R0, SOL1
	
	BRnzp done

numSol0

	BRnzp done
	
done	LD R0, NUMSOL
	LD R1, SOL1
	LD R2, SOL2
	STI R0, A
	STI R1, B
	STI R2, C
	
	
	HALT




		

; Akarsh's Square Root Program
; Inputs: R0, 
; Outputs: R0 (=sqrt(R0))
; uses R0, R1, R2, R3, R4, R5

rtRetTo	.BLKW 1
rtP
	ADD R4, R0, #0
	AND R5, R5, #0
	
rtloop
	ADD R0, R5, #0
	ADD R1, R5, #0
		;multiply R0, R1
	LEA R7, rtret
	ST R7, mRetTo
	LEA R7, mulP
	JMP R7
rtret	
	;R0 has R5^2,

	NOT R0, R0
	ADD R0, R0, #1	;got negative R0

	ADD R2, R4, R0
	BRz drt2
	BRn drt1
	ADD R5, R5, #1
	BRnzp rtloop
drt1
	ADD R5, R5, #-1

drt2	;answer in R1

	ADD R0, R5, #0

drt
	LD R7, rtRetTo
	JMP R7


; Akarsh's Division Program
; Inputs: R0, R1
; Outputs: R0 (=R0/R1), R1 (=R0%R1) 
; uses R0, R1, R2, R3

dRetTo	.BLKW 1
divP	
	LEA R7, divret
	ST R7, sRetTo
	LEA R7, sgnP
	JMP R7
divret
		;now we have signs for |R0|, |R1| stored in R2
		;compute division of R0, R1
	
	ADD R3, R1, #0
	NOT R3, R3
	ADD R3, R3, #1	;R3=-R1

	AND R4, R4, #0
loopdiv	
	ADD R7, R0, R3
	BRn ddiv1
	
	ADD R0, R7, #0	;descent R0
	ADD R4, R4, #1
	
	BRnzp loopdiv

ddiv1
	ADD R1, R0, #0
	ADD R0, R4, #0

	ADD R2, R2, #0
	BRz ddiv
	NOT R0, R0
	ADD R0, R0, #1

ddiv	
	LD R7, dRetTo
	JMP R7
	
	
	
	
	



; Akarsh's Multiply Program
; Inputs: R0, R1,
; Outputs: R0 (=R0*R1)
; Uses registers R0, R1, R2, R3
	
mRetTo	.BLKW 1
mulP
	LEA R7, mulret
	ST R7, sRetTo
	LEA R7, sgnP
	JMP R7
mulret
		;now we have signs for |R0|, |R1| stored in R2
		;compute multiplication of R0, R1 in R0
	
	ADD R3, R0, #0
	AND R0, R0, #0

loopmul
	
	ADD R1, R1, #0
	BRz dmul1
	
	ADD R0, R0, R3
	ADD R1, R1, #-1

	BRnzp loopmul

dmul1
	ADD R2, R2, #0	;here is answer
	BRz dmul

	NOT R0, R0	;computing negative answer
	ADD R0, R0, #1

dmul
	LD R7, mRetTo
	JMP R7





; Akarsh's Sign Program
; Inputs: R0, R1,
; Output: R0=|R0|, R1=|R1|, R2=sign(R0,R1), 0 if positive, 1 if negative
; Uses R0, R1, R2
sRetTo	.BLKW 1
sgnP
	AND R2, R2, #0

	ADD R0, R0, #0
	BRzp skpsgn1 
	ADD R2, R2, #1
	ADD R0, R0, #-1
	NOT R0, R0
skpsgn1
	ADD R1, R1, #0
	BRzp skpsgn2
	ADD R2, R2, #1
	ADD R1, R1, #-1
	NOT R1, R1
skpsgn2	
	ADD R2, R2, #-1
		;R2 will be either -1, 0 or 1 right now
		; -1, 1 means positive out, 0 means negative out

	ADD R2, R2, #0
	BRnp sgn0
	Brz sgn1
sgn0
	AND R2, R2, #0
	BRnzp dsgn
sgn1
	AND R2, R2, #0
	ADD R2, R2, #1
	BRnzp dsgn
dsgn
	LD R7, sRetTo
	JMP R7




A	.FILL x4000
B 	.FILL x4001
C	.FILL x4002
B2	.BLKW 1	;x4003 is b^2
AC4	.BLKW 1	;x4004 is -4ac
DISC	.BLKW 1	;x4005 is b^2-4ac
NUMSOL	.BLKW 1	;is number of solutions
SQRT	.BLKW 1	;x4006 is sqrt(b^2-4ac)
NEGB	.BLKW 1	;x4007 is -b
A2	.BLKW 1
SOL1	.BLKW 1
SOL2	.BLKW 1
		

.END
