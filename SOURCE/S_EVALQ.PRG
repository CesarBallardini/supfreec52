/*
�����������������������������������������������������������������
� FUNCTION EVALQ()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  EVALQ() Evaluates a logical condition in a string
� 
�  Returns:
�  --------
�  <lTrue> => result of evaluating condition
� 
�  Syntax:
�  -------
�  EVALQ(cCondition)
� 
�  Description:
�  ------------
�  Macro expands <cCondition> and returns logical result
� 
�  Examples:
�  ---------
�   locate for evalq( sls_query() )
� 
�  Notes:
�  -------
�  In Clipper 5.01, you're better off doing
�       bQueryblock := &("{||"+sls_query()+"}")
�       locate for eval(bQueryblock)
� 
�  You'll get close to a 100% speed improvement.
� 
�  Source:
�  -------
�  S_EVALQ.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION evalq(cCondition)
RETURN (&cCondition)