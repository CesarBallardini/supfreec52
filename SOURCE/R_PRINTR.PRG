/*
ีออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ This is not an exported function. It is called by other SuperLib
ณ functions, and has been tested within that context. Do not call
ณ this function directly.
ณ 
ณ 
ณ FUNCTION RPRINTREP()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ
ณ  RPRINTREP() Print reports from report definition
ณ
ณ  Returns:
ณ  --------
ณ  NIL
ณ
ณ  Syntax:
ณ  -------
ณ  RPRINTREP(aInvalues,lUseQuery,lUseTag,aTagged)
ณ
ณ  Description:
ณ  ------------
ณ  aInvalues
ณ           holds arrays of report definitions as follows:
ณ           aValues        // this array holds various report elements
ณ                         // like page width, page length etc. that
ณ                         // relate to the report as a whole
ณ
ณ           aHeader       // this array holds the page header(s)
ณ           aFooter       // this array holds the page footer(s)
ณ
ณ           aColumns      // this array holds column expressions
ณ           aTitles       // .................column titles
ณ           aWidths       // .................column widths
ณ           aTotalYN      // .................column total y/n settings
ณ           aPictures     // .................column pictures
ณ
ณ  lUseQuery
ณ          use the stored query?
ณ  lUseTag
ณ          use tagged items to report on
ณ  aTagged
ณ          array of tagged items
ณ
ณ
ณ  PRESUMES A BOX HAS BEEN DRAWN AT 21,9,24,79 and writes to this area
ณ
ิออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*/

#include "Inkey.ch"
#ifndef K_LBUTTONDOWN
 #define K_LBUTTONDOWN   1002   //   mouse left key press
 #define K_RBUTTONDOWN   1004   //   mouse right key press
#endif
#define K_MOUSELEFT K_LBUTTONDOWN
#define K_MOUSERIGHT K_RBUTTONDOWN

#DEFINE M_DBF           1       // dbf name
#DEFINE M_TITLE         2       // report title (name)
#DEFINE M_NDXKEY        3       // index key
#DEFINE M_MAJKEY        4       // major group portion of index key
#DEFINE M_MINKEY        5       // minor group portion of index key
#DEFINE M_MAJTEXT       6       // major group header text
#DEFINE M_MINTEXT       7       // minor group header text
#DEFINE M_WIDTH         8       // page width in characters
#DEFINE M_LENGTH        9       // page length in lines
#DEFINE M_LEFTM        10       // left margin in columns (#blank columns)
#DEFINE M_TOPM         11       // top margin in rows (#blank rows)
#DEFINE M_SPACE        12       // line spacing 0 = single, 1 = double
#DEFINE M_PAUSE        13       // pause between pages ? Y/N
#DEFINE M_NPLINES      14       // page eject if (n) lines left on group change
#DEFINE M_EJB4         15       // page eject before report
#DEFINE M_EJAFT        16       // page eject after report
#DEFINE M_EJMAJOR      17       // page eject on new major group
#DEFINE M_EJMINOR      18       // page eject on new minor group
#DEFINE M_EJGRAND      19       // page eject before grand totals page
#DEFINE M_UNTOTAL      20       // underline totals ? Y/N
#DEFINE M_MAJCHR       21       // major totals underline character
#DEFINE M_MINCHR       22       // minor totals underline character
#DEFINE M_NHEAD        23       // number of header lines (1-9)
#DEFINE M_NFOOT        24       // number of footer lines (1-9)
#DEFINE M_NTITL        25       // number of title lines (1 or 2)
#DEFINE M_TSEP         26       // character for title seperator line
#DEFINE M_COLSEP       27       // character for column seperator line
#DEFINE M_CSEPWID      28       // width of column seperator
#DEFINE M_LINESEP      29       // detail line seperator character
#DEFINE M_NCOLS        30       // number of report columns defined
#DEFINE M_STDHEAD      33       // use standard 2 line header (page#, date, time)
#DEFINE M_QUERY        35       // last used query filter
#DEFINE M_FULLSUM      36       // full or sumary only report
#DEFINE M_PRNCODE      37       // printer code for before report
#DEFINE M_AFTCODE      38       // printer code for after report


//- destination
#define TO_PRINTER  1
#define TO_FILE     2

//-------------------------------------------------------------------------
static aValues        // this array holds various report elements
                      // like page width, page length etc. that
                      // relate to the report as a whole

static  aHeader       // this array holds the page header(s)
static  aFooter       // this array holds the page footer(s)

static  aColumns      // this array holds column expressions
static  aTitles       // .................column titles
static  aWidths       // .................column widths
static  aTotalYN      // .................column total y/n settings
static  aPictures     // .................column pictures

static lCatchup       // are we restarting a report and 'catching up...'?
static nPageNumber    // current page number
static nLineNumber    // current line number
static nDestination   // destination  1=printer  2=file
static nStartPage     // start at page....
static lEjectPage     // eject page flag
static cOutFileName   // output file name for print to file
static cStHead1       // standard header 1 string
static cStHead2       // standard header 2 string
static lAbortPrint    // abort flag

memvar getlist        // old buddy getlist

//-------------------------------------------------------------------------
FUNCTION rPrintRep(aInvalues,lUseQuery,lUseTag,aTagged)

LOCAL   nMaxDetailLines,;   // maximum # of detail lines (after headers, etc)
        cPrintLine,;        // used to build an output line
        expMajorKey, ;      // holds the current Major Key value
        expMinorKey,;       // holds the current Minor Key value
        lIsMajorGroup,;     // is there a major group ?
        lIsMinorGroup,;     // is there a minor group ?
        lIsTotal,;          // are there any totalling columns ?
        lMajorHeading,;     // is it time to print a major group heading ?
        lMinorHeading,;     // is it time to print a minor group heading ?
        cColumnSep,;        // the column seperator string
        bGetMajor,;         // block used to grab the major heading value
        bGetMinor,;         // block used to grab the minor heading value
        lDoPrint,;          // var for the "Go for it?" question
        nThisWidth,;        // width of current column
        expThisColumn,;     // current column expression
        bQuery,;            // code block to eval query
        nCounter,;          // just a counter variable
        aColBlocks,;        // array of blocks to retrieve column values
        aMinorTotals,;      // array to hold minor totals
        aMajorTotals,;      // array to hold major totals
        aGrandTotals,;      // array to hold grand totals
        nInkey,;            // holds inkey() value
        nLastKey,;          // holds lastkey() value
        lAbandoned,;        // report abandoned (aborted) switch
        cBox,;              // holds a makebox() screen variable
        lDoMajorHead,;      // are major group headings to be done at all
        lDoMinorHead        // are minor group headings to be done at all

//- get these static values from the parameter aValues
aValues     := aInValues[1]
aHeader     := aInValues[2]
aFooter     := aInValues[3]
aColumns    := aInValues[4]
aTitles     := aInValues[5]
aWidths     := aInValues[6]
aTotalYN    := aInValues[7]
aPictures   := aInValues[8]

lAbortPrint  := .f.                     // haven't aborted yet

//-- if the user has typed "NONE" in the Major Header Text or
//-- Minor Header Text, then that header is not done at all
lDoMajorHEad := upper(alltrim(aValues[M_MAJTEXT]))<>"NONE"
lDoMinorHead := upper(alltrim(aValues[M_MINTEXT]))<>"NONE"

//- size the totals arrays to the number of columns
aMinorTotals    := array(aValues[M_NCOLS])
aMajorTotals    := array(aValues[M_NCOLS])
aGrandTotals    := array(aValues[M_NCOLS])

//- size the column blocks array to the number of columns
aColBlocks      := array(aValues[M_NCOLS])

//- account for the rest of the parameters
lUseQuery       := iif(lUseQuery#nil,lUseQuery,.f.)
lUseTag         := iif(lUseTag#nil,lUseTag,.f.)
lUseTag         := iif(!empty(aTagged),lUseTag,.f.)

//- set all totals to zero
Afill(aMinorTotals,0)
Afill(aMajorTotals,0)
Afill(aGrandTotals,0)

//- default output file name
cOutFileName="MYREPORT.PRN"

//- set these variables used in reporting process to zero
nPageNumber := 0
nLineNumber := 0

//- determine the maximum detail lines (page length less number of
//- headers less number of footers less number of title lines less
//- (2 if using standard header) less 3 to account for title underline,
//- underline before footer, and 1 more because..it just seems to work)
nMaxDetailLines := aValues[M_LENGTH]-(aValues[M_NHEAD]+aValues[M_NFOOT]+aValues[M_NTITL]+3)
nMaxDetailLines := nMaxDetailLines-IIF(aValues[M_STDHEAD],2,0)-aValues[M_TOPM]

//- create column seperator string (column sep character * width)
cColumnSep      := repl(aValues[M_COLSEP],aValues[M_CSEPWID])

//- default these vars to false
lMinorHeading   := .f.
lMajorHeading   := .f.
lEjectPage      := .f.
lDoPrint      := .F.
lAbandoned    := .f.

//- determine standard header strings 1 and 2
IF aValues[M_STDHEAD]
  cStHead1 := "Date :"+DTOC(DATE())+SPACE(aValues[M_WIDTH]-24)
  cStHead2 := "Time :"+TIME()
ENDIF

//- is there a major group?
lIsMajorGroup := (!EMPTY(aValues[M_MAJKEY]))

//- is there a minor group?
lIsMinorGroup := (!EMPTY(aValues[M_MINKEY]))

//- grand total?
lIsTotal      := (Ascan(aTotalYN,"Y")> 0)

//- there are determined at group change time, so just init to blank
expMajorKey   := ""
expMinorKey   := ""


DO WHILE .T.
   scroll(22,2,23,77,0)   // scroll the question asking area clear

   @22,5 SAY "To: "       // get the destintation
   nDestination := RAT_MENU2({ {22,10 ,"Printer "},;
                               {23,10 ,"Disk File "}},nDestination)
   nDestination := MAX(1,nDestination)

   scroll(22,2,23,77,0)   // scroll the question asking area clear
   IF LASTKEY()=27        // if escape, exit
     EXIT
   ENDIF


   IF nDestination=2      // if sending to file
     getlist := {}
     @22,5 SAY "File name to print to "   // get the file name
     @23,5 GET cOutFileName
     @24,2 say "[OK]"
     RAT_READ(getlist,1,.f.,27,{|r,c|kbenter(r,c)} )
     scroll(22,2,23,77,0)  // scroll the question asking area clear
     @24,2 say "ฤฤฤฤ"

   ENDIF

   IF LASTKEY()=27         // if escape, quit
     EXIT
   ENDIF

   //- determine starting page (usually 1)
   nStartPage   := 1
   getlist      := {}
   @22,5 SAY "Start at page # " GET nStartPage PICT "999"
   @24,2 say "[OK]"
   RAT_READ(getlist,1,.f.,27,{|r,c|kbenter(r,c)} )
   @24,2 say "ฤฤฤฤ"
   scroll(22,2,23,77,0)   // scroll the question asking area clear
   IF LASTKEY()=27        // if escape, quit
     EXIT
   ENDIF

   lCatchup := (nStartPage > 1)  // if starting at anything other than 1
   lDoPrint := .T.               // set the lDoPrint variable to true
   getlist := {}                 // and ask the user to go for it
   @22,5 SAY "Print report now? (Y/N) " GET lDoPrint PICT "Y"
   @24,2 say "[OK]"
   RAT_READ(getlist,1,.f.,27,{|r,c|kbenter(r,c)} )
   @24,2 say "ฤฤฤฤ"
   scroll(22,2,23,77,0)
   IF LASTKEY()=27        // if escape, the set lDoprint to false
     lDoPrint = .f.
   ENDIF

   EXIT                  // exit this loop
ENDDO
IF !lDoPrint             // if this hasn't been set to true,
  RETURN ''              // we ain't printin nuttin
ENDIF

IF nDestination=TO_FILE
    SET PRINTER TO (cOutFileName)      // direct printer to file name
else
    //- get the printer to use, ensure it is ready
    IF !MESSYN("Use default Printer")
      sls_prn(PRNPORT())
    ELSEIF !P_READY(sls_prn())         // if printer not ready, we're gone
      return ''
    endif
    rPrintCodes()                      // get printer codes ready
ENDIF

if !lCatchup                           // if we are not catching up
  SET PRINT ON                         // and are starting at page 1
  if nDestination = 1
    rPrintCodes(.t.)                   // issue the pre-report print codes
  endif
endif

                                      // let the user know that they can
                                      // stop or pause the report
@0,48 SAY "SPACE to pause - ESC to quit"

                                      // make a box to show the report
                                      // progress
cBox = Makebox(1,0,24,79,sls_popcol(),0)

for nCounter = 1 TO aValues[M_NCOLS]   // create the column value
                                       // retrieval blocks
  aColBlocks[nCounter] := &("{||"+aColumns[nCounter]+"}")
next

do while .t.

  GO TOP

  //- create the locate blocks and issue the initial LOCATE
  //- after this, a CONTINUE will be issued each time we need
  //- a new record
  IF lUseQuery                                  // using query
    bQuery := &("{||"+aValues[M_QUERY]+"}")
    //LOCATE FOR eval(bQuery) WHILE (inkey()#27 .and. !rat_rightb() )
    LOCATE FOR eval(bQuery) WHILE ( !rat_checkesc() )
  ELSEIF lUseTag                                // using tag
    bQuery := {||ascan(aTagged,recno())>0}
    //LOCATE FOR eval(bQuery) WHILE (inkey()#27 .and. !rat_rightb() )
    LOCATE FOR eval(bQuery) WHILE ( !rat_checkesc() )
  ELSE                                          // all records
    LOCATE FOR .T.                              // just for uniformity,
                                                // so we can issue a
                                                // locate each time
  ENDIF

  //- if we found any match, and the Eject Before Report flag is true,
  //- the send an eject chr(12) to the output proc: ROUTPUT()
  if aValues[M_EJB4] .and. found()
    rOutput(chr(12))
  endif

  //- if we found any match
  IF FOUND()
    // and if there is a major group key
    IF lIsMajorGroup
      // Then we need to create our major group key block and retrieve
      // our first major key value. We also set the lMajorheading to
      // true, which indicates that we need to print the major heading
      bGetMajor      := &("{||"+aValues[M_MAJKEY]+"}")
      expMajorKey    := eval(bGetMajor)
      lMajorHeading  := .t.
    ENDIF

    // and if there is a minor group key
    IF lIsMinorGroup
      // Then we need to create our minor group key block and retrieve
      // our first minor key value. We also set the lMinorheading to
      // true, which indicates that we need to print the minor heading
      bGetMinor      := &("{||"+aValues[M_MINKEY]+"}")
      expMinorKey    := eval(bGetMinor)
      lMinorHeading  := .t.
    ENDIF

    // call the routine that prints the headers and title lines
    rPrintHead()
  ENDIF

  // here is our major report loop, while the found() flag is true and
  // the user hasn't aborted the report
  DO WHILE FOUND() .and. !lAbortPrint
    cPrintLine := ""                    // reset the print line to ""
    nLastKey   := lastkey()             // capture any past or
    nInkey     := inkey()               // present key strokes

    // if escape of mouse right button pressed, ask the user if
    // they are kidding. If not, set the abandoned flag and
    // exit
    //IF nLastKey=27 .or. nInkey = 27 .or. rat_rightb()
    IF nLastKey=27 .or. nLastKey==K_MOUSERIGHT  .or. rat_checkesc()
       clear typeahead          // clear the keyboard so our message
                                // doesn't just flit on by
       if messyn("Abandon report ?")
          lAbandoned := .t.
          exit
       endif
       keyboard "X"             // clear the escape key out of lastkey()
       inkey()                  // by making it get "X"

    // if the space key has been pressed,
    ELSEIF nLastKey=32 .or. nInkey=32
       CLEAR TYPEAHEAD         // clear the keyboard buffer so that
                               // we can wait for a keystroke
       rat_event(0)            // wait for a keystroke or mouse click
       keyboard "X"            // clear the space key out of lastkey()
       inkey()                 // by making it get "X"
    ENDIF


    // ok, if there's a major group or a minor group,
    // lets check for group change
    IF lIsMajorGroup .or. lIsMinorGroup
        // if there's a minor group, handle it first
        if lIsMinorGroup
          // if the last saved Minor Group Key is not the same
          // as the current record Minor Group Key, then its
          // a Minor Group Break
          IF expMinorKey <> eval(bGetMinor)
            // if there are any totalling columns, print them now
            // for the minor group by calling RPRNTTOTALS()
            // with the current minor key value and the
            // totals value
            IF lIsTotal
               rPrntTotals(TRANS(expMinorKey,"")+" subtotals:",;
                         aMinorTotals,aValues[M_MINCHR])
            else
               // just print a blank line
               rOutput("")
            endif
            // now reset our minor key by eval'ing the bGetMinor block
            expMinorKey     := eval(bGetMinor)

            // set the 'print minor heading' flag to true, so that
            // it gets printed before the next detail line
            lMinorHeading   := .t.

            // set the eject page flag to true if the Eject Page on
            // Minor Group change flag is true
            lEjectPage      := iif(aValues[M_EJMINOR],.t.,lEjectPage)
          ENDIF
        endif
        // if there is a major group
        IF lIsMajorGroup
          // if the last saved Major Group Key is not the same
          // as the current record Major Group Key, then its
          // a Major Group Break
          if (expMajorKey <> eval(bGetMajor) )
               // if there are any totalling columns, print them now
               // for the major group  by calling RPRNTTOTALS()
               // with the current major key value and the
               // totals value
               if lIsTotal
                 rPrntTotals(TRANS(expMajorKey,"")+" subtotals:",;
                             aMajorTotals,aValues[M_MAJCHR])
               else
                 rOutput("")
               endif
               // reset our Major Heading value by eval'ing the bGetMajor block
               expMajorKey  := eval(bGetMajor)

               // force the Major heading to print before the next detail line
               lMajorHeading := .t.

               // determine if an Eject Page is needed, based on if the
               // flag to do so is true, or if the Number of Remaining
               // Lines on Page at which to Eject number equals or
               // exceeds the lines remaining
               lEjectPage   := iif(aValues[M_EJMAJOR],.t.,lEjectPage)
               lEjectPage   := iif(nLineNumber+aValues[M_NPLINES]> nMaxDetailLines,;
                                   .t.,lEjectPage)
          endif
        ENDIF
    ENDIF

    // if we've reached the maximum number of detail lines, set
    // the eject page flag to true
    lEjectPage := iif(nLineNumber>= nMaxDetailLines,.t.,lEjectPage)


    // is the eject page flag true
    IF lEjectPage
      // account for any remaining detail lines by printing blanks up
      // to the number of detail lines
      for nCounter = nLineNumber to nMaxDetailLines
        rOutput("")
      next
      nLineNumber   := 0                // reset this to zero
      rPrintFeet()                      // print the footer(s)
      rOutput(chr(12))                  // send a page eject character

      // if the flag to pause after printing each page is true,
      // pause and let the user consider their fate...
      if aValues[M_PAUSE]
         @24,2 say "[Pausing....press a key   ]" color "*"+setcolor()
         rat_event(0)
         @24,2 say "ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ"
      endif

      // if we've ejected a page, its time to print the headers
      rPrintHead()

      // set the Print Group Heading flags according to whether or
      // not Major and/or Minor groups exist. If they exist, we
      // need to print the headers for the new page
      lMajorHeading := lIsMajorGroup
      lMinorHeading := lIsMinorGroup

    ENDIF

    // if we have a Print Major Heading flag and we are
    // supposed to be printing major headers, now's the time to do it
    if lMajorHeading .and. lDoMajorHead
       rOutput(TRIM(aValues[M_MAJTEXT])+" "+trans(expMajorKey,""))
       if !lMinorHeading   // if no minor heading, leave a blank line
         rOutput("")
       endif
       lMajorHeading    :=.f.    // reset the Print flag
    endif

    // if we have a Print Minor Heading flag and we are
    // supposed to be printing minor headers, now's the time to do it
    if lMinorHeading .and. lDoMinorHead
       rOutput(TRIM(aValues[M_MINTEXT])+' '+TRANS(expMinorKey,""))
       rOutput("")        // print a blank line
       lMinorHeading    := .f.  // reset the Print flag
    endif

    // we finally get to the point where we can: print a detail line!
    // that is, if it is a Full report and not a Summary report
    if aValues[M_FULLSUM]=="F"     // Full report
      cPrintLine        := ""      // reset this line
    endif

    // loop through for each column
    for nCounter = 1 TO aValues[M_NCOLS]

      // get the value for this column by eval'ing the block
      // for this column
      expThisColumn = eval(aColBlocks[nCounter])

      // see if there are totals to accumulate for this column
      IF aTotalYN[nCounter]=="Y"
        IF lIsMinorGroup     // add to minor group totals
          aMinorTotals[nCounter] +=expThisColumn
        ENDIF
        IF lIsMajorGroup     // add to major group totals
          aMajorTotals[nCounter] += expThisColumn
        ENDIF
                            // add to grand totals
        aGrandTotals[nCounter] += expThisColumn
      ENDIF

      // get the column width as a numeric (its stored as a Char)
      nThisWidth := VAL(aWidths[nCounter])

      // apply the picture clause if there is one, and trim/pad the
      // column value to the column width
      if !empty(aPictures[nCounter])
        expThisColumn = padr(TRANS(expThisColumn,aPictures[nCounter]),nThisWidth)
      else
        expThisColumn = padr(TRANS(expThisColumn,""),nThisWidth)
      endif

      // if this is a FULL report
      if aValues[M_FULLSUM]=="F"
        // add the column value to the print line
        cPrintLine += expThisColumn

        // if it is not the last column, add the column seperator string
        // to the print line as well
        IF !nCounter=aValues[M_NCOLS]
          cPrintLine += cColumnSep
        ENDIF
      endif
      // and loop around to the next column
    NEXT


    // if this is a FULL report (nor a SUMMARY report) print the
    // accumulated print line
    if aValues[M_FULLSUM]=="F"
       rOutput(cPrintLine)
    ENDIF

    // set the print line to blank
    cPrintLine := ""

    // if it is a FULL report
    if aValues[M_FULLSUM]=="F"
      // if it is double spaced
      if aValues[M_SPACE]=1
        // print a line using the line seperator character
        rOutput(repl(aValues[M_LINESEP],aValues[M_WIDTH]))
      endif
      // notify the use of the current line number
      @24,2 say "[Line "+TRANS(nLineNumber,"9999")+"                ]"
    endif

    //- issue a CONTINUE (remember that LOCATE way back there???)
    CONTINUE


    IF !found()        // no more matching records
      IF lIsTotal      // are there any totals to handle?

          // handle minor group totals
          // set eject page flag accordingly
          if lIsMinorGroup
            rPrntTotals(TRANS(expMinorKey,"")+;
                         " subtotals:",aMinorTotals,aValues[M_MINCHR])
            lEjectPage  := iif(aValues[M_EJMINOR],.t.,lEjectPage)
          endif

          // handle major group totals
          // set eject page flag accordingly
          IF lIsMajorGroup
              rPrntTotals(TRANS(expMajorKey,"")+" subtotals:",;
                         aMajorTotals,aValues[M_MAJCHR])
              lEjectPage := iif(aValues[M_EJMAJOR],.t.,lEjectPage)
              lEjectPage := iif(nLineNumber+aValues[M_NPLINES]> ;
                            nMaxDetailLines,.t.,lEjectPage)
          ENDIF

          // see if we need to eject the page based on number of lines
          lEjectPage := iif(nLineNumber>= nMaxDetailLines,.t.,lEjectPage)
          lEjectPage := iif(aValues[M_EJGRAND],.t.,lEjectPage)


          // eject the page if needed
          IF lEjectPage
            for nCounter = nLineNumber to nMaxDetailLines
              rOutput("")
            next

            // print footers
            rPrintFeet()
            // send page eject
            rOutput(CHR(12))
            // print headers
            rPrintHead()
          ENDIF

          // print grand totals
          rPrntTotals(" Grand Totals :",aGrandTotals,aValues[M_MAJCHR])

          // print blanks for rest of page
          for nCounter = nLineNumber to nMaxDetailLines
            rOutput("")
          next

          // print footers
          rPrintFeet()

      ELSE                      // no totals to handle

          // just print blanks to end of page
          for nCounter = nLineNumber to nMaxDetailLines
            rOutput("")
          next

          // and print footers
          rPrintFeet()
      ENDIF
    ENDIF

  ENDDO

  if !lAbandoned                // if we did not abandon the report
    rOutput("")
    IF aValues[M_EJAFT]         // do we eject after the report?
      rOutput(CHR(12))
    ENDIF

    rPrintCodes(.f.)            // print the after report print codes
    SET PRINT OFF               // set the printer off
    SET PRINTER TO (sls_prn())
    SCROLL(2,1,23,78,3)         // scroll the user info area
    @21,1 SAY ""
    @22,1 SAY ""                // yo! user! we're done....
    @23,1 SAY " Report Complete - Press a key"
    rat_event(0)
  else
    // even if the report was abandoned, we still need to send the
    // post-report print codes
    rPrintCodes(.f.)
  endif
  exit
enddo
Unbox(cBox)                                     // remove the output box
@0,48 SAY "                            "        // clear the "Press Space.."
                                                // message
SET PRINT OFF                                   // be sure that printer is off
SET PRINTER TO                                  // flush the network spool
SET PRINTER TO (sls_prn())                      // if any

// set these static variables back to NIL
aValues:=aHeader:=aFooter:=aColumns:=aTitles:=aWidths:=aTotalYN:=aPictures:=nil
lCatchup:=nPageNumber:=nLineNumber:=nDestination:=nStartPage:=nil
lEjectPage:=cOutFileName:=cStHead1:=cStHead2:=nil

RETURN ''


//-------------------------------------------------------------------------
//- print a totals line - can be minor, major or grand
static FUNCTION rPrntTotals(cTotalDesc,aTally,cUnderLine)
local nValue                    // holds a temp totals value
local cValue                    // holds a character version of nValue
local nThisWidth                // width of current total column
local nCounter                  // a loop variable
local cPrintLine := ""          // a print line variable
local cPrintUnder:= ""          // an underline print line variable

rOutput("")                     // print a blank line before all totals
rOutput(cTotalDesc)             // print the totals description (passed
                                // as a parameter above)

                                // loop through the columns
for nCounter = 1 TO aValues[M_NCOLS]
  // get the width for this column
  nThisWidth := val(aWidths[nCounter])

  // if this is a total column
  IF aTotalYN[nCounter]=="Y"
    nValue := aTally[nCounter]

    // if there is a picture for the column, use it
    if !empty(aPictures[nCounter])
      cValue := TRANS(nValue,aPictures[nCounter])
    else
      // if no picture, use our built in function to create a
      // string from a number, accounting for decimals
      cValue := RNTRANS(nValue)
    endif

    // make the string match the column width and add it to the print
    // line
    cPrintLine += padr(cValue,nThisWidth)

    // set the tally element for this column to zero
    aTally[nCounter] = 0

    // if we are underlining totals
    if aValues[M_UNTOTAL]
      // add this column width's worth of the supplied underline
      // character to the underline print line
      cPrintUnder += repl(cUnderLine,nThisWidth)
    endif
  ELSE   // not a total column
         // just add spaces for the width of the column, and also
         // for the underline line
     cPrintLine += SPACE(nThisWidth)
     cPrintUnder += SPACE(nThisWidth)
  ENDIF

  // if it is not the last column, add the between-columns
  // string to both the print line and the underline print line
  IF !nCounter=aValues[M_NCOLS]                // if not last column, add colsep width
    cPrintLine += space(aValues[M_CSEPWID])
    cPrintUnder += space(aValues[M_CSEPWID])
  ENDIF
NEXT

// print the print line with the totals
rOutput(cPrintLine)

// if underlining, print the underline print line too
if aValues[M_UNTOTAL]                  // if underline totals
  rOutput(cPrintUnder)
endif

// print a blank line
rOutput("")
RETURN ''


//-------------------------------------------------------------------------
//- print the page headers and title lines
static FUNCTION rPrintHead
local nCounter,;                // a generic counter
      cPrintLine,;              // accumulated print line variable
      cThisTitle,;              // current column title
      nWidth,;                  // holds a column width value
      nCount2                   // a generic counter

lEjectPage  := .f.              // if we're printing headers, its a good
                                // bet that its not time to eject
nLineNumber := 0                // reset the line number counter to zero

nPageNumber++                   // increment the page number counter

// if we are 'catching up' (we didn't start with page 1) and this
// is our target starting page, set the printer on, send the setup
// codes and set lCatchup to false
if nPageNumber=nStartPage .and. lCatchup
	SET PRINT ON
        rPrintCodes(.t.)        // True means print pre-report codes
        lCatchup := .f.
endif

// create the top margin with blank lines
for nCounter = 1 to aValues[M_TOPM]
   rOutput("")
next

// if we are using the standard header, print it out along with
// the page number
IF aValues[M_STDHEAD]
  rOutput(cStHead1+"Page: "+TRANS(nPageNumber,"9999") )
  rOutput(cStHead2)
ENDIF

// print the header lines, accounting for page width
for nCounter = 1 TO aValues[M_NHEAD]
  rOutput(LEFT(aHeader[nCounter],aValues[M_WIDTH]))
NEXT

FOR nCounter = 1 TO aValues[M_NTITL]    // there can be 1 or 2 title lines
                                        // M_NTITL refers to how many
                                        // title lines there are
  cPrintLine = ""                       // clear the print line

  // for each column
  for nCount2 = 1 TO aValues[M_NCOLS]

    // grab the title value for this column and extract the correct
    // portion. (Column title 1 and column title 2 are seperated by
    // a semicolon - takeout() is used to get the right part)
    cThisTitle := takeout(aTitles[nCount2],";",nCounter)

    // grab the width for this column
    nWidth     := VAL(aWidths[nCount2])

    // add the title value (making sure it is the width of the column)
    cPrintLine +=padr(cThisTitle,nWidth)

    // add the column seperator string if this is not the last column
    IF !nCount2=aValues[M_NCOLS]
      cPrintLine := cPrintLine+space(aValues[M_CSEPWID])
    ENDIF
  NEXT
  // output the accumulated print line
  rOutput(cPrintLine)

NEXT

// output a line containing the title/body seperator character
// the width of the page
rOutput(REPL(aValues[M_TSEP],aValues[M_WIDTH]))
RETURN ''


//-------------------------------------------------------------------------
//- print the footers
static FUNCTION rPrintFeet
local nCounter                          // a counter variable

IF aValues[M_NFOOT] > 0
  // if there are footers, then output the title seperator
  // character for the width of the page
  rOutput(REPL(aValues[M_TSEP],aValues[M_WIDTH]))
ENDIF
// loop through and print each footer, trimming to page width
for nCounter = 1 TO aValues[M_NFOOT]
  rOutput(LEFT(aFooter[nCounter],aValues[M_WIDTH]))
NEXT
RETURN ''


//-------------------------------------------------------------------------
//- this function is where ALL printer output is sent through
STATIC FUNCTION rOutput(cPrintLine)

if lCatchup
   // if playing 'catch up' just display the page number
   @10,10 say "Catching up...page "
   ??nPageNumber
else
   // scroll the display window up 1
   SCROLL(2,1,23,78,1)

   // turn the screen off, set the printer on
   SET CONSOLE OFF
   SET PRINT ON

   if nDestination = TO_PRINTER
     // check for printer ready, and make sure the abort print flag isn't
     // set to true
     if p_ready(sls_prn(),nil,.f.) .and. !lAbortPrint
       // output the line, prefaced by enough spaces to make up
       // the left margin (if any)
       ?space(aValues[M_LEFTM])+cPrintLine
     else
       // if the printer isn't ready, and can't be gotten ready,
       // then set the global abort print flag to true
       lAbortPrint := .t.
     endif
   else                 // going to a file
     // output the line, prefaced by enough spaces to make up
     // the left margin (if any)
     ?space(aValues[M_LEFTM])+cPrintLine
   endif

   // turn the printer off, screen on
   SET CONSOLE ON
   SET PRINT OFF

   // show the line we just printed in the display window at the bottom
   @23,1 SAY LEFT(cPrintLine,77)
endif
nLineNumber++
return ''


//-------------------------------------------------------------------------
//- create/print the printer pre and post report escape codes

STATIC FUNCTION rPrintCodes(lStart)

local nCount            // just a loop variable
local cThisCode         // placeholder for codes

static cBeforeCode,cAftCode   // these hold the before and after
                              // codes between calls

if lStart==nil         // if no param passed, that means this is
                       // the first call. Parse and prep the codes
                       // into actual printer codes
    cBeforeCode := ""
    cAftCode    := ""

    // parse pre report print codes
    nCount := 1
    // if there is anything to parse
    if !empty(aValues[M_PRNCODE])


      if "@"$aValues[M_PRNCODE]
        // code is in normal escape sequence style, with exception
        // of ESCAPE code which is entered as a @
        // replace any "@" signs with chr(27) (ESCAPE)
        cBeforecode := STRTRAN(aValues[M_PRNCODE],"@",CHR(27))

      else
        // code is in lotus style decimal format i.e. 27,5,6,5
        // and needs to be parsed into character format

        // parse out the codes between commas using takeout()
        // and turen them into chr() values. Add them all
        // to cBeforeCode
        cThisCode := takeout(aValues[M_PRNCODE],',',nCount)
        do while !empty(cThisCode)
          cBeforeCode := cBeforeCode+chr(val(cThisCode))
          nCount++
          cThisCode := takeout(aValues[M_PRNCODE],',',nCount)
        enddo
      endif
    endif

    // do the post report codes now
    // if there is anything to parse
    nCount := 1
    if !empty(aValues[M_AFTCODE])


      if "@"$aValues[M_AFTCODE]
        // code is in normal escape sequence style, with exception
        // of ESCAPE code which is entered as a @
        // replace any "@" signs with chr(27) (ESCAPE)
        cBeforecode := STRTRAN(aValues[M_AFTCODE],"@",CHR(27))

      else
        // code is in lotus style decimal format i.e. 27,5,6,5
        // and needs to be parsed into character format

        // parse out the codes between commas using takeout()
        // and turen them into chr() values. Add them all
        // to cAftCode
        cThisCode := takeout(aValues[M_AFTCODE],',',nCount)
        do while !empty(cThisCode)
          cAftCode := cAftCode+chr(val(cThisCode))
          nCount++
          cThisCode := takeout(aValues[M_AFTCODE],',',nCount)
        enddo
      endif
    endif

elseif lStart                           // passed param as True, means
                                        // send pre-report code
    // if it isn't empty
    if !empty(cBeforeCode)
       // if the printer is ready
       IF p_ready(sls_prn(),nil,.f.)

         // turn screen off, printer on
         set console off
         set print on

         // send the code
         ??cBeforeCode

         // turn screen on printer off
         set console on
         set print off
       ELSE
          // if the printer isn't ready, well....set the global abort report
          // flag to true
         lAbortPrint := .t.
       ENDIF
    endif
elseif !lStart                          // passed as False means send
                                        // post-report codes
    // if it isn't empty
    if !empty(cAftCode)
       // if the printer is ready
       IF p_ready(sls_prn(),nil,.f.)

         // turn screen off, printer on
         set console off
         set print on

         // send the code
         ??cAftCode

         // turn screen on printer off
         set console on
         set print off
       ELSE
          // if the printer isn't ready, well....set the global abort report
          // flag to true
         lAbortPrint := .t.
       ENDIF
    endif
endif
return ''

//-------------------------------------------------------
//- this takes a numeric and turns it into a string
Static Function rNTrans(nValue)
local cValue                    // holds STR() of the numeric
local cPicture :=""             // we'll build this

cValue := STR(nValue)

IF "." $ cValue                 // decimal point?
  // build the before and after parts of the picture code
  cPicture := REPLICATE("9", AT(".", cValue) - 1) + "."
  cPicture := cPicture + REPLICATE("9", LEN(cValue) - LEN(cPicture))
ELSE
  // otherwise, just "9" times the length of the value
  cPicture := REPLICATE("9", LEN(cValue))
ENDIF
RETURN TRAN(nValue,cPicture)


Static func kbenter(r,c)
if r==24 .and. c>=2 .and. c<=5
  keyboard chr(13)
endif
return nil

