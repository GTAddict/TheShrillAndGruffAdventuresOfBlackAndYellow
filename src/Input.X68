*-----------------------------------------------------------
* Title      : Input
* Written by : Krishna Bharadwaj Y
* Date       : 10/09/2016
* Description: Checks keyboard state and controls player
*              entity movement.
*-----------------------------------------------------------

    SECTION DATA
CHECKINPUTCODE  EQU    19
KEYSTOCHECK     EQU    'W'<<24+'A'<<16+'S'<<8+'D'

    SECTION CODE
CHECKINPUT:
    MOVE.B  #CHECKINPUTCODE, D0
    MOVE.L  #KEYSTOCHECK, D1
    TRAP    #TRAPCODE
    
    BTST.L  #24, D1
    BNE     MOVEUP
    
    BTST.L  #16, D1
    BNE     MOVELEFT
    
    BTST.L  #8, D1
    BNE     MOVEDOWN
    
    BTST.L  #0, D1
    BNE     MOVERIGHT
    
    RTS
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
