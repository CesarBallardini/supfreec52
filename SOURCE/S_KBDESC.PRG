/*
�����������������������������������������������������������������
� FUNCTION KBDESC()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  KBDESC() Keyboards character 27 (escape) when key pressed
� 
�  Returns:
�  --------
�  Nothing
� 
�  Syntax:
�  -------
�  SET KEY xxx TO KBDESC
� 
�  Description:
�  ------------
�  Allows setting an alternate key to the ESCAPE key.
�  ESCAPE normally means 'get me outta here', but sometimes is the
�  key you need to indicate the user is done selecting or some
�  such. This function allows setting another key (e.g. F10) to act
�  as the ESCAPE key.
� 
�  Examples:
�  ---------
�   SET KEY -9 TO KBDESC
� 
�  Warnings:
�  ----------
�  Be sure to issue a   SET KEY xxx TO   command to
�  un-map this function when done
� 
�  Notes:
�  -------
�  Declare as EXTERNAL i.e.
� 
�  EXTERNAL KBDESC
� 
�  Source:
�  -------
�  S_KBDESC.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION kbdesc
KEYBOARD CHR(27)
RETURN ''