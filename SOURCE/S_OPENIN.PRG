/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION OPENIND()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  OPENIND() Opens an array of indexes
³ 
³  Returns:
³  --------
³  Nothing
³ 
³  Syntax:
³  -------
³  OPENIND(aIndexNames)
³ 
³  Description:
³  ------------
³  Opens up the indexes named in <aIndexNames>
³ 
³  Examples:
³  ---------
³   aIndexes := {"CUSTOMER","PRODUCT","PAYDATE"}
³ 
³   OPENIND(aIndexes)
³ 
³  Source:
³  -------
³  S_OPENIN.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION openind(aIndexes)
local aOpenInd := array(15)
LOCAL nIndexLen,nIter
nIndexLen   := aleng(aIndexes)
IF nIndexLen=0
  RETURN ''
ENDIF
Afill(aOpenInd,"")
for nIter = 1 TO nIndexLen
  IF EMPTY(aIndexes[nIter])
    EXIT
  ENDIF
  aOpenInd[nIter]=aIndexes[nIter]
NEXT
SET INDEX TO (aOpenInd[1]),(aOpenInd[2]),(aOpenInd[3]),(aOpenInd[4]),(aOpenInd[5]),(aOpenInd[6]),(aOpenInd[7]),(aOpenInd[8]),(aOpenInd[9]),(aOpenInd[10]),(aOpenInd[11]),(aOpenInd[12]),(aOpenInd[13]),(aOpenInd[14]),(aOpenInd[15])
RETURN ''
*: EOF: S_OPENIN.PRG
