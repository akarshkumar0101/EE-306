; EE 306: Introduction to Computing
; Fall 2018 - Cuevas
; 
; Title: Minesweeper, Pt. 2
; Author: Jerry Yang
; Created on: 11/4/2018
;
; Solution -- Do not give out
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

;***********************************************************
; Global constants used in program
;***********************************************************
SCORE .BLKW 1
MOVES .BLKW 16
NUMMOVES .BLKW 1

;***********************************************************
; GET_MOVE

; Input: None
; Output: R0 - Input 1; R1 - Input 2
;***********************************************************

GET_MOVE
	ST R7, SaveR7In
	LEA R0, PROMPT
	PUTS		; OUTPUT PROMPT
	GETC		; ECHO
	OUT
	ST R0, TEMP	; MOVE INPUT 1 TO R1
	LD R0,COMMA
	OUT
	GETC
	OUT
	ADD R1,R0,#0
	LEA R0,PROMPTEND
	PUTS
	LD R0, TEMP
	LD R7,SaveR7In	
	RET
PROMPT .STRINGZ "Enter a move: ("
PROMPTEND .STRINGZ ")\n"
COMMA .FILL x2C
TEMP .BLKW 1
SaveR7In .BLKW 1

;***********************************************************
; IS_VALID_MOVE

; Input: R0 - Input 1 (row); R1 - Input 2 (col)
; Output: If valid, set (R0,R1)=(row,col) to move; else R0 = -1
;***********************************************************
IS_VALID_MOVE
	ST R2, SaveR2
	LD R2, ASCII0
	NOT R2,R2
	ADD R2,R2,#1
	ADD R0,R0,R2
	BRn Invalid
	ADD R1,R1,R2
	BRn Invalid

	ADD R0,R0,#-3; Check if R0 valid
	BRp Invalid
	ADD R1,R1,#-3
	BRp Invalid
	ADD R0,R0,#3
	ADD R1,R1,#3
	BRnzp Fin

Invalid 
	ST R7,SaveR7Error
	ADD R2,R0,#0
	LEA R0,ErrorMsg
	PUTS
	LD R7,SaveR7Error
	AND R0,R0,#0
	ADD R0,R0,#-1

Fin	LD R2,SaveR2
	RET

ASCII0 .FILL x30
SaveR2 .BLKW 1
SaveR7Error .BLKW 1
ErrorMsg .STRINGZ "Invalid move - try again!\n"

NUMMVS .FILL NUMMOVES
;***********************************************************
; APPLY_MOVE

; Input: (R0,R1) = (Row,Col) of desired move
; Output: None
;***********************************************************
APPLY_MOVE
	ST R7,AMSaveR7
	ST R2,AMSaveR2
	ST R3,AMSaveR3
	ST R0,MROW
	ST R1,MCOL
	LD R1,MROW
	LD R2,MCOL
	JSR GRID_ADDRESS ; R0 = Location address

; check if previously moved here
	LD R2,NUMMOVES
	BRz UPDATE
	LEA R1,MOVES
	ADD R2,R2,#-1
CHECK	
	ADD R3,R1,R2
	LDR R1,R3,#0
	NOT R1,R1
	ADD R1,R1,#1
	ADD R1,R0,R1
	BRz already
	LEA R1, MOVES
	ADD R2,R2,#-1
	BRzp CHECK
	BRnzp UPDATE

; Found previous move
already LEA R0,moved
	PUTS
	BRnzp prep

; Update array of moves
UPDATE	LD R2, NUMMOVES
	LEA R1,MOVES
	ADD R1,R2,R1
	STR R0,R1,#0	
	ADD R2, R2,#1
	ST R2,NUMMOVES
	
; Make move	
MOVEIT	ST R0,ADDRESS
	LDI R0, BLOCKS
	LD R1,MROW
	LD R2,MCOL
	JSR COUNT_BOMBS ; R0 = Number bombs
	ADD R0,R0,#0
	BRz prep
	BRn Bomb
	LD R1,ASCII0
	ADD R1,R1,R0
	BRnzp #1

Bomb	LD R1,AMStar
	
	LD R0,ADDRESS
	STR R1,R0,#0	; store appropriate thing
	
prep	LD R2,AMSaveR2
	LD R3,AMSaveR3
	LD R7,AMSaveR7	
	LD R0,MROW
	LD R1,MCOL
	RET
MROW .FILL 0
MCOL .FILL 0
AMSaveR7 .BLKW 1
AMSaveR2 .BLKW 1
AMSaveR3 .BLKW 1
AMStar .FILL 42
ADDRESS .BLKW 1
moved .STRINGZ "You already tried this location!"

;***********************************************************
; IS_GAME_OVER
; Assume APPLY_MOVE called before. 
; Input: (R0,R1) - (Row,Col) of last move
; Output: 0 - Game not over; 1 - Player won; -1 - Player lost
;***********************************************************
IS_GAME_OVER
	ST R3,IGOSaveR3
	ST R2,IGOSaveR2
	ST R7,IGOSaveR7

; Check if last move was bomb
	ADD R2,R1,#0
	ADD R1,R0,#0
	JSR GRID_ADDRESS ; R0 - Location of last move
	LDR R0,R0,#0
	LD R1, AMStar
	NOT R1,R1
	ADD R1,R1,#1
	ADD R1,R1,R0
	BRnp LAST
YESL 	AND R0,R0,#0
	ADD R0,R0,#-1
	BRnzp BACK
	

; Check if last move was last possible move - count # bombs, add to # moves, check ==16
LAST	LDI R0,CNTB
	LDI R2,NUMMVS
	ADD R0,R0,R2
	AND R1,R1,#0
	ADD R1,R1,#-16
	ADD R1,R0,R1
	BRnp NO
YESW	AND R0,R0,#0
	ADD R0,R0,#1
	BRnzp BACK

; If last move was not last possible move, clear R0.
NO	AND R0,R0,#0

BACK	LD R2,IGOSaveR2
	LD R7,IGOSaveR7
	LD R3,IGOSaveR3
	RET
IGOSaveR3 .BLKW 1
IGOSaveR2 .BLKW 1
IGOSaveR7 .BLKW 1

;***********************************************************
; GAME_OVER

; Input: None
; Output: None
;***********************************************************
GAME_OVER
	ST R7,OVERSaveR7
	ST R0,WL
	LDI R0,LL
	JSR LOAD_BOARD
	LD R0,WL
	BRn #3	

	LEA R0,WIN
	PUTS
	BRnzp PRINTSCORE

	LEA R0,LOSE
	PUTS

PRINTSCORE
	JSR DISPLAY_BOARD
	LEA R0, SCOREP
	PUTS
	LD R0,WL
	BRn #5
	LD R0,ASCII_OFFSET
	ADD R0,R0,#9
	OUT
	OUT
	BRnzp GOBACK
	LDI R0,NUMMVS
	ADD R7,R0,#-10
	BRn ONED

	LD R0,ASCII_OFFSET
	ADD R0,R0,#1
	ST R7,D2
	OUT
	LD R7,D2
	LD R0,ASCII_OFFSET
	ADD R0,R7,R0
	OUT
	BRnzp GOBACK	

ONED	ADD R0,R7,#10
	LD R7,ASCII_OFFSET
	ADD R0,R7,R0
	OUT	
	
GOBACK
	AND R0,R0,#0
	ADD R0,R0,xA
	OUT
	LD R7,OVERSaveR7
	RET

OVERSaveR7 .BLKW 1
WL .FILL 0
LL .FILL x6000
WIN .STRINGZ "\nCongrats, you won!\n"
LOSE .STRINGZ "\nYou lost! Better luck next time!\n"
SCOREP .STRINGZ "\nYour score is: "
D2 .FILL 0
WINSCORE .FILL 99


;***********************************************************
COL                .STRINGZ "   0 1 2 3 "
                   .STRINGZ "  "
ZERO               .STRINGZ "0 "
                   .STRINGZ "  "                   
ONE                .STRINGZ "1 "
                   .STRINGZ "  "
TWO                .STRINGZ "2 "
                   .STRINGZ "  "
THREE              .STRINGZ "3 "
                   .STRINGZ "  "
ASCII_OFFSET       .FILL   x0030
ASCII_NEWLINE      .FILL   x000A


;***********************************************************
;Lab 3 subroutines

;***********************************************************
GRID1 .FILL GRID
ROW11 .FILL ROW1
ROW21 .FILL ROW2
ROW31 .FILL ROW3
;***********************************************************
; DISPLAY_BOARD
;   Displays the current state of the BOARD Grid indicating 
;   where Simba is (*) and any Hyena's(#) and 
;   Simba's Home (H).
; Input: None
; Output: None
; Notes: The displayed grid must have the row and column numbers
;***********************************************************
DISPLAY_BOARD      
          ST    R0, DB_R0                  ; save registers
          ST    R1, DB_R1
          ST    R2, DB_R2
          ST    R3, DB_R3
          ST    R7, DB_R7

          AND   R1, R1, #0                 ; R1 will be loop counter
          ADD   R1, R1, #8
          LD    R2, GRID1		     ; R2 will be pointer to row
          LEA   R3, COL                    ; R3 will be pointer to row number
          ADD   R3,R3,#12
          LD    R0, ASCII_NEWLINE
          OUT
          LEA   R0, COL
          PUTS
DB_ROWOUT LD    R0, ASCII_NEWLINE
          OUT
          ADD   R0, R3, #0                 ; move address of row number to R0
          PUTS
          ADD   R0, R2, #0                 ; move address of row to R0
          PUTS
          ADD   R2, R2, #10                 ; increment R2 to point to next row
          ADD   R3, R3, #3                 ; increment R3 to point to next row number
          ADD   R1, R1, #-1
          BRzp  DB_ROWOUT
          LD    R0, ASCII_NEWLINE
          OUT
          LD    R0, DB_R0                  ; restore registers
          LD    R1, DB_R1
          LD    R2, DB_R2
          LD    R3, DB_R3
          LD    R7, DB_R7
          RET

DB_R0     .BLKW #1
DB_R1     .BLKW #1
DB_R2     .BLKW #1
DB_R3     .BLKW #1
DB_R7     .BLKW #1
CNTB .FILL CNT
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
          ST    R6, addr_R6   		; save registers      
          ST    R3, addr_R3
          ST    R1, addr_R1
          ST    R2, addr_R2
          ADD   R2,R2,R2
          ADD   R2,R2,#1		; Get col offset from col number
          AND   R6, R6, #0
          ADD   R6, R1, #0
          BRz   IsRow0
          AND   R6, R6, #0
          ADD   R6, R1, #-1
          BRz   IsRow1
          AND   R6, R6, #0
          ADD   R6, R1, #-2
          BRz   IsRow2
          AND   R6, R6, #0
          ADD   R6, R1, #-3
          BRz   IsRow3

IsRow0	  LD R3, HOLDROW0
	  ADD R3, R3, R2
	  BR Saved_addr
IsRow1	  LD R3, ROW11
	  ADD R3, R3, R2
	  BR Saved_addr
IsRow2	  LD R3, ROW21
	  ADD R3, R3, R2
	  BR Saved_addr
IsRow3	  LD R3, ROW31
	  ADD R3, R3, R2		

Saved_addr 
          ADD   R0,R3,#0	      ; result expected in R0
          LD    R6, addr_R6     ; restore registers    
          LD    R3, addr_R3
	  LD    R1, addr_R1
	  LD    R2, addr_R2
          RET

addr_R6   .BLKW  1
addr_R3   .BLKW  1
addr_R1   .BLKW  1
addr_R2   .BLKW  1


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
	ST 	R0, List
	ST      R7,LMSaveR7
	LEA	R0, SaveR
	STR	R1,R0,#0
	STR 	R2,R0,#1
	STR 	R3,R0,#2
	STR 	R4,R0,#3

	LD 	R0,List
	BRz 	EndOfList
	ADD	R4,R0,#0	; Make copy of R0 in R4
LMore	BRz	EndOfList
	LDR	R1,R4,#0	; row#
	LDR	R2,R4,#1	; col#
	JSR	GRID_ADDRESS	; Gets address of location
	LD 	R3,Star
	STR	R3,R0,#0	; Store character
	LDR	R4,R4,#2
	BRnp    LMore
EndOfList

; Iterate through all spaces of board
; Store # bombs in each space
; Call COUNT_BOMBS
	LD 	R0, List
	AND	R1,R1,#0
	AND	R2,R2,#0
	ADD	R1,R1,#3 ; Location - start at row 3, col 3
	ADD 	R2,R2,#3
	
OUTER	ADD R1,R1,#0
INNER	
	LD R0, List
	JSR COUNT_BOMBS ; Counts number of bombs
	ADD R0,R0,#0
	BRnz MOVE_ON	; If there's a bomb or no near bombs, move on
	LD R3, ASCII_OFFSET
	ADD R3,R0,R3	; If there isn't, convert # to character
	JSR GRID_ADDRESS
	STR R3,R0,#0	; Store character
	
MOVE_ON	ADD R2,R2,#-1
	BRzp INNER
	ADD R2,R2,#4	; Move to next row
	ADD R1,R1,#-1
	BRzp OUTER

DONE
        LD      R7,LMSaveR7
	LEA	R0,SaveR
	LDR 	R1,R0,#0
	LDR	R2,R0,#1
	LDR	R3,R0,#2
	LDR	R4,R0,#3
	RET

LMSaveR7 .BLKW	1
List .BLKW 1
Star  .FILL  42
SaveR .BLKW 4
HOLDROW0 .FILL ROW0

;***********************************************************
; COUNT_BOMBS
; Input:  R0  has the head of a linked list of
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

; Traverse linked list
; Check if row # within 1 of bomb
; Check if col # within 1 of bomb
; Check if row # and col # match that of bomb - return -1

	ST 	R0, List1
	ST      R7,SR7
	LEA	R7,REGS
	STR	R0,R7,#0
	STR	R1,R7,#1
	STR	R2,R7,#2
	STR	R3,R7,#3
	STR	R4,R7,#4
	STR	R5,R7,#5
	STR	R6,R7,#6
	AND 	R6,R6,#0
	ST	R6,CNT
	
	ADD 	R3,R0,#0
	AND 	R0,R0,#0
	ADD	R3,R3,#0	; Make copy of R0 in R3, R3 contains position in linked list
LMore1	BRz	EndOfList1
	LDR	R4,R3,#0	; R4 = row#
	LDR	R5,R3,#1	; R5 = col#
; Do something w/ current node
	LD R6,CNT		; Counter for # bombs - added in lab 4
	ADD R6,R6,#1
	ST R6,CNT
	NOT R6,R1 		; Calculate R4 = R4-R1
	ADD R6,R6,#1
	ADD R4,R4,R6	

	NOT R6,R2		; Calculate R5 = R5-R2 
	ADD R6,R6,#1
	ADD R5,R5,R6

	ADD R4,R4,#0; Check if R4 and R5 both equal to 0
	BRnp NOTBOMB
	ADD R5,R5,#0
	BRnp NOTBOMB
	AND R0,R0,#0
	ADD R0,R0,#-1
	BRnzp EndOfList1

NOTBOMB	
	ADD R4,R4,#1
	BRn NEXTNODE
	ADD R4,R4,#-2
	BRp NEXTNODE
	ADD R5,R5,#1
	BRn NEXTNODE
	ADD R5,R5,#-2
	BRp NEXTNODE
	ADD R0,R0,#1

; Move on to next node
NEXTNODE
	LDR	R3,R3,#2
	BRnp    LMore1
EndOfList1
	
	LEA	R7,REGS
	LDR	R1,R7,#1
	LDR	R2,R7,#2
	LDR	R3,R7,#3
	LDR	R4,R7,#4
	LDR	R5,R7,#5
	LDR	R6,R7,#6	
	LD	R7,SR7
	RET
List1 .BLKW 1
SR7 .BLKW 1
REGS .BLKW 7
CNT .BLKW 1

          .END