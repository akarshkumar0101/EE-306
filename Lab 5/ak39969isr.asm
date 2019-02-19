; Title: ID Card Data Parser - ISR
; Name: Akarsh Kumar
; EID: ak39969
; Date: 12/9/18
; Recitation Section: F 11AM
; Description of program: Reads a character from console
;	and increments character count
; Keyboard ISR runs when a key is struck


.ORIG xA000

;ISR routine
ST R0, ISRR0	;save R0 val

LDI R0, KBDR	
STI R0, CHAR	

AND R0, R0, #0
STI R0, KBDR
STI R0, KBSR

LDI R0, NUMCHAR
ADD R0, R0, #1
STI R0, NUMCHAR

LD R0, ISRR0

RTI

; Data fields

ISRR0 .BLKW 1

CHAR	.FILL x8000
NUMCHAR	.FILL x8001

KBSR	.FILL xFE00
KBDR	.FILL xFE02


.END
