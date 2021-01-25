
/*
�����������������������������������������������������������������
� FUNCTION SLS_ISCOLOR()
����������������������������������������������������������������� 
�
�  Short:
�  ------
� SLS_ISCOLOR() Tells SuperLib if this is a color monitor
�
� Returns
� <expSetting> => Current value of the setting
�
� Syntax
�
� SLS_ISCOLOR([lNew])        Is this a color monitor (useful for overriding
�                            Clipper's ISCOLOR() )
�
� [lNew] optionally overrides the default
�
� Examples
�
�  SLS_ISCOLOR(.F.)                // override ISCOLOR()
�
� Notes:
�
� Source: S_GLOBAL.PRG
�
����������������������������������������������������������������� 
*/
FUNCTION SLS_ISCOLOR(lNew)
static lIsColor                 := nil
lIsColor := iif(liscolor==nil,iscolor(),lIsColor)
return (lIsColor := iif(lNew#nil,lNew,lIsColor) )

/*
�����������������������������������������������������������������
� FUNCTION SLS_NORMCOL()
����������������������������������������������������������������� 
�
�  Short:
�  ------
� SLS_NORMCOL() A Superlib color setting function
�
� Returns
� <cSetting> => Current value of the setting
�
� Syntax
� SLS_NORMCOL([cNew])
�
� Function                   Setting                     Default
� --------------------------------------------------------------
� SLS_NORMCOL([cNew])        Normal screen output        'W/N,N/W,,,+W/N'
�
� [cNew] sets the setting to a new setting
� If [cNew] is passed, the setting is changed and the
� new setting is returned.
�
�
� Examples
�
�  SETCOLOR(sls_normcol()  )        // use to setcolor()
�
� Notes:
�
� Source: S_GLOBAL.PRG
�
����������������������������������������������������������������� 
*/
FUNCTION SLS_NORMCOL(cNew)
static cMainColor               :=  'W/N,N/W,,,+W/N'
return (cMainColor := iif(cNew#nil,cNew,cMainColor) )


/*
�����������������������������������������������������������������
� FUNCTION SLS_NORMMENU()
����������������������������������������������������������������� 
�
�  Short:
�  ------
� SLS_NORMMENU() A Superlib color setting function
�
� Returns
� <cSetting> => Current value of the setting
�
� Syntax
� SLS_NORMMENU([cNew])
�
� Function                   Setting                     Default
� --------------------------------------------------------------
� SLS_NORMMENU([cNew])       Normal MENU color           'W/N,N/W,,,+W/N'
�
� [cNew] sets the setting to a new setting
� If [cNew] is passed, the setting is changed and the
� new setting is returned.
�
�
� Examples
�
�  SETCOLOR(sls_NORMMENU()  )        // use to setcolor()
�
� Notes:
�
� Source: S_GLOBAL.PRG
�
����������������������������������������������������������������� 
*/
FUNCTION SLS_NORMMENU(cNew)
static cMainMenuColor           :=  'W/N,N/W,,,+W/N'
return (cMainMenuColor := iif(cNew#nil,cNew,cMainMenuColor) )


/*
�����������������������������������������������������������������
� FUNCTION SLS_POPCOL()
����������������������������������������������������������������� 
�
�  Short:
�  ------
� SLS_POPCOL() A Superlib color setting function
�
� Returns
� <cSetting> => Current value of the setting
�
� Syntax
� SLS_POPCOL([cNew])
�
� Function                   Setting                     Default
� --------------------------------------------------------------
� SLS_POPCOL([cNew])         Popup screen output         'N/W,+W/N,,,W/N'
�
� [cNew] sets the setting to a new setting
� If [cNew] is passed, the setting is changed and the
� new setting is returned.
�
�
� Examples
�
�  SETCOLOR(sls_POPCOL()  )        // use to setcolor()
�
� Notes:
�
� Source: S_GLOBAL.PRG
�
����������������������������������������������������������������� 
*/
FUNCTION SLS_POPCOL(cNew)
static cPopupColor              :=  'N/W,+W/N,,,W/N'
return (cPopupColor := iif(cNew#nil,cNew,cPopupColor) )

/*
�����������������������������������������������������������������
� FUNCTION SLS_POPMENU()
����������������������������������������������������������������� 
�
�  Short:
�  ------
� SLS_POPMENU() A Superlib color setting function
�
� Returns
� <cSetting> => Current value of the setting
�
� Syntax
� SLS_POPMENU([cNew])
�
� Function                   Setting                     Default
� --------------------------------------------------------------
� SLS_POPMENU([cNew])        Popup MENU color            'N/W,W/N,,,+W/N'
�
� [cNew] sets the setting to a new setting
� If [cNew] is passed, the setting is changed and the
� new setting is returned.
�
�
� Examples
�
�  SETCOLOR(sls_POPMENU()  )        // use to setcolor()
�
� Notes:
�
� Source: S_GLOBAL.PRG
�
����������������������������������������������������������������� 
*/
FUNCTION SLS_POPMENU(cNew)
static cPopupMenuColor          :=  'N/W,W/N,,,+W/N'
return (cPopupMenuColor := iif(cNew#nil,cNew,cPopupMenuColor) )

/*
�����������������������������������������������������������������
� FUNCTION SLS_FRAME()
����������������������������������������������������������������� 
�
�  Short:
�  ------
� SLS_FRAME() A Superlib box setting function
�
� Returns
� <cSetting> => Current value of the setting
�
� Syntax
� SLS_FRAME([cNew])
�
� Function                   Setting                     Default
� --------------------------------------------------------------
� SLS_FRAME([cNew])          Box frames                   single
�
� [cNew] sets the setting to a new setting
� If [cNew] is passed, the setting is changed and the
� new setting is returned.
�
�
� Examples
�  #include "Box.ch"
�  sls_FRAME(B_SINGLE+" ")
�
� Notes:
�
� Source: S_GLOBAL.PRG
�
����������������������������������������������������������������� 
*/
FUNCTION SLS_FRAME(cNew)
static cFrameString             := "�Ŀ����� "
return (cFrameString := iif(cNew#nil,cNew,cFrameString) )

/*
�����������������������������������������������������������������
� FUNCTION SLS_SHADATT()
����������������������������������������������������������������� 
�
�  Short:
�  ------
� SLS_SHADATT() A Superlib color setting function
�
� Returns
� <nSetting> => Current value of the setting
�
� Syntax
� SLS_SHADATT([nNew])
�
� Function                   Setting                     Default
� --------------------------------------------------------------
� SLS_SHADATT([nNew])        Shadow attribute            8  (+N/N)
�
� [nNew] sets the setting to a new setting
� If [nNew] is passed, the setting is changed and the
� new setting is returned.
�
� Values are numeric color settings (see color chart)
�
� Examples
�
�  SLS_SHADATT(127)        // shadow of +w/w
�
� Notes:
�
� Source: S_GLOBAL.PRG
�
����������������������������������������������������������������� 
*/
FUNCTION SLS_SHADATT(nNew)
static nShadowAtt               := 8
return (nShadowAtt := iif(nNew#nil,nNew,nShadowAtt) )

/*
�����������������������������������������������������������������
� FUNCTION SLS_SHADPOS()
����������������������������������������������������������������� 
�
�  Short:
�  ------
� SLS_SHADPOS() A Superlib color setting function
�
� Returns
� <nSetting> => Current value of the setting
�
� Syntax
� SLS_SHADPOS([nNew])
�
� Function                   Setting                     Default
� --------------------------------------------------------------
� SLS_SHADPOS([nNew])        Shadow position             1  (lower left)
�                            (uses numeric keypad
�                            as guide)
�                              7 upper left
�                              1 lower left
�                              3 lower right
�                              9 upper right
�                              0 none
�
� [nNew] sets the setting to a new setting
� If [nNew] is passed, the setting is changed and the
� new setting is returned.
�
�
� Examples
�
�  SLS_SHADPOS(0)        //  NO SHADOW
�
� Notes:
�
� Source: S_GLOBAL.PRG
�
����������������������������������������������������������������� 
*/
FUNCTION SLS_SHADPOS(nNew)
static nShadowPos               := 1
return (nShadowPos := iif(nNew#nil,nNew,nShadowPos) )

/*
�����������������������������������������������������������������
� FUNCTION SLS_XPLODE()
����������������������������������������������������������������� 
�
�  Short:
�  ------
� SLS_XPLODE() A Superlib box setting function
�
� Returns
� <lSetting> => Current value of the setting
�
� Syntax
� SLS_XPLODE([lNew])
�
� Function                   Setting                     Default
� --------------------------------------------------------------
� SLS_XPLODE([lNew])         Explode/implode popups      .T.
�
� [lNew] sets the setting to a new setting
� If [lNew] is passed, the setting is changed and the
� new setting is returned.
�
�
� Examples
�
�  SLS_XPLODE(.f.)        //  NO EXPLODING BOXES
�
� Notes:
�
� Source: S_GLOBAL.PRG
�
����������������������������������������������������������������� 
*/
FUNCTION SLS_XPLODE(lNew)
static lExplodeBoxes            := .T.
return (lExplodeBoxes := iif(lNew#nil,lNew,lExplodeBoxes) )

/*
�����������������������������������������������������������������
� FUNCTION SLS_PRN()
����������������������������������������������������������������� 
�
�  Short:
�  ------
� SLS_PRN() A Superlib printer setting function
�
� Returns
� <cSetting> => Current value of the setting
�
� Syntax
� SLS_PRN([cNew])
�
� Function                   Setting                     Default
� --------------------------------------------------------------
� SLS_PRN([cNew])            Default printer             'LPT1'
�
� [cNew] sets the setting to a new setting
� If [cNew] is passed, the setting is changed and the
� new setting is returned.
�
�
� Examples
�
�  SLS_PRN("LPT2")
�  SET PRINTER TO (SLS_PRN())
�
� Notes:
�
� Source: S_GLOBAL.PRG
�
����������������������������������������������������������������� 
*/
FUNCTION SLS_PRN(cNew)
static cDefPrinter              := 'LPT1'
return (cDefPrinter := iif(cNew#nil,cNew,cDefPrinter) )

/*
�����������������������������������������������������������������
� FUNCTION SLS_PRNC()
����������������������������������������������������������������� 
�
�  Short:
�  ------
� SLS_PRNC() A Superlib printer setting function
�
� Returns
� <lSetting> => Current value of the setting
�
� Syntax
� SLS_PRNC([lNew])
�
� Function                   Setting                     Default
� --------------------------------------------------------------
� SLS_PRNC([lNew])           Check printer ready         .T.
�                            (set to .f. on
�                            a network)
� [lNew] sets the setting to a new setting
� If [lNew] is passed, the setting is changed and the
� new setting is returned.
�
�
� Examples
�
�  SLS_PRNC(.f.)        //  DO NOT DO A HARDWARE PRINTER READY CHECK
�
� Notes:
�
� Source: S_GLOBAL.PRG
�
����������������������������������������������������������������� 
*/
FUNCTION SLS_PRNC(lNew)
static lCheckPrnStat            := .T.
return (lCheckPrnStat := iif(lNew#nil,lNew,lCheckPrnStat) )

/*
�����������������������������������������������������������������
� FUNCTION SLS_QUERY()
����������������������������������������������������������������� 
�
�  Short:
�  ------
� SLS_QUERY() Sets SuperLib global query string
�
� Returns
� <cSetting> => Current value of the setting
�
� Syntax
� SLS_QUERY([cNew])
�
� Function                   Setting                     Default
� --------------------------------------------------------------
� SLS_QUERY([cNew])          Query string                ''
�                            set by QUERY()
�
� [cNew] sets the setting to a new setting
� If [cNew] is passed, the setting is changed and the
� new setting is returned.
�
� THIS IS MAINLY FOR INTERNAL USE BY SUPERLIB
�
� Examples
�
�  SLS_QUERY({||"R"$lname})
�
� When using SLS_QUERY(), be sure to reset it to ""
� when changing DBFs.
�
� Source: S_GLOBAL.PRG
�
����������������������������������������������������������������� 
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
�����������������������������������������������������������������
� FUNCTION SLS_BQUERY()
����������������������������������������������������������������� 
�
�  Short:
�  ------
� SLS_BQUERY() Sets SuperLib global query block
�
� Returns
� <bSetting> => Current value of the setting
�
� Syntax
� SLS_BQUERY([bNew])
�
� Function                   Setting                     Default
� --------------------------------------------------------------
� SLS_BQUERY([bNew])         Query codeblock            {||.t.}
�                            set by QUERY()
�
� [bNew] sets the setting to a new setting
� If [bNew] is passed, the setting is changed and the
� new setting is returned.
�
� THIS IS MAINLY FOR INTERNAL USE BY SUPERLIB
�
� Examples
�
�  SLS_BQUERY({||"R"$lname})
�
�
� Source: S_GLOBAL.PRG
�
����������������������������������������������������������������� 
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
�����������������������������������������������������������������
� FUNCTION SLS_BQZAP()
����������������������������������������������������������������� 
�
�  Short:
�  ------
� SLS_BQZAP() Resets SuperLib's global query block
�
� Returns
� nil
�
� Syntax
� SLS_BQZAP()
�
� SLS_BQZAP() Resets SuperLib's global query block which is {||.t.}
�
� THIS IS MAINLY FOR INTERNAL USE BY SUPERLIB
�
� Examples
�
� SLS_BQZAP()
�
� Notes:
�
� Source: S_GLOBAL.PRG
�
����������������������������������������������������������������� 
*/
FUNCTION SLS_BQZAP()
sls_bquery( {||.t.} )
return nil

