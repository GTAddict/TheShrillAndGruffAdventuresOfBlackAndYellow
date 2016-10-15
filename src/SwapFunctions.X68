*-----------------------------------------------------------
* Title      :  Swap Functions
* Written by :  Krishna Bharadwaj Y
* Date       :  9/24/2016
* Description:  Swap functionality for words and longs
*-----------------------------------------------------------

    SECTION CODE
; Takes one argument on the stack pointer.
; Replaces the value passed in.
SWAPWORD:
    MOVE.W  4(SP), D1
    ROL.W   #8, D1
    MOVE.W  D1, 4(SP)
    RTS

; Takes one argument on the stack pointer.
; Replaces the value passed in.
SWAPLONG:
    MOVE.L  4(SP), D1
    ROL.W   #8, D1
    SWAP    D1
    ROL.W   #8, D1
    MOVE.L  D1, 4(SP)
    RTS
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
