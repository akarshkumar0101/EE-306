	.ORIG x3000
	LEA R0, hello
	ADD R0, R0, #6	
	LEA R1, drc
	AND R2,R2, #0	;<- A
	
loop	ADD R3, R1, R2	
	LDR R4, R3, #0	
	ADD R5, R0, R2 
	STR R4, R5, #0

	ADD R2, R2, #1
	ADD R3, R2, #-5
	BRn loop
	TRAP x25
hello	.STRINGZ "HELLO WORLD!\n"
drc	.STRINGZ "DR. C"
	.END
