; EE 306: Introduction to Computing
; Fall 2018 - Cuevas
; 
; Title: Minesweeper, Pt. 1
; Name: Akarsh Kumar
; EID: ak39969
; Recitation Section: F 11 AM
;
; You are given the main program
; and some declarations. The subroutines you are responsible for
; are given as empty stubs at the bottom. Follow the contract. 
; You are free to rearrange your subroutines if the need were to 
; arise.

; Testcase 1 - Check if program has been modified

;***********************************************************
.ORIG x3000

;***********************************************************
; Main Program
;***********************************************************
        JSR   DISPLAY_BOARD
        LEA   R0, BOARD_INITIAL
        PUTS
	LDI   R0, BLOCKS
	JSR   LOAD_BOARD
        JSR   DISPLAY_BOARD
        LEA   R0, BOARD_LOADED
        PUTS                        ; output end message
        HALT                        ; halt
BOARD_LOADED       .STRINGZ "\nBoard Loaded\n"
BOARD_INITIAL      .STRINGZ "\nBoard Initial\n"
BLOCKS		    .FILL x6000

;***********************************************************
; Global constants used in program (don't worry about this)
;***********************************************************
SCORE .BLKW 1
;***********************************************************
; This is the data structure for the BOARD grid
;***********************************************************
GRID               .STRINGZ "+-+-+-+-+"
ROW0               .STRINGZ "| | | | |"
                   .STRINGZ "+-+-+-+-+"
ROW1               .STRINGZ "| | | | |"
                   .STRINGZ "+-+-+-+-+"
ROW2               .STRINGZ "| | | | |"
                   .STRINGZ "+-+-+-+-+"
ROW3               .STRINGZ "| | | | |"
                   .STRINGZ "+-+-+-+-+"

;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
; The code above is provided for you. 
; DO NOT MODIFY THE CODE ABOVE THIS LINE.
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************

;***********************************************************
; GRID_ADDRESS
; Input:  R1 has the row number (0-3)
;         R2 has the column number (0-3)
; Output: R0 has the corresponding address of the space in the GRID
; Notes: This is a key routine.  It translates the (row, col) logical 
;        GRID coordinates of a gridblock to the physical address in 
;        the GRID memory.
;***********************************************************

GRID_ADDRESS
	ST R7, R7VGA

	LEA R0, ROW0
	ADD R0, R0, #1

	ST R0, R0VGA

	;20*R1->R1
	AND R0, R0, #0
	ADD R0, R0, #10
	ADD R0, R0, #10
	JSR mulP
	AND R1, R1, #0
	ADD R1, R1, R0	;R1 has 20*R1
	
	;02*R2->R2
	ADD R2, R2, R2	;R2 has 2*R2
	
	LD R0, R0VGA
	ADD R0, R0, R1
	ADD R0, R0, R2

	
	LD R7, R7VGA	
	RET

R0VGA	.BLKW 1
R7VGA	.BLKW 1


;***********************************************************
; DISPLAY_BOARD
;   Displays the current state of the BOARD Grid.
; Input: None
; Output: None
; Notes: The displayed grid must have the row and column numbers.
;***********************************************************

NLCHAR	.FILL xA

EMPSTR	.STRINGZ "  "
COLSTR	.STRINGZ " 0 1 2 3 "
ROWSTR0	.STRINGZ "0 "
ROWSTR1	.STRINGZ "1 "
ROWSTR2	.STRINGZ "2 "
ROWSTR3	.STRINGZ "3 "

DISPLAY_BOARD      
	ST R0, R0VDIS	;Save values that will be altered
	ST R7, R7VDIS
	
	LD R0, NLCHAR
	OUT

	LEA R0, EMPSTR	;Print the board
	PUTS

	LEA R0, COLSTR
	PUTS
	
	LD R0, NLCHAR
	OUT

	LEA R0, EMPSTR
	PUTS

	LEA R0, GRID
	PUTS
	
	LD R0, NLCHAR
	OUT	

	LEA R0, ROWSTR0
	PUTS

	LEA R0, ROW0
	PUTS

	LD R0, NLCHAR
	OUT

	LEA R0, EMPSTR
	PUTS

	LEA R0, GRID
	PUTS
	
	LD R0, NLCHAR
	OUT

	LEA R0, ROWSTR1
	PUTS

	LEA R0, ROW1
	PUTS
	
	LD R0, NLCHAR
	OUT

	LEA R0, EMPSTR
	PUTS

	LEA R0, GRID
	PUTS
	
	LD R0, NLCHAR
	OUT
	
	LEA R0, ROWSTR2
	PUTS

	LEA R0, ROW2
	PUTS

	LD R0, NLCHAR
	OUT

	LEA R0, EMPSTR
	PUTS

	LEA R0, GRID
	PUTS
	
	LD R0, NLCHAR
	OUT

	LEA R0, ROWSTR3
	PUTS

	LEA R0, ROW3
	PUTS

	LD R0, NLCHAR
	OUT

	LEA R0, EMPSTR
	PUTS

	LEA R0, GRID
	PUTS
	
	LD R0, NLCHAR
	OUT

	
	LD R0, R0VDIS	;Load values from before this method
	LD R7, R7VDIS
	RET
R0VDIS	.BLKW 1
R7VDIS	.BLKW 1

;***********************************************************
; LOAD_BOARD
; Input:  R0  has the address of the head of a linked list of
;         gridblock records. Each record has 3 fields:
;		1. row # (0-3)
;		2. col # (0-3)
;               3. Address of the next gridblock in the list
;         The list is guaranteed to be terminated by a gridblock
;	  whose next address field is a zero.
;
; Output: None
;   This function loads the board from a linked list by inserting 
;   bombs (*) or numbers corresponding to the # of bombs near
;   the position into the grid.
;       
;***********************************************************

LOAD_BOARD
	ST R0, R0VLB
	ST R1, R1VLB
	ST R2, R2VLB
	ST R3, R3VLB
	ST R4, R4VLB
	ST R5, R5VLB
	ST R6, R6VLB
	ST R7, R7VLB	

	AND R1, R1, #0
	AND R2, R2, #0
	AND R3, R3, #0
	AND R4, R4, #0
	AND R5, R5, #0
	AND R6, R6, #0
	AND R7, R7, #0
	
	
lprowLB
	
	AND R2, R2, #0
lpcolLB	
	
	ST R0, R0VLB
	ST R1, R1VLB1	
	ST R2, R2VLB1

	JSR GRID_ADDRESS

	AND R3, R3, #0
	ADD R3, R3, R0
		;R3 has the address in memory

	LD R0, R0VLB
	LD R1, R1VLB1
	LD R2, R2VLB1	

	JSR COUNT_BOMBS
	
	AND R4, R4, #0
	
	ADD R0, R0, #0
	BRp notbLB
	BRz eLB
	;is a bomb
	ADD R4, R4, #15	;add 42
	ADD R4, R4, #15
	ADD R4, R4, #12
	BRnzp writeLB


notbLB	
	ADD R4, R4, #15	;add 48
	ADD R4, R4, #15
	ADD R4, R4, #15
	ADD R4, R4, #3

	ADD R4, R4, R0

	BRnzp writeLB

eLB	
	ADD R4, R4, #15	;add 32
	ADD R4, R4, #15
	ADD R4, R4, #2

	BRnzp writeLB


writeLB
	STR R4, R3, #0
	
	LD R0, R0VLB
	
	LD R1, R1VLB1
	LD R2, R2VLB1

	ADD R2, R2, #1
	ADD R2, R2, #-4
	BRz endcLB
	ADD R2, R2, #4
	BRnzp lpcolLB

endcLB	
	ADD R1, R1, #1

	ADD R1, R1, #-4
	BRz endrLB
	ADD R1, R1, #4
	BRnzp lprowLB

endrLB

	
;dLB
	LD R0, R0VLB
	LD R1, R1VLB
	LD R2, R2VLB
	LD R3, R3VLB
	LD R4, R4VLB
	LD R5, R5VLB
	LD R6, R6VLB
	LD R7, R7VLB	

	RET

R0VLB	.BLKW 1
R1VLB	.BLKW 1
R1VLB1	.BLKW 1
R2VLB	.BLKW 1
R2VLB1	.BLKW 1
R3VLB	.BLKW 1
R4VLB	.BLKW 1
R5VLB	.BLKW 1
R6VLB	.BLKW 1
R7VLB	.BLKW 1


;***********************************************************
; COUNT_BOMBS
; Input:  R0  has the address of the head of a linked list of
;         gridblock records. Each record has 3 fields:
;		1. row # (0-3)
;		2. col # (0-3)
;               3. Address of the next gridblock in the list
;         The list is guaranteed to be terminated by a gridblock
;	  whose next address field is a zero.
;
;	  R1 - Row # of location to count bombs around
;	  R2 - Col # of location to count bombs around
;		*Assume that location is valid.
;
; Output: R0 contains the number of bombs
; 		R0 = -1 if the location contains a bomb 
; 
;   This function calculates the number of bombs within one location
;	of the given location.
;       
;***********************************************************

COUNT_BOMBS
	ST R0, R0VCB
	ST R1, R1VCB
	ST R2, R2VCB
	ST R3, R3VCB
	ST R4, R4VCB
	ST R5, R5VCB
	ST R6, R6VCB
	ST R7, R7VCB
	
	AND R3, R3, #0
	AND R4, R4, #0
	AND R5, R5, #0
	AND R6, R6, #0
	AND R7, R7, #0

loopCB
	ADD R0, R0, #0
	BRz dCB
	
	LDR R3, R0, #0
	LDR R4, R0, #1
	
	NOT R3, R3
	ADD R3, R3, #1

	NOT R4, R4
	ADD R4, R4, #1
	
	ADD R3, R1, R3
	ADD R4, R2, R4
	;take absolute values of distances
	ST R0, R0VCB
	ST R1, R1VCB
	ST R2, R2VCB
	
	AND R0, R0, #0
	ADD R0, R3, #0
	AND R1, R1, #0
	ADD R1, R4, #0
	
	JSR sgnP
	
	AND R3, R3, #0
	ADD R3, R0, #0
	AND R4, R4, #0
	ADD R4, R1, #0
	
	LD R0, R0VCB
	LD R1, R1VCB
	LD R2, R2VCB


	;now we have distances to the bomb in R3, R4
	
	;check if our location is a bomb
	ADD R3, R3, #0
	BRnp notbCB
	ADD R4, R4, #0
	BRnp notbCB
		;is a bomb location
	AND R5, R5, #0
	ADD R5, R5, #-1
	BRnzp dCB

notbCB
	;not a bomb location
	ADD R3, R3, #-2
	BRzp notnCB
	ADD R4, R4, #-2
	BRzp notnCB
		;is near a bomb
	ADD R5, R5, #1
	
notnCB	
	
	LDR R0, R0, #2
	BRnzp loopCB
	
dCB	
	AND R0, R0, #0
	ADD R0, R5, #0
	
	LD R1, R1VCB
	LD R2, R2VCB
	LD R3, R3VCB
	LD R4, R4VCB
	LD R5, R5VCB
	LD R6, R6VCB
	LD R7, R7VCB

	RET

R0VCB	.BLKW 1
R1VCB	.BLKW 1
R2VCB	.BLKW 1
R3VCB	.BLKW 1
R4VCB	.BLKW 1
R5VCB	.BLKW 1
R6VCB	.BLKW 1
R7VCB	.BLKW 1


; Akarsh's Multiply Program
; Inputs: R0, R1,
; Outputs: R0 (=R0*R1)
	
	
mulP	
	ST R2, R2VMUL
	ST R3, R3VMUL
	ST R7, R7VMUL
	JSR sgnP
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
	LD R2, R2VMUL
	LD R3, R3VMUL
	LD R7, R7VMUL
	RET

R2VMUL	.BLKW 1
R3VMUL	.BLKW 1
R7VMUL	.BLKW 1





; Akarsh's Sign Program
; Inputs: R0, R1,
; Output: R0=|R0|, R1=|R1|, R2=sign(R0,R1), 0 if positive, 1 if negative
; Uses R0, R1, R2
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
	RET


	.END