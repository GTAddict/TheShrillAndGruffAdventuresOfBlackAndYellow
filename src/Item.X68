*-----------------------------------------------------------
* Title      : Item
* Written by : Krishna Bharadwaj Y
* Date       : 10/10/2016
* Description: This is the collectable that the player will
*              get through the game.
*-----------------------------------------------------------

    SECTION DATA
GETTIMETASK EQU 8    

    SECTION CODE

INITITEM:
    BSR     INITRANDOMIZER
    BSR     PLACEITEMRANDOMLY
    BSR     DRAWITEM
    RTS
    
ERASEITEM:
    SUB.L   #(4 * 7), SP

    LEA     BACKGROUND, A1
    MOVE.L  A1, (SP)
    MOVE.L  ITEM_POS_X, 4(SP)
    MOVE.L  ITEM_POS_Y, 8(SP)
    MOVE.L  ITEM_POS_X, 12(SP)
    MOVE.L  ITEM_POS_Y, 16(SP)
    MOVE.L  #ITEM_WIDTH, 20(SP)
    MOVE.L  #ITEM_HEIGHT, 24(SP)
    BSR     DRAWBMP
    
    ADD.L   #(4 * 7), SP

    RTS

DRAWITEM:    
    SUB.L   #(4 * 7), SP

    LEA     ITEM, A1
    MOVE.L  A1, (SP)
    MOVE.L  ITEM_POS_X, 4(SP)
    MOVE.L  ITEM_POS_Y, 8(SP)
    MOVE.L  #0, 12(SP)
    MOVE.L  #0, 16(SP)
    MOVE.L  #ITEM_WIDTH, 20(SP)
    MOVE.L  #ITEM_HEIGHT, 24(SP)
    BSR     DRAWBMP
    
    ADD.L   #(4 * 7), SP
    
    RTS  
 
INITRANDOMIZER:
    MOVE.B  #GETTIMETASK, D0
    TRAP    #TRAPCODE
    MOVE.L  D1, RANDOMNUMBER
    RTS
   
PLACEITEMRANDOMLY:
    ; https://en.wikipedia.org/wiki/Linear_congruential_generator#Parameters_in_common_use
    ; Using a modified linear congruential generator algorithm
    ; Xn+1= (aXn+c) mod m
    ; C++ 11's minstd_rand0 implementation, a = 16807, c = 0    
    
* Getting the random X position    
    MOVE.L  RANDOMNUMBER, D0
    MULU    #VALUE_A, D0
    ADD.L   #VALUE_C, D0
    AND.L   #ANDBITS, D0                * Getting rid of 1 byte to prevent divide overflow
    DIVU    #(SCREEN_WIDTH-ITEM_WIDTH-SCREEN_LEFT), D0
    MOVE.L  D0, RANDOMNUMBER
    CLR.W   D0
    SWAP    D0
    MOVE.L  D0, ITEM_POS_X
    ADD.L   #SCREEN_LEFT, ITEM_POS_X
    
* Getting the random Y position
    MOVE.L  RANDOMNUMBER, D0
    MULU    #VALUE_A, D0
    ADD.L   #VALUE_C, D0
    AND.L   #ANDBITS, D0                * Getting rid of 1 byte to prevent divide overflow
    DIVU    #(SCREEN_HEIGHT-ITEM_HEIGHT-SCREEN_TOP), D0
    MOVE.L  D0, RANDOMNUMBER
    CLR.W   D0
    SWAP    D0
    MOVE.L  D0, ITEM_POS_Y
    ADD.L   #SCREEN_TOP, ITEM_POS_Y
    
    RTS
    
    SECTION DATA
ITEM_POS_X      DS.L    1
ITEM_POS_Y      DS.L    1    
ITEM_WIDTH      EQU     20
ITEM_HEIGHT     EQU     20
    DS.W 0      ;FORCE EVEN WORD ALIGNMENT
ITEM            INCBIN "../images/Item.bmp"
RANDOMNUMBER    DS.L    1
VALUE_A         EQU     16807
VALUE_C         EQU     0
ANDBITS         EQU     $00FFFFFF
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
