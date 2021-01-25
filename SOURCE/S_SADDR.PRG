/*
�����������������������������������������������������������������
� FUNCTION SADD_REC()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SADD_REC() Attempts to append a blank record
� 
�  Returns:
�  --------
�  <lSuccess> => success
� 
�  Syntax:
�  -------
�  SADD_REC([nTries],[lAskMore],[cAskMessage])
� 
�  Description:
�  ------------
�  Attempts to append a blank record. Tries [nTries]
�  times and then allows user to retry or not if [lAskMore] by
�  giving message [cAskMessage] and asking YES/NO.
� 
�  Examples:
�  ---------
�   IF SADD_REC(5,.T.,"Unable to ADD,Try again?")
� 
�       IF SREC_LOCK(5,.T.,"Unable to lock, Try again?")
�         REPLACE XXX WITH YYY, ZZZ WITH BBB
�         UNLOCK
�       ENDIF
�   ENDIF
� 
�  Source:
�  -------
�  S_SADDR.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION Sadd_rec(nTries, lAskMore, cAskMessage)
local nOrigTries, lReturn
nTries      := iif(nTries#nil,nTries,5)
lAskMore    := iif(lAskMore#nil,lAskMore,.f. )
cAskMessage := iif(cAskMessage#nil,cAskMessage,"Unable to add. Keep trying?" )
nOrigTries  := nTries
lReturn     := .f.
WHILE nTries > 0
      APPEND BLANK
      if !NETERR()
         lReturn := .t.
         exit
      endif
      nTries--
      if nTries = 0 .and. lAskMore
        if messyn(cAskMessage)
          nTries := nOrigTries
        endif
      else
        inkey(.5)
      endif
ENDDO
RETURN lReturn

