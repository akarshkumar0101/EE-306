; Akarsh's Multiply Program
; Inputs: R0, R1
; Outputs: R0 (=R0*R1), uses registers R0, R1, R2, R3, R7 as working registers
	
	.ORIG x3000
	
	LEA R4, sgnP
	LEA R7, mulret
	JMP R4
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
	ADD R2, R2, #0
	BRz dmul
	NOT R0, R0
	ADD R0, R0, #1
dmul
	BRnzp done

sgnP
; Akarsh's Sign Algorithm
; Inputs: R0, R1
; Output: R0=|R0|, R1=|R1|, R2=sign(R0,R1), 0 if positive, 1 if negative
; works with all signs
	
	AND R3, R3, #0

	ADD R0, R0, #0
	BRzp skpsgn1 
	ADD R3, R3, #1
	ADD R0, R0, #-1
	NOT R0, R0
skpsgn1
	ADD R1, R1, #0
	BRzp skpsgn2
	ADD R3, R3, #1
	ADD R1, R1, #-1
	NOT R1, R1
skpsgn2	
	ADD R3, R3, #-1
		;R3 will be either -1, 0 or 1 right now
		; -1, 1 means positive out, 0 means negative out
	AND R2, R2, #0	;assume positive output
	ADD R3, R3, #0
	BRnp dsgn 
	ADD R2, R2, #1	;apply negative out
dsgn
	RET




done	HALT

	.END