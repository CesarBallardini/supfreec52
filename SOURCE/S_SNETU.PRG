
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SNET_USE()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  SNET_USE() Attempts to  open a DBF
³ 
³  Returns:
³  --------
³  <lSuccess> => for success
³ 
³  Syntax:
³  -------
³  SNET_USE(cDbfName,cAlias,lExclusive,nTries,lAskMore,cMoreMsg )
³ 
³  Description:
³  ------------
³  Attempts to open a DBF file <cDbfName> with alias of
³  <cAlias>, opening EXCLUSIVE or NOT based on <lExclusive>. Tries
³  <nTries> times and then allows user to retry or not based on
³  <lAskMore> by giving message <cMoreMsg> and asking YES/NO.
³ 
³  Examples:
³  ---------
³   IF SNET_USE("CUSTOMER.DBF","CUSTOMER",.F.,5,.T.,;
³     "Unable to open CUSTOMER.DBF. Try again?")
³       SET INDEX TO CUSTOMER,ACCTNO
³   ELSE
³       MSG("Unable to proceed, returning to menu")
³       loop
³   ENDIF
³ 
³  Source:
³  -------
³  S_SNETU.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
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

