/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION POPEX()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  POPEX() Pops up an achoice for a certain filespec
ณ 
ณ  Returns:
ณ  --------
ณ  <cFileName> => file name or "" for none
ณ 
ณ  Syntax:
ณ  -------
ณ  POPEX(cSkel,[cTitle])
ณ 
ณ  Description:
ณ  ------------
ณ  Pops up a picklist for all files matching the
ณ  skeleton given as <cSkel>. i.e. "*.dbf"
ณ 
ณ  If a path is passed, the path is returned as part of
ณ  the filename.
ณ 
ณ  Optional title string [cTitle] - displays at top of
ณ  box
ณ 
ณ  Examples:
ณ  ---------
ณ   cOpendbf := POPEX("*.DBF")
ณ       // => will return DBF name
ณ 
ณ   opendbf = POPEX("C:\FILES\*.DBF")
ณ       // => will return "C:\FILES\" plus DBF name
ณ 
ณ  Source:
ณ  -------
ณ  S_POPEX.PRG
ณ 
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION popex(cSkeleton,cTitle)
local cReturn,nMatches,nTop,nBottom,nPopSize,nSelection,cSkelPath,cUnder
local nOldCursor,aPopDir,nCount

nOldCursor := setcursor(0)
cTitle     := iif(cTitle#nil,cTitle,"Select: ")
cReturn := ''
IF !EMPTY(cSkeleton)
  * if a path was specified, save it for return
  cSkelPath = stripskel(cSkeleton)
  IF (nCount := Adir(cSkeleton) ) > 0
    *-create an array to match the filespec
    aPopDir := array(nCount)
    Adir(cSkeleton,aPopDir)
    Asort(aPopDir)
    
    * determine box size and draw it
    nMatches := Adir(cSkeleton)
    nPopSize := ROUND(nMatches/2,0)
    nTop     := MAX(2, 12-nPopSize)
    nBottom  := MIN(22,13+nPopSize)
    
    
    cUnder=makebox(nTop,30,nBottom,50,sls_popcol())

    @nTop,31 SAY '['+LEFT(cTitle,16)+']'
    *- do the achoice to get the nSelection
    nSelection := SACHOICE(nTop+1,31,nBottom-1,49,aPopDir,nil,nil,nil,nBottom,43,{||kbdesc()})
    cReturn    := IIF(nSelection > 0,cSkelPath+aPopDir[nSelection],'')
    
    unbox(cUnder)
  ELSE
    cReturn = ''
  ENDIF
ENDIF

*- set cursor
SETCURSOR(nOldCursor)

*- return the nSelection
RETURN cReturn

*#09-24-1990 added this to return full path of file selected

static function stripskel(cFileSpec)
local nLenSpec,nIter,cOutSpec,cNextLetter
cOutSpec := ""
nLenSpec := len(cFileSpec)
for  nIter = nLenSpec  to 1 step -1
     cNextLetter  := subst(cFileSpec,nIter,1)
     if cNextLetter$"/\:"
       cOutSpec   := left(cFileSpec,nIter)
       exit
     endif
next
return cOutSpec



