
//------------------------------------------------------------------------
#include "getexit.ch"
#include "inKey.ch"
#ifndef K_LBUTTONDOWN
 #define K_LBUTTONDOWN   1002   //   mouse left key press
 #define K_RBUTTONDOWN   1004   //   mouse right key press
#endif
#define K_MOUSELEFT K_LBUTTONDOWN
#define K_MOUSERIGHT K_RBUTTONDOWN
#define K_PLUS  43
#define K_MINUS 45
#ifndef K_SPACE
#define K_SPACE 32
#endif



//-----------------------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION PMREADER()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ 
³  Short:
³  ------
³  PMREADER() Creates specialized PLUS/MINUS get reader block
³ 
³  Returns:
³  --------
³  <bReader> => get reader block for GET
³ 
³  Syntax:
³  -------
³  PMREADER()
³ 
³  Description:
³  ------------
³  Creates a get reader block that allows
³  increment/decrement of date of numeric values with the plus or minus key.
³ 
³  Implement by using the SEND keyword for your
³  @Say..Get.. statements.
³ 
³    i.e. @10,10 say blah get blahblah SEND reader:=PMREADER()
³ 
³  Examples:
³  ---------
³   // while in the get V1, you will be able to use the +-  keys to
³   // increase/decrease the value of V1
³ 
³   v1 := 100
³   @10,10 get v1 SEND reader := pmreader()
³   READ
³ 
³  Source:
³  -------
³  S_READRS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
function PMreader()
return {|g,nRmKey, aLmKeys, bLMouse|_pmreader(g,nRmKey, aLmKeys, bLMouse)}

//-----------------------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SBREADER()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SBREADER() Creates specialized spacebar spinner get reader
³  block
³ 
³  Returns:
³  --------
³  <bReader> => get reader block for GET
³ 
³  Syntax:
³  -------
³  SBREADER(aValues)
³
³  Description:
³  ------------
³  Creates a get reader block that allows space bar to
³  rotate values from an array into the current get.
³ 
³  Implement by using the SEND keyword for your
³  @Say..Get.. statements.
³ 
³  i.e. @10,10 say blah get blahblah SEND ;
³                      reader:=SBREADER(aValues)
³ 
³  <aValues> is an array of values that are of the same
³  type and length as the GET.
³ 
³  Examples:
³  ---------
³   // while in the get V1, you will be able to use the spacebar to
³   // rotate values from the array
³ 
³   aValues := {"Section 1","Section 2","Section 3"}
³   v1 := "Section 1"
³   @10,10 get v1 send reader := sbreader(aValues)
³   READ
³
³  Source:
³  -------
³  S_READRS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
function SBreader(aValues)
return {|g,nRmKey, aLmKeys, bLMouse|_sbreader(g,aValues,nRmKey, aLmKeys, bLMouse)}

//-----------------------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION YNREADER()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  YNREADER() Creates specialized Yes/No get reader block
³ 
³  Returns:
³  --------
³  <bReader> => get reader block for logical GET
³ 
³  Syntax:
³  -------
³  YNREADER()
³ 
³  Description:
³  ------------
³  Creates a reader block that pops up a Yes/No window
³  to get the logical value for the current get.
³ 
³  Implement by using the SEND keyword for your
³  @Say..Get.. statements.
³ 
³  i.e. @10,10 say blah get blahblah SEND reader:=YNREADER()
³ 
³  Use this on a LOGICAL get only.
³ 
³  Examples:
³  ---------
³   // while in the get V1, a Yes/No window pops up for
³  logical selection
³ 
³   v1 := .f.
³ 
³   @10,10 get v1 send reader := ynreader()
³ 
³   READ
³ 
³  Source:
³  -------
³  S_READRS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
function YNreader()
return {|g,nRmKey, aLmKeys, bLMouse|_ynreader(g,nRmKey, aLmKeys, bLMouse)}

//-----------------------------------------------------------------------
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION PICKREADER()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  PICKREADER() Creates specialized picklist reader block
³ 
³  Returns:
³  --------
³  <bReader> => get reader block for GET
³ 
³  Syntax:
³  -------
³  PICKREADER(aValues,[nTop,nLeft],[nBottom,nRight])
³ 
³  Description:
³  ------------
³  Creates a get reader block that is a popup list from
³  the array <aValues>.
³ 
³  Implement by using the SEND keyword for your
³  @Say..Get.. statements.
³ 
³    i.e. @10,10 say blah get blahblah SEND reader:=PICKREADER(aValues)
³ 
³  <aValues> is an array of values that are of the same
³  type and length as the GET.
³ 
³  [nTop,nLeft] optional top, left coordinates
³
³  [nBottom,nRight] optional bottom/right coordinates
³ 
³  Examples:
³  ---------
³   // while in the get V1, you will be presented with a picklist
³   // of aValues.
³ 
³   aValues := {"Section 1","Section 2","Section 3"}
³   v1 := "Section 1"
³   @10,10 get v1 send reader := pickreader(aValues,10,10)
³ 
³   READ
³ 
³  Source:
³  -------
³  S_READRS.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
function pickreader(aPop,nTop,nLeft,nBottom,nRight)
return {|g,nRmKey, aLmKeys, bLMouse|;
        _pickreader(g,aPop,nTop,nLeft,nBottom,nRight,nRmKey, aLmKeys, bLMouse)}

//-----------------------------------------------------------------------

/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION GENREADER()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ 
³  Short:
³  ------
³  GENREADER() Creates specialized user defined get reader block
³ 
³ 
³  Returns:
³  --------
³  <bReader> => get reader block for GET
³ 
³  Syntax:
³  -------
³  GENREADER(bBlock,lPass)
³ 
³  Description:
³  ------------
³  Creates a get reader block that first passes control
³  to code block <bBlock> for each keypress. <bBlock> is passed
³  the following values:
³
³       1. lastkey() value
³       2. proc name
³       3. var name
³       4. current get value
³ 
³  If <bBlock> returns any value but a Nil, the get is
³  assigned this value. If a Nil is returned, and <lPass> is True,
³  then the key is passed to the regular get handler.
³ 
³  Implement by using the SEND keyword for your
³  @Say..Get.. statements.
³
³    @10,10 say blah get blahblah SEND reader:=GENREADER(bBlock,lPass)
³ 
³  Or simply refer to the last get added with ATAIL(getlist)
³
³    @10,10 say blah get blahlblah
³    ATAIL(getlist):reader := GENREADER(bBlock,lPass)
³ 
³  Examples:
³  ---------
³   // while in the get V1, you will be able to type 1, 2 or 3
³   // to get a value from the array
³ 
³   aValues := {"Section 1","Section 2","Section 3"}
³   bBlock  := ;
³        {  | k|  iif( (nAtk:=at(chr(k),"123")) >  0,aValues[nAtk],nil)  }
³ 
³   v1 := "Section 1"
³   @10,10 get v1 send reader := genreader(bBlock)
³   READ
³
³  Source:
³  -------
³  S_READRS.PRG
³
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
function genReader(bBlock, lPass)  // generic reader
return {|g,nRmKey, aLmKeys, bLMouse|_genreader(g,bBlock,lPass,nRmKey, aLmKeys, bLMouse) }
//-----------------------------------------------------------------------

static function _PMReader( oGet,nRmKey, aLmKeys, bLMouse )  // PLUS/MINUS reader
local nLastKey, nMouseR, nMouseC
local nJump := 0
local lRatRead := (R_ISRATREAD())
local nHotAt
if ( iif(lRatRead,RatPrevalidate(oGet),GetPreValidate(oGet)) )
  oGet:SetFocus()
  while ( oGet:exitState == GE_NOEXIT )
    if ( oGet:typeOut )
            oGet:exitState := GE_ENTER
    endif
    while ( oGet:exitState == GE_NOEXIT )
         nLastKey := rat_event(0,.f.)
         nMouseR := rat_eqmrow()
         nMouseC := rat_eqmcol()

         if aLmKeys#nil .and. nLastKey==K_MOUSELEFT .and. ;
           (nHotAt := MOUSEHOTAT(nMouseR, nMouseC, aLmKeys)) # 0
            nLastKey := nHotAt
         endif

         do case
         case nLastkey == K_PLUS .and. oGet:type=="N"
           oGet:varput(val(oGet:buffer)+1)
           oGet:updatebuffer()
           oGet:display()
         case nLastkey == K_MINUS .and. oGet:type=="N"
           oGet:varput(val(oGet:buffer)-1)
           oGet:updatebuffer()
           oGet:display()
         case nLastkey == K_PLUS .and. oGet:type=="D"
           if empty(oGet:varget())
             oGet:varput(date())
           else
             oGet:varput(ctod(oGet:buffer)+1)
           endif
           oGet:updatebuffer()
           oGet:display()
         case nLastkey == K_MINUS .and. oGet:type=="D"
           if empty(oGet:varget())
             oGet:varput(date())
           else
             oGet:varput(ctod(oGet:buffer)-1)
           endif
           oGet:updatebuffer()
           oGet:display()
         case nLastKey==K_MOUSELEFT
            if nMouseR==oGet:row .and. nMouseC>=oGet:col .and. nMouseC<= ;
               oGet:col+len(trans(oGet:varget(),oGet:picture))-1
               while (oGet:col-1+oGet:pos) < nMouseC .and. !oGet:typeout
                 oGet:right()
                 oGet:display()
               end
               while (oGet:col-1+oGet:pos) > nMouseC .and. !oGet:typeout
                 oGet:left()
                 oGet:display()
               end
            elseif (nJump := GETJUMP2(nMouseR, nMouseC)) > 0
                  oGet:exitState := GE_ENTER
            elseif bLMouse#nil
                eval(bLMouse,nMouseR,nMouseC)
            endif
         case nLAstKey==K_MOUSERIGHT .and. nRmKey#nil
            iif(lRatRead,RatApplyKey(oGet,nRmKey),GetApplyKey(oGet,nRmKey))
         otherwise
            iif(lRatRead,RatApplyKey(oGet,nLastKey),GetApplyKey(oGet,nLastKey))
         endcase
         IF (   iif(lRatRead,RatKill(),.f.)        )
            oGet:exitState := GE_ESCAPE
         ENDIF
    end
    if ( !iif(lRatRead,RatPostvalidate(oGet),GetPostValidate(oGet))  )
            oGet:exitState := GE_NOEXIT
            nJump := 0
    endif
  end
  oGet:KillFocus()
endif
return nJump

//-------------------------------------------------------------------
static function _sbReader( oGet,aValues,nRmKey, aLmKeys, bLMouse )  // space bar reader
local nStart
local nLastKey, nMouseR, nMouseC
local nJump := 0
local lRatRead := (R_ISRATREAD())
LOCAL nHotAt
if ( iif(lRatRead,RatPrevalidate(oGet),GetPreValidate(oGet)) )
  oGet:SetFocus()
  nStart := max(1,ascan(aValues,oGet:varget()) )
  while ( oGet:exitState == GE_NOEXIT )
    if ( oGet:typeOut )
            oGet:exitState := GE_ENTER
    endif
    while ( oGet:exitState == GE_NOEXIT )
         nLastKey := rat_event(0,.f.)
         nMouseR := rat_eqmrow()
         nMouseC := rat_eqmcol()

         if aLmKeys#nil .and. nLastKey==K_MOUSELEFT .and. ;
           (nHotAt := MOUSEHOTAT(nMouseR, nMouseC, aLmKeys)) # 0
            nLastKey := nHotAt
         endif

         do case
         case nLastkey == K_SPACE .and. aValues#nil
           if nStart = len(aValues)
             nStart := 1
           else
             nStart++
           endif
           if valtype(aValues[nStart])==oGet:type
             if oGet:type$"LDN"
               oGet:varput(aValues[nStart])
               oGet:updatebuffer()
               oGet:display()
             else
               oGet:buffer := padr(aValues[nStart],len(oGet:buffer))
               oGet:assign()
               oGet:display()
             endif
           endif
         case nLastKey==K_MOUSELEFT
            if nMouseR==oGet:row .and. nMouseC>=oGet:col .and. nMouseC<= ;
               oGet:col+len(trans(oGet:varget(),oGet:picture))-1
               while (oGet:col-1+oGet:pos) < nMouseC .and. !oGet:typeout
                 oGet:right()
                 oGet:display()
               end
               while (oGet:col-1+oGet:pos) > nMouseC .and. !oGet:typeout
                 oGet:left()
                 oGet:display()
               end
            elseif (nJump := GETJUMP2(nMouseR, nMouseC)) > 0
                  oGet:exitState := GE_ENTER
            elseif bLMouse#nil
                eval(bLMouse,nMouseR,nMouseC)
            endif
         case nLAstKey==K_MOUSERIGHT .and. nRmKey#nil
            iif(lRatRead,RatApplyKey(oGet,nRmKey),GetApplyKey(oGet,nRmKey))
         otherwise
            iif(lRatRead,RatApplyKey(oGet,nLastKey),GetApplyKey(oGet,nLastKey))
         endcase
         IF (   iif(lRatRead,RatKill(),.f.)        )
            oGet:exitState := GE_ESCAPE
         ENDIF
    end
    if ( !iif(lRatRead,RatPostvalidate(oGet),GetPostValidate(oGet))  )
            oGet:exitState := GE_NOEXIT
            nJump := 0
    endif
  end
  oGet:KillFocus()
endif
return nJump

//-------------------------------------------------------------------
static function _ynReader( oGet,nRmKey, aLmKeys, bLMouse)  // yn reader
local nTop:= oGet:row,nLeft:= oGet:col
local cBox
local nYesNo := iif(oGet:varget(),1,2)
local nInExit := oGet:exitstate
local nLastKey, nMouseR, nMouseC, nHotAt
local nJump := 0
local lRatRead := (R_ISRATREAD())
if nInExit == GE_DOWN
  nInExit := GE_ENTER
endif
while nLeft +4 > maxcol()
  nLeft--
end
while nTop + 3 > maxrow()
  nTop--
end
if ( iif(lRatRead,RatPrevalidate(oGet),GetPreValidate(oGet)) )
  oGet:SetFocus()
  while ( oGet:exitState == GE_NOEXIT )
    if ( oGet:typeOut )
            oGet:exitState := GE_ENTER
    endif
    cBox := makebox(nTop,nLeft,nTop+3,nLeft+4)
    @nTop+1,nLeft+1 prompt "Yes"
    @nTop+2,nLeft+1 prompt "No "
    nYesNo := RAT_MENU2({{nTop+1,nLeft+1,"Yes"},{nTop+2,nLEft+1,"No"} } )
    unbox(cBox)
    if !lastkey()=27
      oGet:varput(iif(nYesNo==1,.t.,.f.))
      oGet:updatebuffer()
      oGet:display()
    endif
    oGet:exitstate := nInExit
    if ( !iif(lRatRead,RatPostvalidate(oGet),GetPostValidate(oGet))  )
            oGet:exitState := GE_NOEXIT
    endif
    IF (   iif(lRatRead,RatKill(),.f.)        )
       oGet:exitState := GE_ESCAPE
    ENDIF
  end
  oGet:KillFocus()
endif
return nJump

//-------------------------------------------------------------------
static function _genReader( oGet,bBlock, lPass,nRmKey, aLmKeys, bLMouse)  // generic reader
local expReturn
local nLastKey, nMouseR, nMouseC, nHotAt
local nJump := 0
local lRatRead := (R_ISRATREAD())
lPass   := iif(lPass#nil,lPass,.t.)
if ( iif(lRatRead,RatPrevalidate(oGet),GetPreValidate(oGet)) )
  oGet:SetFocus()
  while ( oGet:exitState == GE_NOEXIT )
    if ( oGet:typeOut )
            oGet:exitState := GE_ENTER
    endif
    while ( oGet:exitState == GE_NOEXIT )
         nLastKey := rat_event(0,.f.)
         nMouseR := rat_eqmrow()
         nMouseC := rat_eqmcol()
         oGet:assign()
         if aLmKeys#nil .and. nLastKey==K_MOUSELEFT .and. ;
           (nHotAt := MOUSEHOTAT(nMouseR, nMouseC, aLmKeys)) # 0
            nLastKey := nHotAt
         endif
         do case
         case (expReturn := eval(bBlock,nLastkey,procname(3),readvar(),oGet:varget() ) )#nil
              if valtype(expReturn)==oGet:type
                if oGet:type$"LDN"
                  oGet:varput(expReturn)
                  oGet:updatebuffer()
                  oGet:display()
                else
                  oGet:home()
                  oGet:buffer := padr(expReturn,len(oGet:buffer))
                  oGet:display()
                  oGet:assign()
                  oGet:end()
                endif
              endif
         case nLastKey==K_MOUSELEFT
            if nMouseR==oGet:row .and. nMouseC>=oGet:col .and. nMouseC<= ;
               oGet:col+len(trans(oGet:varget(),oGet:picture))-1
               while (oGet:col-1+oGet:pos) < nMouseC .and. !oGet:typeout
                 oGet:right()
                 oGet:display()
               end
               while (oGet:col-1+oGet:pos) > nMouseC .and. !oGet:typeout
                 oGet:left()
                 oGet:display()
               end
            elseif (nJump := GETJUMP2(nMouseR, nMouseC)) > 0
                  oGet:exitState := GE_ENTER
            elseif bLMouse#nil
                eval(bLMouse,nMouseR,nMouseC)
            endif
         case nLAstKey==K_MOUSERIGHT .and. nRmKey#nil
            iif(lRatRead,RatApplyKey(oGet,nRmKey),GetApplyKey(oGet,nRmKey))
         otherwise
           if lPass
              iif(lRatRead,RatApplyKey(oGet,nLastKey),GetApplyKey(oGet,nLastKey))
           elseif nLastkey==K_ESC
             oGet:exitstate := GE_ESCAPE
           endif
         endcase
         IF (   iif(lRatRead,RatKill(),.f.)        )
            oGet:exitState := GE_ESCAPE
         ENDIF
    end
    if ( !iif(lRatRead,RatPostvalidate(oGet),GetPostValidate(oGet)) )
            oGet:exitState := GE_NOEXIT
            nJump := 0
    endif
  end
  oGet:KillFocus()
endif
return nJump

//-------------------------------------------------------------------
static function _pickreader( oGet,aPop,nTop,nLeft,nBottom,nRight,;
                             nRmKey, aLmKeys, bLMouse)
local nInExit := oGet:exitstate
local expReturn,nReturn
local lRatRead := (R_ISRATREAD())
if nInExit == GE_DOWN
  nInExit := GE_ENTER
endif
nReturn := ascan(aPop,oGet:varget())
if ( iif(lRatRead,RatPrevalidate(oGet),GetPreValidate(oGet)) )
  oGet:SetFocus()
  while ( oGet:exitState == GE_NOEXIT )
    if ( oGet:typeOut )
            oGet:exitState := GE_ENTER
    endif

    if (nReturn := mchoice(aPop,nTop,nLeft,nBottom,nRight,nil,nil,nReturn) ) > 0
      expReturn := aPop[nReturn]
      if valtype(expReturn)==oGet:type
        if oGet:type$"LDN"
          oGet:varput(expReturn)
          oGet:updatebuffer()
          oGet:display()
        else
          oGet:home()
          oGet:buffer := padr(expReturn,len(oGet:buffer))
          oGet:display()
          oGet:assign()
          oGet:end()
        endif
      endif
    endif

    IF (   iif(lRatRead,RatKill(),.f.)        )
       oGet:exitState := GE_ESCAPE
    ELSE
      oGet:exitstate := nInExit
      if ( !iif(lRatRead,RatPostvalidate(oGet),GetPostValidate(oGet))  )
            oGet:exitState := GE_NOEXIT
      endif
    ENDIF
  end
  oGet:KillFocus()
endif
return 0



