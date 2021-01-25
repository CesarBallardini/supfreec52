
/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SLS_ISCOLOR()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ
ณ  Short:
ณ  ------
ณ SLS_ISCOLOR() Tells SuperLib if this is a color monitor
ณ
ณ Returns
ณ <expSetting> => Current value of the setting
ณ
ณ Syntax
ณ
ณ SLS_ISCOLOR([lNew])        Is this a color monitor (useful for overriding
ณ                            Clipper's ISCOLOR() )
ณ
ณ [lNew] optionally overrides the default
ณ
ณ Examples
ณ
ณ  SLS_ISCOLOR(.F.)                // override ISCOLOR()
ณ
ณ Notes:
ณ
ณ Source: S_GLOBAL.PRG
ณ
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION SLS_ISCOLOR(lNew)
static lIsColor                 := nil
lIsColor := iif(liscolor==nil,iscolor(),lIsColor)
return (lIsColor := iif(lNew#nil,lNew,lIsColor) )

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SLS_NORMCOL()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ
ณ  Short:
ณ  ------
ณ SLS_NORMCOL() A Superlib color setting function
ณ
ณ Returns
ณ <cSetting> => Current value of the setting
ณ
ณ Syntax
ณ SLS_NORMCOL([cNew])
ณ
ณ Function                   Setting                     Default
ณ --------------------------------------------------------------
ณ SLS_NORMCOL([cNew])        Normal screen output        'W/N,N/W,,,+W/N'
ณ
ณ [cNew] sets the setting to a new setting
ณ If [cNew] is passed, the setting is changed and the
ณ new setting is returned.
ณ
ณ
ณ Examples
ณ
ณ  SETCOLOR(sls_normcol()  )        // use to setcolor()
ณ
ณ Notes:
ณ
ณ Source: S_GLOBAL.PRG
ณ
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION SLS_NORMCOL(cNew)
static cMainColor               :=  'W/N,N/W,,,+W/N'
return (cMainColor := iif(cNew#nil,cNew,cMainColor) )


/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SLS_NORMMENU()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ
ณ  Short:
ณ  ------
ณ SLS_NORMMENU() A Superlib color setting function
ณ
ณ Returns
ณ <cSetting> => Current value of the setting
ณ
ณ Syntax
ณ SLS_NORMMENU([cNew])
ณ
ณ Function                   Setting                     Default
ณ --------------------------------------------------------------
ณ SLS_NORMMENU([cNew])       Normal MENU color           'W/N,N/W,,,+W/N'
ณ
ณ [cNew] sets the setting to a new setting
ณ If [cNew] is passed, the setting is changed and the
ณ new setting is returned.
ณ
ณ
ณ Examples
ณ
ณ  SETCOLOR(sls_NORMMENU()  )        // use to setcolor()
ณ
ณ Notes:
ณ
ณ Source: S_GLOBAL.PRG
ณ
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION SLS_NORMMENU(cNew)
static cMainMenuColor           :=  'W/N,N/W,,,+W/N'
return (cMainMenuColor := iif(cNew#nil,cNew,cMainMenuColor) )


/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SLS_POPCOL()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ
ณ  Short:
ณ  ------
ณ SLS_POPCOL() A Superlib color setting function
ณ
ณ Returns
ณ <cSetting> => Current value of the setting
ณ
ณ Syntax
ณ SLS_POPCOL([cNew])
ณ
ณ Function                   Setting                     Default
ณ --------------------------------------------------------------
ณ SLS_POPCOL([cNew])         Popup screen output         'N/W,+W/N,,,W/N'
ณ
ณ [cNew] sets the setting to a new setting
ณ If [cNew] is passed, the setting is changed and the
ณ new setting is returned.
ณ
ณ
ณ Examples
ณ
ณ  SETCOLOR(sls_POPCOL()  )        // use to setcolor()
ณ
ณ Notes:
ณ
ณ Source: S_GLOBAL.PRG
ณ
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION SLS_POPCOL(cNew)
static cPopupColor              :=  'N/W,+W/N,,,W/N'
return (cPopupColor := iif(cNew#nil,cNew,cPopupColor) )

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SLS_POPMENU()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ
ณ  Short:
ณ  ------
ณ SLS_POPMENU() A Superlib color setting function
ณ
ณ Returns
ณ <cSetting> => Current value of the setting
ณ
ณ Syntax
ณ SLS_POPMENU([cNew])
ณ
ณ Function                   Setting                     Default
ณ --------------------------------------------------------------
ณ SLS_POPMENU([cNew])        Popup MENU color            'N/W,W/N,,,+W/N'
ณ
ณ [cNew] sets the setting to a new setting
ณ If [cNew] is passed, the setting is changed and the
ณ new setting is returned.
ณ
ณ
ณ Examples
ณ
ณ  SETCOLOR(sls_POPMENU()  )        // use to setcolor()
ณ
ณ Notes:
ณ
ณ Source: S_GLOBAL.PRG
ณ
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION SLS_POPMENU(cNew)
static cPopupMenuColor          :=  'N/W,W/N,,,+W/N'
return (cPopupMenuColor := iif(cNew#nil,cNew,cPopupMenuColor) )

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SLS_FRAME()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ
ณ  Short:
ณ  ------
ณ SLS_FRAME() A Superlib box setting function
ณ
ณ Returns
ณ <cSetting> => Current value of the setting
ณ
ณ Syntax
ณ SLS_FRAME([cNew])
ณ
ณ Function                   Setting                     Default
ณ --------------------------------------------------------------
ณ SLS_FRAME([cNew])          Box frames                   single
ณ
ณ [cNew] sets the setting to a new setting
ณ If [cNew] is passed, the setting is changed and the
ณ new setting is returned.
ณ
ณ
ณ Examples
ณ  #include "Box.ch"
ณ  sls_FRAME(B_SINGLE+" ")
ณ
ณ Notes:
ณ
ณ Source: S_GLOBAL.PRG
ณ
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION SLS_FRAME(cNew)
static cFrameString             := "ฺฤฟณูฤภณ "
return (cFrameString := iif(cNew#nil,cNew,cFrameString) )

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SLS_SHADATT()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ
ณ  Short:
ณ  ------
ณ SLS_SHADATT() A Superlib color setting function
ณ
ณ Returns
ณ <nSetting> => Current value of the setting
ณ
ณ Syntax
ณ SLS_SHADATT([nNew])
ณ
ณ Function                   Setting                     Default
ณ --------------------------------------------------------------
ณ SLS_SHADATT([nNew])        Shadow attribute            8  (+N/N)
ณ
ณ [nNew] sets the setting to a new setting
ณ If [nNew] is passed, the setting is changed and the
ณ new setting is returned.
ณ
ณ Values are numeric color settings (see color chart)
ณ
ณ Examples
ณ
ณ  SLS_SHADATT(127)        // shadow of +w/w
ณ
ณ Notes:
ณ
ณ Source: S_GLOBAL.PRG
ณ
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION SLS_SHADATT(nNew)
static nShadowAtt               := 8
return (nShadowAtt := iif(nNew#nil,nNew,nShadowAtt) )

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SLS_SHADPOS()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ
ณ  Short:
ณ  ------
ณ SLS_SHADPOS() A Superlib color setting function
ณ
ณ Returns
ณ <nSetting> => Current value of the setting
ณ
ณ Syntax
ณ SLS_SHADPOS([nNew])
ณ
ณ Function                   Setting                     Default
ณ --------------------------------------------------------------
ณ SLS_SHADPOS([nNew])        Shadow position             1  (lower left)
ณ                            (uses numeric keypad
ณ                            as guide)
ณ                              7 upper left
ณ                              1 lower left
ณ                              3 lower right
ณ                              9 upper right
ณ                              0 none
ณ
ณ [nNew] sets the setting to a new setting
ณ If [nNew] is passed, the setting is changed and the
ณ new setting is returned.
ณ
ณ
ณ Examples
ณ
ณ  SLS_SHADPOS(0)        //  NO SHADOW
ณ
ณ Notes:
ณ
ณ Source: S_GLOBAL.PRG
ณ
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION SLS_SHADPOS(nNew)
static nShadowPos               := 1
return (nShadowPos := iif(nNew#nil,nNew,nShadowPos) )

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SLS_XPLODE()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ
ณ  Short:
ณ  ------
ณ SLS_XPLODE() A Superlib box setting function
ณ
ณ Returns
ณ <lSetting> => Current value of the setting
ณ
ณ Syntax
ณ SLS_XPLODE([lNew])
ณ
ณ Function                   Setting                     Default
ณ --------------------------------------------------------------
ณ SLS_XPLODE([lNew])         Explode/implode popups      .T.
ณ
ณ [lNew] sets the setting to a new setting
ณ If [lNew] is passed, the setting is changed and the
ณ new setting is returned.
ณ
ณ
ณ Examples
ณ
ณ  SLS_XPLODE(.f.)        //  NO EXPLODING BOXES
ณ
ณ Notes:
ณ
ณ Source: S_GLOBAL.PRG
ณ
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION SLS_XPLODE(lNew)
static lExplodeBoxes            := .T.
return (lExplodeBoxes := iif(lNew#nil,lNew,lExplodeBoxes) )

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SLS_PRN()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ
ณ  Short:
ณ  ------
ณ SLS_PRN() A Superlib printer setting function
ณ
ณ Returns
ณ <cSetting> => Current value of the setting
ณ
ณ Syntax
ณ SLS_PRN([cNew])
ณ
ณ Function                   Setting                     Default
ณ --------------------------------------------------------------
ณ SLS_PRN([cNew])            Default printer             'LPT1'
ณ
ณ [cNew] sets the setting to a new setting
ณ If [cNew] is passed, the setting is changed and the
ณ new setting is returned.
ณ
ณ
ณ Examples
ณ
ณ  SLS_PRN("LPT2")
ณ  SET PRINTER TO (SLS_PRN())
ณ
ณ Notes:
ณ
ณ Source: S_GLOBAL.PRG
ณ
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION SLS_PRN(cNew)
static cDefPrinter              := 'LPT1'
return (cDefPrinter := iif(cNew#nil,cNew,cDefPrinter) )

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SLS_PRNC()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ
ณ  Short:
ณ  ------
ณ SLS_PRNC() A Superlib printer setting function
ณ
ณ Returns
ณ <lSetting> => Current value of the setting
ณ
ณ Syntax
ณ SLS_PRNC([lNew])
ณ
ณ Function                   Setting                     Default
ณ --------------------------------------------------------------
ณ SLS_PRNC([lNew])           Check printer ready         .T.
ณ                            (set to .f. on
ณ                            a network)
ณ [lNew] sets the setting to a new setting
ณ If [lNew] is passed, the setting is changed and the
ณ new setting is returned.
ณ
ณ
ณ Examples
ณ
ณ  SLS_PRNC(.f.)        //  DO NOT DO A HARDWARE PRINTER READY CHECK
ณ
ณ Notes:
ณ
ณ Source: S_GLOBAL.PRG
ณ
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION SLS_PRNC(lNew)
static lCheckPrnStat            := .T.
return (lCheckPrnStat := iif(lNew#nil,lNew,lCheckPrnStat) )

/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SLS_QUERY()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ
ณ  Short:
ณ  ------
ณ SLS_QUERY() Sets SuperLib global query string
ณ
ณ Returns
ณ <cSetting> => Current value of the setting
ณ
ณ Syntax
ณ SLS_QUERY([cNew])
ณ
ณ Function                   Setting                     Default
ณ --------------------------------------------------------------
ณ SLS_QUERY([cNew])          Query string                ''
ณ                            set by QUERY()
ณ
ณ [cNew] sets the setting to a new setting
ณ If [cNew] is passed, the setting is changed and the
ณ new setting is returned.
ณ
ณ THIS IS MAINLY FOR INTERNAL USE BY SUPERLIB
ณ
ณ Examples
ณ
ณ  SLS_QUERY({||"R"$lname})
ณ
ณ When using SLS_QUERY(), be sure to reset it to ""
ณ when changing DBFs.
ณ
ณ Source: S_GLOBAL.PRG
ณ
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
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
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SLS_BQUERY()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ
ณ  Short:
ณ  ------
ณ SLS_BQUERY() Sets SuperLib global query block
ณ
ณ Returns
ณ <bSetting> => Current value of the setting
ณ
ณ Syntax
ณ SLS_BQUERY([bNew])
ณ
ณ Function                   Setting                     Default
ณ --------------------------------------------------------------
ณ SLS_BQUERY([bNew])         Query codeblock            {||.t.}
ณ                            set by QUERY()
ณ
ณ [bNew] sets the setting to a new setting
ณ If [bNew] is passed, the setting is changed and the
ณ new setting is returned.
ณ
ณ THIS IS MAINLY FOR INTERNAL USE BY SUPERLIB
ณ
ณ Examples
ณ
ณ  SLS_BQUERY({||"R"$lname})
ณ
ณ
ณ Source: S_GLOBAL.PRG
ณ
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
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
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION SLS_BQZAP()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ
ณ  Short:
ณ  ------
ณ SLS_BQZAP() Resets SuperLib's global query block
ณ
ณ Returns
ณ nil
ณ
ณ Syntax
ณ SLS_BQZAP()
ณ
ณ SLS_BQZAP() Resets SuperLib's global query block which is {||.t.}
ณ
ณ THIS IS MAINLY FOR INTERNAL USE BY SUPERLIB
ณ
ณ Examples
ณ
ณ SLS_BQZAP()
ณ
ณ Notes:
ณ
ณ Source: S_GLOBAL.PRG
ณ
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
*/
FUNCTION SLS_BQZAP()
sls_bquery( {||.t.} )
return nil

