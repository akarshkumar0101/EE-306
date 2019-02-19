; EE 306: Introduction to Computing
; Fall 2018 - Cuevas
; 
; Title: Minesweeper, Pt. 2
; Author:
; Recitation Section:
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

;***********************************************************
; GET_MOVE

; Input: None
; Output: R0 - Input 1; R1 - Input 2
;***********************************************************
GET_MOVE
	
	RET


;***********************************************************
; IS_VALID_MOVE

; Input: R0 - Input 1 (row); R1 - Input 2 (col)
; Output: If valid, set (R0,R1)=(row,col) to move; else R0 = -1
;***********************************************************
IS_VALID_MOVE

	RET

;***********************************************************
; APPLY_MOVE

; Input: (R0,R1) = (Row,Col) of desired move
; Output: (R0,R1) = (Row,Col) of completed move
;***********************************************************
APPLY_MOVE

	RET

;***********************************************************
; IS_GAME_OVER
; Assume APPLY_MOVE called before. 
; Input: (R0,R1) - (Row,Col) of last move
; Output: 0 - Game not over; 1 - Player won; -1 - Player lost
;***********************************************************
IS_GAME_OVER

	RET


;***********************************************************
; GAME_OVER
; 
; Input: R0 = 1 if player won; R0 = -1 if player lost
; Output: None
;***********************************************************
GAME_OVER

	RET


;***********************************************************
; Lab 3 subroutines - copy here
;***********************************************************

;***********************************************************
; DISPLAY_BOARD
;   Displays the current state of the BOARD Grid.
; Input: None
; Output: None
; Notes: The displayed grid must have the row and column numbers.
;***********************************************************

DISPLAY_BOARD      

          RET

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

	RET

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

	RET


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

          RET

          .END