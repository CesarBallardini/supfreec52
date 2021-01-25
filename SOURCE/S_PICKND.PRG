/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION PICKNDX()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  PICKNDX() Allows user to select indexes to open
ณ 
ณ  Returns:
ณ  --------
ณ  <nSelected> => number of indexes selected
ณ 
ณ  Syntax:
ณ  -------
ณ  PICKNDX(aIndexes)
ณ 
ณ  Description:
ณ  ------------
ณ  Allows the user to point and shoot index selection.
ณ 
ณ  [aIndexes] is an array to fill with index names. It
ณ  can be of any size, including {}. It is set back to {}
ณ  before selection
ณ 
ณ  Examples:
ณ  ---------
ณ   aIndexes := {}
ณ   nPicked  := pickndx(aIndexes)
ณ 
ณ  Source:
ณ  -------
ณ  S_PICKND.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION pickndx(aIndexes)
local I
local bOldF10 := setkey(-9,{||kbdesc()})
local cPopbox,nThisPick,cIndexName,cThisKey
local cIndexExt := '*'+INDEXEXT()
local nFoundIndexes := adir(cIndexExt)
local aFoundIndexes := array(nFoundIndexes)

IF !VALTYPE(aIndexes)=="A" .OR. !used()
  if !used()
    msg("Database required")
  endif
  RETURN ''
ELSEIF nFoundIndexes==0
  msg("No Indexes found")
  return ''
ELSE
  asize(aIndexes,0)
ENDIF

Adir(cIndexExt,aFoundIndexes)
Asort(aFoundIndexes)

*- set up temp array for marking selected aIndexes
plswait(.T.,"Finding Indexes...")
for i = 1 TO nFoundIndexes
  aFoundIndexes[i] = padr(aFoundIndexes[i],12)+" key->>"+nkey(aFoundIndexes[i])
NEXT
plswait(.F.)


*- draw the box
cPopbox := makebox(1,10,17,60,sls_popcol())
@1,22 SAY  "  Select/Deselect Indices  "
@17,22 SAY "  [F10=Done]"
nThisPick := 1
DO WHILE .T.
  *- get a selection
  nThisPick := SACHOICE(2,11,16,59,aFoundIndexes,NIL,;
                 nThisPick,nil,17,11,{|r,c|iif(r=17.and.c>=24.and.c<=33,KBDESC(),nil)})
  IF nThisPick = 0
    EXIT
  ENDI
  *- if its not already marked, mark it
  IF LEFT(aFoundIndexes[nThisPick],2)<>"๛ "
    cIndexName := TRIM(LEFT(aFoundIndexes[nThisPick],12))
    
    *- get index key to test
    cThisKey := Alltrim(nkey(cIndexName))
    if !empty(cThisKey)
      IF !(TYPE(cThisKey)== "U" .OR. TYPE(cThisKey) == "UE")
        aadd(aIndexes, aFoundIndexes[nThisPick])
        aFoundIndexes[nThisPick] := '๛ '+aFoundIndexes[nThisPick]
      ELSE
        msg("That index either does not match the DBF","or this program does not support a function","in the index expression")
      ENDIF
    elseif messyn("Unable to verify index/dbf match. Open anyways?")
        aadd(aIndexes, aFoundIndexes[nThisPick])
        aFoundIndexes[nThisPick] := '๛ '+aFoundIndexes[nThisPick]
    endif
  ELSE
    aFoundIndexes[nThisPick] := SUBST(aFoundIndexes[nThisPick],3)
    adel(aIndexes, Ascan(aIndexes,aFoundIndexes[nThisPick]) )
    asize(aIndexes,len(aIndexes)-1)
  ENDIF
ENDDO
for i = 1 TO len(aIndexes)
  aIndexes[i] = TRIM(LEFT(aIndexes[i],12))
NEXT
setkey(-9,bOldF10)
unbox(cPopbox)
openind(aIndexes)
RETURN ''


