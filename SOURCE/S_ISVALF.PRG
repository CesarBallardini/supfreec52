/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION ISVALFILE()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  ISVALFILE() Checks a file name for validity
³ 
³  Returns:
³  --------
³  <lValid> => is file name a valid dos file name
³ 
³  Syntax:
³  -------
³  ISVALFILE(cName,[lCheckDup],[@cMessage])
³ 
³  Description:
³  ------------
³  Checks the proposed file name in <cName> for
³  adherance to the dos file naming conventions.
³ 
³  [lCheckDup] will check for existance of the file if
³  True. Default False.
³ 
³  [@cMessage] a string passed by reference. The reason
³  for rejection will be placed in the string. Messages returned
³  are:
³ 
³    "File name is empty"
³    "Duplicate file exists"
³    "File name is too long"
³    "Too many periods"
³    "Too many characters after the period"
³    "Too many characters before the period"
³    "Too many characters with no period"
³    "Invalid character: " (character)
³    "Illegal file name"
³ 
³  Examples:
³  ---------
³ 
³   cFn := space(15)
³ 
³   while .t.
³     cMessage := ""
³     @10,10 get cFn
³     read
³     @20,10 say iif(isvalfile(cFn,.t.,@cMessage),"Valid  ","Not Valid")
³     @21,10 say padr(cMessage,50)
³   end
³ 
³  Source:
³  -------
³  S_ISVALF.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION ISVALFILE(cName,lCheckDup,cMessage)
local lValid := .t.
lCheckDup := iif(lCheckDup#nil,lCheckDup,.f.)
cMessage  := ""
do case
case  empty(cName)
  lValid := .f.
  cMessage := "File name is empty"
case !allowed(cName,@cMessage)
  lValid := .f.
case lCheckDup .and. file(cName)
  lValid := .f.
  cMessage := "Duplicate file exists"
endcase
return lValid



static function allowed(cName,cMessage)
local lAllowed := .t.
local cAllowed := "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_^$~!#%&-{}()@'`."
local nChar

cName := upper(alltrim(cName))
while .t.
  if len(trim(cName)) > 12
    lAllowed := .f.
    cMessage := "File name is too long"
    exit
  elseif "."$cName
    if at(".", strtran(cName,".","",1,1) )> 0
      // double dots
      lAllowed := .f.
      cMessage := "Too many periods"
      exit
    elseif len( subst(cName,at(".",cName)) ) > 4
      // too many characters after the period
      lAllowed := .f.
      cMessage := "Too many characters after the period"
      exit
    elseif len(subst(cName,1,at(".",cName)-1)) > 8
      lAllowed := .f.
      cMessage := "Too many characters before the period"
      exit
    elseif at(".",cName)==1
      lAllowed := .f.
      cMessage := "File name has extension only - needs prefix"
      exit
    endif
  elseif !"."$cName .and. len(cName) > 8
      lAllowed := .f.
      cMessage := "Too many characters with no period"
      exit
  endif
  for nChar = 1 to len(cName)
   if !subst(cName,nChar,1)$cAllowed
     lAllowed := .f.
     cMessage := "Invalid character: "+subst(cName,nChar,1)
     exit
   endif
  next
  if cName=="CLOCK$" .or. cName=="CON" .or. cName=="AUX" .or. cName=="COM1" ;
    .or. cName=="COM2" .or. cName=="COM3" .or. cName == "COM4" ;
    .or. cName=="LPT1" .or. cName=="LPT2" .or. cName == "LPT3" ;
    .or. cName=="NUL" .or. cName=="PRN2"
    lAllowed := .f.
    cMessage := "Illegal file name"
  ENDIF
  exit
end
return lAllowed
