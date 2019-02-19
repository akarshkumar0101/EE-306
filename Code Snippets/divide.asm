;
; A program that finds the quotient and remainder of R0/R1
; 
;
; Inputs:  R0 - divident (positive)
;          R1 - divisor  (positive)
;
; Outputs: R0 - quotient
;          R1 - remainder
;

	.ORIG x3000

	AND R2, R2, #0
	NOT R1, R1
	ADD R1, R1, #1		; 2's complement
	
loop	ADD R0, R0, #0
	BRz done
	BRn remain
	ADD R0, R0, R1
	ADD R2, R2, #1
	BRnzp loop

remain	NOT R1, R1
	ADD R1, R1, #1
	ADD R0, R0, R1		;
	ADD R2, R2, #-1

done	AND R1, R1, #0
	ADD R1, R1, R0
	AND R0, R0, #0
	ADD R0, R0, R2

	TRAP x25
	.END