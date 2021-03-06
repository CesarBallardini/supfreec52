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

//±±±±±±±±±±±±±±±±±±±±±
// Job Control
//±±±±±±±±±±±±±±±±±±±±±

//----------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SL_RESET()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SL_RESET() Resets the printer to user defaults
³
³  Returns:
³  --------
³  cCode => control string to send to the printer
³
³  Syntax:
³  -------
³  SL_RESET()
³
³  Description:
³  ------------
³  Resets the printer to user defaults
³
³  Examples:
³  ---------
³   ?SL_RESET()
³
³  Notes:
³  -------
³  Does not send anything to the printer - instead
³  returns a control string that you send to the printer. String can be
³  sent with ? or ?? or  QOUT() or QQOUT().
³ 
³  For HP and compatible(PCL) Laserjet printers.
³ 
³  Source:
³  -------
³  S_HPLAS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
function SL_Reset
return chr(27)+"E"

//-------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SL_COPIES()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SL_COPIES() Sets the laserjet to print n copies of each page
³ 
³  Returns:
³  --------
³  cCode => control string to send to the printer
³ 
³  Syntax:
³  -------
³  SL_COPIES(nCopies)
³ 
³  Description:
³  ------------
³  Sets the laserjet to print <nCopies> copies of each
³  page.
³ 
³  Examples:
³  ---------
³   cCode := SL_COPIES(2)  // prints 2 or each page
³ 
³   ?cCode
³ 
³  Notes:
³  -------
³  Does not send anything to the printer - instead
³  returns a control string that you send to the printer. String can be
³  sent with ? or ?? or  QOUT() or QQOUT().
³ 
³  For HP and compatible(PCL) Laserjet printers.
³ 
³  Source:
³  -------
³  S_HPLAS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
function SL_Copies(nCopies)
RETURN ( chr(27)+'&l'+alltrim(str(nCopies))+'X' )

//±±±±±±±±±±±±±±±±±±±±±
// Page Control
//±±±±±±±±±±±±±±±±±±±±±

//----------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SL_LANDS()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SL_LANDS() Sets laserjet orientation to LANDSCAPE
³ 
³  Returns:
³  --------
³  cCode => control string to send to the printer
³ 
³  Syntax:
³  -------
³  SL_LANDS()
³ 
³  Description:
³  ------------
³  Sets laserjet orientation to LANDSCAPE
³ 
³  Examples:
³  ---------
³   ?SL_LANDS()
³ 
³  Notes:
³  -------
³  Does not send anything to the printer - instead
³  returns a control string that you send to the printer. String can be
³  sent with ? or ?? or  QOUT() or QQOUT().
³ 
³  For HP and compatible(PCL) Laserjet printers.
³ 
³  Source:
³  -------
³  S_HPLAS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
function SL_Lands
return CHR(27) + '&l1O'

//----------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SL_PORT()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SL_PORT() Sets the laserjet orientation to PORTRAIT
³ 
³  Returns:
³  --------
³  cCode => control string to send to the printer
³ 
³  Syntax:
³  -------
³  SL_PORT()
³ 
³  Description:
³  ------------
³  Sets the laserject orientation to PORTRAIT
³ 
³  Examples:
³  ---------
³   cSetup := SL_PORT()
³ 
³   ?cSetup
³ 
³  Notes:
³  -------
³  Does not send anything to the printer - instead
³  returns a control string that you send to the printer. String can be
³  sent with ? or ?? or  QOUT() or QQOUT().
³ 
³  For HP and compatible(PCL) Laserjet printers.
³ 
³  Source:
³  -------
³  S_HPLAS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SL_PAGESIZE()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SL_PAGESIZE() Sets the page size on the laserjet
³ 
³  Returns:
³  --------
³  cCode => control string to send to the printer
³ 
³  Syntax:
³  -------
³  SL_PAGESIZE(nSize)
³ 
³  Description:
³  ------------
³  Sets the page size on the laserjet where <nSize> is
³  one of the following:
³ 
³       1 Executive          (7.25" x 10.5")
³       2 Letter                 (8.5" x 11")
³       3 Legal                  (8.5" x 14")
³      26 A4                     (210mm x 297mm)
³      80 Monarch Envelope   (3 7/8" x 7 1/2")
³      90 COM-10 Envelope    (4 1/8" x 8 1/2")
³      91 International C5   (162mm  x 229mm)
³ 
³  Examples:
³  ---------
³   cCode := SL_PAGESIZE(2)  // letter size
³   ?cCode
³   cCode := SL_PAGESIZE(3)  // legal  size
³   ?cCode
³   cCode := SL_PAGESIZE(26)  // A4 size
³   ?cCode
³ 
³  Notes:
³  -------
³  Does not send anything to the printer - instead
³  returns a control string that you send to the printer. String can be
³  sent with ? or ?? or  QOUT() or QQOUT().
³ 
³  For HP and compatible(PCL) Laserjet printers.
³ 
³  Source:
³  -------
³  S_HPLAS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
function SL_Pagesize(nSize)
nSize := iif(ascan({1,2,3,26,80,81,90,91},nSize)>0,nSize,2)
return CHR(27) + "&l"+alltrim(str(nSize))+"A"

//-------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SL_LEFTMARG()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SL_LEFTMARG() Sets the left margin to the left edge of the
³  specified column
³ 
³  Returns:
³  --------
³  cCode => control string to send to the printer
³ 
³  Syntax:
³  -------
³  SL_LEFTMARG(nColumn)
³ 
³  Description:
³  ------------
³  Sets the left margin to the left edge of the
³  specified column in <nColumn>.
³ 
³  Examples:
³  ---------
³   ?SL_LEFTMARG(3) // sets left margin to column3
³ 
³  Notes:
³  -------
³  Does not send anything to the printer - instead
³  returns a control string that you send to the printer. String can be
³  sent with ? or ?? or  QOUT() or QQOUT().
³ 
³  For HP and compatible(PCL) Laserjet printers.
³ 
³  Source:
³  -------
³  S_HPLAS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
function SL_LeftMarg(nColumn)
RETURN ( chr(27)+'&a'+alltrim(str(nColumn))+'L' )

//-------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SL_RIGHTMARG()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SL_RIGHTMARG() Sets the right margin to the right edge of the
³  specified column
³ 
³  Returns:
³  --------
³  cCode => control string to send to the printer
³ 
³  Syntax:
³  -------
³  SL_RIGHTMARG(nCol)
³ 
³  Description:
³  ------------
³  Sets the right margin to the right edge of the
³  specified column <nCol>
³
³  Examples:
³  ---------
³   ?SL_RIGHTMARG(70) // sets right margin to 70
³ 
³  Notes:
³  -------
³  Does not send anything to the printer - instead
³  returns a control string that you send to the printer. String can be
³  sent with ? or ?? or  QOUT() or QQOUT().
³ 
³  For HP and compatible(PCL) Laserjet printers.
³ 
³  Source:
³  -------
³  S_HPLAS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
function SL_RightMarg(nColumn)
RETURN ( chr(27)+'&a'+alltrim(str(nColumn))+'M' )

//-------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SL_TOPMARG()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SL_TOPMARG() Designates the number of lines of top margin
³ 
³  Returns:
³  --------
³  cCode => control string to send to the printer
³ 
³  Syntax:
³  -------
³  SL_TOPMARG(nLines)
³ 
³  Description:
³  ------------
³  Designates the number of lines of top margin <nLines>
³ 
³  Examples:
³  ---------
³   ?SL_TOPMARG(3) // sets top margin to 3
³ 
³  Notes:
³  -------
³  Does not send anything to the printer - instead
³  returns a control string that you send to the printer. String can be
³  sent with ? or ?? or  QOUT() or QQOUT().
³ 
³  For HP and compatible(PCL) Laserjet printers.
³ 
³  Source:
³  -------
³  S_HPLAS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
*/
function SL_TopMarg(nLines)
RETURN ( chr(27)+'&l'+alltrim(str(nLines))+'E' )

//----------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SL_SETLPI()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SL_SETLPI() Sets the lines per inch for the laserjet
³ 
³  Returns:
³  --------
³  cCode => control string to send to the printer
³ 
³  Syntax:
³  -------
³  SL_SETLPI(nLPI)
³ 
³  Description:
³  ------------
³  Sets the lines per inch for the laserjet to <nLpi>
³  which  can be:
³ 
³  1 - 1 line/inch
³  2 - 2 line/inch
³  3 - 3 line/inch
³  4 - 4 line/inch
³  6 - 6 line/inch
³  8 - 8 line/inch
³  12-12 line/inch
³  16-16 line/inch
³  24-24 line/inch
³  48-48 line/inch
³ 
³  Examples:
³  ---------
³   cCode := SL_SETLPI(6)     // sets LPI to 6 - the default
³ 
³   ?cCode
³ 
³  Notes:
³  -------
³  Does not send anything to the printer - instead
³  returns a control string that you send to the printer. String can be
³  sent with ? or ?? or  QOUT() or QQOUT().
³ 
³  For HP and compatible(PCL) Laserjet printers.
³ 
³  Source:
³  -------
³  S_HPLAS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
function SL_Setlpi(nLpi)
local cLpi := alltrim(str(nLpi))
cLpi := iif(cLpi$"1;2;3;4;6;8;12;16;24;48",cLpi,"6")
return CHR(27) + "&l"+cLpi+"D"

//-------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SL_EJECT()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SL_EJECT() Ejects the current page
³ 
³  Returns:
³  --------
³  cCode => control string to send to the printer
³ 
³  Syntax:
³  -------
³  SL_EJECT()
³ 
³  Description:
³  ------------
³  Ejects the current page
³ 
³  Examples:
³  ---------
³   ?SL_EJECT()
³ 
³  Notes:
³  -------
³  Does not send anything to the printer - instead
³  returns a control string that you send to the printer. String can be
³  sent with ? or ?? or  QOUT() or QQOUT().
³ 
³  QOUT() or QQOUT().
³ 
³  For HP and compatible(PCL) Laserjet printers.
³ 
³  Source:
³  -------
³  S_HPLAS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
function SL_Eject
RETURN ( chr(12) )



//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// Cursor control by Row/Column
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//-------------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SL_GOTO()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SL_GOTO() Move the printer cursor to row/col
³ 
³  Returns:
³  --------
³  cCode => control string to send to the printer
³ 
³  Syntax:
³  -------
³  SL_GOTO(nRow,nCol)
³ 
³  Description:
³  ------------
³  Move print head to row <nRow> and column <nCol>.
³  Actual end position will depend on both LINES PER INCH and
³  CHARACTERS PER INCH settings.
³ 
³  Examples:
³  ---------
³   ?SL_GOTO(10,10)
³ 
³   ??"Hello world"
³ 
³   ?SL_GOTO(9,10)
³ 
³   ??"Attention:"
³ 
³  Notes:
³  -------
³  Does not send anything to the printer - instead
³  returns a control string that you send to the printer. String can be
³  sent with ? or ?? or  QOUT() or QQOUT().
³ 
³  For HP and compatible(PCL) Laserjet printers.
³ 
³  Source:
³  -------
³  S_HPLAS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
*/
function SL_Goto(nRow,nCol)
return chr(27)+"&a"+alltrim(str(nRow))+"r"+alltrim(str(nCol))+"C"

//-------------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SL_DOWNROW()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SL_DOWNROW() Move the printer cursor up/down by # rows,
³  relative to position
³ 
³  Returns:
³  --------
³  cCode => control string to send to the printer
³ 
³  Syntax:
³  -------
³  SL_DOWNROW(nRows)
³ 
³  Description:
³  ------------
³  Move print head down <nRows>. A negative number means
³  move UP.
³ 
³  Actual end position will depend on both LINES PER
³  INCH settings.
³ 
³  Examples:
³  ---------
³   ?SL_DOWNROW(10)
³ 
³   ??"Hello world"
³ 
³   ?SL_DOWNROW(-1)    // moves to prior row
³ 
³   ?SL_OVERCOL(-11)   // and back to starting column
³ 
³   ??"Attention:"
³ 
³  Notes:
³  -------
³  Does not send anything to the printer - instead
³  returns a control string that you send to the printer. String can be
³  sent with ? or ?? or  QOUT() or QQOUT().
³ 
³  For HP and compatible(PCL) Laserjet printers.
³ 
³  Source:
³  -------
³  S_HPLAS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
function SL_DownRow(nRows)
local cPrefix := iif(nRows>0,"+","")
return chr(27)+"&a"+cPrefix+alltrim(str(nRows))+"R"

//-------------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SL_OVERCOL()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SL_OVERCOL() Move the printer cursor right/left # columns
³  relative to position
³ 
³  Returns:
³  --------
³  cCode => control string to send to the printer
³ 
³  Syntax:
³  -------
³  SL_OVERCOL(nColumns)
³
³  Description:
³  ------------
³  Move print head left/right <nColumns>. A negative
³  number means move left, a positive number means move right.
³ 
³  Actual end position will depend on CHARACTERS PER
³  INCH settings.
³ 
³  Examples:
³  ---------
³   ?SL_OVERCOL(10)
³ 
³   ??"Hello world"
³ 
³   ?SL_DOWNROW(-1)    // moves to prior row
³ 
³   ?SL_OVERCOL(-11)   // and back to starting column
³ 
³   ??"Attention:"
³
³  Notes:
³  -------
³  Does not send anything to the printer - instead
³  returns a control string that you send to the printer. String can be
³  sent with ? or ?? or  QOUT() or QQOUT().
³ 
³  For HP and compatible(PCL) Laserjet printers.
³ 
³  Source:
³  -------
³  S_HPLAS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
function SL_OverCol(nCols)
local cPrefix := iif(nCols>0,"+","")
return chr(27)+"&a"+cPrefix+alltrim(str(nCols))+"C"

//-------------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SL_PUSHCURS()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SL_PUSHCURS() Pushes the printer cursor position for later
³  popping
³ 
³  Returns:
³  --------
³  cCode => control string to send to the printer
³ 
³  Syntax:
³  -------
³  SL_PUSHCURS()
³ 
³  Description:
³  ------------
³  Pushes the current printer cursor position for later
³  retrieval (popping) with SL_POPCURS(). Up to 20 positions may be pushed.
³ 
³  Examples:
³  ---------
³   ?SL_PUSHCURS()
³ 
³  Notes:
³  -------
³  Does not send anything to the printer - instead
³  returns a control string that you send to the printer. String can be
³  sent with ? or ?? or  QOUT() or QQOUT().
³ 
³  For HP and compatible(PCL) Laserjet printers.
³ 
³  Source:
³  -------
³  S_HPLAS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
Function SL_PushCurs
return chr(27)+"&f0S"

//-------------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SL_POPCURS()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SL_POPCURS() Pops the printer cursor position for later popping
³ 
³  Returns:
³  --------
³  cCode => control string to send to the printer
³ 
³  Syntax:
³  -------
³  SL_POPCURS()
³ 
³  Description:
³  ------------
³  Pops the current printer cursor position pushed by
³  with SL_PUSHCURS(). Up to 20 positions may be POPed.
³ 
³  Examples:
³  ---------
³   ?SL_POPCURS()
³ 
³  Notes:
³  -------
³  Does not send anything to the printer - instead
³  returns a control string that you send to the printer. String can be
³  sent with ? or ?? or  QOUT() or QQOUT().
³ 
³  For HP and compatible(PCL) Laserjet printers.
³ 
³  Source:
³  -------
³  S_HPLAS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
Function SL_PopCurs
return chr(27)+"&f1S"


//±±±±±±±±±±±±±±±±±±±±±
// Font Selection
//±±±±±±±±±±±±±±±±±±±±±

//-------------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SL_BOLD()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SL_BOLD() Sets font stroke weight to BOLD (ultra black)
³ 
³  Returns:
³  --------
³  cCode => control string to send to the printer
³ 
³  Syntax:
³  -------
³  SL_BOLD()
³ 
³  Description:
³  ------------
³  Sets font stroke weight to BOLD (ultra black)
³ 
³  Examples:
³  ---------
³   ?"Now I am "+SL_BOLD()+"REALLY"+SL_NORMAL()+" mad!"
³ 
³  Notes:
³  -------
³  Does not send anything to the printer - instead
³  returns a control string that you send to the printer. String can be
³  sent with ? or ?? or  QOUT() or QQOUT().
³ 
³  For HP and compatible(PCL) Laserjet printers.
³ 
³  Source:
³  -------
³  S_HPLAS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
function SL_Bold
return chr(27)+"(s7B"

//-------------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SL_NORMAL()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ 
³  Short:
³  ------
³  SL_NORMAL() Sets font stroke weight to NORMAL (non bold)
³ 
³  Returns:
³  --------
³  cCode => control string to send to the printer
³ 
³  Syntax:
³  -------
³  SL_NORMAL()
³ 
³  Description:
³  ------------
³  Sets font stroke weight to NORMAL (non bold)
³ 
³  Examples:
³  ---------
³   ?"Now I am "+SL_NORMAL()+"REALLY"+SL_NORMAL()+" mad!"
³ 
³  Notes:
³  -------
³  Does not send anything to the printer - instead
³  returns a control string that you send to the printer. String can be
³  sent with ? or ?? or  QOUT() or QQOUT().
³ 
³  For HP and compatible(PCL) Laserjet printers.
³ 
³  Source:
³  -------
³  S_HPLAS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
function SL_Normal
return chr(27)+"(s0B"

//-------------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SL_UNDER()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SL_UNDER() Sets automatic text underlining on
³ 
³  Returns:
³  --------
³  cCode => control string to send to the printer
³ 
³  Syntax:
³  -------
³  SL_UNDER()
³ 
³  Description:
³  ------------
³  Sets automatic text underlining on
³
³  Examples:
³  ---------
³   ?"Now I am "+SL_UNDER()+"REALLY"+SL_UNDEROFF()+" mad!"
³ 
³  Notes:
³  -------
³  Does not send anything to the printer - instead
³  returns a control string that you send to the printer. String can be
³  sent with ? or ?? or  QOUT() or QQOUT().
³ 
³  For HP and compatible(PCL) Laserjet printers.
³ 
³  Source:
³  -------
³  S_HPLAS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
function SL_Under
return chr(27)+"&d0D"

//-------------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SL_UNDEROFF()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SL_UNDEROFF() Sets automatic text underlining off
³ 
³  Returns:
³  --------
³  cCode => control string to send to the printer
³ 
³  Syntax:
³  -------
³  SL_UNDEROFF()
³ 
³  Description:
³  ------------
³  Sets automatic text underlining off
³ 
³  Examples:
³  ---------
³   ?"Now I am "+SL_UNDER()+"REALLY"+SL_UNDEROFF()+" mad!"
³ 
³  Notes:
³  -------
³  Does not send anything to the printer - instead
³  returns a control string that you send to the printer. String can be
³  sent with ? or ?? or  QOUT() or QQOUT().
³ 
³  For HP and compatible(PCL) Laserjet printers.
³ 
³  Source:
³  -------
³  S_HPLAS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
function SL_UnderOff
return chr(27)+"&d@"

//-------------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SL_ITALIC()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SL_ITALIC() Sets font style to italic
³ 
³  Returns:
³  --------
³  cCode => control string to send to the printer
³ 
³  Syntax:
³  -------
³  SL_ITALIC()
³ 
³  Description:
³  ------------
³  Sets font style to italic
³ 
³  Examples:
³  ---------
³   ?"Now I am "+SL_ITALIC()+"REALLY"+SL_ITALICOFF()+" mad!"
³ 
³  Notes:
³  -------
³  Does not send anything to the printer - instead
³  returns a control string that you send to the printer. String can be
³  sent with ? or ?? or  QOUT() or QQOUT().
³ 
³  For HP and compatible(PCL) Laserjet printers.
³ 
³  Source:
³  -------
³  S_HPLAS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
Function SL_Italic
return chr(27)+"(s1S"

//-------------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SL_ITALICOFF()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SL_ITALICOFF() Sets font style to upright (non italic)
³ 
³  Returns:
³  --------
³  cCode => control string to send to the printer
³ 
³  Syntax:
³  -------
³  SL_ITALICOFF()
³ 
³  Description:
³  ------------
³  Sets font style to upright( non italic)
³ 
³  Examples:
³  ---------
³   ?"Now I am "+SL_ITALIC()+"REALLY"+SL_ITALICOFF()+" mad!"
³ 
³  Notes:
³  -------
³  Does not send anything to the printer - instead
³  returns a control string that you send to the printer. String can be
³  sent with ? or ?? or  QOUT() or QQOUT().
³ 
³  For HP and compatible(PCL) Laserjet printers.
³ 
³  Source:
³  -------
³  S_HPLAS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
Function SL_ItalicOff
return chr(27)+"(s0S"

//----------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SL_SETCPI()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SL_SETCPI() Sets characters per inch
³ 
³  Returns:
³  --------
³  cCode => control string to send to the printer
³ 
³  Syntax:
³  -------
³  SL_SETCPI(nCPI)
³ 
³  Description:
³  ------------
³  Sets characters per inch to <nCpi>  - valid to 2
³  decimal places. Current font must support this CPI.
³ 
³  Examples:
³  ---------
³   ?SL_SETCPI(16.66)   // sets to compressed
³ 
³   ?SL_SETCPI(12)     // sets to 12 cpi
³ 
³   ?SL_SETCPI(10)     // sets to 10 cpi  (default)
³ 
³  Notes:
³  -------
³  Does not send anything to the printer - instead
³  returns a control string that you send to the printer. String can be
³  sent with ? or ?? or  QOUT() or QQOUT().
³ 
³  For HP and compatible(PCL) Laserjet printers.
³ 
³  Source:
³  -------
³  S_HPLAS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
function SL_Setcpi(nCpi)
local cCpi := alltrim(str( iif(nCpi#nil,Round(nCpi,2),10) ))
return CHR(27) + "(s"+cCpi+"H"



//±±±±±±±±±±±±±±±±±±±±±±±
// Drawing by Row/Column
//±±±±±±±±±±±±±±±±±±±±±±±

//----------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SL_FILL()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SL_FILL() Fills a rectangle with shading or a pattern.
³ 
³  Returns:
³  --------
³  cCode => control string to send to the printer
³ 
³  Syntax:
³  -------
³  SL_FILL(nTop,nLeft,nBottom,nRight,[cShade],[cFill],[nCpi],[nLpi])
³ 
³  Description:
³  ------------
³  Fills a rectangle based on rows and columns at
³  <nTop,nLeft> to <nBottom,nRight>. The area may be shaded
³  [cShade] or filled with a pattern [cFill] :
³ 
³  The shading percentages are (default "20") :
³ 
³         "1 thru 2" = 2% shade
³        "3 thru 10" = 10% shade
³       "11 thru 20" = 20% shade
³       "21 thru 35" = 30% shade
³       "36 thru 55" = 45% shade
³       "56 thru 80" = 70% shade
³       "81 thru 99" = 90% shade
³              "100" = 100% shade
³ 
³  The pattern fills are (default "6"):
³ 
³       "1" = horizontal lines
³       "2" = vertical lines
³       "3" = diagonal lines top right to bottom left
³       "4" = diagonal lines top left to bottom right
³       "5" = #1 and # 2 combined
³       "6" = #3 and # 4 combined
³ 
³  <nCpi> is the characters per inch, and defaults to
³  10. <nLpi> is the lines per inch, and defaults to 6.
³ 
³  Examples:
³  ---------
³   SL_FILL(10,10,20,20,"50")
³    // fills from 10,10 to 20 20 with 50% shading
³ 
³  Notes:
³  -------
³  Does not send anything to the printer - instead
³  returns a control string that you send to the printer. String can be
³  sent with ? or ?? or  QOUT() or QQOUT().
³ 
³  For HP and compatible(PCL) Laserjet printers.
³ 
³  Source:
³  -------
³  S_HPLAS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SL_HLINE()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SL_HLINE() Draws a horizontal line from row,col to row,endcol
³ 
³  Returns:
³  --------
³  cCode => control string to send to the printer
³ 
³  Syntax:
³  -------
³  SL_HLINE(nTop,nLeft,nBottom,nRight,[cShade],[nDPIThick],[nCpi])
³ 
³  Description:
³  ------------
³  Draws a horizontal line from <nTop,nLeft> to
³  <nBottom,nRight>. Based on rows and columns.
³ 
³  [cShade] refers to the density of the line.
³ 
³  The shading percentages are (default "100" - black) :
³ 
³         "1 thru 2" = 2% shade
³        "3 thru 10" = 10% shade
³       "11 thru 20" = 20% shade
³       "21 thru 35" = 30% shade
³       "36 thru 55" = 45% shade
³       "56 thru 80" = 70% shade
³       "81 thru 99" = 90% shade
³              "100" = 100% shade
³ 
³  [nDPIThick] is the thickness in DotsPerInch of the
³  line. Default is 2.
³ 
³  [nCpi] is the characters per inch, and defaults to 10.
³ 
³  Examples:
³  ---------
³   ??SL_HLINE(10,10,10,20,"50")  // draws a line 10,10 to 20,20 with
³                                 //50%  shading
³ 
³  Notes:
³  -------
³  Does not send anything to the printer - instead
³  returns a control string that you send to the printer. String can be
³  sent with ? or ?? or  QOUT() or QQOUT().
³ 
³  For HP and compatible(PCL) Laserjet printers.
³ 
³  Source:
³  -------
³  S_HPLAS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SL_VLINE()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SL_VLINE() Draws a vertical line from row,col to endrow,col
³ 
³  Returns:
³  --------
³  cCode => control string to send to the printer
³ 
³  Syntax:
³  -------
³  SL_VLINE(nTop,nLeft,nBottom,nRight,[cShade],[nDPIThick],[nLpi])
³ 
³  Description:
³  ------------
³  Draws a vertical line from <nTop,nLeft> to <nBottom,nRight>. Based
³  on rows and columns.
³ 
³  [cShade] refers to the density of the line.
³ 
³  The shading percentages are (default "100" - black) :
³ 
³         "1 thru 2" = 2% shade
³        "3 thru 10" = 10% shade
³       "11 thru 20" = 20% shade
³       "21 thru 35" = 30% shade
³       "36 thru 55" = 45% shade
³       "56 thru 80" = 70% shade
³       "81 thru 99" = 90% shade
³              "100" = 100% shade
³ 
³  [nDPIThick] is the thickness in DotsPerInch of the
³  line. Default is 2.
³ 
³  [nLpi] is the lines per inch, and defaults to 6.
³ 
³  Examples:
³  ---------
³   ??SL_VLINE(10,20,10,10,"50")  // draws a line 10,10 to 20,10 with
³                                          // 50% shading
³ 
³  Notes:
³  -------
³  Does not send anything to the printer - instead
³  returns a control string that you send to the printer. String can be
³  sent with ? or ?? or  QOUT() or QQOUT().
³ 
³  For HP and compatible(PCL) Laserjet printers.
³ 
³  Source:
³  -------
³  S_HPLAS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SL_BOX()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SL_BOX() Draws a box line from row,col to endrow,endcol
³ 
³  Returns:
³  --------
³  cCode => control string to send to the printer
³ 
³  Syntax:
³  -------
³  SL_BOX(nTop,nLeft,nBottom,nRight,[cShade],[nDPIThick],[nCpi],[nLpi])
³ 
³  Description:
³  ------------
³  Draws a box from nTop,nLeft to nBottom,nRight. Based
³  on rows and columns.
³ 
³  [cShade] refers to the density of the line.
³ 
³  The shading percentages are (default "100" - black) :
³ 
³         "1 thru 2" = 2% shade
³        "3 thru 10" = 10% shade
³       "11 thru 20" = 20% shade
³       "21 thru 35" = 30% shade
³       "36 thru 55" = 45% shade
³       "56 thru 80" = 70% shade
³       "81 thru 99" = 90% shade
³              "100" = 100% shade
³ 
³  [nDPIThick] is the thickness in DotsPerInch of the
³  line. Default is 2.
³ 
³  [nCpi] is the characters per inch, and defaults to 10.
³ 
³  [nLpi] is the lines per inch, and defaults to 6.
³ 
³  Examples:
³  ---------
³   SL_BOX(10,10,20,20,"50",10)
³                     // draws a box 10,10 to 20 20 with 50%
³                        //shading and 10 DPI thick
³ 
³  Notes:
³  -------
³  Does not send anything to the printer - instead
³  returns a control string that you send to the printer. String can be
³  sent with ? or ?? or  QOUT() or QQOUT().
³ 
³  QOUT() or QQOUT().
³ 
³  For HP and compatible(PCL) Laserjet printers.
³ 
³  Source:
³  -------
³  S_HPLAS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SL_WRAP()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SL_WRAP() Sets line wrapping on or off
³ 
³  Returns:
³  --------
³  cCode => control string to send to the printer
³ 
³  Syntax:
³  -------
³  SL_WRAP(lSet)
³ 
³  Description:
³  ------------
³  Sets line wrapping on (.t.) or off (.f.) with <lSet>
³ 
³  Examples:
³  ---------
³   ?SL_WRAP(.T.)  // set line wrapping on
³ 
³  Notes:
³  -------
³  Does not send anything to the printer - instead
³  returns a control string that you send to the printer. String can be
³  sent with ? or ?? or  QOUT() or QQOUT().
³ 
³  For HP and compatible(PCL) Laserjet printers.
³ 
³  Source:
³  -------
³  S_HPLAS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
function SL_Wrap(lWrap)
IF lWrap
  RETURN ( chr(27)+'&s0C' )
ENDIF
RETURN ( chr(27)+'&s1C' )

//±±±±±±±±±±±±±±±±±±±±±
// Internal
//±±±±±±±±±±±±±±±±±±±±±
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

