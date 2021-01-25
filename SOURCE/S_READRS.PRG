
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
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION PMREADER()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ 
ณ  Short:
ณ  ------
ณ  PMREADER() Creates specialized PLUS/MINUS get reader block
ณ 
ณ  Returns:
ณ  --------
ณ  <bReader> => get reader block for GET
ณ 
ณ  Syntax:
ณ  -------
ณ  PMREADER()
ณ 
ณ  Description:
ณ  ------------
ณ  Creates a get reader block that allows
ณ  increment/decrement of date of numeric values with the plus or minus key.
ณ 
ณ  Implement by using the SEND keyword for your
ณ  @Say..Get.. statements.
ณ 
ณ    i.e. @10,10 say blah get blahblah SEND reader:=PMREADER()
ณ 
ณ  Examples:
ณ  ---------
ณ   // while in the get V1, you will be able to use the +-  keys to
ณ   // increase/decrease the value of V1
ณ 
ณ   v1 := 100
ณ   @10,10 get v1 SEND reader := pmreader()
ณ   READ
ณ 
ณ  Source:
ณ  -------
ณ  S_READRS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function PMreader()
return {|g,nRmKey, aLmKeys, bLMouse|_pmreader(g,nRmKey, aLmKeys, bLMouse)}

//-----------------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SBREADER()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SBREADER() Creates specialized spacebar spinner get reader
ณ  block
ณ 
ณ  Returns:
ณ  --------
ณ  <bReader> => get reader block for GET
ณ 
ณ  Syntax:
ณ  -------
ณ  SBREADER(aValues)
ณ
ณ  Description:
ณ  ------------
ณ  Creates a get reader block that allows space bar to
ณ  rotate values from an array into the current get.
ณ 
ณ  Implement by using the SEND keyword for your
ณ  @Say..Get.. statements.
ณ 
ณ  i.e. @10,10 say blah get blahblah SEND ;
ณ                      reader:=SBREADER(aValues)
ณ 
ณ  <aValues> is an array of values that are of the same
ณ  type and length as the GET.
ณ 
ณ  Examples:
ณ  ---------
ณ   // while in the get V1, you will be able to use the spacebar to
ณ   // rotate values from the array
ณ 
ณ   aValues := {"Section 1","Section 2","Section 3"}
ณ   v1 := "Section 1"
ณ   @10,10 get v1 send reader := sbreader(aValues)
ณ   READ
ณ
ณ  Source:
ณ  -------
ณ  S_READRS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function SBreader(aValues)
return {|g,nRmKey, aLmKeys, bLMouse|_sbreader(g,aValues,nRmKey, aLmKeys, bLMouse)}

//-----------------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION YNREADER()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  YNREADER() Creates specialized Yes/No get reader block
ณ 
ณ  Returns:
ณ  --------
ณ  <bReader> => get reader block for logical GET
ณ 
ณ  Syntax:
ณ  -------
ณ  YNREADER()
ณ 
ณ  Description:
ณ  ------------
ณ  Creates a reader block that pops up a Yes/No window
ณ  to get the logical value for the current get.
ณ 
ณ  Implement by using the SEND keyword for your
ณ  @Say..Get.. statements.
ณ 
ณ  i.e. @10,10 say blah get blahblah SEND reader:=YNREADER()
ณ 
ณ  Use this on a LOGICAL get only.
ณ 
ณ  Examples:
ณ  ---------
ณ   // while in the get V1, a Yes/No window pops up for
ณ  logical selection
ณ 
ณ   v1 := .f.
ณ 
ณ   @10,10 get v1 send reader := ynreader()
ณ 
ณ   READ
ณ 
ณ  Source:
ณ  -------
ณ  S_READRS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function YNreader()
return {|g,nRmKey, aLmKeys, bLMouse|_ynreader(g,nRmKey, aLmKeys, bLMouse)}

//-----------------------------------------------------------------------
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION PICKREADER()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  PICKREADER() Creates specialized picklist reader block
ณ 
ณ  Returns:
ณ  --------
ณ  <bReader> => get reader block for GET
ณ 
ณ  Syntax:
ณ  -------
ณ  PICKREADER(aValues,[nTop,nLeft],[nBottom,nRight])
ณ 
ณ  Description:
ณ  ------------
ณ  Creates a get reader block that is a popup list from
ณ  the array <aValues>.
ณ 
ณ  Implement by using the SEND keyword for your
ณ  @Say..Get.. statements.
ณ 
ณ    i.e. @10,10 say blah get blahblah SEND reader:=PICKREADER(aValues)
ณ 
ณ  <aValues> is an array of values that are of the same
ณ  type and length as the GET.
ณ 
ณ  [nTop,nLeft] optional top, left coordinates
ณ
ณ  [nBottom,nRight] optional bottom/right coordinates
ณ 
ณ  Examples:
ณ  ---------
ณ   // while in the get V1, you will be presented with a picklist
ณ   // of aValues.
ณ 
ณ   aValues := {"Section 1","Section 2","Section 3"}
ณ   v1 := "Section 1"
ณ   @10,10 get v1 send reader := pickreader(aValues,10,10)
ณ 
ณ   READ
ณ 
ณ  Source:
ณ  -------
ณ  S_READRS.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
function pickreader(aPop,nTop,nLeft,nBottom,nRight)
return {|g,nRmKey, aLmKeys, bLMouse|;
        _pickreader(g,aPop,nTop,nLeft,nBottom,nRight,nRmKey, aLmKeys, bLMouse)}

//-----------------------------------------------------------------------

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION GENREADER()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ 
ณ  Short:
ณ  ------
ณ  GENREADER() Creates specialized user defined get reader block
ณ 
ณ 
ณ  Returns:
ณ  --------
ณ  <bReader> => get reader block for GET
ณ 
ณ  Syntax:
ณ  -------
ณ  GENREADER(bBlock,lPass)
ณ 
ณ  Description:
ณ  ------------
ณ  Creates a get reader block that first passes control
ณ  to code block <bBlock> for each keypress. <bBlock> is passed
ณ  the following values:
ณ
ณ       1. lastkey() value
ณ       2. proc name
ณ       3. var name
ณ       4. current get value
ณ 
ณ  If <bBlock> returns any value but a Nil, the get is
ณ  assigned this value. If a Nil is returned, and <lPass> is True,
ณ  then the key is passed to the regular get handler.
ณ 
ณ  Implement by using the SEND keyword for your
ณ  @Say..Get.. statements.
ณ
ณ    @10,10 say blah get blahblah SEND reader:=GENREADER(bBlock,lPass)
ณ 
ณ  Or simply refer to the last get added with ATAIL(getlist)
ณ
ณ    @10,10 say blah get blahlblah
ณ    ATAIL(getlist):reader := GENREADER(bBlock,lPass)
ณ 
ณ  Examples:
ณ  ---------
ณ   // while in the get V1, you will be able to type 1, 2 or 3
ณ   // to get a value from the array
ณ 
ณ   aValues := {"Section 1","Section 2","Section 3"}
ณ   bBlock  := ;
ณ        {  | k|  iif( (nAtk:=at(chr(k),"123")) >  0,aValues[nAtk],nil)  }
ณ 
ณ   v1 := "Section 1"
ณ   @10,10 get v1 send reader := genreader(bBlock)
ณ   READ
ณ
ณ  Source:
ณ  -------
ณ  S_READRS.PRG
ณ
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
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



