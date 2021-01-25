
STATIC cDbfName      := ""
STATIC nIndexOrd     := 0
STATIC cDefaultDir   := ""
STATIC aIndexes      := {}

memvar getlist


PROC MAIN()
local cInScreen := savescreen(0,0,24,79)
local aMenu

*- initialize superfunctions
SLS_ISCOLOR( PCOUNT()=0 )
if SLS_ISCOLOR()
  SATTCOLOR()
ELSE
  SATTMONO()
ENDIF

cDbfName        := ''
aIndexes        := {}
sls_query("")
sls_bquery(nil)

*- set some sets
SET TALK OFF
SET ECHO OFF
SET CONFIRM OFF
SET BELL OFF
SET SAFETY OFF
SET SCOREBOARD OFF
SET TYPEAHEAD TO 50

*- set color
Setcolor(sls_normcol())

*- draw the screen
paint_sf()

*- define the menu
bungstart()
     bungoption("Files")
     bungdrop()
          bungoption("DBF")
              bungdrop()
                bungoption("Open",{||sf_opendbf(),bungeetop()},{||!used()})
                bungoption("Modify",{||sf_modify()},{||!used()})
                bungoption("Close",{||dbclosearea(),cDbfName:="",aIndexes:={}},{||used()})
              bungundrop()
          bungoption("Index")
              bungdrop()
                bungoption("Open",{||sf_openind(),bungeetop()} ,{||used()})
                bungoption("Create",{||sf_newind()},{||used()})
                bungoption("Set Order",{||sf_order()},{||used() .and. len(aIndexes)>0 })
              bungundrop()
          bungoption("CROSSBAR")
          bungoption("Copy to...")
              bungdrop()
                bungoption("Copy to ~DBF",{||copyitout()},{||used()})
                bungoption("Copy ~Fields to DBF",{||copyfields()},{||used()})
                bungoption("Copy to ~SDF or Delimited File",{||sexport()},{||used()})
                bungoption("Copy to ~MailMerge File",{||smailmerge()},{||used()})
              bungundrop()
          bungoption("Append",{||appendit()},{||used()} )
          bungoption("CROSSBAR")
          bungoption("Quit",{||bungeequit()},nil)
     bungundrop()
     bungoption("Edit")
     bungdrop()
          bungoption("ViewPort",{||viewport(.t.)},{||used()})
          bungoption("Table Edit",{||EditDb(.t.)},{||used()})
          bungoption("Global Replace",{||globrep(.t.)},{||used()})
     bungundrop()
     bungoption("Reporting")
     bungdrop()
          bungoption("Query",{||query()},{||used()})
          bungoption("CROSSBAR")
          bungoption("Print Lists",{||lister()},{||used()})
          bungoption("Duplicate Report")
           bungdrop()
                bungoption("Listing Only",{||duplook(nil,aIndexes)},{||used()})
                bungoption("Delete and/or copy",{||duphandle(nil,nil,aIndexes)},{||used()})
           bungundrop()
          bungoption("CROSSBAR")
          bungoption("Mailing Labels",{||clabel()},{||used()})
          bungoption("Form Letters",{||formletr()},{||used()})
          bungoption("CROSSBAR")
          bungoption("Sum numeric field",{||sum_ave()},{||used()})
          bungoption("Average numeric field",{||sum_ave("AVE")},{||used()})
          bungoption("Fr~equency Analysis",{||freqanal()},{||used()})
          bungoption("Time/date Analysis",{||timeper()},{||used()})
          bungoption("D~BF Statistics",{||DBSTATS()},{||used()})
          bungoption("CROSSBAR")
          bungoption("Report Writer",{||Reporter()},{||used()})
     bungundrop()
     bungoption("Appearance")
     bungdrop()
          bungoption("Set colors and other screen items",{||sf_setc()})
          bungoption("Pick from list of predefined colors",{||sf_setcp()})
     bungundrop()
     bungoption("Utilities")
     bungdrop()
          bungoption("List text file",{||fileread()})
          bungoption("Change Directories",{||dirpicker()})
          bungoption("To Do list",{||todolist()})
          bungoption("Cal~endar",{||getdate()})
          bungoption("Calc~ulator",{||getcalc()})
          bungoption("Weights & Measures table",{||wgt_meas()})
          bungoption("Appointment book",{||sappoint()})
     bungundrop()
aMenu := bungend()


bungee(1,2,78,aMenu,nil,nil,nil,nil,nil,nil,nil,2)


ss_fold(0,0,24,79,cInscreen)
CLOSE DATA
cDbfName := ''
aIndexes := {}
RETURN


STATIC func sf_newind
local cNewIndex := bldndx(NIL,NIL,NIL,.T.)
IF !EMPTY(cNewIndex)
   aadd(aIndexes,"")
   Ains(aIndexes,1)    && insert in active index array
   aIndexes[1] := Alltrim(cNewIndex)+Indexext()
   openind(aIndexes,getdfp())       && open them
   nIndexOrd   := 1
ENDIF
sf_show()


//-----------------------------------------------------------------
STATIC FUNCTION sf_pickdbf(lByPass)
local cDbfnoext,cDbfPick
if !lBypass
  cDbfpick := popex(getdfp()+'*.dbf')
else
  cDbfpick := cDbfName
endif
IF !EMPTY(cDbfpick)
   cDbfnoext := STRIP_PATH(cDbfpick,.t.)
   IF SNET_USE(cDbfpick,cDbfnoext,.f.,5,.t.,"Network error opening "+cDbfpick+" . Keep trying?")
     IF !used()
        USE
        msg("UNABLE TO OPEN "+cDbfpick+"- POSSIBLY CORRUPT OR .DBT FILE MISSING  ")
     ENDIF
   endif
   *- set globals
   if USED() .AND. !lBypass
      sls_query("")
      cDbfName := cDbfPick
      aIndexes := {}
   elseif !used()
      sls_query("")
      cDbfName := ""
      aIndexes := {}
   endif
ENDIF
RETURN ''

//----------------------------------------------------------
STATIC FUNCTION sf_order
local nOrder := nIndexOrd
nIndexOrd := mchoice(aIndexes,10,10,20,60,"Select Controlling Index")
IF nIndexOrd = 0
   nIndexOrd = nOrder
ELSE
   SET ORDER TO (nIndexOrd)
ENDIF
RETURN ''

//----------------------------------------------------------
STATIC FUNCTION paint_sf

Setcolor(sls_normcol())
CLEAR
*- draw center box with C function bxx()
dispbox(0,0,24,79)
dispbox(3,1,17,78,'±±±±±±±±±')
@2,1 to 2,78
@18,1 to 18,78
@20,03 SAY   "Datafile in use   -  "
@21,03 SAY   "Indexes in use    -  "
@22,3  SAY   "Current Directory -  "
RETURN ''

//----------------------------------------------------------
STATIC FUNCTION sf_show
local i
local cRecords
*- display the dbfs and indexes
Scroll(20,24,23,78,0)
if !empty(getdfp() )
  @22,24 say getdfp()
else
  @22,24 say Curdir()
endif
IF used()
   cRecords := IIF(!EMPTY(cDbfName),' Containing '+Alltrim(STR(RECC()))+;
                ' RECORDS','')
   @20,24 SAY cDbfName+cRecords
   devpos(21,24)
   for i = 1 to len(aIndexes)
     ??aIndexes[i]+" "
   next
ENDIF
RETURN ''

static func sf_setc
      setcolors()
      SETCOLOR(sls_normcol())
      dispbegin()
      paint_sf()            && repaint screen
      BUNGREDRAW()
      dispend()
return nil

static func sf_setcp
      colpik()
      dispbegin()
      SETCOLOR(sls_normcol())
      paint_sf()            && repaint screen
      BUNGREDRAW()
      dispend()
return nil

static func dirpicker
cDefaultDir := ""
fulldir(.F.,@cDefaultDir)
IF !EMPTY(cDefaultDir)
  set default to (cDefaultDir)
  CLOSE DATA
  cDbfName := ''
  aIndexes := {}
  sls_query("")
  sls_bquery(nil)
  paint_sf()
ENDIF
return nil


STATIC FUNC sf_openDbf
IF Adir('*.dbf')>0
  sf_pickdbf(.f.)
else
  msg("No DBFs detected in this directory")
endif
sf_show()
return nil


static func sf_openind
IF Adir('*'+IndexExt())>0
  pickndx(aIndexes,getdfp(),.f.)
else
  msg("No indexes present")
endif
sf_show()


static func sf_modify
local lUsed := USED()
dbclosearea()
modify()
dbclosearea()
if lUsed
  sf_pickdbf(.T.)
  openind(aIndexes,getdfp())
endif
sf_show()

