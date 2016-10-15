*-----------------------------------------------------------
* Title      : Spike
* Written by : Krishna Bharadwaj Y
* Date       : 10/10/2016
* Description: This has the enemy spike, including physics
*              update and rendering.
*-----------------------------------------------------------
 
    SECTION CODE
    
INITSPIKES:
    CMP.B   #1, SPIKESACTIVE
    BNE     DONTERASE
    BSR     ERASESPIKE
DONTERASE:
    MOVE.L  PLAYER_POS_X, SPIKE_POS_X
    MOVE.L  #0, SPIKE_POS_Y
    MOVE.L  #0, SPIKE_VELOCITY
    MOVE.B  #1, SPIKESACTIVE
    RTS
    
UPDATESPIKE:
    CMP.B   #1, SPIKESACTIVE
    BNE     INACTIVE
    BSR     ERASESPIKE
    MOVE.L  SPIKE_VELOCITY, D0
    ADD.L   #SPIKE_ACCELERATION, D0
    MOVE.L  D0, SPIKE_VELOCITY
    MOVE.L  D0, D1
    CLR.W   D1
    SWAP    D1
    MOVE.L  D1, D0
    ADD.L   SPIKE_POS_Y, D0
    MOVE.L  D0, SPIKE_POS_Y
    CMP.L   #SCREEN_HEIGHT, D0
    BLT     SPIKEINSIDEBOUNDS
    MOVE    #0, SPIKESACTIVE
    RTS
SPIKEINSIDEBOUNDS:
* Check collisions with item
* If item.x < spike.x + spike.width
    MOVE.L  SPIKE_POS_X, D0
    ADD.L   #SPIKE_WIDTH, D0
    CMP.L   ITEM_POS_X, D0
    BLE     NOITEMCOLLISIONS
    
* If item.x + item.width > spike.x
    MOVE.L  ITEM_POS_X, D0
    ADD.L   #ITEM_WIDTH, D0
    CMP.L   SPIKE_POS_X, D0
    BLE     NOITEMCOLLISIONS
    
* If item.y < spike.y + spike.height 
    MOVE.L  SPIKE_POS_Y, D0
    ADD.L   #SPIKE_HEIGHT, D0
    CMP.L   ITEM_POS_Y, D0
    BLE     NOITEMCOLLISIONS
    
* If item.height + item.y > spike.y
    MOVE.L  ITEM_POS_Y, D0
    ADD.L   #(ITEM_HEIGHT << 1), D0    ; Just adding a buffer
    CMP.L   SPIKE_POS_Y, D0
    BLE     NOITEMCOLLISIONS
    
    BSR     ERASEITEM
    BSR     DRAWITEM
    
NOITEMCOLLISIONS:
* Check collisions with player
* If player.x < spike.x + spike.width
    MOVE.L  SPIKE_POS_X, D0
    ADD.L   #SPIKE_WIDTH, D0
    CMP.L   PLAYER_POS_X, D0
    BLE     DRAW
    
* If player.x + player.width > spike.x
    MOVE.L  PLAYER_POS_X, D0
    ADD.L   #PLAYER_WIDTH, D0
    CMP.L   SPIKE_POS_X, D0
    BLE     DRAW
    
* If player.y < spike.y + spike.height 
    MOVE.L  SPIKE_POS_Y, D0
    ADD.L   #SPIKE_HEIGHT, D0
    CMP.L   PLAYER_POS_Y, D0
    BLE     DRAW
    
* If player.height + player.y > spike.y
    MOVE.L  PLAYER_POS_Y, D0
    ADD.L   #PLAYER_HEIGHT, D0
    CMP.L   SPIKE_POS_Y, D0
    BLE     DRAW
    
    BRA     GAMELOST
    
DRAW:
    BSR     DRAWSPIKE
INACTIVE:
    RTS
    
    
ERASESPIKE:
    SUB.L   #(4 * 7), SP

    LEA     BACKGROUND, A1
    MOVE.L  A1, (SP)
    MOVE.L  SPIKE_POS_X, 4(SP)
    MOVE.L  SPIKE_POS_Y, 8(SP)
    MOVE.L  SPIKE_POS_X, 12(SP)
    MOVE.L  SPIKE_POS_Y, 16(SP)
    MOVE.L  #SPIKE_WIDTH, 20(SP)
    MOVE.L  #SPIKE_HEIGHT, 24(SP)
    BSR     DRAWBMP
    
    ADD.L   #(4 * 7), SP

    RTS

DRAWSPIKE:    
    SUB.L   #(4 * 7), SP

    LEA     SPIKE, A1
    MOVE.L  A1, (SP)
    MOVE.L  SPIKE_POS_X, 4(SP)
    MOVE.L  SPIKE_POS_Y, 8(SP)
    MOVE.L  #0, 12(SP)
    MOVE.L  #0, 16(SP)
    MOVE.L  #SPIKE_WIDTH, 20(SP)
    MOVE.L  #SPIKE_HEIGHT, 24(SP)
    BSR     DRAWBMP
    
    ADD.L   #(4 * 7), SP
    
    RTS
    
    SECTION DATA
SPIKESACTIVE        DS.B    1
SPIKE_POS_X         DS.L    1
SPIKE_POS_Y         DS.L    1    
SPIKE_WIDTH         EQU     40
SPIKE_HEIGHT        EQU     40
SPIKE_VELOCITY      DS.L    1
SPIKE_ACCELERATION  EQU     $FFFF
SPIKE_FRACBITS      EQU     16
    DS.W 0      ; Force even word alignment
SPIKE               INCBIN "../images/Spikes.bmp"
*=========================================================================
* END SPIKE
*=========================================================================



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
