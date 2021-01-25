
/*
�����������������������������������������������������������������
� FUNCTION SNET_USE()
����������������������������������������������������������������� 
� 
�  Short:
�  ------
�  SNET_USE() Attempts to  open a DBF
� 
�  Returns:
�  --------
�  <lSuccess> => for success
� 
�  Syntax:
�  -------
�  SNET_USE(cDbfName,cAlias,lExclusive,nTries,lAskMore,cMoreMsg )
� 
�  Description:
�  ------------
�  Attempts to open a DBF file <cDbfName> with alias of
�  <cAlias>, opening EXCLUSIVE or NOT based on <lExclusive>. Tries
�  <nTries> times and then allows user to retry or not based on
�  <lAskMore> by giving message <cMoreMsg> and asking YES/NO.
� 
�  Examples:
�  ---------
�   IF SNET_USE("CUSTOMER.DBF","CUSTOMER",.F.,5,.T.,;
�     "Unable to open CUSTOMER.DBF. Try again?")
�       SET INDEX TO CUSTOMER,ACCTNO
�   ELSE
�       MSG("Unable to proceed, returning to menu")
�       loop
�   ENDIF
� 
�  Source:
�  -------
�  S_SNETU.PRG
� 
����������������������������������������������������������������� 
*/
FUNCTION SNET_USE(cDbfName, cAlias, lUseExclusive, nTries, lAsk, cMessage)
local nTriesOrig, lReturn
nTriesOrig := nTries
lReturn    := .f.
do while nTries > 0
        DBUSEAREA(nil,nil,cDbfName,cAlias,!lUseExclusive)
        if (.not. NETERR()) .and. USED()
           lReturn := .t.
           exit
        endif
        inkey(.5)
        nTries--
        if nTries = 0 .and. lAsk
          if messyn(cMessage)
            nTries := nTriesOrig
          endif
        endif
enddo
return lReturn
