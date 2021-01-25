/*
   Area Fill ID
   ------------
     Area fill uses a percentage of shading OR a pattern

     The shading percentages are:

           "1 thru 2" = 2% shade
          "3 thru 10" = 10% shade
         "11 thru 20" = 20% shade
         "21 thru 35" = 30% shade
         "36 thru 55" = 45% shade
         "56 thru 80" = 70% shade
         "81 thru 99" = 90% shade
                "100" = 100% shade

     The pattern fills are:

        #"1" = horizontal lines
         "2" = vertical lines
         "3" = diagonal lines top right to bottom left
         "4" = diagonal lines top left to bottom right
         "5" = #1 and # 2 combined
         "6" = #3 and # 4 combined

*/

//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
// Job Control
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ

//----------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SL_RESET()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SL_RESET() Resets the printer to user defaults
ณ
ณ  Returns:
ณ  --------
ณ  cCode => control string to send to the printer
ณ
ณ  Syntax:
ณ  -------
ณ  SL_RESET()
ณ
ณ  Description:
ณ  ------------
ณ  Resets the printer to user defaults
ณ
ณ  Examples:
ณ  ---------
ณ   ?SL_RESET()
ณ
ณ  Notes:
ณ  -------
ณ  Does not send anything to the printer - instead
ณ  returns a control string that you send to the printer. String can be
ณ  sent with ? or ?? or  QOUT() or QQOUT().
ณ 
ณ  For HP and compatible(PCL) Laserjet printers.
ณ 
ณ  Source:
ณ  -------
ณ  S_HPLAS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function SL_Reset
return chr(27)+"E"

//-------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SL_COPIES()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SL_COPIES() Sets the laserjet to print n copies of each page
ณ 
ณ  Returns:
ณ  --------
ณ  cCode => control string to send to the printer
ณ 
ณ  Syntax:
ณ  -------
ณ  SL_COPIES(nCopies)
ณ 
ณ  Description:
ณ  ------------
ณ  Sets the laserjet to print <nCopies> copies of each
ณ  page.
ณ 
ณ  Examples:
ณ  ---------
ณ   cCode := SL_COPIES(2)  // prints 2 or each page
ณ 
ณ   ?cCode
ณ 
ณ  Notes:
ณ  -------
ณ  Does not send anything to the printer - instead
ณ  returns a control string that you send to the printer. String can be
ณ  sent with ? or ?? or  QOUT() or QQOUT().
ณ 
ณ  For HP and compatible(PCL) Laserjet printers.
ณ 
ณ  Source:
ณ  -------
ณ  S_HPLAS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function SL_Copies(nCopies)
RETURN ( chr(27)+'&l'+alltrim(str(nCopies))+'X' )

//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
// Page Control
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ

//----------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SL_LANDS()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SL_LANDS() Sets laserjet orientation to LANDSCAPE
ณ 
ณ  Returns:
ณ  --------
ณ  cCode => control string to send to the printer
ณ 
ณ  Syntax:
ณ  -------
ณ  SL_LANDS()
ณ 
ณ  Description:
ณ  ------------
ณ  Sets laserjet orientation to LANDSCAPE
ณ 
ณ  Examples:
ณ  ---------
ณ   ?SL_LANDS()
ณ 
ณ  Notes:
ณ  -------
ณ  Does not send anything to the printer - instead
ณ  returns a control string that you send to the printer. String can be
ณ  sent with ? or ?? or  QOUT() or QQOUT().
ณ 
ณ  For HP and compatible(PCL) Laserjet printers.
ณ 
ณ  Source:
ณ  -------
ณ  S_HPLAS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function SL_Lands
return CHR(27) + '&l1O'

//----------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SL_PORT()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SL_PORT() Sets the laserjet orientation to PORTRAIT
ณ 
ณ  Returns:
ณ  --------
ณ  cCode => control string to send to the printer
ณ 
ณ  Syntax:
ณ  -------
ณ  SL_PORT()
ณ 
ณ  Description:
ณ  ------------
ณ  Sets the laserject orientation to PORTRAIT
ณ 
ณ  Examples:
ณ  ---------
ณ   cSetup := SL_PORT()
ณ 
ณ   ?cSetup
ณ 
ณ  Notes:
ณ  -------
ณ  Does not send anything to the printer - instead
ณ  returns a control string that you send to the printer. String can be
ณ  sent with ? or ?? or  QOUT() or QQOUT().
ณ 
ณ  For HP and compatible(PCL) Laserjet printers.
ณ 
ณ  Source:
ณ  -------
ณ  S_HPLAS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function SL_Port
return CHR(27) + '&l0O'

//----------------------------------------------------
/*
  1 Executive           (7.25" x 10.5")
  2 Letter              (8.5" x 11")
  3 Legal               (8.5" x 14")
 26 A4                  (210mm x 297mm)
 80 Monarch Envelope    (3 7/8" x 7 1/2")
 90 COM-10 Envelope     (4 1/8" x 8 1/2")
 91 International C5    (162mm  x 229mm)
*/
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SL_PAGESIZE()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SL_PAGESIZE() Sets the page size on the laserjet
ณ 
ณ  Returns:
ณ  --------
ณ  cCode => control string to send to the printer
ณ 
ณ  Syntax:
ณ  -------
ณ  SL_PAGESIZE(nSize)
ณ 
ณ  Description:
ณ  ------------
ณ  Sets the page size on the laserjet where <nSize> is
ณ  one of the following:
ณ 
ณ       1 Executive          (7.25" x 10.5")
ณ       2 Letter                 (8.5" x 11")
ณ       3 Legal                  (8.5" x 14")
ณ      26 A4                     (210mm x 297mm)
ณ      80 Monarch Envelope   (3 7/8" x 7 1/2")
ณ      90 COM-10 Envelope    (4 1/8" x 8 1/2")
ณ      91 International C5   (162mm  x 229mm)
ณ 
ณ  Examples:
ณ  ---------
ณ   cCode := SL_PAGESIZE(2)  // letter size
ณ   ?cCode
ณ   cCode := SL_PAGESIZE(3)  // legal  size
ณ   ?cCode
ณ   cCode := SL_PAGESIZE(26)  // A4 size
ณ   ?cCode
ณ 
ณ  Notes:
ณ  -------
ณ  Does not send anything to the printer - instead
ณ  returns a control string that you send to the printer. String can be
ณ  sent with ? or ?? or  QOUT() or QQOUT().
ณ 
ณ  For HP and compatible(PCL) Laserjet printers.
ณ 
ณ  Source:
ณ  -------
ณ  S_HPLAS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function SL_Pagesize(nSize)
nSize := iif(ascan({1,2,3,26,80,81,90,91},nSize)>0,nSize,2)
return CHR(27) + "&l"+alltrim(str(nSize))+"A"

//-------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SL_LEFTMARG()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SL_LEFTMARG() Sets the left margin to the left edge of the
ณ  specified column
ณ 
ณ  Returns:
ณ  --------
ณ  cCode => control string to send to the printer
ณ 
ณ  Syntax:
ณ  -------
ณ  SL_LEFTMARG(nColumn)
ณ 
ณ  Description:
ณ  ------------
ณ  Sets the left margin to the left edge of the
ณ  specified column in <nColumn>.
ณ 
ณ  Examples:
ณ  ---------
ณ   ?SL_LEFTMARG(3) // sets left margin to column3
ณ 
ณ  Notes:
ณ  -------
ณ  Does not send anything to the printer - instead
ณ  returns a control string that you send to the printer. String can be
ณ  sent with ? or ?? or  QOUT() or QQOUT().
ณ 
ณ  For HP and compatible(PCL) Laserjet printers.
ณ 
ณ  Source:
ณ  -------
ณ  S_HPLAS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function SL_LeftMarg(nColumn)
RETURN ( chr(27)+'&a'+alltrim(str(nColumn))+'L' )

//-------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SL_RIGHTMARG()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SL_RIGHTMARG() Sets the right margin to the right edge of the
ณ  specified column
ณ 
ณ  Returns:
ณ  --------
ณ  cCode => control string to send to the printer
ณ 
ณ  Syntax:
ณ  -------
ณ  SL_RIGHTMARG(nCol)
ณ 
ณ  Description:
ณ  ------------
ณ  Sets the right margin to the right edge of the
ณ  specified column <nCol>
ณ
ณ  Examples:
ณ  ---------
ณ   ?SL_RIGHTMARG(70) // sets right margin to 70
ณ 
ณ  Notes:
ณ  -------
ณ  Does not send anything to the printer - instead
ณ  returns a control string that you send to the printer. String can be
ณ  sent with ? or ?? or  QOUT() or QQOUT().
ณ 
ณ  For HP and compatible(PCL) Laserjet printers.
ณ 
ณ  Source:
ณ  -------
ณ  S_HPLAS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function SL_RightMarg(nColumn)
RETURN ( chr(27)+'&a'+alltrim(str(nColumn))+'M' )

//-------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SL_TOPMARG()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SL_TOPMARG() Designates the number of lines of top margin
ณ 
ณ  Returns:
ณ  --------
ณ  cCode => control string to send to the printer
ณ 
ณ  Syntax:
ณ  -------
ณ  SL_TOPMARG(nLines)
ณ 
ณ  Description:
ณ  ------------
ณ  Designates the number of lines of top margin <nLines>
ณ 
ณ  Examples:
ณ  ---------
ณ   ?SL_TOPMARG(3) // sets top margin to 3
ณ 
ณ  Notes:
ณ  -------
ณ  Does not send anything to the printer - instead
ณ  returns a control string that you send to the printer. String can be
ณ  sent with ? or ?? or  QOUT() or QQOUT().
ณ 
ณ  For HP and compatible(PCL) Laserjet printers.
ณ 
ณ  Source:
ณ  -------
ณ  S_HPLAS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*/
function SL_TopMarg(nLines)
RETURN ( chr(27)+'&l'+alltrim(str(nLines))+'E' )

//----------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SL_SETLPI()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SL_SETLPI() Sets the lines per inch for the laserjet
ณ 
ณ  Returns:
ณ  --------
ณ  cCode => control string to send to the printer
ณ 
ณ  Syntax:
ณ  -------
ณ  SL_SETLPI(nLPI)
ณ 
ณ  Description:
ณ  ------------
ณ  Sets the lines per inch for the laserjet to <nLpi>
ณ  which  can be:
ณ 
ณ  1 - 1 line/inch
ณ  2 - 2 line/inch
ณ  3 - 3 line/inch
ณ  4 - 4 line/inch
ณ  6 - 6 line/inch
ณ  8 - 8 line/inch
ณ  12-12 line/inch
ณ  16-16 line/inch
ณ  24-24 line/inch
ณ  48-48 line/inch
ณ 
ณ  Examples:
ณ  ---------
ณ   cCode := SL_SETLPI(6)     // sets LPI to 6 - the default
ณ 
ณ   ?cCode
ณ 
ณ  Notes:
ณ  -------
ณ  Does not send anything to the printer - instead
ณ  returns a control string that you send to the printer. String can be
ณ  sent with ? or ?? or  QOUT() or QQOUT().
ณ 
ณ  For HP and compatible(PCL) Laserjet printers.
ณ 
ณ  Source:
ณ  -------
ณ  S_HPLAS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function SL_Setlpi(nLpi)
local cLpi := alltrim(str(nLpi))
cLpi := iif(cLpi$"1;2;3;4;6;8;12;16;24;48",cLpi,"6")
return CHR(27) + "&l"+cLpi+"D"

//-------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SL_EJECT()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SL_EJECT() Ejects the current page
ณ 
ณ  Returns:
ณ  --------
ณ  cCode => control string to send to the printer
ณ 
ณ  Syntax:
ณ  -------
ณ  SL_EJECT()
ณ 
ณ  Description:
ณ  ------------
ณ  Ejects the current page
ณ 
ณ  Examples:
ณ  ---------
ณ   ?SL_EJECT()
ณ 
ณ  Notes:
ณ  -------
ณ  Does not send anything to the printer - instead
ณ  returns a control string that you send to the printer. String can be
ณ  sent with ? or ?? or  QOUT() or QQOUT().
ณ 
ณ  QOUT() or QQOUT().
ณ 
ณ  For HP and compatible(PCL) Laserjet printers.
ณ 
ณ  Source:
ณ  -------
ณ  S_HPLAS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function SL_Eject
RETURN ( chr(12) )



//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
// Cursor control by Row/Column
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//-------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SL_GOTO()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SL_GOTO() Move the printer cursor to row/col
ณ 
ณ  Returns:
ณ  --------
ณ  cCode => control string to send to the printer
ณ 
ณ  Syntax:
ณ  -------
ณ  SL_GOTO(nRow,nCol)
ณ 
ณ  Description:
ณ  ------------
ณ  Move print head to row <nRow> and column <nCol>.
ณ  Actual end position will depend on both LINES PER INCH and
ณ  CHARACTERS PER INCH settings.
ณ 
ณ  Examples:
ณ  ---------
ณ   ?SL_GOTO(10,10)
ณ 
ณ   ??"Hello world"
ณ 
ณ   ?SL_GOTO(9,10)
ณ 
ณ   ??"Attention:"
ณ 
ณ  Notes:
ณ  -------
ณ  Does not send anything to the printer - instead
ณ  returns a control string that you send to the printer. String can be
ณ  sent with ? or ?? or  QOUT() or QQOUT().
ณ 
ณ  For HP and compatible(PCL) Laserjet printers.
ณ 
ณ  Source:
ณ  -------
ณ  S_HPLAS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*/
function SL_Goto(nRow,nCol)
return chr(27)+"&a"+alltrim(str(nRow))+"r"+alltrim(str(nCol))+"C"

//-------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SL_DOWNROW()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SL_DOWNROW() Move the printer cursor up/down by # rows,
ณ  relative to position
ณ 
ณ  Returns:
ณ  --------
ณ  cCode => control string to send to the printer
ณ 
ณ  Syntax:
ณ  -------
ณ  SL_DOWNROW(nRows)
ณ 
ณ  Description:
ณ  ------------
ณ  Move print head down <nRows>. A negative number means
ณ  move UP.
ณ 
ณ  Actual end position will depend on both LINES PER
ณ  INCH settings.
ณ 
ณ  Examples:
ณ  ---------
ณ   ?SL_DOWNROW(10)
ณ 
ณ   ??"Hello world"
ณ 
ณ   ?SL_DOWNROW(-1)    // moves to prior row
ณ 
ณ   ?SL_OVERCOL(-11)   // and back to starting column
ณ 
ณ   ??"Attention:"
ณ 
ณ  Notes:
ณ  -------
ณ  Does not send anything to the printer - instead
ณ  returns a control string that you send to the printer. String can be
ณ  sent with ? or ?? or  QOUT() or QQOUT().
ณ 
ณ  For HP and compatible(PCL) Laserjet printers.
ณ 
ณ  Source:
ณ  -------
ณ  S_HPLAS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function SL_DownRow(nRows)
local cPrefix := iif(nRows>0,"+","")
return chr(27)+"&a"+cPrefix+alltrim(str(nRows))+"R"

//-------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SL_OVERCOL()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SL_OVERCOL() Move the printer cursor right/left # columns
ณ  relative to position
ณ 
ณ  Returns:
ณ  --------
ณ  cCode => control string to send to the printer
ณ 
ณ  Syntax:
ณ  -------
ณ  SL_OVERCOL(nColumns)
ณ
ณ  Description:
ณ  ------------
ณ  Move print head left/right <nColumns>. A negative
ณ  number means move left, a positive number means move right.
ณ 
ณ  Actual end position will depend on CHARACTERS PER
ณ  INCH settings.
ณ 
ณ  Examples:
ณ  ---------
ณ   ?SL_OVERCOL(10)
ณ 
ณ   ??"Hello world"
ณ 
ณ   ?SL_DOWNROW(-1)    // moves to prior row
ณ 
ณ   ?SL_OVERCOL(-11)   // and back to starting column
ณ 
ณ   ??"Attention:"
ณ
ณ  Notes:
ณ  -------
ณ  Does not send anything to the printer - instead
ณ  returns a control string that you send to the printer. String can be
ณ  sent with ? or ?? or  QOUT() or QQOUT().
ณ 
ณ  For HP and compatible(PCL) Laserjet printers.
ณ 
ณ  Source:
ณ  -------
ณ  S_HPLAS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function SL_OverCol(nCols)
local cPrefix := iif(nCols>0,"+","")
return chr(27)+"&a"+cPrefix+alltrim(str(nCols))+"C"

//-------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SL_PUSHCURS()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SL_PUSHCURS() Pushes the printer cursor position for later
ณ  popping
ณ 
ณ  Returns:
ณ  --------
ณ  cCode => control string to send to the printer
ณ 
ณ  Syntax:
ณ  -------
ณ  SL_PUSHCURS()
ณ 
ณ  Description:
ณ  ------------
ณ  Pushes the current printer cursor position for later
ณ  retrieval (popping) with SL_POPCURS(). Up to 20 positions may be pushed.
ณ 
ณ  Examples:
ณ  ---------
ณ   ?SL_PUSHCURS()
ณ 
ณ  Notes:
ณ  -------
ณ  Does not send anything to the printer - instead
ณ  returns a control string that you send to the printer. String can be
ณ  sent with ? or ?? or  QOUT() or QQOUT().
ณ 
ณ  For HP and compatible(PCL) Laserjet printers.
ณ 
ณ  Source:
ณ  -------
ณ  S_HPLAS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
Function SL_PushCurs
return chr(27)+"&f0S"

//-------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SL_POPCURS()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SL_POPCURS() Pops the printer cursor position for later popping
ณ 
ณ  Returns:
ณ  --------
ณ  cCode => control string to send to the printer
ณ 
ณ  Syntax:
ณ  -------
ณ  SL_POPCURS()
ณ 
ณ  Description:
ณ  ------------
ณ  Pops the current printer cursor position pushed by
ณ  with SL_PUSHCURS(). Up to 20 positions may be POPed.
ณ 
ณ  Examples:
ณ  ---------
ณ   ?SL_POPCURS()
ณ 
ณ  Notes:
ณ  -------
ณ  Does not send anything to the printer - instead
ณ  returns a control string that you send to the printer. String can be
ณ  sent with ? or ?? or  QOUT() or QQOUT().
ณ 
ณ  For HP and compatible(PCL) Laserjet printers.
ณ 
ณ  Source:
ณ  -------
ณ  S_HPLAS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
Function SL_PopCurs
return chr(27)+"&f1S"


//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
// Font Selection
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ

//-------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SL_BOLD()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SL_BOLD() Sets font stroke weight to BOLD (ultra black)
ณ 
ณ  Returns:
ณ  --------
ณ  cCode => control string to send to the printer
ณ 
ณ  Syntax:
ณ  -------
ณ  SL_BOLD()
ณ 
ณ  Description:
ณ  ------------
ณ  Sets font stroke weight to BOLD (ultra black)
ณ 
ณ  Examples:
ณ  ---------
ณ   ?"Now I am "+SL_BOLD()+"REALLY"+SL_NORMAL()+" mad!"
ณ 
ณ  Notes:
ณ  -------
ณ  Does not send anything to the printer - instead
ณ  returns a control string that you send to the printer. String can be
ณ  sent with ? or ?? or  QOUT() or QQOUT().
ณ 
ณ  For HP and compatible(PCL) Laserjet printers.
ณ 
ณ  Source:
ณ  -------
ณ  S_HPLAS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function SL_Bold
return chr(27)+"(s7B"

//-------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SL_NORMAL()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ 
ณ  Short:
ณ  ------
ณ  SL_NORMAL() Sets font stroke weight to NORMAL (non bold)
ณ 
ณ  Returns:
ณ  --------
ณ  cCode => control string to send to the printer
ณ 
ณ  Syntax:
ณ  -------
ณ  SL_NORMAL()
ณ 
ณ  Description:
ณ  ------------
ณ  Sets font stroke weight to NORMAL (non bold)
ณ 
ณ  Examples:
ณ  ---------
ณ   ?"Now I am "+SL_NORMAL()+"REALLY"+SL_NORMAL()+" mad!"
ณ 
ณ  Notes:
ณ  -------
ณ  Does not send anything to the printer - instead
ณ  returns a control string that you send to the printer. String can be
ณ  sent with ? or ?? or  QOUT() or QQOUT().
ณ 
ณ  For HP and compatible(PCL) Laserjet printers.
ณ 
ณ  Source:
ณ  -------
ณ  S_HPLAS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function SL_Normal
return chr(27)+"(s0B"

//-------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SL_UNDER()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SL_UNDER() Sets automatic text underlining on
ณ 
ณ  Returns:
ณ  --------
ณ  cCode => control string to send to the printer
ณ 
ณ  Syntax:
ณ  -------
ณ  SL_UNDER()
ณ 
ณ  Description:
ณ  ------------
ณ  Sets automatic text underlining on
ณ
ณ  Examples:
ณ  ---------
ณ   ?"Now I am "+SL_UNDER()+"REALLY"+SL_UNDEROFF()+" mad!"
ณ 
ณ  Notes:
ณ  -------
ณ  Does not send anything to the printer - instead
ณ  returns a control string that you send to the printer. String can be
ณ  sent with ? or ?? or  QOUT() or QQOUT().
ณ 
ณ  For HP and compatible(PCL) Laserjet printers.
ณ 
ณ  Source:
ณ  -------
ณ  S_HPLAS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function SL_Under
return chr(27)+"&d0D"

//-------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SL_UNDEROFF()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SL_UNDEROFF() Sets automatic text underlining off
ณ 
ณ  Returns:
ณ  --------
ณ  cCode => control string to send to the printer
ณ 
ณ  Syntax:
ณ  -------
ณ  SL_UNDEROFF()
ณ 
ณ  Description:
ณ  ------------
ณ  Sets automatic text underlining off
ณ 
ณ  Examples:
ณ  ---------
ณ   ?"Now I am "+SL_UNDER()+"REALLY"+SL_UNDEROFF()+" mad!"
ณ 
ณ  Notes:
ณ  -------
ณ  Does not send anything to the printer - instead
ณ  returns a control string that you send to the printer. String can be
ณ  sent with ? or ?? or  QOUT() or QQOUT().
ณ 
ณ  For HP and compatible(PCL) Laserjet printers.
ณ 
ณ  Source:
ณ  -------
ณ  S_HPLAS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function SL_UnderOff
return chr(27)+"&d@"

//-------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SL_ITALIC()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SL_ITALIC() Sets font style to italic
ณ 
ณ  Returns:
ณ  --------
ณ  cCode => control string to send to the printer
ณ 
ณ  Syntax:
ณ  -------
ณ  SL_ITALIC()
ณ 
ณ  Description:
ณ  ------------
ณ  Sets font style to italic
ณ 
ณ  Examples:
ณ  ---------
ณ   ?"Now I am "+SL_ITALIC()+"REALLY"+SL_ITALICOFF()+" mad!"
ณ 
ณ  Notes:
ณ  -------
ณ  Does not send anything to the printer - instead
ณ  returns a control string that you send to the printer. String can be
ณ  sent with ? or ?? or  QOUT() or QQOUT().
ณ 
ณ  For HP and compatible(PCL) Laserjet printers.
ณ 
ณ  Source:
ณ  -------
ณ  S_HPLAS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
Function SL_Italic
return chr(27)+"(s1S"

//-------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SL_ITALICOFF()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SL_ITALICOFF() Sets font style to upright (non italic)
ณ 
ณ  Returns:
ณ  --------
ณ  cCode => control string to send to the printer
ณ 
ณ  Syntax:
ณ  -------
ณ  SL_ITALICOFF()
ณ 
ณ  Description:
ณ  ------------
ณ  Sets font style to upright( non italic)
ณ 
ณ  Examples:
ณ  ---------
ณ   ?"Now I am "+SL_ITALIC()+"REALLY"+SL_ITALICOFF()+" mad!"
ณ 
ณ  Notes:
ณ  -------
ณ  Does not send anything to the printer - instead
ณ  returns a control string that you send to the printer. String can be
ณ  sent with ? or ?? or  QOUT() or QQOUT().
ณ 
ณ  For HP and compatible(PCL) Laserjet printers.
ณ 
ณ  Source:
ณ  -------
ณ  S_HPLAS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
Function SL_ItalicOff
return chr(27)+"(s0S"

//----------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SL_SETCPI()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SL_SETCPI() Sets characters per inch
ณ 
ณ  Returns:
ณ  --------
ณ  cCode => control string to send to the printer
ณ 
ณ  Syntax:
ณ  -------
ณ  SL_SETCPI(nCPI)
ณ 
ณ  Description:
ณ  ------------
ณ  Sets characters per inch to <nCpi>  - valid to 2
ณ  decimal places. Current font must support this CPI.
ณ 
ณ  Examples:
ณ  ---------
ณ   ?SL_SETCPI(16.66)   // sets to compressed
ณ 
ณ   ?SL_SETCPI(12)     // sets to 12 cpi
ณ 
ณ   ?SL_SETCPI(10)     // sets to 10 cpi  (default)
ณ 
ณ  Notes:
ณ  -------
ณ  Does not send anything to the printer - instead
ณ  returns a control string that you send to the printer. String can be
ณ  sent with ? or ?? or  QOUT() or QQOUT().
ณ 
ณ  For HP and compatible(PCL) Laserjet printers.
ณ 
ณ  Source:
ณ  -------
ณ  S_HPLAS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function SL_Setcpi(nCpi)
local cCpi := alltrim(str( iif(nCpi#nil,Round(nCpi,2),10) ))
return CHR(27) + "(s"+cCpi+"H"



//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
// Drawing by Row/Column
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ

//----------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SL_FILL()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SL_FILL() Fills a rectangle with shading or a pattern.
ณ 
ณ  Returns:
ณ  --------
ณ  cCode => control string to send to the printer
ณ 
ณ  Syntax:
ณ  -------
ณ  SL_FILL(nTop,nLeft,nBottom,nRight,[cShade],[cFill],[nCpi],[nLpi])
ณ 
ณ  Description:
ณ  ------------
ณ  Fills a rectangle based on rows and columns at
ณ  <nTop,nLeft> to <nBottom,nRight>. The area may be shaded
ณ  [cShade] or filled with a pattern [cFill] :
ณ 
ณ  The shading percentages are (default "20") :
ณ 
ณ         "1 thru 2" = 2% shade
ณ        "3 thru 10" = 10% shade
ณ       "11 thru 20" = 20% shade
ณ       "21 thru 35" = 30% shade
ณ       "36 thru 55" = 45% shade
ณ       "56 thru 80" = 70% shade
ณ       "81 thru 99" = 90% shade
ณ              "100" = 100% shade
ณ 
ณ  The pattern fills are (default "6"):
ณ 
ณ       "1" = horizontal lines
ณ       "2" = vertical lines
ณ       "3" = diagonal lines top right to bottom left
ณ       "4" = diagonal lines top left to bottom right
ณ       "5" = #1 and # 2 combined
ณ       "6" = #3 and # 4 combined
ณ 
ณ  <nCpi> is the characters per inch, and defaults to
ณ  10. <nLpi> is the lines per inch, and defaults to 6.
ณ 
ณ  Examples:
ณ  ---------
ณ   SL_FILL(10,10,20,20,"50")
ณ    // fills from 10,10 to 20 20 with 50% shading
ณ 
ณ  Notes:
ณ  -------
ณ  Does not send anything to the printer - instead
ณ  returns a control string that you send to the printer. String can be
ณ  sent with ? or ?? or  QOUT() or QQOUT().
ณ 
ณ  For HP and compatible(PCL) Laserjet printers.
ณ 
ณ  Source:
ณ  -------
ณ  S_HPLAS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
Function SL_Fill(nTop,nLeft,nBottom,nRight,cShade,cFill,nCpi,nLpi)
local cReturn := ""
local nRows := nBottom-nTop+1
local nCols := nRight-nLeft+1
local cDotsV,cDotsH
local cFilltype := iif(cShade#nil,"2","3")
cFill  := iif(cFill#nil,cFill,"6")
cShade := iif(cShade#nil,cShade,"20")
nCpi := iif(nCpi==nil,10,nCpi)
nLpi := iif(nLpi==nil,6,nLpi)
cReturn += SL_Goto(nTop,nLeft)
cReturn += chr(27)+"*c"  // area fill
cDotsH  := alltrim(str(SL_InchtoDot(nCols/nCpi)))
cDotsV  := alltrim(str(SL_InchtoDot(nRows/nLpi)))
cReturn += alltrim(cDotsH)+"a"+alltrim(cDotsV)+"b"
if cFillType=="2" //shade
  cReturn += cShade+"g2P"
else
  cReturn += cFill+"g3P"
endif
return cReturn

//-------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SL_HLINE()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SL_HLINE() Draws a horizontal line from row,col to row,endcol
ณ 
ณ  Returns:
ณ  --------
ณ  cCode => control string to send to the printer
ณ 
ณ  Syntax:
ณ  -------
ณ  SL_HLINE(nTop,nLeft,nBottom,nRight,[cShade],[nDPIThick],[nCpi])
ณ 
ณ  Description:
ณ  ------------
ณ  Draws a horizontal line from <nTop,nLeft> to
ณ  <nBottom,nRight>. Based on rows and columns.
ณ 
ณ  [cShade] refers to the density of the line.
ณ 
ณ  The shading percentages are (default "100" - black) :
ณ 
ณ         "1 thru 2" = 2% shade
ณ        "3 thru 10" = 10% shade
ณ       "11 thru 20" = 20% shade
ณ       "21 thru 35" = 30% shade
ณ       "36 thru 55" = 45% shade
ณ       "56 thru 80" = 70% shade
ณ       "81 thru 99" = 90% shade
ณ              "100" = 100% shade
ณ 
ณ  [nDPIThick] is the thickness in DotsPerInch of the
ณ  line. Default is 2.
ณ 
ณ  [nCpi] is the characters per inch, and defaults to 10.
ณ 
ณ  Examples:
ณ  ---------
ณ   ??SL_HLINE(10,10,10,20,"50")  // draws a line 10,10 to 20,20 with
ณ                                 //50%  shading
ณ 
ณ  Notes:
ณ  -------
ณ  Does not send anything to the printer - instead
ณ  returns a control string that you send to the printer. String can be
ณ  sent with ? or ?? or  QOUT() or QQOUT().
ณ 
ณ  For HP and compatible(PCL) Laserjet printers.
ณ 
ณ  Source:
ณ  -------
ณ  S_HPLAS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
Function SL_Hline(nTop,nLeft,nBottom,nRight,cShade,nDPIThick,nCpi)
local cReturn := ""
local nCols := nRight-nLeft+1
local cDotsH
cShade := iif(cShade#nil,cShade,"100")
nCpi := iif(nCpi==nil,10,nCpi)
nDPIThick := iif(nDPIThick==nil,2,nDPIThick)
cReturn += SL_Goto(nTop,nLeft)
cReturn += chr(27)+"*c"  // area fill
cDotsH  := alltrim(str(SL_InchtoDot(nCols/nCpi)))
cReturn += alltrim(cDotsH)+"a"+alltrim(str(nDPIThick))+"b"
cReturn += cShade+"g2P"
return cReturn

//-------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SL_VLINE()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SL_VLINE() Draws a vertical line from row,col to endrow,col
ณ 
ณ  Returns:
ณ  --------
ณ  cCode => control string to send to the printer
ณ 
ณ  Syntax:
ณ  -------
ณ  SL_VLINE(nTop,nLeft,nBottom,nRight,[cShade],[nDPIThick],[nLpi])
ณ 
ณ  Description:
ณ  ------------
ณ  Draws a vertical line from <nTop,nLeft> to <nBottom,nRight>. Based
ณ  on rows and columns.
ณ 
ณ  [cShade] refers to the density of the line.
ณ 
ณ  The shading percentages are (default "100" - black) :
ณ 
ณ         "1 thru 2" = 2% shade
ณ        "3 thru 10" = 10% shade
ณ       "11 thru 20" = 20% shade
ณ       "21 thru 35" = 30% shade
ณ       "36 thru 55" = 45% shade
ณ       "56 thru 80" = 70% shade
ณ       "81 thru 99" = 90% shade
ณ              "100" = 100% shade
ณ 
ณ  [nDPIThick] is the thickness in DotsPerInch of the
ณ  line. Default is 2.
ณ 
ณ  [nLpi] is the lines per inch, and defaults to 6.
ณ 
ณ  Examples:
ณ  ---------
ณ   ??SL_VLINE(10,20,10,10,"50")  // draws a line 10,10 to 20,10 with
ณ                                          // 50% shading
ณ 
ณ  Notes:
ณ  -------
ณ  Does not send anything to the printer - instead
ณ  returns a control string that you send to the printer. String can be
ณ  sent with ? or ?? or  QOUT() or QQOUT().
ณ 
ณ  For HP and compatible(PCL) Laserjet printers.
ณ 
ณ  Source:
ณ  -------
ณ  S_HPLAS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
Function SL_Vline(nTop,nLeft,nBottom,nRight,cShade,nDPIThick,nLpi)
local cReturn := ""
local nRows := nBottom-ntop+1
local cDotsV
cShade := iif(cShade#nil,cShade,"100")
nLpi := iif(nLpi==nil,6,nLpi)
nDPIThick := iif(nDPIThick==nil,2,nDPIThick)
cReturn += SL_Goto(nTop,nLeft)
cReturn += chr(27)+"*c"  // area fill
cDotsV  := alltrim(str(SL_InchtoDot(nRows/nLpi)))
cReturn += alltrim(str(nDPIThick))+"a"+alltrim(cDotsV)+"b"
cReturn += cShade+"g2P"
return cReturn


//-------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SL_BOX()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SL_BOX() Draws a box line from row,col to endrow,endcol
ณ 
ณ  Returns:
ณ  --------
ณ  cCode => control string to send to the printer
ณ 
ณ  Syntax:
ณ  -------
ณ  SL_BOX(nTop,nLeft,nBottom,nRight,[cShade],[nDPIThick],[nCpi],[nLpi])
ณ 
ณ  Description:
ณ  ------------
ณ  Draws a box from nTop,nLeft to nBottom,nRight. Based
ณ  on rows and columns.
ณ 
ณ  [cShade] refers to the density of the line.
ณ 
ณ  The shading percentages are (default "100" - black) :
ณ 
ณ         "1 thru 2" = 2% shade
ณ        "3 thru 10" = 10% shade
ณ       "11 thru 20" = 20% shade
ณ       "21 thru 35" = 30% shade
ณ       "36 thru 55" = 45% shade
ณ       "56 thru 80" = 70% shade
ณ       "81 thru 99" = 90% shade
ณ              "100" = 100% shade
ณ 
ณ  [nDPIThick] is the thickness in DotsPerInch of the
ณ  line. Default is 2.
ณ 
ณ  [nCpi] is the characters per inch, and defaults to 10.
ณ 
ณ  [nLpi] is the lines per inch, and defaults to 6.
ณ 
ณ  Examples:
ณ  ---------
ณ   SL_BOX(10,10,20,20,"50",10)
ณ                     // draws a box 10,10 to 20 20 with 50%
ณ                        //shading and 10 DPI thick
ณ 
ณ  Notes:
ณ  -------
ณ  Does not send anything to the printer - instead
ณ  returns a control string that you send to the printer. String can be
ณ  sent with ? or ?? or  QOUT() or QQOUT().
ณ 
ณ  QOUT() or QQOUT().
ณ 
ณ  For HP and compatible(PCL) Laserjet printers.
ณ 
ณ  Source:
ณ  -------
ณ  S_HPLAS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
Function SL_Box(nTop,nLeft,nBottom,nRight,cShade,nDPIThick,nCpi,nLpi)
local cReturn := ""
local nCols := nRight-nLeft+1
local nRows := nBottom-ntop+1
local cDotsH,nDotsH
local cDotsV,nDotsV
local cDPI,cbottomDots
local cLowerRight
cShade := iif(cShade#nil,cShade,"100")
nCpi := iif(nCpi==nil,10,nCpi)
nLpi := iif(nLpi==nil,6,nLpi)

nDotsH  := SL_InchtoDot(nCols/nCpi)
nDotsV  := SL_InchtoDot(nRows/nLpi)
cDotsH  := alltrim(str(nDotsH))
cDotsV  := alltrim(str(nDotsV))
nDPIThick := iif(nDPIThick==nil,2,nDPIThick)
cDPI  := alltrim(str(nDPIThick))
cBottomDots := alltrim(str(nDotsH+nDPIThick))
//--- top
cReturn += SL_Goto(nTop,nLeft)
cReturn += chr(27)+"*c"  // area fill
cReturn += cDotsH+"a"+cDPI+"b"
cReturn += cShade+"g2P"
//-- left
cReturn += chr(27)+"*c"  // area fill
cReturn += cDPI+"a"+cDotsV+"b"
cReturn += cShade+"g2P"
//--- right
cReturn += SL_MoveH(nDotsH)
cReturn += chr(27)+"*c"  // area fill
cReturn += cDPI+"a"+cDotsV+"b"
cReturn += cShade+"g2P"
//--- bottom
cReturn += SL_MoveH(-nDotsH)
cReturn += SL_MoveV(nDotsV)
cReturn += chr(27)+"*c"  // area fill
cReturn += cBottomDots+"a"+cDPI+"b"
*cReturn += cDotsH+"a"+cDPI+"b"
cReturn += cShade+"g2P"
return cReturn


//-------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SL_WRAP()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SL_WRAP() Sets line wrapping on or off
ณ 
ณ  Returns:
ณ  --------
ณ  cCode => control string to send to the printer
ณ 
ณ  Syntax:
ณ  -------
ณ  SL_WRAP(lSet)
ณ 
ณ  Description:
ณ  ------------
ณ  Sets line wrapping on (.t.) or off (.f.) with <lSet>
ณ 
ณ  Examples:
ณ  ---------
ณ   ?SL_WRAP(.T.)  // set line wrapping on
ณ 
ณ  Notes:
ณ  -------
ณ  Does not send anything to the printer - instead
ณ  returns a control string that you send to the printer. String can be
ณ  sent with ? or ?? or  QOUT() or QQOUT().
ณ 
ณ  For HP and compatible(PCL) Laserjet printers.
ณ 
ณ  Source:
ณ  -------
ณ  S_HPLAS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function SL_Wrap(lWrap)
IF lWrap
  RETURN ( chr(27)+'&s0C' )
ENDIF
RETURN ( chr(27)+'&s1C' )

//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
// Internal
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//----------------------------------------------------
static function SL_Inchtodot(nInches)  // presuming 300 DPI
return 300 * nInches

//----------------------------------------------------
static function SL_MoveH(nDots)
local cPrefix := iif(nDots>0,"+","")
return chr(27)+"*p"+cPrefix+alltrim(str(nDots))+"X"

//----------------------------------------------------
static function SL_MoveV(nDots)
local cPrefix := iif(nDots>0,"+","")
return chr(27)+"*p"+cPrefix+alltrim(str(nDots))+"Y"

