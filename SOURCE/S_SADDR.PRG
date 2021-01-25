/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SADD_REC()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SADD_REC() Attempts to append a blank record
ณ 
ณ  Returns:
ณ  --------
ณ  <lSuccess> => success
ณ 
ณ  Syntax:
ณ  -------
ณ  SADD_REC([nTries],[lAskMore],[cAskMessage])
ณ 
ณ  Description:
ณ  ------------
ณ  Attempts to append a blank record. Tries [nTries]
ณ  times and then allows user to retry or not if [lAskMore] by
ณ  giving message [cAskMessage] and asking YES/NO.
ณ 
ณ  Examples:
ณ  ---------
ณ   IF SADD_REC(5,.T.,"Unable to ADD,Try again?")
ณ 
ณ       IF SREC_LOCK(5,.T.,"Unable to lock, Try again?")
ณ         REPLACE XXX WITH YYY, ZZZ WITH BBB
ณ         UNLOCK
ณ       ENDIF
ณ   ENDIF
ณ 
ณ  Source:
ณ  -------
ณ  S_SADDR.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
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


