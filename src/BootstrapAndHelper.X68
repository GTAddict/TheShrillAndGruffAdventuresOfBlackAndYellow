*-----------------------------------------------------------
* Title      : Bootstrap and Helper
* Written by : Krishna Bharadwaj Y
* Date       : 10/09/2016
* Description: This houses the startup code and restart code.
*-----------------------------------------------------------

    SECTION DATA
SET_DRAWING_MODE_TASK       EQU 92
REPAINT_SCREEN_TASK         EQU 94
ENABLE_DOUBLE_BUFFER_CODE   EQU 17
SCREEN_TASK                 EQU 11
CLEAR_SCREEN_COMMAND        EQU $FF00
READ_KEY_TASK               EQU 19

    SECTION CODE
* This is the entry point of the application.
START:

* Enable double buffering.
    CLR.L   D1
    MOVE.B  #ENABLE_DOUBLE_BUFFER_CODE, D1
    MOVE.B  #SET_DRAWING_MODE_TASK, D0
    TRAP    #TRAPCODE
    
    BSR     LOADSOUNDS
    BSR     PLAYBG
    
INIT:
   
    BSR     INITSOUNDRANDOMIZER
    BSR     RENDERLOADING
    BSR     DRAWBG
    BSR     INITITEM
    BSR     INITPLAYER
    BSR     PLAYRANDOMSTARTSOUND
    
    BRA     MAIN
    
DRAWBG:
    
    SUB.L   #(4 * 7), SP

    LEA     BACKGROUND, A1
    MOVE.L  A1, (SP)
    MOVE.L  #0, 4(SP)
    MOVE.L  #0, 8(SP)
    MOVE.L  #0, 12(SP)
    MOVE.L  #0, 16(SP)
    MOVE.L  #BG_WIDTH, 20(SP)
    MOVE.L  #BG_HEIGHT, 24(SP)
    BSR     DRAWBMP
    
    ADD.L   #(4 * 7), SP
    
    RTS
    
RENDERLOADING:
    BSR     CLEARSCREEN
    
    SUB.L   #(4 * 7), SP

    LEA     LOADINGIMAGE, A1
    MOVE.L  A1, (SP)
    MOVE.L  #LOADING_LEFT, 4(SP)
    MOVE.L  #LOADING_TOP, 8(SP)
    MOVE.L  #0, 12(SP)
    MOVE.L  #0, 16(SP)
    MOVE.L  #LOADING_WIDTH, 20(SP)
    MOVE.L  #LOADING_HEIGHT, 24(SP)
    BSR     DRAWBMP
    
    ADD.L   #(4 * 7), SP
    
    CLR.L   D0
    MOVE.B  #REPAINT_SCREEN_TASK, D0
    TRAP    #TRAPCODE
    
    RTS

GAMELOST:
    MOVE.B  #0, SPIKESACTIVE
    
    BSR     PLAYRANDOMLOSSSOUND
    BSR     CLEARSCREEN
    
    SUB.L   #(4 * 7), SP

    LEA     LOSTIMAGE, A1
    MOVE.L  A1, (SP)
    MOVE.L  #LOST_SCREEN_LEFT, 4(SP)
    MOVE.L  #LOST_SCREEN_TOP, 8(SP)
    MOVE.L  #0, 12(SP)
    MOVE.L  #0, 16(SP)
    MOVE.L  #LOST_WIDTH, 20(SP)
    MOVE.L  #LOST_HEIGHT, 24(SP)
    BSR     DRAWBMP
    
    ADD.L   #(4 * 7), SP
    
    BRA     RESTART
    
GAMEWON:
    MOVE.B  #0, SPIKESACTIVE
    
    BSR     PLAYRANDOMWINSOUND
    BSR     CLEARSCREEN
     
    SUB.L   #(4 * 7), SP

    LEA     WONIMAGE, A1
    MOVE.L  A1, (SP)
    MOVE.L  #WON_SCREEN_LEFT, 4(SP)
    MOVE.L  #WON_SCREEN_TOP, 8(SP)
    MOVE.L  #0, 12(SP)
    MOVE.L  #0, 16(SP)
    MOVE.L  #WON_WIDTH, 20(SP)
    MOVE.L  #WON_HEIGHT, 24(SP)
    BSR     DRAWBMP
    
    ADD.L   #(4 * 7), SP
    
    BRA     RESTART
    
CLEARSCREEN:
    MOVE.L  #SCREEN_TASK, D0
    MOVE.L  #CLEAR_SCREEN_COMMAND, D1
    TRAP    #TRAPCODE
    RTS
    
RESTART:
    CLR.L   D0
    MOVE.B  #REPAINT_SCREEN_TASK, D0
    TRAP    #TRAPCODE

WAITFORINPUT:    
    CLR.L   D0
    CLR.L   D1
    MOVE.B  #READ_KEY_TASK, D0
    TRAP    #TRAPCODE
    
    CMP.W   #ENTER_KEY, D1
    BNE     WAITFORINPUT
    
    BRA     INIT

    SECTION DATA
    DS.W            0   ; Force even word alignment
BACKGROUND          INCBIN "../images/Background.bmp"
    DS.W                0   ; Force even word alignment
WONIMAGE            INCBIN "../images/Won.bmp"   
    DS.W                0   ; Force even word alignment
LOSTIMAGE           INCBIN "../images/Lost.bmp"
    DS.W                0   ; Force even word alignment
LOADINGIMAGE        INCBIN "../images/Loading.bmp"

WON_SCREEN_LEFT     EQU 0
WON_SCREEN_TOP      EQU 210
WON_WIDTH           EQU 640
WON_HEIGHT          EQU 80

LOST_SCREEN_LEFT    EQU 0
LOST_SCREEN_TOP     EQU 210
LOST_WIDTH          EQU 640
LOST_HEIGHT         EQU 60

LOADING_LEFT    EQU 229
LOADING_TOP     EQU 219
LOADING_WIDTH   EQU 181
LOADING_HEIGHT  EQU 42

SCREEN_LEFT         EQU     0
SCREEN_RIGHT        EQU     640
SCREEN_TOP          EQU     40
SCREEN_BOTTOM       EQU     480
SCREEN_WIDTH        EQU     (SCREEN_RIGHT-SCREEN_LEFT)
SCREEN_HEIGHT       EQU     (SCREEN_BOTTOM-SCREEN_TOP)
BG_WIDTH            EQU     640
BG_HEIGHT           EQU     480

ENTER_KEY           EQU     $D

    END     START




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
