;
; A program that finds the product of R0*R1
; 
; Program assumes that the multiplication does not produce overflow.
;
; Inputs:  R0 - multiplicand
;          R1 - multiplier
;
; Outputs: R0 - product
;

	.ORIG x3000

	; Check if either input is zero
	; Also track how many inputs are negative	
	AND R2, R2, #0
	ADD R0, R0, #0
	BRz zero
	BRp #3
	ADD R2, R2, #1
	NOT R0, R0
	ADD R0, R0, #1

	ADD R1, R1, #0
	BRz zero
	BRp #3
	ADD R2, R2, #1
	NOT R1, R1
	ADD R1, R1, #1


	; Perform multiplication	
	AND R4, R4, #0
	ADD R4, R4, R0
	AND R0, R0, #0

loop	ADD R0, R0, R4
	ADD R1, R1, #-1
	BRnp loop

	; Apply sign (if necessary)
	ADD R2, R2, #-1
	BRnp done
	NOT R0, R0
	ADD R0, R0, #1
	
done	TRAP x25
	
zero	AND R0, R0, 0
	BR done


	.END