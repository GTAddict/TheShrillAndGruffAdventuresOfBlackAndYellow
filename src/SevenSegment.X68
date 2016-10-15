*-----------------------------------------------------------
* Title      : Seven Segment
* Written by : Krishna Bharadwaj Y
* Date       : 10/09/2016
* Description: Renders a 7-Segment LED image at 0, 0.
*-----------------------------------------------------------

    SECTION CODE
DRAW7SEG:
    
    LEA     BITSETS, A3
    MOVE.W  4(SP), D1
    ADD.L   D1, A3
    CLR.L   D1
    MOVE.B  (A3), D1
    
    MOVE.L  #0, D2
    
    CLR.L   D4
    MOVE.B  #0, D0
    
DISPLAYSEG:
    BTST    D2, D1
    BEQ     DONTRENDER
    
    
    MOVE.B  D2, COUNTER
    MOVE.B  D1, CURRENTBIT
    MOVE.L  D0, TABLEOFFSET
    
    SUB.L   #(4 * 7), SP
    
    LEA     SEGMENTFILE, A3
    MOVE.L  A3, (SP)
    
    LEA     SEG_X_START, A3
    ADD.L   D0, A3
    MOVE.L  (A3), 4(SP)
    
    LEA     SEG_Y_START, A3
    ADD.L   D0, A3
    MOVE.L  (A3), 8(SP)
    
    LEA     SEG_X_START, A3
    ADD.L   D0, A3
    MOVE.L  (A3), 12(SP)
    
    LEA     SEG_Y_START, A3
    ADD.L   D0, A3
    MOVE.L  (A3), 16(SP)
    
    LEA     SEG_WIDTH, A3
    ADD.L   D0, A3
    MOVE.L  (A3), 20(SP)
    
    LEA     SEG_HEIGHT, A3
    ADD.L   D0, A3
    MOVE.L  (A3), 24(SP)

    BSR     DRAWBMP
    ADD.L   #(4 * 7), SP
    
    MOVE.B  COUNTER, D2
    MOVE.B  CURRENTBIT, D1
    MOVE.L  TABLEOFFSET, D0
    
DONTRENDER:
    ADD.B   #1, D2
    ADD.L   #4, D0      ; Incrementing in intervals of 4 as we are dealing with longs
    CMP.L   #28, D0     ; 7 elements
    BLT     DISPLAYSEG
    
    
    RTS
    
ERASE7SEG:
    SUB.L   #(4 * 7), SP

    LEA     BACKGROUND, A1
    MOVE.L  A1, (SP)
    MOVE.L  #0, 4(SP)
    MOVE.L  #0, 8(SP)
    MOVE.L  #0, 12(SP)
    MOVE.L  #0, 16(SP)
    MOVE.L  #(TOTAL_WIDTH), 20(SP)
    MOVE.L  #(TOTAL_HEIGHT), 24(SP)
    BSR     DRAWBMP
    
    ADD.L   #(4 * 7), SP
    
    RTS
    
    SECTION DATA
    DS.W    0       ; Force even word alignment
SEGMENTFILE INCBIN "../images/7seg.bmp"

BITSETS     DC.B        $3F, $6, $5B, $4F, $66, $6D, $7D, $7, $7F, $6F
SEG_X_START DC.L        4,  16, 15, 0,  1,  2,  2
SEG_Y_START DC.L        0,  4,  23, 38, 23, 4,  19
SEG_WIDTH   DC.L        16, 4,  3,  16, 3,  3,  16 
SEG_HEIGHT  DC.L        2,  13, 13, 2,  13, 13, 2
COUNTER     DS.B        1
TABLEOFFSET DS.L        1
CURRENTBIT  DS.B        1
DUMMY       DS.B        1
TOTAL_WIDTH     EQU     20
TOTAL_HEIGHT    EQU     40



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
