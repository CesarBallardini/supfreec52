
/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SLS_ISCOLOR()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³
³  Short:
³  ------
³ SLS_ISCOLOR() Tells SuperLib if this is a color monitor
³
³ Returns
³ <expSetting> => Current value of the setting
³
³ Syntax
³
³ SLS_ISCOLOR([lNew])        Is this a color monitor (useful for overriding
³                            Clipper's ISCOLOR() )
³
³ [lNew] optionally overrides the default
³
³ Examples
³
³  SLS_ISCOLOR(.F.)                // override ISCOLOR()
³
³ Notes:
³
³ Source: S_GLOBAL.PRG
³
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION SLS_ISCOLOR(lNew)
static lIsColor                 := nil
lIsColor := iif(liscolor==nil,iscolor(),lIsColor)
return (lIsColor := iif(lNew#nil,lNew,lIsColor) )

/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SLS_NORMCOL()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³
³  Short:
³  ------
³ SLS_NORMCOL() A Superlib color setting function
³
³ Returns
³ <cSetting> => Current value of the setting
³
³ Syntax
³ SLS_NORMCOL([cNew])
³
³ Function                   Setting                     Default
³ --------------------------------------------------------------
³ SLS_NORMCOL([cNew])        Normal screen output        'W/N,N/W,,,+W/N'
³
³ [cNew] sets the setting to a new setting
³ If [cNew] is passed, the setting is changed and the
³ new setting is returned.
³
³
³ Examples
³
³  SETCOLOR(sls_normcol()  )        // use to setcolor()
³
³ Notes:
³
³ Source: S_GLOBAL.PRG
³
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION SLS_NORMCOL(cNew)
static cMainColor               :=  'W/N,N/W,,,+W/N'
return (cMainColor := iif(cNew#nil,cNew,cMainColor) )


/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SLS_NORMMENU()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³
³  Short:
³  ------
³ SLS_NORMMENU() A Superlib color setting function
³
³ Returns
³ <cSetting> => Current value of the setting
³
³ Syntax
³ SLS_NORMMENU([cNew])
³
³ Function                   Setting                     Default
³ --------------------------------------------------------------
³ SLS_NORMMENU([cNew])       Normal MENU color           'W/N,N/W,,,+W/N'
³
³ [cNew] sets the setting to a new setting
³ If [cNew] is passed, the setting is changed and the
³ new setting is returned.
³
³
³ Examples
³
³  SETCOLOR(sls_NORMMENU()  )        // use to setcolor()
³
³ Notes:
³
³ Source: S_GLOBAL.PRG
³
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION SLS_NORMMENU(cNew)
static cMainMenuColor           :=  'W/N,N/W,,,+W/N'
return (cMainMenuColor := iif(cNew#nil,cNew,cMainMenuColor) )


/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SLS_POPCOL()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³
³  Short:
³  ------
³ SLS_POPCOL() A Superlib color setting function
³
³ Returns
³ <cSetting> => Current value of the setting
³
³ Syntax
³ SLS_POPCOL([cNew])
³
³ Function                   Setting                     Default
³ --------------------------------------------------------------
³ SLS_POPCOL([cNew])         Popup screen output         'N/W,+W/N,,,W/N'
³
³ [cNew] sets the setting to a new setting
³ If [cNew] is passed, the setting is changed and the
³ new setting is returned.
³
³
³ Examples
³
³  SETCOLOR(sls_POPCOL()  )        // use to setcolor()
³
³ Notes:
³
³ Source: S_GLOBAL.PRG
³
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION SLS_POPCOL(cNew)
static cPopupColor              :=  'N/W,+W/N,,,W/N'
return (cPopupColor := iif(cNew#nil,cNew,cPopupColor) )

/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SLS_POPMENU()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³
³  Short:
³  ------
³ SLS_POPMENU() A Superlib color setting function
³
³ Returns
³ <cSetting> => Current value of the setting
³
³ Syntax
³ SLS_POPMENU([cNew])
³
³ Function                   Setting                     Default
³ --------------------------------------------------------------
³ SLS_POPMENU([cNew])        Popup MENU color            'N/W,W/N,,,+W/N'
³
³ [cNew] sets the setting to a new setting
³ If [cNew] is passed, the setting is changed and the
³ new setting is returned.
³
³
³ Examples
³
³  SETCOLOR(sls_POPMENU()  )        // use to setcolor()
³
³ Notes:
³
³ Source: S_GLOBAL.PRG
³
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION SLS_POPMENU(cNew)
static cPopupMenuColor          :=  'N/W,W/N,,,+W/N'
return (cPopupMenuColor := iif(cNew#nil,cNew,cPopupMenuColor) )

/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SLS_FRAME()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³
³  Short:
³  ------
³ SLS_FRAME() A Superlib box setting function
³
³ Returns
³ <cSetting> => Current value of the setting
³
³ Syntax
³ SLS_FRAME([cNew])
³
³ Function                   Setting                     Default
³ --------------------------------------------------------------
³ SLS_FRAME([cNew])          Box frames                   single
³
³ [cNew] sets the setting to a new setting
³ If [cNew] is passed, the setting is changed and the
³ new setting is returned.
³
³
³ Examples
³  #include "Box.ch"
³  sls_FRAME(B_SINGLE+" ")
³
³ Notes:
³
³ Source: S_GLOBAL.PRG
³
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION SLS_FRAME(cNew)
static cFrameString             := "ΪΔΏ³ΩΔΐ³ "
return (cFrameString := iif(cNew#nil,cNew,cFrameString) )

/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SLS_SHADATT()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³
³  Short:
³  ------
³ SLS_SHADATT() A Superlib color setting function
³
³ Returns
³ <nSetting> => Current value of the setting
³
³ Syntax
³ SLS_SHADATT([nNew])
³
³ Function                   Setting                     Default
³ --------------------------------------------------------------
³ SLS_SHADATT([nNew])        Shadow attribute            8  (+N/N)
³
³ [nNew] sets the setting to a new setting
³ If [nNew] is passed, the setting is changed and the
³ new setting is returned.
³
³ Values are numeric color settings (see color chart)
³
³ Examples
³
³  SLS_SHADATT(127)        // shadow of +w/w
³
³ Notes:
³
³ Source: S_GLOBAL.PRG
³
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION SLS_SHADATT(nNew)
static nShadowAtt               := 8
return (nShadowAtt := iif(nNew#nil,nNew,nShadowAtt) )

/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SLS_SHADPOS()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³
³  Short:
³  ------
³ SLS_SHADPOS() A Superlib color setting function
³
³ Returns
³ <nSetting> => Current value of the setting
³
³ Syntax
³ SLS_SHADPOS([nNew])
³
³ Function                   Setting                     Default
³ --------------------------------------------------------------
³ SLS_SHADPOS([nNew])        Shadow position             1  (lower left)
³                            (uses numeric keypad
³                            as guide)
³                              7 upper left
³                              1 lower left
³                              3 lower right
³                              9 upper right
³                              0 none
³
³ [nNew] sets the setting to a new setting
³ If [nNew] is passed, the setting is changed and the
³ new setting is returned.
³
³
³ Examples
³
³  SLS_SHADPOS(0)        //  NO SHADOW
³
³ Notes:
³
³ Source: S_GLOBAL.PRG
³
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION SLS_SHADPOS(nNew)
static nShadowPos               := 1
return (nShadowPos := iif(nNew#nil,nNew,nShadowPos) )

/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SLS_XPLODE()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³
³  Short:
³  ------
³ SLS_XPLODE() A Superlib box setting function
³
³ Returns
³ <lSetting> => Current value of the setting
³
³ Syntax
³ SLS_XPLODE([lNew])
³
³ Function                   Setting                     Default
³ --------------------------------------------------------------
³ SLS_XPLODE([lNew])         Explode/implode popups      .T.
³
³ [lNew] sets the setting to a new setting
³ If [lNew] is passed, the setting is changed and the
³ new setting is returned.
³
³
³ Examples
³
³  SLS_XPLODE(.f.)        //  NO EXPLODING BOXES
³
³ Notes:
³
³ Source: S_GLOBAL.PRG
³
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION SLS_XPLODE(lNew)
static lExplodeBoxes            := .T.
return (lExplodeBoxes := iif(lNew#nil,lNew,lExplodeBoxes) )

/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SLS_PRN()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³
³  Short:
³  ------
³ SLS_PRN() A Superlib printer setting function
³
³ Returns
³ <cSetting> => Current value of the setting
³
³ Syntax
³ SLS_PRN([cNew])
³
³ Function                   Setting                     Default
³ --------------------------------------------------------------
³ SLS_PRN([cNew])            Default printer             'LPT1'
³
³ [cNew] sets the setting to a new setting
³ If [cNew] is passed, the setting is changed and the
³ new setting is returned.
³
³
³ Examples
³
³  SLS_PRN("LPT2")
³  SET PRINTER TO (SLS_PRN())
³
³ Notes:
³
³ Source: S_GLOBAL.PRG
³
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION SLS_PRN(cNew)
static cDefPrinter              := 'LPT1'
return (cDefPrinter := iif(cNew#nil,cNew,cDefPrinter) )

/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SLS_PRNC()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³
³  Short:
³  ------
³ SLS_PRNC() A Superlib printer setting function
³
³ Returns
³ <lSetting> => Current value of the setting
³
³ Syntax
³ SLS_PRNC([lNew])
³
³ Function                   Setting                     Default
³ --------------------------------------------------------------
³ SLS_PRNC([lNew])           Check printer ready         .T.
³                            (set to .f. on
³                            a network)
³ [lNew] sets the setting to a new setting
³ If [lNew] is passed, the setting is changed and the
³ new setting is returned.
³
³
³ Examples
³
³  SLS_PRNC(.f.)        //  DO NOT DO A HARDWARE PRINTER READY CHECK
³
³ Notes:
³
³ Source: S_GLOBAL.PRG
³
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION SLS_PRNC(lNew)
static lCheckPrnStat            := .T.
return (lCheckPrnStat := iif(lNew#nil,lNew,lCheckPrnStat) )

/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SLS_QUERY()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³
³  Short:
³  ------
³ SLS_QUERY() Sets SuperLib global query string
³
³ Returns
³ <cSetting> => Current value of the setting
³
³ Syntax
³ SLS_QUERY([cNew])
³
³ Function                   Setting                     Default
³ --------------------------------------------------------------
³ SLS_QUERY([cNew])          Query string                ''
³                            set by QUERY()
³
³ [cNew] sets the setting to a new setting
³ If [cNew] is passed, the setting is changed and the
³ new setting is returned.
³
³ THIS IS MAINLY FOR INTERNAL USE BY SUPERLIB
³
³ Examples
³
³  SLS_QUERY({||"R"$lname})
³
³ When using SLS_QUERY(), be sure to reset it to ""
³ when changing DBFs.
³
³ Source: S_GLOBAL.PRG
³
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION SLS_QUERY(cNew)
static cQueryExp                := ''
if cNew#nil
  if empty(cNew)
    SLS_BQZAP()
  else
    sls_bquery( &("{||"+cNew+"}") )
  endif
endif
return (cQueryExp := iif(cNew#nil,cNew,cQueryExp) )

/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SLS_BQUERY()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³
³  Short:
³  ------
³ SLS_BQUERY() Sets SuperLib global query block
³
³ Returns
³ <bSetting> => Current value of the setting
³
³ Syntax
³ SLS_BQUERY([bNew])
³
³ Function                   Setting                     Default
³ --------------------------------------------------------------
³ SLS_BQUERY([bNew])         Query codeblock            {||.t.}
³                            set by QUERY()
³
³ [bNew] sets the setting to a new setting
³ If [bNew] is passed, the setting is changed and the
³ new setting is returned.
³
³ THIS IS MAINLY FOR INTERNAL USE BY SUPERLIB
³
³ Examples
³
³  SLS_BQUERY({||"R"$lname})
³
³
³ Source: S_GLOBAL.PRG
³
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION SLS_BQUERY(bNew)
static bQueryBlock              := nil
if bQueryBlock==nil .and. bNew==nil
  if !empty(SLS_QUERY())
    bQueryBlock := &("{||"+sls_query()+"}")
  else
    bQueryBlock := {||.t.}
  endif
endif
return (bQueryBlock := iif(bNew#nil,bNew,bQueryBlock) )

/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION SLS_BQZAP()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³
³  Short:
³  ------
³ SLS_BQZAP() Resets SuperLib's global query block
³
³ Returns
³ nil
³
³ Syntax
³ SLS_BQZAP()
³
³ SLS_BQZAP() Resets SuperLib's global query block which is {||.t.}
³
³ THIS IS MAINLY FOR INTERNAL USE BY SUPERLIB
³
³ Examples
³
³ SLS_BQZAP()
³
³ Notes:
³
³ Source: S_GLOBAL.PRG
³
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
*/
FUNCTION SLS_BQZAP()
sls_bquery( {||.t.} )
return nil

