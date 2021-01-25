/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION NBR2STR()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  NBR2STR() Correctly orders numerics where negative
ณ 
ณ  Returns:
ณ  --------
ณ  String
ณ 
ณ  Syntax:
ณ  -------
ณ  NBR2STR(nNumber)
ณ 
ณ  Description:
ณ  ------------
ณ  Ensure numeric fields are correctly ordered when
ณ  converting to type character and when taking negatives into account.
ณ 
ณ  This is done by attaching CR, DB or CZ to the end of
ณ  the number to overcome the placement of (-+) in the ASCII scale.
ณ 
ณ  Examples:
ณ  ---------
ณ   index on LASTNAME+NBR2STR(amount_due) to NEWINDEX
ณ 
ณ  Source:
ณ  -------
ณ  S_NBR2ST.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
*FUNCTION nbr2str(nNumber)
*RETURN TRANS(nNumber,"@CX")+IIF(nNumber=0," CZ","")
*--- the above was incorrect
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION NBR2STR()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  NBR2STR() Correctly orders numerics where negative
ณ 
ณ  Returns:
ณ  --------
ณ  String
ณ 
ณ  Syntax:
ณ  -------
ณ  NBR2STR(nNumber)
ณ 
ณ  Description:
ณ  ------------
ณ  Ensure numeric fields are correctly ordered when
ณ  converting to type character and when taking negatives into account.
ณ 
ณ  This is done by attaching CR, DB or CZ to the end of
ณ  the number to overcome the placement of (-+) in the ASCII scale.
ณ 
ณ  Examples:
ณ  ---------
ณ   index on LASTNAME+NBR2STR(amount_due) to NEWINDEX
ณ 
ณ  Source:
ณ  -------
ณ  S_NBR2ST.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION nbr2str(nNumber)
RETURN TRANS(1000000000000+nNumber,"")

