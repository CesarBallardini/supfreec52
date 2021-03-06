/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION EVALQ()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  EVALQ() Evaluates a logical condition in a string
³ 
³  Returns:
³  --------
³  <lTrue> => result of evaluating condition
³ 
³  Syntax:
³  -------
³  EVALQ(cCondition)
³ 
³  Description:
³  ------------
³  Macro expands <cCondition> and returns logical result
³ 
³  Examples:
³  ---------
³   locate for evalq( sls_query() )
³ 
³  Notes:
³  -------
³  In Clipper 5.01, you're better off doing
³       bQueryblock := &("{||"+sls_query()+"}")
³       locate for eval(bQueryblock)
³ 
³  You'll get close to a 100% speed improvement.
³ 
³  Source:
³  -------
³  S_EVALQ.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION evalq(cCondition)
RETURN (&cCondition)
