
#include "inKey.ch"
#ifndef K_LBUTTONDOWN
 #define K_LBUTTONDOWN   1002   //   mouse left key press
 #define K_RBUTTONDOWN   1004   //   mouse right key press
#endif
#define K_MOUSELEFT K_LBUTTONDOWN
#define K_MOUSERIGHT K_RBUTTONDOWN
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION POPUPDIR()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  POPUPDIR() Popup of a given directory for file selection
³ 
³  Returns:
³  --------
³  <cFileName> => name of the file selected
³ 
³  Syntax:
³  -------
³  POPUPDIR([cSpec,cAttrib,cTitle,cColor,lAllowView])
³ 
³  Description:
³  ------------
³  Displays a popup of the directory specified, for
³  selection of a file.
³ 
³  The name of the file selected is returned. You may
³  indicate optional file viewing.
³ 
³  [cSpec] specifies the drive, directory and file
³  specification
³ 
³  Wildcards are allowed. Default is "*.*", current
³  drive, current dir.
³ 
³  [cAttrib] is a string containing file attribute
³  symbols for inclusion of special file types. The symbols are:
³ 
³     H                     Include hidden files
³     S                     Include system files
³     D                     Include directories
³     V                     Search for the DOS volume label and exclude
³                           all other files
³ 
³  [cTitle] a string to be displayed on the top of the
³  popup box. Default is
³ 
³  "Directory Viewer"
³ 
³  [cColor] color of the box. Default is sls_normcol()
³ 
³  [lAllowView]  if True, allows Alt-V to view the
³  currently highlited file. A DBF is browsed, a text file is viewed with
³  FILEREAD().
³ 
³  Default is False.
³ 
³  Examples:
³  ---------
³   cFileName := POPUPDIR("c:\windows\*.INI",nil,nil,nil,.t.)
³ 
³  Source:
³  -------
³  S_POPDIR.PRG
³ 
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION POPUPDIR(cSpec,cAttributes,cTitle,cColor,lAllowView)
local aDirectory := DIRECTORY((cSpec:=IIF(cSpec#nil,cSpec,"*.*")),cAttributes)
local nElement := 1
local nLastkey, nMouseR, nMouseC, aButtons,nButton
local cBox
local oTb
local cFile := ""
local cPath := iif("\"$cSpec,SUBST(cSpec,1,RAT("\",cSpec)),"")
local lClick

if len(aDirectory) > 0
   dispbegin()
   cTitle := iif(cTitle#nil,cTitle,"Directory Viewer")
   cColor := iif(cColor#nil,cColor,SLS_NORMCOL())
   lAllowView := iif(lAllowView#nil,lAllowView,.f.)
   cBox := makebox(2,2,23,78,cColor)
   oTb := tbrowseNew(3,3,19,77)
   @20,3 to 20,77
   oTb:addcolumn(tbColumnNew("File",{||padr(aDirectory[nElement,1],13)}  ))
   oTb:addcolumn(tbColumnNew("",{||iif("D"$aDirectory[nElement,5],"<DIR>","     ")}  ))
   oTb:addcolumn(tbColumnNew("Size",{||iif("D"$aDirectory[nElement,5],space(10),padl(aDirectory[nElement,2],10))}  ))
   oTb:addcolumn(tbColumnNew("Date",{||aDirectory[nElement,3]}  ))
   oTb:addcolumn(tbColumnNew("Time",{||aDirectory[nElement,4]}  ))
   oTb:SKIPBLOCK := {|n|AASKIP(n,@nElement,LEN(aDirectory))}
   oTb:gobottomblock := {||nElement := len(aDirectory)}
   oTb:gotopblock    := {||nElement := 1}
   oTb:headsep       := chr(196)


   @2,3 say cTitle
   @22,3 SAY "[][][][]  [Enter=select]   [Escape=abort]   "+;
                  iif(lAllowView,"[Alt-V to view file]","")
   abuttons := {{22,17,22,30,K_ENTER},{22,34,22,47,K_ESC}}
   if lAllowView
     aadd(aButtons,{22,51,22,70,K_ALT_V})
   endif
   dispend()
   while .t.
     @21,3 say padc("DIRECTORY:"+cSpec,75) color cColor
     while !oTb:stabilize()
     end
     nMouseR := 0; nMouseC := 0
     nLastKey := rat_event(0,.f.,.f.,@nMouseR,@nMouseC)
     nButton := MOUSEHOTAT(nMouseR, nMouseC, aButtons)
     lClick  := MBRZCLICK(oTb,nMouseR, nMouseC)
     do case
     CASE nLastKey = K_UP          && UP ONE ROW
       oTb:UP()
     CASE nLastKey = K_PGUP        && UP ONE PAGE
       oTb:PAGEUP()
     CASE nLastKey = K_LEFT        && UP ONE ROW
       oTb:left()
     CASE nLastKey = K_RIGHT       && UP ONE PAGE
       oTb:right()
     CASE nLastKey = K_HOME        && HOME
       oTb:GOTOP()
     CASE nLastKey = K_DOWN        && DOWN ONE ROW
       oTb:DOWN()
     CASE nLastKey = K_PGDN        && DOWN ONE PAGE
       oTb:PAGEdOWN()
     CASE nLastKey = K_END         && END
       oTb:GOBOTTOM()
     case nLastkey == K_ENTER .or. nbutton==K_ENTER  .or. lClick
       cFile := aDirectory[nElement,1]
       exit
     case nLastkey == K_ESC  .or. nButton==K_ESC
       EXIT
     case (nLastkey == K_ALT_V  .or. nbutton==K_ALT_V) .and. lAllowView  // view
       pdviewit(cPath+aDirectory[nElement,1] )
     case ISMOUSEAT(nMouseR, nMouseC, 22, 3, 22,5)
         oTb:up()
         IFMOUSEHD({||oTb:up()},oTB)
     case ISMOUSEAT(nMouseR, nMouseC, 22, 6, 22,8)
         oTb:down()
         IFMOUSEHD({||oTb:down()},oTB)
     case ISMOUSEAT(nMouseR, nMouseC, 22, 9,22,11)
         oTb:right()
         IFMOUSEHD({||oTb:right()},oTB)
     case ISMOUSEAT(nMouseR, nMouseC, 22,12,22,14)
         oTb:left()
         IFMOUSEHD({||oTb:left()},oTB)
     CASE MBRZMOVE(oTb,nMouseR,nMouseC,5,3,19,77)
     endcase
   end
   unbox(cBox)
endif
return cFile
//--------------------------------------------------------------
static function pdviewit(cFileName)
local cBox
local nSelect := SELECT()
select 0
IF ('.DBF' $ cFileName)
  *- check for arbitrary amount of available memory
  *- change this higher or lower, based on your own best guess <g>
  IF MEMORY(0) > 20
    IF SELECT( strip_path(cFilename,.t.) ) > 0  // check for already open
        msg("That file is in use , cannot re-open")
    elseIF SNET_USE(cFileName,"ADBF",.f.,5,.t.,"Unable to open file . Try again?")
        cBox := makebox(2,2,23,78)
        EDITDB(.f.,nil,nil,.t.,.t.)
        USE
        unbox(cBox)
    endif
  ELSE
    MSG("Insufficient memory to read the dbf file")
  ENDIF
ELSEIF ('.NTX' $ cFileName) .OR. ('.NDX' $ cFileName)
  msg("Index key for "+cFileName+" is :",nkey(cFileName))
ELSEIF !(('.EXE' $ cFileName) .OR. ('.COM' $ cFileName).OR.('.SYS' $ cFileName)  )
  Fileread(2,2,23,78,cFileName)
ENDIF
SELECT (nSelect)
RETURN nil


