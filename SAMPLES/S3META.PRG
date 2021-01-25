STATIC lDbfOpen      := .F.
STATIC cDbfName      := ""
STATIC nIndexOrd     := 0
STATIC cDefaultDir   := ""
STATIC aIndexes      := {}

memvar getlist


PROC SUPERSUPER()
local cInScreen := savescreen(0,0,24,79)
local aMenuOpts := array(7)
local aMenuDefs := array(7)
local nSelection,cPopBox
local cNewIndex
local nInSelect := select()
SELECT 0

*- initialize superfunctions
SLS_ISCOLOR( PCOUNT()=0 )
slsf_color("S3COLOR")
INITSUP(.F.)

cDbfName := ''
CLOSE DATA
aIndexes := {}
lDbfOpen := .F.
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


*- menu choice definitions
aMenuOpts[1] := "Files:Select:Define:Copy:Append:Field Copy:Export:Mailmerge"
aMenuOpts[2] := "Indexes:Select:Order:New"
aMenuOpts[3] := "Editing:Edit:Global Replace:Tabular Edit"
aMenuOpts[4] := "Reporting:Build Query:Print Lists:Duplicates:Create Labels:Write Form Letters:Sum or Average a Field:DBF Field Frequency Analysis:Time Analysis:REPORT WRITER!:Statistics"
aMenuOpts[5] := "Appearance:Screen Appearance:Predefined Colors"
aMenuOpts[6] := "Utility:List text file:Directory:Todo List:Calendar:"+;
                 "Solar Calculator:Weights&Measures:Appointments"
aMenuOpts[7] := "Quit:Quit"
nSelection = 1.01

*- define menu boxes
aMenuDefs[1] := .f.               && draw the top bar box ?
aMenuDefs[2] := sls_normcol()      && top bar color string
aMenuDefs[3] := sls_popmenu()      && drop box color
aMenuDefs[4] := sls_frame()        && drop box frame
aMenuDefs[5] := 3                 && drop box shadow position (1,3,7,9,0)
aMenuDefs[6] := sls_shadatt()      && drop box shadow attribute
aMenuDefs[7] := 1             && row # of menu bar

DO WHILE .T.
   sf_show()                   && display dbfs and indexes
   
   *- do the menu
   nSelection := pulldn(nSelection,aMenuOpts,aMenuDefs)
   
   
   *- if 0 returned, selection is QUIT
   IF nSelection = 0
      nSelection := 7.01
   ENDIF
   nSelection := val(trans(nSelection,"9.99"))
   
   *- do the action corresponding to the menu choice
   DO CASE
   CASE nSelection = 1.01     && select a DBF
      
      IF Adir('*.dbf') > 0
         sf_pickdbf(.f.)
      ELSE
         msg("No DBFs detected in this directory")
      ENDIF
      
      
   CASE nSelection = 1.02   && modify structure
      USE
      modify()
      USE
      if lDbfOpen
        sf_pickdbf(.T.)
        openind(aIndexes,getdfp())       && open them
      endif
      
   CASE nSelection < 5  .AND. !lDbfOpen
      msg("Need a DBF open for this option")
      
      
   CASE nSelection = 1.03   && copy records out

      copyitout()
      
   CASE nSelection = 1.04   && append records in
      appendit()

   CASE nSelection = 1.05   && copy fields
      copyfields()
   CASE nSelection = 1.06   && export
      sexport()
   CASE nSelection = 1.07   && mailmerge
      smailmerge()
      
   CASE nSelection =2.01                && select indexes
      IF Adir('*'+IndexExt()) > 0
         pickndx(aIndexes,getdfp(),.f.)
      else
         msg("No indexes present")
      ENDIF
      
   CASE nSelection = 2.02   .AND. len(aIndexes) > 0
      sf_order()      && change index order
   CASE nSelection = 2.03        && make temp index
      cNewIndex := bldndx(NIL,NIL,NIL,.T.)
      IF !EMPTY(cNewIndex)
         aadd(aIndexes,"")
         Ains(aIndexes,1)    && insert in active index array
         aIndexes[1] := Alltrim(cNewIndex)+Indexext()
         openind(aIndexes,getdfp())       && open them
         nIndexOrd   := 1
      ENDIF

   CASE nSelection = 3.01            && vertical edit
      VIEWPORT(.T.)
      
   CASE nSelection = 3.02            && global replace
      globrep()
      
   CASE nSelection = 3.03            && horizontal edit
      editdb(.T.)
      
   CASE nSelection = 4.01            && query
      QUERY()
      
      
   CASE nSelection = 4.02            && print list
      lister()
      
   CASE nSelection = 4.03            && hunt duplicates
      if messyn("Duplicates","Listing only","Delete and/or copy")
        duplook(NIL,aIndexes)
      else
        duphandle(nil,nil,aIndexes)
      endif
      
   CASE nSelection = 4.04            && labels
      clabel()
      
   CASE nSelection = 4.05        && form letter
      formletr()
      
   CASE nSelection = 4.06     && sum/AVERAGE
      IF messyn("Sum or Average?","Sum","Average")
         sum_ave()
      ELSE
         sum_ave("AVE")
      ENDIF
      
      
   CASE nSelection = 4.07    && occurance
      freqanal()
   CASE nSelection = 4.08    && time analysis
      TIMEPER()
   CASE nSelection = 4.09    && report writer
      REPORTER()
   CASE nSelection = 4.10    && stats
      DBSTATS()
      
      
   CASE nSelection = 5.01            && color setting
      setcolors()
      SETCOLOR(sls_normcol())
      paint_sf()            && repaint screen
      
      *- redefine menu box data
      aMenuDefs[1] = .F.
      aMenuDefs[2] = sls_normcol()
      aMenuDefs[3] = sls_popmenu()
      aMenuDefs[4] = sls_frame()
      aMenuDefs[5] = sls_shadpos()
      aMenuDefs[6] = sls_shadatt()
      aMenuDefs[7] = 1
      
   CASE nSelection = 5.02            && predefined colors
      colpik()
      SETCOLOR(sls_normcol())
      paint_sf()            && repaint screen
      
      *- redefine menu box data
      aMenuDefs[1] = .F.
      aMenuDefs[2] = sls_normcol()
      aMenuDefs[3] = sls_popmenu()
      aMenuDefs[4] = sls_frame()
      aMenuDefs[5] = sls_shadpos()
      aMenuDefs[6] = sls_shadatt()
      aMenuDefs[7] = 1
      
      
   CASE nSelection = 6.01    && list text file
      Fileread()
   CASE nSelection = 6.02  && dir picker
         cDefaultDir := ""
         fulldir(.F.,@cDefaultDir)
         IF !EMPTY(cDefaultDir)
           set default to (cDefaultDir)
           CLOSE DATA
           cDbfName := ''
           aIndexes := {}
           lDbfOpen := .F.
           sls_query("")
           sls_bquery(nil)
           paint_sf()
         ENDIF
      
   CASE nSelection = 6.03  && todo list
      todolist()
      
   CASE nSelection = 6.04  && calendar
      getdate()

   CASE nSelection = 6.05  && calculator
      getcalc()
   CASE nSelection = 6.06  && weights&measures
      wgt_meas()
   CASE nSelection = 6.07  && appointments
      sappoint()
      
   CASE nSelection = 7.01            && quit
      IF messyn('Are you sure?')
         SET CURSOR ON
         ss_fold(0,0,24,79,cInscreen)
         EXIT
      ENDIF
   ENDCASE
enddo
CLOSE DATA
cDbfName := ''
aIndexes := {}
lDbfOpen := .F.
SELECT (nInSelect)
RETURN


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
      lDbfOpen := .T.
      sls_query("")
      cDbfName := cDbfPick
      aIndexes := {}
   elseif !used()
      lDbfOpen := .F.
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
dispbox(3,1,17,77,'±±±±±±±±±')
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
IF lDbfOpen
   cRecords := IIF(!EMPTY(cDbfName),' Containing '+Alltrim(STR(RECC()))+;
                ' RECORDS','')
   @20,24 SAY cDbfName+cRecords
   devpos(21,24)
   for i = 1 to len(aIndexes)
     ??aIndexes[i]+" "
   next
ENDIF
RETURN ''



