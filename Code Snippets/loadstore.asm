;
; This program demonstrates load and store instructions
;

	.ORIG x3000

	LD R0, mem	; load x0001 into R0
	LDI R0, addr	; load x0002 into R0
	LEA R0, m em	; load address of mem into R0
	LDR R1, R0, #4	; load x0005 into R1
	
	ST R1, mem	; store x0005 into mem
	STI R1, addr	; store x0005 into mem + 1
	STR R1, R0, #2	; store x0005 into mem + 3




	TRAP x25

mem	.FILL x0001
	.FILL x0002
	.FILL x0003
	.FILL x0004
	.FILL x0005
addr	.FILL x3009
	
	.END