/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION NBR2STR()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  NBR2STR() Correctly orders numerics where negative
³ 
³  Returns:
³  --------
³  String
³ 
³  Syntax:
³  -------
³  NBR2STR(nNumber)
³ 
³  Description:
³  ------------
³  Ensure numeric fields are correctly ordered when
³  converting to type character and when taking negatives into account.
³ 
³  This is done by attaching CR, DB or CZ to the end of
³  the number to overcome the placement of (-+) in the ASCII scale.
³ 
³  Examples:
³  ---------
³   index on LASTNAME+NBR2STR(amount_due) to NEWINDEX
³ 
³  Source:
³  -------
³  S_NBR2ST.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
*FUNCTION nbr2str(nNumber)
*RETURN TRANS(nNumber,"@CX")+IIF(nNumber=0," CZ","")
*--- the above was incorrect
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION NBR2STR()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  NBR2STR() Correctly orders numerics where negative
³ 
³  Returns:
³  --------
³  String
³ 
³  Syntax:
³  -------
³  NBR2STR(nNumber)
³ 
³  Description:
³  ------------
³  Ensure numeric fields are correctly ordered when
³  converting to type character and when taking negatives into account.
³ 
³  This is done by attaching CR, DB or CZ to the end of
³  the number to overcome the placement of (-+) in the ASCII scale.
³ 
³  Examples:
³  ---------
³   index on LASTNAME+NBR2STR(amount_due) to NEWINDEX
³ 
³  Source:
³  -------
³  S_NBR2ST.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION nbr2str(nNumber)
RETURN TRANS(1000000000000+nNumber,"")

