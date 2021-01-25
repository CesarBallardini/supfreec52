/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION OPENIND()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  OPENIND() Opens an array of indexes
ณ 
ณ  Returns:
ณ  --------
ณ  Nothing
ณ 
ณ  Syntax:
ณ  -------
ณ  OPENIND(aIndexNames)
ณ 
ณ  Description:
ณ  ------------
ณ  Opens up the indexes named in <aIndexNames>
ณ 
ณ  Examples:
ณ  ---------
ณ   aIndexes := {"CUSTOMER","PRODUCT","PAYDATE"}
ณ 
ณ   OPENIND(aIndexes)
ณ 
ณ  Source:
ณ  -------
ณ  S_OPENIN.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
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
