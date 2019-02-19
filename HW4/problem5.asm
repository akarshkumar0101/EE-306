	.ORIG x3000
        LD R0, Addr1
        LEA R1, Addr1
        LDI R2, Addr1
        LDR R3, R0, #-6
        LDR R4, R1, #0
        ADD R1, R1, #3
        ST R2, #5
        STR R1, R0, #3
        STI R4, Addr4
        HALT
Addr1   .FILL x300B
Addr2   .FILL x000A
Addr3   .BLKW 1
Addr4   .FILL x300D
Addr5   .FILL x300C
        .END