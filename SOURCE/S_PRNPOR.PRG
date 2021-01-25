/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION PRNPORT()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  PRNPORT() Determine Printer Port to use
ณ 
ณ  Returns:
ณ  --------
ณ  <cPort> => port chosen
ณ
ณ  Syntax:
ณ  -------
ณ  PRNPORT([cPort1],[cPort2]..[cPort9])
ณ 
ณ  Description:
ณ  ------------
ณ  Allows user to select printer port for SET PRINTER TO
ณ  output. Printer is set to this port
ณ
ณ  [cPort1-9] are valid SET PRINTER TO strings
ณ
ณ  LPT1 LPT2 LPT3 COM1 COM2 COM3 COM4 <FILENAME>
ณ
ณ  Default is "LPT1","LPT2","LPT3"
ณ
ณ  Examples:
ณ  ---------
ณ   cTheport := PRNPORT("LPT1","COM1")
ณ
ณ  Source:
ณ  -------
ณ  S_PRNPOR.PRG
ณ
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
*/
FUNCTION prnport(dev1,dev2,dev3,dev4,dev5,dev6,dev7,dev8,dev9)
local cDevice,cUnder,nTop,nBottom,nIter,nSelection
local aDevSet := {}
local aPrompts := {}
local cDeviceNow := upper(set(_SET_PRINTFILE))
if "."$cDeviceNow
  cDeviceNow := left(cDeviceNow,at(".",cDeviceNow)-1 )
endif
if pcount() > 0
  aDevSet := prnpset(dev1,dev2,dev3,dev4,dev5,dev6,dev7,dev8,dev9)
endif
if len(aDevset)=0
  aDevset := {"LPT1","LPT2","LPT3"}
endif
nSelection := 0
nTop    :=8
nBottom :=nTop+len(aDevset)+1
cUnder  := makebox(nTop,30,nBottom,46,sls_popcol())
cDevice := "LPT1"
@nTop,32 SAY '[Printer Port]'
for nIter = 1 TO len(aDevset)
  aadd(aPrompts,{nTop+nIter,34,aDevset[nIter]} )
  if cDeviceNow == aDevSet[nIter]
       nSelection := nIter
  endif
NEXT
nSelection := RAT_MENU2(aPrompts,nSelection)
IF nSelection > 0
  SET PRINTER TO (aDevset[nSelection])
  sls_prn(aDevset[nSelection])
ELSE
  SET PRINTER TO
ENDIF
unbox(cUnder)
RETURN ( sls_prn() )

static FUNCTION PRNPSET(dev1,dev2,dev3,dev4,dev5,dev6,dev7,dev8,dev9)
local aDevset := {dev1,dev2,dev3,dev4,dev5,dev6,dev7,dev8,dev9}
while atail(aDevset)==nil .and. len(aDevset)>0
  asize(aDevset,len(aDevset)-1)
end
return aDevset

*: EOF: S_PRNPOR.PRG

