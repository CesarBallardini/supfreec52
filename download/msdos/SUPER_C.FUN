
  --------------C and ASM Functions-------------------
  ÿ
  ÿ
   Below are the C and Assembler functions in the library

Function:     Aleng()
Purpose :     Determines initialized length of an array
Usage   :     Aleng(<array>)
Params  :     <array> the array you wish to determine the length of
Returns :     Length of the array
Found in:     aleng.c

--------------------------------------------------------------------------

Function:     Att()
Purpose :     Change attribute of area of the screen
Usage   :     Att(<expN1>, <expN2>, <expN3>, <expN4>, <expN5>, [expC] )
Params  :     expN1 - top row
              expN2 - left col
              expN3 - bottom row
              expN4 - right column
              expN5 - attribute to set area
              expC  - character to fill area with
Returns :     nothing.
Found in:     att.c


--------------------------------------------------------------------------

 * INTERNAL *

Function:     Attt()
Purpose :     Used by C functions to color a screen area
Usage   :     See relevent C functions. To be called from a C
              function ONLY. Use ATT() from Clipper.
Found in:     attt.c


--------------------------------------------------------------------------

Function:     Bigelem()
Purpose :     Returns length of longest character element in array
Usage   :     Bigelem(<array>)
Params  :     <array> the array you wish to determine longest element of
Returns :     Length of the longest element
Found in:     bigel.c

--------------------------------------------------------------------------


Function:     Bxx()
Purpose :     Draw a box on the screen with attribute and optional shadow
Usage   :     Bxx(<expN1>, <expN2>, <expN3>, <expN4>, <expN5>, [expN6] )
Params  :     expN1 - top row
              expN2 - left col
              expN3 - bottom row
              expN4 - right column
              expN5 - attribute to box
              expN6 - numeric shadow type  (default 0 - no shadow)
                      follow numeric keypad     |  7 8 9
                                                |  4 5 6
                                                |  1 2 3
              expN7 - shadow attribute (default 7 - grey on black)
              expC  - frame string - MUST be 9 characters - default single

Returns :     nothing.
Found in:     bxx.c

--------------------------------------------------------------------------

Function:     Capslock()
Purpose :     sets capslock on
Usage   :     Capslock()
Params  :     nada
Returns :     nada
Found in:     s_caps.c

--------------------------------------------------------------------------


Function:     Capsloff()
Purpose :     sets capslock off
Usage   :     Capsloff()
Params  :     nada
Returns :     nada
Found in:     s_caps.c

--------------------------------------------------------------------------
Function:     Cdir()
Purpose :     Change to new directory
Usage   :     Cdir(<expC>)
Params  :     <expC> a valid directory on current drive
Returns :     .t. if succesful, .f. otherwise
Found in:     cdd.asm

!seealso:newdrv() curd()

--------------------------------------------------------------------------


Function:     C_grid()
Purpose :     Draws screen in SETCOLORS() function
Usage   :     c_grid(<expN>,<expN>)
Params  :     <expN1-2> Coordinates of top-left corner
Returns :
Found in:     c_grid.c


--------------------------------------------------------------------------

 * INTERNAL *

Function:     _gvidm()
Purpose :     Used by Super - C functions to determine video mode
Usage   :     See relevent C functions. To be called from a C
              function ONLY. Use ISCOLOR() from Clipper.
Found in:     gvidm.asm
!seealso:attt()

--------------------------------------------------------------------------
Function:     Imbox()
Purpose :     Implodes a screen variable off the screen
Usage   :     Imbox(<expN1..4>,<expC>,<expN5>)
Params  :     expN1..4 - coordinates of the saved screen
              expC     - the saved screen
              expN5    - relative speed of implosion - try 20
Example :     imbox(m->box_top,m->box_left,m->box_bot,m->box_right,m->tbox,20)
Returns :     diddly
Found in:     unbox.c

--------------------------------------------------------------------------


Function:     Prnt()
Purpose :     Write string to row/col with attribute
Usage   :     Prnt(<expN1>, <expN2>, <expC>, <expN3>)
Params  :     expN1 - row
              expN2 - col
              expC  - String to write
              expN3 - color attribute of string
Example :     Prnt(10,10,"Hello, Dolly , yes hello, Dolly",23)
Found in:     prnt.c

Returns :     nothing. Does not change cursor location or color setting.

--------------------------------------------------------------------------

Function:     Takeout()
Purpose :     Extract section of a string between delimiters
Usage   :     Takeout(<expC1>, <expC2>, <expN>)
Params  :     expC1 - string
              expC2 - delimiter  (beginning and end of string are considered
                                  delimiters)
              expN  - occurance

Example :     takeout("Next:Previous:First:Quit",":",3)
              returns "First"

Returns :     Section of string between delimiters, occurance <expN>.
Found in:     between.c


--------------------------------------------------------------------------

Function:     xBxx()
Purpose :     Draw a box on the screen with attribute and optional shadow
Usage   :     Bxx(<expN1>, <expN2>, <expN3>, <expN4>, <expN5>, <expN6>, ;
                   <expN7>,<expC1>,<expn8>,<expn9>)
Params  :     expN1 - top row
              expN2 - left col
              expN3 - bottom row
              expN4 - right column
              expN5 - attribute of box
              expN6 - numeric shadow type  (default 0 - no shadow)
                      follow numeric keypad     |  7 8 9
                                                |  4 5 6
                                                |  1 2 3
              expN7 - shadow attribute (default 7 - grey on black)
              expC  - frame string - MUST be 8 characters - default single
              expN8 - explode speed factor 1-1000 (depends on machine)

              All params MUST be passed. For numerics, pass -1 for default.
              For string, pass '' for default.

Returns :     nothing.
Found in:     xbxx.c

--------------------------------------------------------------------------
Function:     __drive()
Purpose :     Get drive number (0,1,2..)
Usage   :     See S_DRIVE.PRG, which converts the return value to
              a drive letter in the form [D:]
Params  :     none
Returns :     current drive letter (0,1,2..)
Found in:     _drive.asm


