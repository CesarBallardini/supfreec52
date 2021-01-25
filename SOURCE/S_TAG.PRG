
#include "inKey.ch"
#ifndef K_LBUTTONDOWN
 #define K_LBUTTONDOWN   1002   //   mouse left key press
 #define K_RBUTTONDOWN   1004   //   mouse right key press
#endif
#define K_MOUSELEFT K_LBUTTONDOWN
#define K_MOUSERIGHT K_RBUTTONDOWN
#define GOINGDOWN 1
#define GOINGUP   2
#define MAXTAG    1000
#ifndef K_SPACE
#define K_SPACE 32
#endif

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION TAGIT()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  TAGIT() Tag records in a dbf for later action
ณ 
ณ  Returns:
ณ  --------
ณ  <aTagged> => An array of tagged record numbers
ณ 
ณ  Syntax:
ณ  -------
ณ  TAGIT(aTagged,[aFields,aFieldDesc],[cTitle])
ณ 
ณ  Description:
ณ  ------------
ณ  <aTagged> is an array. To start, it is an empty array. It is both
ณ  modified by reference and returned as a parameter. It
ณ  is filled with the record numbers of tagged records. If it is not
ณ  empty when passed in, it is presumed to be filled with already tagged
ณ  record numbers.
ณ 
ณ  <aTagged> is always 'packed' on entry, so any empty()
ณ  or nil elements are removed, and the length adjusted.
ณ 
ณ  [aFields,aFieldDesc] are optional arrays of field
ณ  names and field descriptions.
ณ 
ณ  [cTitle] is an optional title for the tag popup.
ณ 
ณ  Examples:
ณ  ---------
ณ   aTag := {}
ณ   tagit(aTag,nil,nil,"Tag records to copy")
ณ   copy to temp for (ascan(aTag,recno()) > 0)
ณ 
ณ  Notes:
ณ  -------
ณ  There are slight differences in behavior from
ณ  previous versions.
ณ 
ณ  Previous versions required an array of fixed length,
ณ  and only allowed tagging up to that length. This version grows or
ณ  shrinks the array as needed. This version will also shrink an empty
ณ  array down to zero on startup.
ณ 
ณ  Source:
ณ  -------
ณ  S_TAG.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION tagit(aTagged, aFields, aFieldNames, cTitle)

local cTagScreen, nIterator
local oTb, nFoundTagged, nLastkey
local nTaggedRecords     := 0
local nOldCursor  := SETCURSOR(0)
local nIndexOrder := INDEXORD()
local nDirection  := GOINGDOWN
local nOnRecord, cLastkey
local bSearch, nThisRec, aTypes, aLens
local nCount, nScanned, bTag, bDisplay
local nMouseR, nMouseC, aButtons
local nButton := 0

*- look for the array aTagged[]
IF VALTYPE(aTagged)# "A"
  aTagged := {}
ENDIF
aPack(aTagged)
nTaggedRecords := LEN(aTagged)

*- build the field arrays if needed
IF !VALTYPE(aFields)=="A"
  aFields := array(fcount())
  aFieldNames:= array(fcount())
  Afields(aFields)
  Afields(aFieldNames)
ENDIF


*- draw the box
cTagScreen=makebox(4,5,22,75,sls_popcol())
IF cTitle#nil
  @4,6 SAY '['+cTitle+']'
ENDIF
@6,6 TO 6,74
@21,6 SAY "[][][][]  [space=TAG]  [C=CLEAR]  [F10=DONE]  [S=SEARCH]"
@20,6 TO 20,74
aButtons := {;
            {21,6,21,8,K_UP},;
            {21,9,21,11,K_DOWN},;
            {21,12,21,14,K_RIGHT},;
            {21,15,21,17,K_LEFT},;
            {21,20,21,30,K_SPACE},;
            {21,33,21,41,asc("C")},;
            {21,44,21,53,K_F10},;
            {21,56,21,65,asc("S")};
            }

*- build the tbrowse object
oTb := tbrowsedb(7,6,19,74)
oTb:colsep := "ณ"
oTb:headsep := chr(196)

*- add the tbcolumns
//oTb:addcolumn(TBColumnNew('Tag',{||iif(is_it_tag(recno(),aTagged) ,'๛   ','    ')} ))
oTb:addcolumn(TBColumnNew('Tag',{||iif((Ascan(aTagged,recno())> 0) ,'๛   ','    ')} ))
oTb:getcolumn(1):headsep := chr(196)
for nIterator := 1 to len(aFields)
   if isfield(aFields[nIterator])
    oTb:addcolumn(TBColumnNew( aFieldNames[nIterator],workblock(aFields[nIterator])))
   else
    oTb:addcolumn(TBColumnNew( aFieldNames[nIterator],expblock(aFields[nIterator])))
   endif
next

oTb:freeze  := 1

do while .t.
   while !oTb:stabilize()
   end
   @5,20 say padR( alltrim(str(nTaggedRecords))+" records tagged",30 )
   if deleted()
     @5,6 say "-=DELETED=-"
   ELSE
     @5,6 say "           "
   endif
   nButton := 0
   nMouseR := 0
   nMouseC := 0

   nLastKey := RAT_EVENT(0,.f.,.f.,@nMouseR, @nMouseC)
   cLastkey := upper(chr(nLastkey))
   if nLastKey==K_MOUSELEFT
     nButton := MOUSEHOTAT(nMouseR, nMouseC, aButtons)
     if nButton<>0
       cLastKey := upper(chr(nButton))
     endif
   endif

   DO CASE
   case nLastkey = K_UP .or. nButton==K_UP         && up one row
     oTb:up()
     nDirection := GOINGUP
     if nButton==K_UP
       IFMOUSEHD({||oTb:up()},oTb)
     endif
   case nLastkey = K_PGUP        && up one page
     oTb:pageUp()
     nDirection := GOINGUP
   case nLastkey = K_HOME        && home
     oTb:gotop()
     nDirection := GOINGDOWN
   case nLastkey = K_DOWN  .or. nButton==K_DOWN           && down one row
     oTb:down()
     nDirection := GOINGDOWN
     if nButton==K_DOWN
       IFMOUSEHD({||oTb:down()},oTb)
     endif
   case nLastkey = K_PGDN        && down one page
     oTb:pageDown()
     nDirection := GOINGDOWN
   case nLastkey = K_END         && end
     oTb:gobottom()
     nDirection := GOINGUP
   case nLastkey == K_LEFT  .or. nButton==K_LEFT          && left
     oTb:left()
     if nButton==K_LEFT
       IFMOUSEHD({||oTb:left()},oTb)
     endif
   case nLastkey == K_RIGHT  .or. nButton==K_RIGHT         && right
     oTb:right()
     if nButton==K_RIGHT
            IFMOUSEHD({||oTb:right()},oTb)
     endif
   CASE nLastkey = K_F10     .or. nButton==K_F10
     EXIT
   CASE nLastkey = K_SPACE  .or. nButton==K_SPACE
     *- look for record # in array
     nFoundTagged = Ascan(aTagged,recno())

     *- if there, remove it, else add it
     *- immediately say the results
     IF nFoundTagged > 0
       Adel(aTagged,nFoundTagged)
       nTaggedRecords--
       asize(aTagged,nTaggedRecords)
     ELSE
       nTaggedRecords++
       asize(aTagged,nTaggedRecords)
       AINS(aTagged,1)
       aTagged[1] := recno()
     ENDIF
     oTb:refreshcurrent()
     IF nDirection == GOINGUP
        oTb:up()
     ELSE
        oTb:down()
     ENDIF
   CASE cLastkey == "C"
     asize(aTagged,0)
     nTaggedRecords  := 0
     oTb:refreshall()
   CASE cLastkey == "S"
     SET ORDER TO 0
     SKIP 0
     if aTypes==nil
        aTypes := array(len(aFields))
        aLens  := array(len(aFields))
        FILLARR(aFields,aTypes,aLens)
     endif
     bSearch := searchme(aFields,aTypes,aLens,aFieldNames)
     if bSearch#nil .and. found()
       nThisRec := recno()
       if messyn("Tag all matching records?")
         amsg({"Maximum of",MAXTAG,"will be tagged"})
         dbgotop()
         nCount   := 0
         nScanned := 0
         bTag := {||IIF(nTaggedRecords< MAXTAG .AND. Ascan(aTagged,recno())==0 ,;
                 (nCount++,nTaggedRecords++,asize(aTagged,nTaggedRecords),;
                 AINS(aTagged,1),aTagged[1]:=recno()),nil)}
         bDisplay := {||alltrim(str(nCount))+" tagged of "+;
                        alltrim(str(nScanned++))+" scanned"}
         ProgEval(bTag,bSearch,"Tagging Matches",bDisplay,.t.)
       endif
       dbgoto(nThisRec)
     endif
     SET ORDER TO nIndexOrder
     oTb:refreshall()
   CASE nLastkey = 27
     exit
   CASE MBRZMOVE(oTb,nMouseR,nMouseC,7,6,19,74)
   CASE MBRZCLICK(oTb,nMouseR,nMouseC)
     keyboard " "
   ENDCASE
enddo
SETCURSOR(nOldCursor)
UNBOX(cTagScreen)
RETURN aTagged


static function apack(aIn)
local nStartlen := len(aIn)
local i
for i = 1 to len(aIn)
  if empty(aIn[i])
    asize(aIn,i-1)
    exit
  endif
next
return nil


