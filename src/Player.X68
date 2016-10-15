*-----------------------------------------------------------
* Title      : Player
* Written by : Krishna Bharadwaj Y
* Date       : 10/09/2016
* Description: The player entity. This contains code to erase
*              player image at current position, re-draw
*              background at that position and render at new
*              position. This also has collision detection
*              logic against items and also contains item
*              spawnage and collection code.
*-----------------------------------------------------------

    SECTION CODE
    
INITPLAYER:
    MOVE.L  #320,   PLAYER_POS_X
    MOVE.L  #120,   PLAYER_POS_Y
    MOVE.W  #0,      SCORE
    BSR     DRAWPLAYER
    
    SUB.L   #2, SP
    MOVE.W  SCORE, (SP)
    BSR     DRAW7SEG
    ADD.L   #2, SP
    
    RTS    
    
MOVELEFT:
    BSR     ERASECURRENTBLOCK
    MOVE.L  PLAYER_POS_X, D0
    SUB.L   #VELOCITY, D0
    CMP.L   #SCREEN_LEFT, D0
    BGE     LEFTFINE
    MOVE.L  #SCREEN_LEFT, D0
LEFTFINE:
    MOVE.L  D0, PLAYER_POS_X
    BSR     CHECKCOLLISIONS
    RTS
    
MOVERIGHT:
    BSR     ERASECURRENTBLOCK
    MOVE.L  PLAYER_POS_X, D0
    ADD.L   #VELOCITY, D0
    CMP.L   #(SCREEN_RIGHT-PLAYER_WIDTH), D0
    BLT     RIGHTFINE
    MOVE.L  #(SCREEN_RIGHT-PLAYER_WIDTH), D0
RIGHTFINE:
    MOVE.L  D0, PLAYER_POS_X
    BSR     CHECKCOLLISIONS
    RTS
    
MOVEUP:
    BSR     ERASECURRENTBLOCK
    MOVE.L  PLAYER_POS_Y, D0
    SUB.L   #VELOCITY, D0
    CMP.L   #SCREEN_TOP, D0
    BGE     UPFINE
    MOVE.L  #SCREEN_TOP, D0
UPFINE:    
    MOVE.L  D0, PLAYER_POS_Y
    BSR     CHECKCOLLISIONS
    RTS
    
MOVEDOWN:
    BSR     ERASECURRENTBLOCK
    MOVE.L  PLAYER_POS_Y, D0
    ADD.L   #VELOCITY, D0
    CMP.L   #(SCREEN_BOTTOM-PLAYER_HEIGHT), D0
    BLT     DOWNFINE
    MOVE.L  #(SCREEN_BOTTOM-PLAYER_HEIGHT), D0
DOWNFINE:    
    MOVE.L  D0, PLAYER_POS_Y
    BSR     CHECKCOLLISIONS
    RTS
    
CHECKCOLLISIONS:
* If player.x < item.x + item.width
    MOVE.L  ITEM_POS_X, D0
    ADD.L   #ITEM_WIDTH, D0
    CMP.L   PLAYER_POS_X, D0
    BLE     NOCOLLISION
    
* If player.x + player.width > item.x
    MOVE.L  PLAYER_POS_X, D0
    ADD.L   #PLAYER_WIDTH, D0
    CMP.L   ITEM_POS_X, D0
    BLE     NOCOLLISION
    
* If player.y < item.y + item.height
    MOVE.L  ITEM_POS_Y, D0
    ADD.L   #ITEM_HEIGHT, D0
    CMP.L   PLAYER_POS_Y, D0
    BLE     NOCOLLISION
    
* If player.height + player.y > item.y
    MOVE.L  PLAYER_POS_Y, D0
    ADD.L   #PLAYER_HEIGHT, D0
    CMP.L   ITEM_POS_Y, D0
    BLE     NOCOLLISION
    
* Collision detected
    BSR     ERASEITEM
    BSR     PLACEITEMRANDOMLY
    BSR     DRAWITEM
    BSR     INITSPIKES
    
    CMP.W   #MAXSCORE, SCORE
    BEQ     GAMEWON
    
    BSR     PLAYRANDOMCOLLECTSOUND
    
    MOVE.W  SCORE, D0
    ADD.W   #1, D0
    MOVE.W  D0, SCORE
    
    BSR     ERASE7SEG
    
    SUB.L   #2, SP
    MOVE.W  SCORE, (SP)
    BSR     DRAW7SEG
    ADD.L   #2, SP
    
NOCOLLISION:
    BSR     DRAWPLAYER
    RTS
    
ERASECURRENTBLOCK:
    SUB.L   #(4 * 7), SP

    LEA     BACKGROUND, A1
    MOVE.L  A1, (SP)
    MOVE.L  PLAYER_POS_X, 4(SP)
    MOVE.L  PLAYER_POS_Y, 8(SP)
    MOVE.L  PLAYER_POS_X, 12(SP)
    MOVE.L  PLAYER_POS_Y, 16(SP)
    MOVE.L  #PLAYER_WIDTH, 20(SP)
    MOVE.L  #PLAYER_HEIGHT, 24(SP)
    BSR     DRAWBMP
    
    ADD.L   #(4 * 7), SP

    RTS

DRAWPLAYER:
    SUB.L   #(4 * 7), SP

    LEA     PLAYER, A1
    MOVE.L  A1, (SP)
    MOVE.L  PLAYER_POS_X, 4(SP)
    MOVE.L  PLAYER_POS_Y, 8(SP)
    MOVE.L  #0, 12(SP)
    MOVE.L  #0, 16(SP)
    MOVE.L  #PLAYER_WIDTH, 20(SP)
    MOVE.L  #PLAYER_HEIGHT, 24(SP)
    BSR     DRAWBMP
    
    ADD.L   #(4 * 7), SP
    
    RTS
      
      
    SECTION DATA
PLAYER_POS_X        DS.L    1
PLAYER_POS_Y        DS.L    1
VELOCITY            EQU     5
PLAYER_WIDTH        EQU     60
PLAYER_HEIGHT       EQU     60
    DS.W 0      ; Force even word alignment
PLAYER              INCBIN "../images/Player.bmp"
SCORE               DS.W    1
MAXSCORE            EQU     9

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
