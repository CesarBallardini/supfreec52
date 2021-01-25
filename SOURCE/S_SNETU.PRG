
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SNET_USE()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  SNET_USE() Attempts to  open a DBF
ณ 
ณ  Returns:
ณ  --------
ณ  <lSuccess> => for success
ณ 
ณ  Syntax:
ณ  -------
ณ  SNET_USE(cDbfName,cAlias,lExclusive,nTries,lAskMore,cMoreMsg )
ณ 
ณ  Description:
ณ  ------------
ณ  Attempts to open a DBF file <cDbfName> with alias of
ณ  <cAlias>, opening EXCLUSIVE or NOT based on <lExclusive>. Tries
ณ  <nTries> times and then allows user to retry or not based on
ณ  <lAskMore> by giving message <cMoreMsg> and asking YES/NO.
ณ 
ณ  Examples:
ณ  ---------
ณ   IF SNET_USE("CUSTOMER.DBF","CUSTOMER",.F.,5,.T.,;
ณ     "Unable to open CUSTOMER.DBF. Try again?")
ณ       SET INDEX TO CUSTOMER,ACCTNO
ณ   ELSE
ณ       MSG("Unable to proceed, returning to menu")
ณ       loop
ณ   ENDIF
ณ 
ณ  Source:
ณ  -------
ณ  S_SNETU.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
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

