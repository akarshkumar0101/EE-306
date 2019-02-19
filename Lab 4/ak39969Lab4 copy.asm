; EE 306: Introduction to Computing
; Fall 2018 - Cuevas
; 
; Title: Minesweeper, Pt. 2
; Author: Akarsh Kumar
; Recitation Section: F 11 AM
;
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
	LEA   R0, START_GAME
	PUTS
        JSR   DISPLAY_BOARD
        LEA   R0, BOARD_INITIAL
        PUTS
ENGINE	JSR   GET_MOVE
	JSR   IS_VALID_MOVE
	ADD   R0,R0,#0
	BRn   ENGINE
	JSR   APPLY_MOVE
        JSR   DISPLAY_BOARD
	JSR   IS_GAME_OVER
	ADD   R0,R0,#0
	BRz   ENGINE
	JSR   GAME_OVER	
        HALT                        ; halt
BOARD_LOADED       .STRINGZ "\nBoard Loaded\n"
BOARD_INITIAL      .STRINGZ "\nBoard Initial\n"
START_GAME	.STRINGZ "Minesweeper\n"
BLOCKS		    .FILL x6000

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

MOVSTR	.STRINGZ "Enter a move: ("
COMMSTR	.STRINGZ ","
ENDPSTR	.StRINGZ ")\n"
;***********************************************************
; GET_MOVE

; Input: None
; Output: R0 - Input 1; R1 - Input 2
;***********************************************************
GET_MOVE
	ST R0, GMR0
	ST R1, GMR1
	ST R2, GMR2
	ST R3, GMR3
	ST R4, GMR4
	ST R5, GMR5
	ST R6, GMR6
	ST R7, GMR7

	LEA R0, MOVSTR
	PUTS
	
	GETC
	OUT
	
	ADD R1, R0, #0
	
	LEA R0, COMMSTR
	PUTS

	GETC
	OUT
	ADD R2, R0, #0
	
	LEA R0, ENDPSTR
	PUTS
	
	ADD R0, R1, #0
	ADD R1, R2, #0

	LD R2, GMR2
	LD R3, GMR3
	LD R4, GMR4
	LD R5, GMR5
	LD R6, GMR6
	LD R7, GMR7

	RET
GMR0	.BLKW 1
GMR1	.BLKW 1
GMR2	.BLKW 1
GMR3	.BLKW 1
GMR4	.BLKW 1
GMR5	.BLKW 1
GMR6	.BLKW 1
GMR7	.BLKW 1


CHAR0	.STRINGZ "0"
CHARSP	.STRINGZ " "
CHARAS	.STRINGZ "*"
IVMESTR	.STRINGZ "Invalid move - try again!\n"

;***********************************************************
; IS_VALID_MOVE

; Input: R0 - Input 1 (row); R1 - Input 2 (col)
; Output: If valid, set (R0,R1)=(row,col) to move; else R0 = -1
;***********************************************************
IS_VALID_MOVE
	ST R0, IVMR0
	ST R1, IVMR1
	ST R2, IVMR2
	ST R3, IVMR3
	ST R4, IVMR4
	ST R5, IVMR5
	ST R6, IVMR6
	ST R7, IVMR7
	
	LD R2, CHAR0
	NOT R2, R2
	ADD R2, R2, #1
	
	ADD R0, R0, R2
	ADD R1, R1, R2

	;check bounds between [0,3]
	
	ADD R0, R0, #0
	BRn IVMERR
	ADD R2, R0, #-3
	BRp IVMERR
	
	ADD R1, R1, #0
	BRn IVMERR
	ADD R2, R1, #-3
	BRp IVMERR
	
	BRnzp IVMDNE
	
IVMERR	
	LEA R0, IVMESTR
	PUTS
	AND R0, R0, #0
	ADD R0, R0, #-1
	LD R1, IVMR1
	BRnzp IVMDNE

IVMDNE
	LD R2, IVMR2
	LD R3, IVMR3
	LD R4, IVMR4
	LD R5, IVMR5
	LD R6, IVMR6
	LD R7, IVMR7
	RET

IVMR0	.BLKW 1
IVMR1	.BLKW 1
IVMR2	.BLKW 1
IVMR3	.BLKW 1
IVMR4	.BLKW 1
IVMR5	.BLKW 1
IVMR6	.BLKW 1
IVMR7	.BLKW 1

STATUS	.FILL 0

PMOVES	.BLKW 16
NMOVE	.FILL PMOVES

TRYDSTR	.STRINGZ "You already tried this location!"



;***********************************************************
; APPLY_MOVE

; Input: (R0,R1) = (Row,Col) of desired move
; Output: (R0,R1) = (Row,Col) of completed move
;***********************************************************
APPLY_MOVE
	ST R0, AMR0
	ST R1, AMR1
	ST R2, AMR2
	ST R3, AMR3
	ST R4, AMR4
	ST R5, AMR5
	ST R6, AMR6
	ST R7, AMR7
	
	LD R1, AMR0
	LD R2, AMR1
	
	JSR GRID_ADDRESS
	ADD R6, R0,#0

	JSR HAS_MOVE
	ADD R1, R1, #0
	BRp AMHASM
	
	;put the new move now
	JSR INCSCR

	LDI R0, BLOCKSA
	LDR R0, R0, #0
	LD R1, AMR0
	LD R2, AMR1
	
	JSR COUNT_BOMBS
	
	LD R5, NMOVE
	STR R6, R5, #0
	ADD R5, R5, #1
	ST R5, NMOVE
	
	JSR NUM_BOMBS	
	ADD R5, R3, R5

	LEA R4, NMOVE
	NOT R5, R5
	ADD R5, R5, #1
	ADD R5, R5, R4
	BRnp AMNWON
	;won
	LD R5, STATUS
	AND R5, R5, #0
	ADD R5, R5, #1
	ST R5, STATUS
AMNWON

	ADD R0, R0, #0
	BRn HITB
	BRz HIT0
	BRp HITNUM

HITB	
	LD R1, CHARAS
	STR R1, R6, #0
	
	AND R5, R5, #0
	ADD R5, R5, #-1
	ST R5, STATUS

	BRnzp AMDNE
HIT0	
	LD R1, CHARSP
	STR R1, R6, #0
	BRnzp AMDNE
HITNUM	
	LD R1, CHAR0
	ADD R0, R0, R1
	STR R0, R6, #0
	BRnzp AMDNE
	
AMHASM
	LEA R0, TRYDSTR
	PUTS
	BRnzp AMDNE

AMDNE
	
	LD R0, AMR0
	LD R1, AMR1
	LD R2, AMR2
	LD R3, AMR3
	LD R4, AMR4
	LD R5, AMR5
	LD R6, AMR6
	LD R7, AMR7
	
	RET

AMR0	.BLKW 1
AMR1	.BLKW 1
AMR2	.BLKW 1
AMR3	.BLKW 1
AMR4	.BLKW 1
AMR5	.BLKW 1
AMR6	.BLKW 1
AMR7	.BLKW 1

BLOCKSA	.FILL BLOCKS

;input: R0
HAS_MOVE
	AND R1, R1, #0

	LEA R2, PMOVES	;address of pmoves
	AND R3, R3, #0
	ADD R3, R3, #15	;amount of offset
	
HMLOOP
	ADD R4, R2, R3	;current address to check
	LDR R4, R4, #0
	
	NOT R4, R4
	ADD R4, R4, #1
	
	ADD R4, R0, R4

	BRz HMYES
	
	ADD R3, R3, #-1
	BRn HMNO
	BRnzp HMLOOP

HMYES
ADD R1, R1, #1

HMNO

	RET


SCORE1	.FILL x30
SCORE0	.FILL x30
NLCHAR1	.FILL xA
TCHAR1	.FILL 0

SCORE	.FILL SCORE0

INCSCR	
	ST R0, ISR0
	ST R1, ISR1
	ST R2, ISR2
	ST R3, ISR3
	ST R4, ISR4
		
	LD R0, SCORE0
	LD R1, SCORE1
	
	ADD R2, R0, #0
	ADD R2, R2, #-10
	ADD R2, R2, #-10
	ADD R2, R2, #-10
	ADD R2, R2, #-10
	ADD R2, R2, #-10
	ADD R2, R2, #-7
	BRz CNGDIG
	BRn KPDIG
	
KPDIG	
	ADD R0, R0, #1
	
	BRnzp STDIG
CNGDIG
	ADD R0, R0, #-9
	ADD R1, R1, #1
	LEA R2, SCORE1
	ST R2, SCORE

	BRnzp STDIG
STDIG	ST R0, SCORE0
	ST R1, SCORE1
	
	LD R0, ISR0
	LD R1, ISR1
	LD R2, ISR2
	LD R3, ISR3
	LD R4, ISR4
	RET

ISR0	.BLKW 1
ISR1	.BLKW 1
ISR2	.BLKW 1
ISR3	.BLKW 1
ISR4	.BLKW 1




;***********************************************************
; IS_GAME_OVER
; Assume APPLY_MOVE called before. 
; Input: (R0,R1) - (Row,Col) of last move
; Output: 0 - Game not over; 1 - Player won; -1 - Player lost
;***********************************************************
IS_GAME_OVER
	LD R0, STATUS
	RET



WONSTR	.STRINGZ "\nCongrats, you won!\n"
LOSSTR	.STRINGZ "\nYou lost! Better luck next time!\n"
SCRSTR	.STRINGZ "\nYour score is: "

WINSCRS	.STRINGZ "99\n"
;***********************************************************
; GAME_OVER
; 
; Input: R0 = 1 if player won; R0 = -1 if player lost
; Output: None
;***********************************************************
GAME_OVER
	ST R0, GOR0
	ST R1, GOR1
	ST R2, GOR2
	ST R3, GOR3
	ST R4, GOR4
	ST R5, GOR5
	ST R6, GOR6
	ST R7, GOR7



	ADD R1, R0, #0
	BRn GOLOS
	BRp GOWIN
	
	
GOWIN	LEA R0, WONSTR
	PUTS

	LEA R1, WINSCRS

	BRnzp GOM
	

GOLOS	LEA R0, LOSSTR
	PUTS

	LD R1, SCORE

	BRnzp GOM
	
	
GOM	
	LDI R0, BLOCKSA
	LDR R0, R0, #0

	JSR LOAD_BOARD
	JSR DISPLAY_BOARD
	LEA R0, SCRSTR
	PUTS
	ADD R0, R1, #0
	PUTS
	
	
	LD R0, GOR0
	LD R1, GOR1
	LD R2, GOR2
	LD R3, GOR3
	LD R4, GOR4
	LD R5, GOR5
	LD R6, GOR6
	LD R7, GOR7



	RET
GOR0	.BLKW 1
GOR1	.BLKW 1
GOR2	.BLKW 1
GOR3	.BLKW 1
GOR4	.BLKW 1
GOR5	.BLKW 1
GOR6	.BLKW 1
GOR7	.BLKW 1


NUM_BOMBS
	ST R0, NBR0
	ST R1, NBR1
	ST R2, NBR2
	ST R3, NBR3
	ST R4, NBR4
	ST R5, NBR5
	ST R6, NBR6
	ST R7, NBR7


	LDI R0, BLOCKSA
	LDR R0, R0, #0
	;R0 is address of the head
	
	AND R1, R1, #0
	
NBLoop
	ADD R0, R0, #0
	BRz NBDNE
	
	ADD R1, R1, #1
	LDR R0, R0, #2
	BRnzp NBLoop
	
NBDNE	
	ADD R3, R1, #0
	
	LD R0, NBR0
	LD R1, NBR1
	LD R2, NBR2
	LD R4, NBR4
	LD R5, NBR5
	LD R6, NBR6
	LD R7, NBR7


	RET

NBR0	.BLKW 1
NBR1	.BLKW 1
NBR2	.BLKW 1
NBR3	.BLKW 1
NBR4	.BLKW 1
NBR5	.BLKW 1
NBR6	.BLKW 1
NBR7	.BLKW 1





;***********************************************************
; Lab 3 subroutines - copy here
;***********************************************************

GRIDA	.FILL GRID
ROW0A	.FILL ROW0
ROW1A	.FILL ROW1
ROW2A	.FILL ROW2
ROW3A	.FILL ROW3

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

	LD R0, ROW0A
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

	LD R0, GRIDA
	PUTS
	
	LD R0, NLCHAR
	OUT	

	LEA R0, ROWSTR0
	PUTS

	LD R0, ROW0A
	PUTS

	LD R0, NLCHAR
	OUT

	LEA R0, EMPSTR
	PUTS

	LD R0, GRIDA
	PUTS
	
	LD R0, NLCHAR
	OUT

	LEA R0, ROWSTR1
	PUTS

	LD R0, ROW1A
	PUTS
	
	LD R0, NLCHAR
	OUT

	LEA R0, EMPSTR
	PUTS

	LD R0, GRIDA
	PUTS
	
	LD R0, NLCHAR
	OUT
	
	LEA R0, ROWSTR2
	PUTS

	LD R0, ROW2A
	PUTS

	LD R0, NLCHAR
	OUT

	LEA R0, EMPSTR
	PUTS

	LD R0, GRIDA
	PUTS
	
	LD R0, NLCHAR
	OUT

	LEA R0, ROWSTR3
	PUTS

	LD R0, ROW3A
	PUTS

	LD R0, NLCHAR
	OUT

	LEA R0, EMPSTR
	PUTS

	LD R0, GRIDA
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