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

//���������������������
// Job Control
//���������������������

//----------------------------------------------------
/*
�����������������������������������������������������������������
� FUNCTION SL_RESET()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SL_RESET() Resets the printer to user defaults
�
�  Returns:
�  --------
�  cCode => control string to send to the printer
�
�  Syntax:
�  -------
�  SL_RESET()
�
�  Description:
�  ------------
�  Resets the printer to user defaults
�
�  Examples:
�  ---------
�   ?SL_RESET()
�
�  Notes:
�  -------
�  Does not send anything to the printer - instead
�  returns a control string that you send to the printer. String can be
�  sent with ? or ?? or  QOUT() or QQOUT().
� 
�  For HP and compatible(PCL) Laserjet printers.
� 
�  Source:
�  -------
�  S_HPLAS.PRG
� 
����������������������������������������������������������������� 
*/
function SL_Reset
return chr(27)+"E"

//-------------------------------------------------------
/*
�����������������������������������������������������������������
� FUNCTION SL_COPIES()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SL_COPIES() Sets the laserjet to print n copies of each page
� 
�  Returns:
�  --------
�  cCode => control string to send to the printer
� 
�  Syntax:
�  -------
�  SL_COPIES(nCopies)
� 
�  Description:
�  ------------
�  Sets the laserjet to print <nCopies> copies of each
�  page.
� 
�  Examples:
�  ---------
�   cCode := SL_COPIES(2)  // prints 2 or each page
� 
�   ?cCode
� 
�  Notes:
�  -------
�  Does not send anything to the printer - instead
�  returns a control string that you send to the printer. String can be
�  sent with ? or ?? or  QOUT() or QQOUT().
� 
�  For HP and compatible(PCL) Laserjet printers.
� 
�  Source:
�  -------
�  S_HPLAS.PRG
� 
����������������������������������������������������������������� 
*/
function SL_Copies(nCopies)
RETURN ( chr(27)+'&l'+alltrim(str(nCopies))+'X' )

//���������������������
// Page Control
//���������������������

//----------------------------------------------------
/*
�����������������������������������������������������������������
� FUNCTION SL_LANDS()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SL_LANDS() Sets laserjet orientation to LANDSCAPE
� 
�  Returns:
�  --------
�  cCode => control string to send to the printer
� 
�  Syntax:
�  -------
�  SL_LANDS()
� 
�  Description:
�  ------------
�  Sets laserjet orientation to LANDSCAPE
� 
�  Examples:
�  ---------
�   ?SL_LANDS()
� 
�  Notes:
�  -------
�  Does not send anything to the printer - instead
�  returns a control string that you send to the printer. String can be
�  sent with ? or ?? or  QOUT() or QQOUT().
� 
�  For HP and compatible(PCL) Laserjet printers.
� 
�  Source:
�  -------
�  S_HPLAS.PRG
� 
����������������������������������������������������������������� 
*/
function SL_Lands
return CHR(27) + '&l1O'

//----------------------------------------------------
/*
�����������������������������������������������������������������
� FUNCTION SL_PORT()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SL_PORT() Sets the laserjet orientation to PORTRAIT
� 
�  Returns:
�  --------
�  cCode => control string to send to the printer
� 
�  Syntax:
�  -------
�  SL_PORT()
� 
�  Description:
�  ------------
�  Sets the laserject orientation to PORTRAIT
� 
�  Examples:
�  ---------
�   cSetup := SL_PORT()
� 
�   ?cSetup
� 
�  Notes:
�  -------
�  Does not send anything to the printer - instead
�  returns a control string that you send to the printer. String can be
�  sent with ? or ?? or  QOUT() or QQOUT().
� 
�  For HP and compatible(PCL) Laserjet printers.
� 
�  Source:
�  -------
�  S_HPLAS.PRG
� 
����������������������������������������������������������������� 
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
�����������������������������������������������������������������
� FUNCTION SL_PAGESIZE()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SL_PAGESIZE() Sets the page size on the laserjet
� 
�  Returns:
�  --------
�  cCode => control string to send to the printer
� 
�  Syntax:
�  -------
�  SL_PAGESIZE(nSize)
� 
�  Description:
�  ------------
�  Sets the page size on the laserjet where <nSize> is
�  one of the following:
� 
�       1 Executive          (7.25" x 10.5")
�       2 Letter                 (8.5" x 11")
�       3 Legal                  (8.5" x 14")
�      26 A4                     (210mm x 297mm)
�      80 Monarch Envelope   (3 7/8" x 7 1/2")
�      90 COM-10 Envelope    (4 1/8" x 8 1/2")
�      91 International C5   (162mm  x 229mm)
� 
�  Examples:
�  ---------
�   cCode := SL_PAGESIZE(2)  // letter size
�   ?cCode
�   cCode := SL_PAGESIZE(3)  // legal  size
�   ?cCode
�   cCode := SL_PAGESIZE(26)  // A4 size
�   ?cCode
� 
�  Notes:
�  -------
�  Does not send anything to the printer - instead
�  returns a control string that you send to the printer. String can be
�  sent with ? or ?? or  QOUT() or QQOUT().
� 
�  For HP and compatible(PCL) Laserjet printers.
� 
�  Source:
�  -------
�  S_HPLAS.PRG
� 
����������������������������������������������������������������� 
*/
function SL_Pagesize(nSize)
nSize := iif(ascan({1,2,3,26,80,81,90,91},nSize)>0,nSize,2)
return CHR(27) + "&l"+alltrim(str(nSize))+"A"

//-------------------------------------------------------
/*
�����������������������������������������������������������������
� FUNCTION SL_LEFTMARG()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SL_LEFTMARG() Sets the left margin to the left edge of the
�  specified column
� 
�  Returns:
�  --------
�  cCode => control string to send to the printer
� 
�  Syntax:
�  -------
�  SL_LEFTMARG(nColumn)
� 
�  Description:
�  ------------
�  Sets the left margin to the left edge of the
�  specified column in <nColumn>.
� 
�  Examples:
�  ---------
�   ?SL_LEFTMARG(3) // sets left margin to column3
� 
�  Notes:
�  -------
�  Does not send anything to the printer - instead
�  returns a control string that you send to the printer. String can be
�  sent with ? or ?? or  QOUT() or QQOUT().
� 
�  For HP and compatible(PCL) Laserjet printers.
� 
�  Source:
�  -------
�  S_HPLAS.PRG
� 
����������������������������������������������������������������� 
*/
function SL_LeftMarg(nColumn)
RETURN ( chr(27)+'&a'+alltrim(str(nColumn))+'L' )

//-------------------------------------------------------
/*
�����������������������������������������������������������������
� FUNCTION SL_RIGHTMARG()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SL_RIGHTMARG() Sets the right margin to the right edge of the
�  specified column
� 
�  Returns:
�  --------
�  cCode => control string to send to the printer
� 
�  Syntax:
�  -------
�  SL_RIGHTMARG(nCol)
� 
�  Description:
�  ------------
�  Sets the right margin to the right edge of the
�  specified column <nCol>
�
�  Examples:
�  ---------
�   ?SL_RIGHTMARG(70) // sets right margin to 70
� 
�  Notes:
�  -------
�  Does not send anything to the printer - instead
�  returns a control string that you send to the printer. String can be
�  sent with ? or ?? or  QOUT() or QQOUT().
� 
�  For HP and compatible(PCL) Laserjet printers.
� 
�  Source:
�  -------
�  S_HPLAS.PRG
� 
����������������������������������������������������������������� 
*/
function SL_RightMarg(nColumn)
RETURN ( chr(27)+'&a'+alltrim(str(nColumn))+'M' )

//-------------------------------------------------------
/*
�����������������������������������������������������������������
� FUNCTION SL_TOPMARG()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SL_TOPMARG() Designates the number of lines of top margin
� 
�  Returns:
�  --------
�  cCode => control string to send to the printer
� 
�  Syntax:
�  -------
�  SL_TOPMARG(nLines)
� 
�  Description:
�  ------------
�  Designates the number of lines of top margin <nLines>
� 
�  Examples:
�  ---------
�   ?SL_TOPMARG(3) // sets top margin to 3
� 
�  Notes:
�  -------
�  Does not send anything to the printer - instead
�  returns a control string that you send to the printer. String can be
�  sent with ? or ?? or  QOUT() or QQOUT().
� 
�  For HP and compatible(PCL) Laserjet printers.
� 
�  Source:
�  -------
�  S_HPLAS.PRG
� 
�����������������������������������������������������������������
*/
function SL_TopMarg(nLines)
RETURN ( chr(27)+'&l'+alltrim(str(nLines))+'E' )

//----------------------------------------------------
/*
�����������������������������������������������������������������
� FUNCTION SL_SETLPI()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SL_SETLPI() Sets the lines per inch for the laserjet
� 
�  Returns:
�  --------
�  cCode => control string to send to the printer
� 
�  Syntax:
�  -------
�  SL_SETLPI(nLPI)
� 
�  Description:
�  ------------
�  Sets the lines per inch for the laserjet to <nLpi>
�  which  can be:
� 
�  1 - 1 line/inch
�  2 - 2 line/inch
�  3 - 3 line/inch
�  4 - 4 line/inch
�  6 - 6 line/inch
�  8 - 8 line/inch
�  12-12 line/inch
�  16-16 line/inch
�  24-24 line/inch
�  48-48 line/inch
� 
�  Examples:
�  ---------
�   cCode := SL_SETLPI(6)     // sets LPI to 6 - the default
� 
�   ?cCode
� 
�  Notes:
�  -------
�  Does not send anything to the printer - instead
�  returns a control string that you send to the printer. String can be
�  sent with ? or ?? or  QOUT() or QQOUT().
� 
�  For HP and compatible(PCL) Laserjet printers.
� 
�  Source:
�  -------
�  S_HPLAS.PRG
� 
����������������������������������������������������������������� 
*/
function SL_Setlpi(nLpi)
local cLpi := alltrim(str(nLpi))
cLpi := iif(cLpi$"1;2;3;4;6;8;12;16;24;48",cLpi,"6")
return CHR(27) + "&l"+cLpi+"D"

//-------------------------------------------------------
/*
�����������������������������������������������������������������
� FUNCTION SL_EJECT()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SL_EJECT() Ejects the current page
� 
�  Returns:
�  --------
�  cCode => control string to send to the printer
� 
�  Syntax:
�  -------
�  SL_EJECT()
� 
�  Description:
�  ------------
�  Ejects the current page
� 
�  Examples:
�  ---------
�   ?SL_EJECT()
� 
�  Notes:
�  -------
�  Does not send anything to the printer - instead
�  returns a control string that you send to the printer. String can be
�  sent with ? or ?? or  QOUT() or QQOUT().
� 
�  QOUT() or QQOUT().
� 
�  For HP and compatible(PCL) Laserjet printers.
� 
�  Source:
�  -------
�  S_HPLAS.PRG
� 
����������������������������������������������������������������� 
*/
function SL_Eject
RETURN ( chr(12) )



//�����������������������������
// Cursor control by Row/Column
//�����������������������������
//-------------------------------------------------------------
/*
�����������������������������������������������������������������
� FUNCTION SL_GOTO()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SL_GOTO() Move the printer cursor to row/col
� 
�  Returns:
�  --------
�  cCode => control string to send to the printer
� 
�  Syntax:
�  -------
�  SL_GOTO(nRow,nCol)
� 
�  Description:
�  ------------
�  Move print head to row <nRow> and column <nCol>.
�  Actual end position will depend on both LINES PER INCH and
�  CHARACTERS PER INCH settings.
� 
�  Examples:
�  ---------
�   ?SL_GOTO(10,10)
� 
�   ??"Hello world"
� 
�   ?SL_GOTO(9,10)
� 
�   ??"Attention:"
� 
�  Notes:
�  -------
�  Does not send anything to the printer - instead
�  returns a control string that you send to the printer. String can be
�  sent with ? or ?? or  QOUT() or QQOUT().
� 
�  For HP and compatible(PCL) Laserjet printers.
� 
�  Source:
�  -------
�  S_HPLAS.PRG
� 
�����������������������������������������������������������������
*/
function SL_Goto(nRow,nCol)
return chr(27)+"&a"+alltrim(str(nRow))+"r"+alltrim(str(nCol))+"C"

//-------------------------------------------------------------
/*
�����������������������������������������������������������������
� FUNCTION SL_DOWNROW()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SL_DOWNROW() Move the printer cursor up/down by # rows,
�  relative to position
� 
�  Returns:
�  --------
�  cCode => control string to send to the printer
� 
�  Syntax:
�  -------
�  SL_DOWNROW(nRows)
� 
�  Description:
�  ------------
�  Move print head down <nRows>. A negative number means
�  move UP.
� 
�  Actual end position will depend on both LINES PER
�  INCH settings.
� 
�  Examples:
�  ---------
�   ?SL_DOWNROW(10)
� 
�   ??"Hello world"
� 
�   ?SL_DOWNROW(-1)    // moves to prior row
� 
�   ?SL_OVERCOL(-11)   // and back to starting column
� 
�   ??"Attention:"
� 
�  Notes:
�  -------
�  Does not send anything to the printer - instead
�  returns a control string that you send to the printer. String can be
�  sent with ? or ?? or  QOUT() or QQOUT().
� 
�  For HP and compatible(PCL) Laserjet printers.
� 
�  Source:
�  -------
�  S_HPLAS.PRG
� 
����������������������������������������������������������������� 
*/
function SL_DownRow(nRows)
local cPrefix := iif(nRows>0,"+","")
return chr(27)+"&a"+cPrefix+alltrim(str(nRows))+"R"

//-------------------------------------------------------------
/*
�����������������������������������������������������������������
� FUNCTION SL_OVERCOL()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SL_OVERCOL() Move the printer cursor right/left # columns
�  relative to position
� 
�  Returns:
�  --------
�  cCode => control string to send to the printer
� 
�  Syntax:
�  -------
�  SL_OVERCOL(nColumns)
�
�  Description:
�  ------------
�  Move print head left/right <nColumns>. A negative
�  number means move left, a positive number means move right.
� 
�  Actual end position will depend on CHARACTERS PER
�  INCH settings.
� 
�  Examples:
�  ---------
�   ?SL_OVERCOL(10)
� 
�   ??"Hello world"
� 
�   ?SL_DOWNROW(-1)    // moves to prior row
� 
�   ?SL_OVERCOL(-11)   // and back to starting column
� 
�   ??"Attention:"
�
�  Notes:
�  -------
�  Does not send anything to the printer - instead
�  returns a control string that you send to the printer. String can be
�  sent with ? or ?? or  QOUT() or QQOUT().
� 
�  For HP and compatible(PCL) Laserjet printers.
� 
�  Source:
�  -------
�  S_HPLAS.PRG
� 
����������������������������������������������������������������� 
*/
function SL_OverCol(nCols)
local cPrefix := iif(nCols>0,"+","")
return chr(27)+"&a"+cPrefix+alltrim(str(nCols))+"C"

//-------------------------------------------------------------
/*
�����������������������������������������������������������������
� FUNCTION SL_PUSHCURS()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SL_PUSHCURS() Pushes the printer cursor position for later
�  popping
� 
�  Returns:
�  --------
�  cCode => control string to send to the printer
� 
�  Syntax:
�  -------
�  SL_PUSHCURS()
� 
�  Description:
�  ------------
�  Pushes the current printer cursor position for later
�  retrieval (popping) with SL_POPCURS(). Up to 20 positions may be pushed.
� 
�  Examples:
�  ---------
�   ?SL_PUSHCURS()
� 
�  Notes:
�  -------
�  Does not send anything to the printer - instead
�  returns a control string that you send to the printer. String can be
�  sent with ? or ?? or  QOUT() or QQOUT().
� 
�  For HP and compatible(PCL) Laserjet printers.
� 
�  Source:
�  -------
�  S_HPLAS.PRG
� 
����������������������������������������������������������������� 
*/
Function SL_PushCurs
return chr(27)+"&f0S"

//-------------------------------------------------------------
/*
�����������������������������������������������������������������
� FUNCTION SL_POPCURS()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SL_POPCURS() Pops the printer cursor position for later popping
� 
�  Returns:
�  --------
�  cCode => control string to send to the printer
� 
�  Syntax:
�  -------
�  SL_POPCURS()
� 
�  Description:
�  ------------
�  Pops the current printer cursor position pushed by
�  with SL_PUSHCURS(). Up to 20 positions may be POPed.
� 
�  Examples:
�  ---------
�   ?SL_POPCURS()
� 
�  Notes:
�  -------
�  Does not send anything to the printer - instead
�  returns a control string that you send to the printer. String can be
�  sent with ? or ?? or  QOUT() or QQOUT().
� 
�  For HP and compatible(PCL) Laserjet printers.
� 
�  Source:
�  -------
�  S_HPLAS.PRG
� 
����������������������������������������������������������������� 
*/
Function SL_PopCurs
return chr(27)+"&f1S"


//���������������������
// Font Selection
//���������������������

//-------------------------------------------------------------
/*
�����������������������������������������������������������������
� FUNCTION SL_BOLD()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SL_BOLD() Sets font stroke weight to BOLD (ultra black)
� 
�  Returns:
�  --------
�  cCode => control string to send to the printer
� 
�  Syntax:
�  -------
�  SL_BOLD()
� 
�  Description:
�  ------------
�  Sets font stroke weight to BOLD (ultra black)
� 
�  Examples:
�  ---------
�   ?"Now I am "+SL_BOLD()+"REALLY"+SL_NORMAL()+" mad!"
� 
�  Notes:
�  -------
�  Does not send anything to the printer - instead
�  returns a control string that you send to the printer. String can be
�  sent with ? or ?? or  QOUT() or QQOUT().
� 
�  For HP and compatible(PCL) Laserjet printers.
� 
�  Source:
�  -------
�  S_HPLAS.PRG
� 
����������������������������������������������������������������� 
*/
function SL_Bold
return chr(27)+"(s7B"

//-------------------------------------------------------------
/*
�����������������������������������������������������������������
� FUNCTION SL_NORMAL()
�����������������������������������������������������������������
� 
�  Short:
�  ------
�  SL_NORMAL() Sets font stroke weight to NORMAL (non bold)
� 
�  Returns:
�  --------
�  cCode => control string to send to the printer
� 
�  Syntax:
�  -------
�  SL_NORMAL()
� 
�  Description:
�  ------------
�  Sets font stroke weight to NORMAL (non bold)
� 
�  Examples:
�  ---------
�   ?"Now I am "+SL_NORMAL()+"REALLY"+SL_NORMAL()+" mad!"
� 
�  Notes:
�  -------
�  Does not send anything to the printer - instead
�  returns a control string that you send to the printer. String can be
�  sent with ? or ?? or  QOUT() or QQOUT().
� 
�  For HP and compatible(PCL) Laserjet printers.
� 
�  Source:
�  -------
�  S_HPLAS.PRG
� 
����������������������������������������������������������������� 
*/
function SL_Normal
return chr(27)+"(s0B"

//-------------------------------------------------------------
/*
�����������������������������������������������������������������
� FUNCTION SL_UNDER()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SL_UNDER() Sets automatic text underlining on
� 
�  Returns:
�  --------
�  cCode => control string to send to the printer
� 
�  Syntax:
�  -------
�  SL_UNDER()
� 
�  Description:
�  ------------
�  Sets automatic text underlining on
�
�  Examples:
�  ---------
�   ?"Now I am "+SL_UNDER()+"REALLY"+SL_UNDEROFF()+" mad!"
� 
�  Notes:
�  -------
�  Does not send anything to the printer - instead
�  returns a control string that you send to the printer. String can be
�  sent with ? or ?? or  QOUT() or QQOUT().
� 
�  For HP and compatible(PCL) Laserjet printers.
� 
�  Source:
�  -------
�  S_HPLAS.PRG
� 
����������������������������������������������������������������� 
*/
function SL_Under
return chr(27)+"&d0D"

//-------------------------------------------------------------
/*
�����������������������������������������������������������������
� FUNCTION SL_UNDEROFF()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SL_UNDEROFF() Sets automatic text underlining off
� 
�  Returns:
�  --------
�  cCode => control string to send to the printer
� 
�  Syntax:
�  -------
�  SL_UNDEROFF()
� 
�  Description:
�  ------------
�  Sets automatic text underlining off
� 
�  Examples:
�  ---------
�   ?"Now I am "+SL_UNDER()+"REALLY"+SL_UNDEROFF()+" mad!"
� 
�  Notes:
�  -------
�  Does not send anything to the printer - instead
�  returns a control string that you send to the printer. String can be
�  sent with ? or ?? or  QOUT() or QQOUT().
� 
�  For HP and compatible(PCL) Laserjet printers.
� 
�  Source:
�  -------
�  S_HPLAS.PRG
� 
����������������������������������������������������������������� 
*/
function SL_UnderOff
return chr(27)+"&d@"

//-------------------------------------------------------------
/*
�����������������������������������������������������������������
� FUNCTION SL_ITALIC()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SL_ITALIC() Sets font style to italic
� 
�  Returns:
�  --------
�  cCode => control string to send to the printer
� 
�  Syntax:
�  -------
�  SL_ITALIC()
� 
�  Description:
�  ------------
�  Sets font style to italic
� 
�  Examples:
�  ---------
�   ?"Now I am "+SL_ITALIC()+"REALLY"+SL_ITALICOFF()+" mad!"
� 
�  Notes:
�  -------
�  Does not send anything to the printer - instead
�  returns a control string that you send to the printer. String can be
�  sent with ? or ?? or  QOUT() or QQOUT().
� 
�  For HP and compatible(PCL) Laserjet printers.
� 
�  Source:
�  -------
�  S_HPLAS.PRG
� 
����������������������������������������������������������������� 
*/
Function SL_Italic
return chr(27)+"(s1S"

//-------------------------------------------------------------
/*
�����������������������������������������������������������������
� FUNCTION SL_ITALICOFF()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SL_ITALICOFF() Sets font style to upright (non italic)
� 
�  Returns:
�  --------
�  cCode => control string to send to the printer
� 
�  Syntax:
�  -------
�  SL_ITALICOFF()
� 
�  Description:
�  ------------
�  Sets font style to upright( non italic)
� 
�  Examples:
�  ---------
�   ?"Now I am "+SL_ITALIC()+"REALLY"+SL_ITALICOFF()+" mad!"
� 
�  Notes:
�  -------
�  Does not send anything to the printer - instead
�  returns a control string that you send to the printer. String can be
�  sent with ? or ?? or  QOUT() or QQOUT().
� 
�  For HP and compatible(PCL) Laserjet printers.
� 
�  Source:
�  -------
�  S_HPLAS.PRG
� 
����������������������������������������������������������������� 
*/
Function SL_ItalicOff
return chr(27)+"(s0S"

//----------------------------------------------------
/*
�����������������������������������������������������������������
� FUNCTION SL_SETCPI()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SL_SETCPI() Sets characters per inch
� 
�  Returns:
�  --------
�  cCode => control string to send to the printer
� 
�  Syntax:
�  -------
�  SL_SETCPI(nCPI)
� 
�  Description:
�  ------------
�  Sets characters per inch to <nCpi>  - valid to 2
�  decimal places. Current font must support this CPI.
� 
�  Examples:
�  ---------
�   ?SL_SETCPI(16.66)   // sets to compressed
� 
�   ?SL_SETCPI(12)     // sets to 12 cpi
� 
�   ?SL_SETCPI(10)     // sets to 10 cpi  (default)
� 
�  Notes:
�  -------
�  Does not send anything to the printer - instead
�  returns a control string that you send to the printer. String can be
�  sent with ? or ?? or  QOUT() or QQOUT().
� 
�  For HP and compatible(PCL) Laserjet printers.
� 
�  Source:
�  -------
�  S_HPLAS.PRG
� 
����������������������������������������������������������������� 
*/
function SL_Setcpi(nCpi)
local cCpi := alltrim(str( iif(nCpi#nil,Round(nCpi,2),10) ))
return CHR(27) + "(s"+cCpi+"H"



//�����������������������
// Drawing by Row/Column
//�����������������������

//----------------------------------------------------
/*
�����������������������������������������������������������������
� FUNCTION SL_FILL()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SL_FILL() Fills a rectangle with shading or a pattern.
� 
�  Returns:
�  --------
�  cCode => control string to send to the printer
� 
�  Syntax:
�  -------
�  SL_FILL(nTop,nLeft,nBottom,nRight,[cShade],[cFill],[nCpi],[nLpi])
� 
�  Description:
�  ------------
�  Fills a rectangle based on rows and columns at
�  <nTop,nLeft> to <nBottom,nRight>. The area may be shaded
�  [cShade] or filled with a pattern [cFill] :
� 
�  The shading percentages are (default "20") :
� 
�         "1 thru 2" = 2% shade
�        "3 thru 10" = 10% shade
�       "11 thru 20" = 20% shade
�       "21 thru 35" = 30% shade
�       "36 thru 55" = 45% shade
�       "56 thru 80" = 70% shade
�       "81 thru 99" = 90% shade
�              "100" = 100% shade
� 
�  The pattern fills are (default "6"):
� 
�       "1" = horizontal lines
�       "2" = vertical lines
�       "3" = diagonal lines top right to bottom left
�       "4" = diagonal lines top left to bottom right
�       "5" = #1 and # 2 combined
�       "6" = #3 and # 4 combined
� 
�  <nCpi> is the characters per inch, and defaults to
�  10. <nLpi> is the lines per inch, and defaults to 6.
� 
�  Examples:
�  ---------
�   SL_FILL(10,10,20,20,"50")
�    // fills from 10,10 to 20 20 with 50% shading
� 
�  Notes:
�  -------
�  Does not send anything to the printer - instead
�  returns a control string that you send to the printer. String can be
�  sent with ? or ?? or  QOUT() or QQOUT().
� 
�  For HP and compatible(PCL) Laserjet printers.
� 
�  Source:
�  -------
�  S_HPLAS.PRG
� 
����������������������������������������������������������������� 
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
�����������������������������������������������������������������
� FUNCTION SL_HLINE()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SL_HLINE() Draws a horizontal line from row,col to row,endcol
� 
�  Returns:
�  --------
�  cCode => control string to send to the printer
� 
�  Syntax:
�  -------
�  SL_HLINE(nTop,nLeft,nBottom,nRight,[cShade],[nDPIThick],[nCpi])
� 
�  Description:
�  ------------
�  Draws a horizontal line from <nTop,nLeft> to
�  <nBottom,nRight>. Based on rows and columns.
� 
�  [cShade] refers to the density of the line.
� 
�  The shading percentages are (default "100" - black) :
� 
�         "1 thru 2" = 2% shade
�        "3 thru 10" = 10% shade
�       "11 thru 20" = 20% shade
�       "21 thru 35" = 30% shade
�       "36 thru 55" = 45% shade
�       "56 thru 80" = 70% shade
�       "81 thru 99" = 90% shade
�              "100" = 100% shade
� 
�  [nDPIThick] is the thickness in DotsPerInch of the
�  line. Default is 2.
� 
�  [nCpi] is the characters per inch, and defaults to 10.
� 
�  Examples:
�  ---------
�   ??SL_HLINE(10,10,10,20,"50")  // draws a line 10,10 to 20,20 with
�                                 //50%  shading
� 
�  Notes:
�  -------
�  Does not send anything to the printer - instead
�  returns a control string that you send to the printer. String can be
�  sent with ? or ?? or  QOUT() or QQOUT().
� 
�  For HP and compatible(PCL) Laserjet printers.
� 
�  Source:
�  -------
�  S_HPLAS.PRG
� 
����������������������������������������������������������������� 
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
�����������������������������������������������������������������
� FUNCTION SL_VLINE()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SL_VLINE() Draws a vertical line from row,col to endrow,col
� 
�  Returns:
�  --------
�  cCode => control string to send to the printer
� 
�  Syntax:
�  -------
�  SL_VLINE(nTop,nLeft,nBottom,nRight,[cShade],[nDPIThick],[nLpi])
� 
�  Description:
�  ------------
�  Draws a vertical line from <nTop,nLeft> to <nBottom,nRight>. Based
�  on rows and columns.
� 
�  [cShade] refers to the density of the line.
� 
�  The shading percentages are (default "100" - black) :
� 
�         "1 thru 2" = 2% shade
�        "3 thru 10" = 10% shade
�       "11 thru 20" = 20% shade
�       "21 thru 35" = 30% shade
�       "36 thru 55" = 45% shade
�       "56 thru 80" = 70% shade
�       "81 thru 99" = 90% shade
�              "100" = 100% shade
� 
�  [nDPIThick] is the thickness in DotsPerInch of the
�  line. Default is 2.
� 
�  [nLpi] is the lines per inch, and defaults to 6.
� 
�  Examples:
�  ---------
�   ??SL_VLINE(10,20,10,10,"50")  // draws a line 10,10 to 20,10 with
�                                          // 50% shading
� 
�  Notes:
�  -------
�  Does not send anything to the printer - instead
�  returns a control string that you send to the printer. String can be
�  sent with ? or ?? or  QOUT() or QQOUT().
� 
�  For HP and compatible(PCL) Laserjet printers.
� 
�  Source:
�  -------
�  S_HPLAS.PRG
� 
����������������������������������������������������������������� 
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
�����������������������������������������������������������������
� FUNCTION SL_BOX()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SL_BOX() Draws a box line from row,col to endrow,endcol
� 
�  Returns:
�  --------
�  cCode => control string to send to the printer
� 
�  Syntax:
�  -------
�  SL_BOX(nTop,nLeft,nBottom,nRight,[cShade],[nDPIThick],[nCpi],[nLpi])
� 
�  Description:
�  ------------
�  Draws a box from nTop,nLeft to nBottom,nRight. Based
�  on rows and columns.
� 
�  [cShade] refers to the density of the line.
� 
�  The shading percentages are (default "100" - black) :
� 
�         "1 thru 2" = 2% shade
�        "3 thru 10" = 10% shade
�       "11 thru 20" = 20% shade
�       "21 thru 35" = 30% shade
�       "36 thru 55" = 45% shade
�       "56 thru 80" = 70% shade
�       "81 thru 99" = 90% shade
�              "100" = 100% shade
� 
�  [nDPIThick] is the thickness in DotsPerInch of the
�  line. Default is 2.
� 
�  [nCpi] is the characters per inch, and defaults to 10.
� 
�  [nLpi] is the lines per inch, and defaults to 6.
� 
�  Examples:
�  ---------
�   SL_BOX(10,10,20,20,"50",10)
�                     // draws a box 10,10 to 20 20 with 50%
�                        //shading and 10 DPI thick
� 
�  Notes:
�  -------
�  Does not send anything to the printer - instead
�  returns a control string that you send to the printer. String can be
�  sent with ? or ?? or  QOUT() or QQOUT().
� 
�  QOUT() or QQOUT().
� 
�  For HP and compatible(PCL) Laserjet printers.
� 
�  Source:
�  -------
�  S_HPLAS.PRG
� 
����������������������������������������������������������������� 
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
�����������������������������������������������������������������
� FUNCTION SL_WRAP()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SL_WRAP() Sets line wrapping on or off
� 
�  Returns:
�  --------
�  cCode => control string to send to the printer
� 
�  Syntax:
�  -------
�  SL_WRAP(lSet)
� 
�  Description:
�  ------------
�  Sets line wrapping on (.t.) or off (.f.) with <lSet>
� 
�  Examples:
�  ---------
�   ?SL_WRAP(.T.)  // set line wrapping on
� 
�  Notes:
�  -------
�  Does not send anything to the printer - instead
�  returns a control string that you send to the printer. String can be
�  sent with ? or ?? or  QOUT() or QQOUT().
� 
�  For HP and compatible(PCL) Laserjet printers.
� 
�  Source:
�  -------
�  S_HPLAS.PRG
� 
����������������������������������������������������������������� 
*/
function SL_Wrap(lWrap)
IF lWrap
  RETURN ( chr(27)+'&s0C' )
ENDIF
RETURN ( chr(27)+'&s1C' )

//���������������������
// Internal
//���������������������
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
