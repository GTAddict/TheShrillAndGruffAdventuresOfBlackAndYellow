*-----------------------------------------------------------
* Title      : Bitmap Functions
* Written by : Krishna Bharadwaj Y
* Date       : 09/24/2016
* Description: This code will read and display a bitmap with
*              configurable screen X, Y, image X, Y, and
*              width and height to draw.
*-----------------------------------------------------------

    SECTION DATA
BMPSIGNATURE        EQU $424D
COMMANDSETPENCOLOR  EQU 80
COMMANDDRAWPIXEL    EQU 82
TRAPCODE            EQU 15

    SECTION CODE
* Earlier, we had split the call into 2. One to load the file
* (essentially read the header), and one to render it.
* This would prevent the same header from being read over and
* over if it was used in sequences, but I removed this
* performance optimization since it causes more code at the 
* other end.
    
* * This method will look at the stack and load the file.
* READBMP:
*     MOVE.L  4(SP), A2
*     BRA     READHEADER
*     MOVE.L  4(SP), A2
*     ADD.L   (IMAGEOFFSET), A2
*     RTS

VALIDATEFILE:
    MOVE.W  (A2)+, D1
    CMP.W   #BMPSIGNATURE, D1
    BNE     INVALIDFILE
    RTS
    
INVALIDFILE:
    RTS
    
; We shall read each field directly into the stack pointer and call the swap routine.
; On return, we shall move that into the corresponding variable.    
READHEADER:
    BSR VALIDATEFILE
    
    MOVE.L  (A2)+, -(SP)
    BSR     SWAPLONG
    MOVE.L  (SP)+, FILESIZE
    
    MOVE.W  (A2)+, -(SP)
    BSR     SWAPWORD
    MOVE.W  (SP)+, RESERVEDVAL
    
    MOVE.W  (A2)+, -(SP)
    BSR     SWAPWORD
    MOVE.W  (SP)+, (RESERVEDVAL + 2)
    
    MOVE.L  (A2)+, -(SP)
    BSR     SWAPLONG
    MOVE.L  (SP)+, IMAGEOFFSET
    
    MOVE.L  (A2)+, -(SP)
    BSR     SWAPLONG
    MOVE.L  (SP)+, DATAHEADERSIZE 
    
    MOVE.L  (A2)+, -(SP)
    BSR     SWAPLONG
    MOVE.L  (SP)+, IMAGEWIDTH 
    
    MOVE.L  (A2)+, -(SP)
    BSR     SWAPLONG
    MOVE.L  (SP)+, IMAGEHEIGHT

    MOVE.W  (A2)+, -(SP)
    BSR     SWAPWORD
    MOVE.W  (SP)+, PLANES

    MOVE.W  (A2)+, -(SP)
    BSR     SWAPWORD
    MOVE.W  (SP)+, BITSPERPIXEL
    
    MOVE.L  (A2)+, -(SP)
    BSR     SWAPLONG
    MOVE.L  (SP)+, COMPRESSIONMODE 
    
    MOVE.L  (A2)+, -(SP)
    BSR     SWAPLONG
    MOVE.L  (SP)+, PIXELDATASIZE
    
    MOVE.L  (A2)+, -(SP)
    BSR     SWAPLONG
    MOVE.L  (SP)+, WIDTHRESOLUTION
    
    MOVE.L  (A2)+, -(SP)
    BSR     SWAPLONG
    MOVE.L  (SP)+, HEIGHTRESOLUTION
    
    MOVE.L  (A2)+, -(SP)
    BSR     SWAPLONG
    MOVE.L  (SP)+, COLORSUSED
    
    MOVE.L  (A2)+, -(SP)
    BSR     SWAPLONG
    MOVE.L  (SP)+, IMPORTANTCOLORS
    
    RTS

* This method takes 7 arguments.
* 1. The location of the image.
* 2. The top left X position of the screen to display the image at
* 3. The top left Y position of the screen to display the image at
* 4. The top left X position of the image to start drawing from
* 5. The top leftT Y POSITION of the image to start drawing from
* 6. The width of the image to draw
* 7. The height of the image to draw
DRAWBMP
    MOVE.L   4(SP), A2
    MOVE.L   8(SP), SCREEN_START_X
    MOVE.L  12(SP), SCREEN_START_Y
    MOVE.L  16(SP), IMAGE_START_X
    MOVE.L  20(SP), IMAGE_START_Y
    MOVE.L  24(SP), WIDTH_TO_DRAW
    MOVE.L  28(SP), HEIGHT_TO_DRAW
    
    BSR     READHEADER
    MOVE.L  4(SP), A2
    ADD.L   (IMAGEOFFSET), A2
    
    MOVE.L  IMAGEHEIGHT, D1
    SUB.L   #1, D1
    SUB.L   IMAGE_START_Y, D1
    MOVE.L  IMAGEWIDTH, D2
    MULU    D2, D1
    MOVE.L  D1, D3              ; Move high bits to new register.
    LSR.L   #8, D3
    LSR.L   #8, D3
    MULU    #4, D1              ; Each pixel takes 4 bytes.
    MULU    #4, D3
    LSL.L   #8, D3
    LSL.L   #8, D3    
    ADD.L   D3, D1
    ADD.L   D1, A2              ; Skip to the last column.
    MOVE.L  IMAGE_START_X, D2
    MULU    #4, D2
    ADD.L   D2, A2   ; Skip to the start X.
    
    MOVE.L  IMAGEWIDTH, D1
    ADD.L   WIDTH_TO_DRAW, D1
    MULU    #4, D1              ; Each pixel takes 4 bytes.
    MOVE.L  D1, NEXTCOLUMNPIXELS
    
    
    MOVE.L  #0, COLUMNSDRAWN
    
    MOVE.L  SCREEN_START_X, SCREEN_CURRENT_X
    MOVE.L  SCREEN_START_Y, SCREEN_CURRENT_Y
    
DRAWBMP32
    MOVE.L  #0, ROWSDRAWN
    MOVE.L  SCREEN_START_X, SCREEN_CURRENT_X
    
DRAWROW
* Set pen color
    MOVE.L  (A2)+, D1
    LSR.L   #8, D1
    MOVE.L  #COMMANDSETPENCOLOR, D0
    TRAP    #TRAPCODE
    
* Draw pixel
    MOVE.L  (SCREEN_CURRENT_X), D1
    MOVE.L  (SCREEN_CURRENT_Y), D2
    MOVE.L  #COMMANDDRAWPIXEL, D0
    TRAP    #TRAPCODE
    
    ADD.L   #1, ROWSDRAWN
    ADD.L   #1, SCREEN_CURRENT_X
    
    MOVE.L  WIDTH_TO_DRAW, D1
    CMP.L   ROWSDRAWN, D1
    BGT     DRAWROW     
    
    
NEXTCOLUMN
    ADD.L   #1, COLUMNSDRAWN
    SUB.L   NEXTCOLUMNPIXELS, A2
    ADD.L   #1, SCREEN_CURRENT_Y
    
    MOVE.L  HEIGHT_TO_DRAW, D1
    CMP.L   COLUMNSDRAWN, D1
    BGT     DRAWBMP32
    
DONE
    RTS
    
    SECTION DATA
SCREEN_START_X      DS.L    1
SCREEN_START_Y      DS.L    1
SCREEN_CURRENT_X    DS.L    1
SCREEN_CURRENT_Y    DS.L    1

IMAGE_START_X       DS.L    1
IMAGE_START_Y       DS.L    1

WIDTH_TO_DRAW       DS.L    1
HEIGHT_TO_DRAW      DS.L    1

ROWSDRAWN           DS.L    1
COLUMNSDRAWN        DS.L    1
NEXTCOLUMNPIXELS    DS.L    1
           
FILESIZE            DS.L    1
RESERVEDVAL         DS.W    2
IMAGEOFFSET         DS.L    1
DATAHEADERSIZE      DS.L    1
IMAGEWIDTH          DS.L    1
IMAGEHEIGHT         DS.L    1
PLANES              DS.W    1
BITSPERPIXEL        DS.W    1
COMPRESSIONMODE     DS.L    1
PIXELDATASIZE       DS.L    1
WIDTHRESOLUTION     DS.L    1
HEIGHTRESOLUTION    DS.L    1
COLORSUSED          DS.L    1
IMPORTANTCOLORS     DS.L    1





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
