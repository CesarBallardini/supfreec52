/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SETEXACT()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SETEXACT() Determines if exact is on/off
³ 
³  Returns:
³  --------
³  <lExact> => Exact is on/off
³ 
³  Syntax:
³  -------
³  SETEXACT([lNew])
³ 
³  Description:
³  ------------
³  Returns current SET EXACT setting and optionally sets
³  exact on/off with [lNew]  .t. = ON .f. = OFF
³ 
³  Examples:
³  ---------
³   nOldexact = SETEXACT(.f.) // SET EXACT OFF
³ 
³   * code
³ 
³   SETEXACT(nOldexact)
³ 
³  Source:
³  -------
³  S_SETEX.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION SETEXACT(lExact)
return SET(_SET_EXACT,lExact)
