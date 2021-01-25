/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION EVALQ()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  EVALQ() Evaluates a logical condition in a string
ณ 
ณ  Returns:
ณ  --------
ณ  <lTrue> => result of evaluating condition
ณ 
ณ  Syntax:
ณ  -------
ณ  EVALQ(cCondition)
ณ 
ณ  Description:
ณ  ------------
ณ  Macro expands <cCondition> and returns logical result
ณ 
ณ  Examples:
ณ  ---------
ณ   locate for evalq( sls_query() )
ณ 
ณ  Notes:
ณ  -------
ณ  In Clipper 5.01, you're better off doing
ณ       bQueryblock := &("{||"+sls_query()+"}")
ณ       locate for eval(bQueryblock)
ณ 
ณ  You'll get close to a 100% speed improvement.
ณ 
ณ  Source:
ณ  -------
ณ  S_EVALQ.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION evalq(cCondition)
RETURN (&cCondition)
