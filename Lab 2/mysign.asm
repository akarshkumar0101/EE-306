; Akarsh's Sign Algorithm
; Inputs: R0, R1
; Output: R0=|R0|, R1=|R1|, R2=sign(R0,R1), 0 if positive, 1 if negative
; works with all signs
	
	.ORIG x3000
	
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
	HALT

	.END