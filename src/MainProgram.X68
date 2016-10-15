*-----------------------------------------------------------
* Title      : The Shrill and Gruff Tales of Black and Yellow
* Written by : Krishna Bharadwaj Y
* Date       : 10/08/2016
* Description: An interactive game created in a week satisfying
*              the following requirements:
* 1 - User input control of game entity
* 2 - Bitmap background with entities moving around over it
* 3 - Physics update of game entity, including acceleration
* 4 - Fixed point math
* 5 - Collision detection between game entities
* 6 - A score indicator as a 7-segment LED
* 7 - Randomness
*-----------------------------------------------------------

* We define storage areas that can be used across the game.
* This is important especially when our code is layed out
* over multiple files.
CODE EQU 0
DATA EQU 1
    
    SECTION CODE
    ORG $1000
    
    SECTION DATA
    ORG $2000

* All the includes. Order is important as some of the defines
* used by subsequent files are defined in earlier files.
    INCLUDE 'SwapFunctions.X68'
    INCLUDE 'BitmapFunctions.X68'
    INCLUDE 'SevenSegment.X68'
    INCLUDE 'Input.X68'
    INCLUDE 'Player.X68'
    INCLUDE 'Item.X68'
    INCLUDE 'Spike.X68'
    INCLUDE 'Sound.X68'
    

    SECTION CODE
* Main loop. This is where processing is done every frame.
MAIN:
    BSR CHECKINPUT
    BSR UPDATESPIKE
    
    * Redraw screen and loop
    CLR.L   D0
    MOVE.B  #REPAINT_SCREEN_TASK, D0
    TRAP    #TRAPCODE
    BRA MAIN
    
    INCLUDE 'BootstrapAndHelper.X68'













*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
