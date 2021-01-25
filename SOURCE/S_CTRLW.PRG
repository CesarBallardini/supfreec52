/*
�����������������������������������������������������������������
� FUNCTION CTRLW()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  CTRLW() Sends chr(23) (Control-W) to the keyboard
� 
�  Returns:
�  --------
�  Nothing
� 
�  Syntax:
�  -------
�  SET KEY XXX to CTRLW
� 
�  Description:
�  ------------
�  Allows remapping a key to Ctrl-W - a common Clipper
�  EXIT key. CTRL-W is not a really intuitive key, but is often
�  required by Clipper. I'll often set F10 to act as Ctrl-W.
� 
�  Examples:
�  ---------
�   EXTERNAL CTRLW
� 
�   SET KEY 27 to CTRLW  // remaps ESCAPE to CTRL-W
�   also
�   SETKEY(K_F10,{||ctrlw()})
� 
�  Notes:
�  -------
�  Declare as EXTERNAL i.e. EXTERNAL CTRLW
� 
�  Source:
�  -------
�  S_CTRLW.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION ctrlw
KEYBOARD CHR(23)
RETURN ''