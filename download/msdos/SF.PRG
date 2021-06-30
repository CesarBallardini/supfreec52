*:*********************************************************************
*:
*:        Program: SF.PRG
*:
*:         System: Super.Lib Library for Clipper
*:         Author: Garry Prefontaine
*:      Copyright (c) 1989, Garry Prefontaine
*:  Last modified: 12/12/89     11:27
*:
*:  Procs & Fncts: PAINT_SF()
*:               : SF_SHOW()
*:               : SF_PICKDBF()
*:               : COPYITOUT()
*:               : SF_APPEND()
*:               : SF_PICKND()
*:               : SF_ORDER()
*:               : SF_OPENEM()
*:               : PICK_NDX()
*:
*:          Calls: INITSUP()      (function in SUPER.LIB)
*:               : CAPSLOCK()     (function in SUPER.LIB)
*:               : PULLDN()       (function in SUPER.LIB)
*:               : MSG()          (function in SUPER.LIB)
*:               : MESSYN()       (function in SUPER.LIB)
*:               : MODIS()        (function in SUPER.LIB)
*:               : BLDNDX()       (function in SUPER.LIB)
*:               : GLOBREP()      (function in SUPER.LIB)
*:               : EDITDB()       (function in SUPER.LIB)
*:               : DOITALL()      (function in SUPER.LIB)
*:               : LISTER()       (function in SUPER.LIB)
*:               : DUPLOOK()      (function in SUPER.LIB)
*:               : CLABEL()       (function in SUPER.LIB)
*:               : FORMLETR()     (function in SUPER.LIB)
*:               : SUM_AVE()      (function in SUPER.LIB)
*:               : OCCUR()        (function in SUPER.LIB)
*:               : SETCOLORS()    (function in SUPER.LIB)
*:               : INITCOL()      (function in SUPER.LIB)
*:               : FULLDIR()      (function in SUPER.LIB)
*:               : PAINT_SF()     (function  in SF.PRG)
*:               : SF_SHOW()      (function  in SF.PRG)
*:               : SF_PICKDBF()   (function  in SF.PRG)
*:               : COPYITOUT()    (function  in SF.PRG)
*:               : SF_APPEND()    (function  in SF.PRG)
*:               : SF_PICKND()    (function  in SF.PRG)
*:               : SF_ORDER()     (function  in SF.PRG)
*:               : SF_OPENEM()    (function  in SF.PRG)
*:
*:      Documented 12/12/89 at 11:32                SNAP!  version 3.12e
*:*********************************************************************

*- initialize metafunctions
initsup()

*- define type of index
defindex = '*'+Indexext()


*- set caps on
capslock(.T.)

*- initialize some variables
isfopen = .F.
STORE '' TO dbfname,ndx_string,query_exp
ndx_order = 1

*- set some sets
SET TALK OFF
SET ECHO OFF
SET CONFIRM OFF
SET BELL OFF
SET SAFETY OFF
SET SCOREBOARD OFF
SET TYPEAHEAD TO 50
EXTERNAL kbd_escape
EXTERNAL fastform

*- initialize SF arrays for holding
*- indexes in current directory
DECLARE sf_ndxs[adir(defindex)+1]
*- active indexes
DECLARE sf_acndx[6]


*- set color
Setcolor(c_normcol)


*- draw the screen
paint_sf()


*- menu choice definitions
PRIVATE choices[6]
choices[1] = "Datafiles:Use Datafile:Define New Datafile:Modify Existing Datafile Definition:Copy records out:Append records in"
choices[2] = "Indices:Select Indices:Index order:New Index"
choices[3] = "Editing:Field Replacement:Tabular Edit:Vertical Edit"
choices[4] = "Reporting:Build Query:Print Lists:Hunt Duplicates:Create Labels:Write Form Letters:Sum or Average a Field:Field Occurrance"
choices[5] = "Other:List text file:Design Screen Appearance:Change Directory"
choices[6] = "Quit:Quit:Author:Info"
sf_sel = 1.01

*- define menu boxes
PRIVATE boxdata[7]
boxdata[1] = !(ISCOLOR())      && draw the top bar box ?
boxdata[2] = m->c_normcol      && top bar color string
boxdata[3] = m->c_popmenu      && drop box color
boxdata[4] = m->c_frame        && drop box frame
boxdata[5] = 3                 && drop box shadow position (1,3,7,9,0)
boxdata[6] = m->c_shadatt      && drop box shadow attribute
boxdata[7] = 0                 && row # of menu bar


DO WHILE .T.
   sf_show()                   && display dbfs and indexes
   
   
   *- do the menu
   sf_sel = pulldn(m->sf_sel,m->choices,m->boxdata)
   
   
   *- if 0 returned, selection is QUIT
   IF m->sf_sel = 0
      m->sf_sel = 6.01
   ENDIF
   
   
   *- do the action corresponding to the menu choice
   DO CASE
   CASE m->sf_sel = 1.01     && select a DBF
      
      IF Adir('*.dbf') > 0
         sf_pickdbf()
      ELSE
         msg("No DBFs detected in this directory")
      ENDIF
      
      
   CASE m->sf_sel = 1.02   && create structure
      
      IF messyn("Datafiles will be closed while defining new datafile","Continue","Quit",10,10)
         modis("C")
         CLOSE DATA
         isfopen = .F.
         dbfname = ''
      ENDIF
      
      
   CASE m->sf_sel = 1.03   && modify structure
      IF messyn("Datafiles will be closed while modifying datafile","Continue","Quit",10,10)
         modis("M")
         CLOSE DATA
         isfopen = .F.
         dbfname = ''
      ENDIF
      
      *- rest of options below 5 require dbf open
   CASE m->sf_sel < 5  .AND. !m->isfopen
      msg("Need a DBf open for this option")
      
      
   CASE m->sf_sel = 1.04   && copy records out
      copyitout()
      
   CASE m->sf_sel = 1.05   && append records in
      sf_append()
      
   CASE m->sf_sel =2.01                && select indices
      IF Adir(m->defindex) > 0
         sf_picknd()
      ENDIF
      
   CASE m->sf_sel = 2.02   .AND. !EMPTY(m->ndx_string)  && index order
      
      sf_order()          && change index order
      
   CASE m->sf_sel = 2.03        && make temp index
      inname = bldndx()
      IF !EMPTY(m->inname)
         Ains(m->sf_acndx,1)    && insert in active index array
         sf_acndx[1] = Alltrim(m->inname)+Indexext()
         
         sf_openem()            && reopen indexes
         ndx_order = 1
      ENDIF
      
   CASE m->sf_sel = 3.01            && global replace
      globrep()
      
   CASE m->sf_sel = 3.02            && horizontal edit
      editdb(.T.)
      
   CASE m->sf_sel = 3.03            && vertical edit
      PRIVATE opts[2],procs[2]      && build arrays for 'Other' menu
      opts[1]="Single Formletter"
      opts[2]="Quit"
      procs[1] = "FASTFORM"
      procs[2] = ""
      doitall(m->opts,m->procs)
      
   CASE m->sf_sel = 4.01            && query
      query_exp = QUERY()
      
      
   CASE m->sf_sel = 4.02            && print list
      lister()
      
   CASE m->sf_sel = 4.03            && hunt duplicates
      duplook()
      
      *- open index files again
      sf_openem()
      
   CASE m->sf_sel = 4.04            && labels
      clabel()
      
   CASE m->sf_sel = 4.05        && form letter
      formletr()
      
   CASE m->sf_sel = 4.06     && sum/AVERAGE
      IF messyn("Sum or Average?","Sum","Average")
         sum_ave()
      ELSE
         sum_ave("AVE")
      ENDIF
      
      
   CASE m->sf_sel = 4.07    && occurance
      occur()
      
   CASE m->sf_sel = 5.01    && list text file
      Fileread()
      
      
   CASE m->sf_sel = 5.02            && color setting
      setcolors()
      RESTORE FROM COLORS.MEM ADDIT
      SET COLOR TO (m->c_normcol)
      paint_sf()                    && repaint screen
      
      *- redefine menu box data
      boxdata[1] = !(ISCOLOR())
      boxdata[2] = m->c_normcol
      boxdata[3] = m->c_popmenu
      boxdata[4] = m->c_frame
      boxdata[5] = m->c_shadpos
      boxdata[6] = m->c_shadatt
      boxdata[7] = 0
      
      
   CASE m->sf_sel = 5.03  && dir picker
      IF fulldir()
         CLOSE DATA
         isfopen = .F.
         query_exp=''
         paint_sf()
      ENDIF
      
      
   CASE m->sf_sel = 6.01            && quit
      IF messyn('Are you sure?')
         SET CURSOR ON
         CLEAR
         EXIT
      ENDIF
      
   CASE m->sf_sel = 6.02
      msg(" Super.Lib Library for Clipper","","Written by Garry A Prefontaine","920 N Washington","Edmond, Oklahoma, 73034","(405) 340-1940","Copyright (c) 1989, Garry A Prefontaine")
      
   CASE m->sf_sel = 6.03
      
      msg(" This program was written to demonstrate the capabilities",;
         "of the Super.Lib Library for Clipper. The library is available",;
         "from: ",;
         "          Functional Software",;
         "          920 N Washington",;
         "          Edmond, OK, 73034",;
         "          (405) 340-1940  ",;
         "",;
         "for $47.50. Source code is included.")
      
   ENDCASE
ENDDO


*!*********************************************************************
*!
*!       Function: SF_PICKDBF()
*!
*!      Called by: SF.PRG                        
*!
*!          Calls: POPEX()        (function in SUPER.LIB)
*!               : MSG()          (function in SUPER.LIB)
*!               : DELARRAY()     (function in SUPER.LIB)
*!
*!           Uses: (M->DBFPICK).DBF
*!
*!*********************************************************************
FUNCTION sf_pickdbf
dbfpick = popex('*.dbf')
IF !EMPTY(m->dbfpick)
   USE (m->dbfpick)
   IF EMPTY(ALIAS())
      msg("UNABLE TO OPEN DATABASE  - POSSIBLY CORRUPT OR .DBT FILE MISSING  ")
      RETURN ''
   ENDIF
   
   *- set globals
   isfopen = .T.
   query_exp = ''
   dbfname = m->dbfpick
   delarray(m->sf_acndx)    && delete index array
   ndx_string=''
   
ENDIF
RETURN ''
*!*********************************************************************
*!
*!       Function: SF_PICKND()
*!
*!      Called by: SF.PRG                        
*!
*!          Calls: DELARRAY()     (function in SUPER.LIB)
*!               : PICK_NDX()     (function  in SF.PRG)
*!               : SF_OPENEM()    (function  in SF.PRG)
*!
*!*********************************************************************
FUNCTION sf_picknd

delarray(m->sf_acndx)    && delete index array
Adir(m->defindex,m->sf_ndxs)
pick_ndx()        && get a list of active indices into sf_acndx
sf_openem()       && open them
RETURN ''

*!*********************************************************************
*!
*!       Function: SF_ORDER()
*!
*!      Called by: SF.PRG                        
*!
*!          Calls: MCHOICE()      (function in SUPER.LIB)
*!
*!*********************************************************************
FUNCTION sf_order
PRIVATE old_o
old_o = m->ndx_order
ndx_order = mchoice('sf_acndx',10,10,20,50)
IF m->ndx_order = 0
   ndx_order = m->old_o
ELSE
   SET ORDER TO (m->ndx_order)
ENDIF
RETURN ''

*!*********************************************************************
*!
*!       Function: SF_OPENEM()
*!
*!      Called by: SF.PRG                        
*!               : SF_PICKND()    (function  in SF.PRG)
*!
*!          Calls: ALENG()        (function in SUPER.LIB)
*!
*!        Indexes: (SF_ACNDX[1]).NDX
*!               : (SF_ACNDX[2]).NDX
*!               : (SF_ACNDX[3]).NDX
*!               : (SF_ACNDX[4]).NDX
*!               : (SF_ACNDX[5]).NDX
*!               : (SF_ACNDX[6]).NDX
*!
*!*********************************************************************
FUNCTION sf_openem
PRIVATE tindex[6]

afill(m->tindex,"")
ndx_string = ''
PRIVATE knt,I
knt = aleng(m->sf_acndx)
FOR I = 1 TO M->KNT
   ndx_string = m->ndx_string+sf_acndx[m->i]+' '
   tindex[m->i] = sf_acndx[m->i]
NEXT
SET INDEX TO (tindex[1]),(tindex[2]),(tindex[3]),(tindex[4]),(tindex[5]),(tindex[6])
SET ORDER TO (m->ndx_order)
RETURN ''

*!*********************************************************************
*!
*!       Function: PICK_NDX()
*!
*!      Called by: SF_PICKND()    (function  in SF.PRG)
*!
*!          Calls: TEMPID[ADIR()  (function in SUPER.LIB)
*!               : KBD_ESCAPE.PRG
*!               : MAKEBOX()      (function in SUPER.LIB)
*!               : NKEY()         (function in SUPER.LIB)
*!               : MSG()          (function in SUPER.LIB)
*!               : UNBOX()        (function in SUPER.LIB)
*!
*!*********************************************************************
FUNCTION pick_ndx

PRIVATE nwin,nextndx,pr_el,n_name
PRIVATE tempid[adir(m->defindex)+1]


*- set up temp array for marking selected indexes
Acopy(m->sf_ndxs,m->tempid)

*- make F10 seem like ESCAPE
SET KEY -9 TO kbd_escape

*- draw the box
nwin = makebox(1,20,17,50,m->c_normcol)
@1,22 SAY  "[Select/Deselect Indices]"
@17,22 SAY "[Press F10 when done   ]"

nextndx= 1
pr_el = 1
DO WHILE .T.
   
   *- get a selection
   pr_el =  Achoice(2,21,16,49,m->tempid,'','',m->pr_el)
   IF m->pr_el = 0
      EXIT
   ENDI
   
   *- if its not already marked, mark it
   IF LEFT(tempid[m->pr_el],2)<>"û "
      n_name = sf_ndxs[m->pr_el]
      
      *- get index key to test
      KEY = Alltrim(nkey(m->n_name))
      IF !(TYPE("&KEY")== "U" .OR. TYPE("&KEY") == "UE")   && see if the index key will evaluate w/out ERRORS
         tempid[m->pr_el] = 'û '+tempid[m->pr_el]
         sf_acndx[m->nextNDX]   = sf_ndxs[m->pr_el]
         nextndx = m->nextndx+ 1
      ELSE
         msg("That index either does not match the DBF","or this program does not support a function","in the index expression")
         msg("For your info, the index expression is:",KEY)
      ENDIF
   ELSE    && otherwise, unmark it
      tempid[m->pr_el] = SUBST(tempid[m->pr_el],3)
      takeout = Ascan(m->sf_acndx,tempid[m->pr_el])
      Adel(m->sf_acndx,m->takeout)
      nextndx= m->nextndx- 1
   ENDIF
   
   *- if we've got 6, that's all we made room for
   IF m->nextndx = 7
      EXIT
   ENDIF
ENDDO

SET KEY -9 TO
unbox(m->nwin)
RETURN ''


*!*********************************************************************
*!
*!       Function: PAINT_SF()
*!
*!      Called by: SF.PRG                        
*!
*!          Calls: BXX()          (function in SUPER.LIB)
*!               : STANDARD()     (function in SUPER.LIB)
*!               : PRNT()         (function in SUPER.LIB)
*!
*!*********************************************************************
FUNCTION paint_sf

Setcolor(m->c_normcol)
CLEAR
*- draw center box with C function bxx()
bxx(2,0,18,79,standard(),0,0,'±±±±±±±±±',50)
IF !ISCOLOR()
   bxx(19,0,24,79)
ENDIF
Setcolor(m->c_popcol)
bxx(10,20,13,59,standard(),3,m->c_shadatt,'         ',50)
*- print text with C function prnt()
prnt(11,22,"Super.Lib  Demonstration Program",standard())
prnt(12,34,"Version 1.51",standard())
Setcolor(m->c_normmenu)
RETURN ''



*!*********************************************************************
*!
*!       Function: COPYITOUT()
*!
*!      Called by: SF.PRG                        
*!
*!          Calls: MENU_V()       (function in SUPER.LIB)
*!               : TAGIT()        (function in SUPER.LIB)
*!               : MESSYN()       (function in SUPER.LIB)
*!               : ONE_READ()     (function in SUPER.LIB)
*!               : PLSWAIT()      (function in SUPER.LIB)
*!               : MSG()          (function in SUPER.LIB)
*!
*!           Uses: (M->THE_DBF).DBF
*!               : (M->NEWFILE).DBF
*!
*!*********************************************************************
FUNCTION copyitout

*- get selection
choice = menu_v("","Tag records to copy","Copy records meeting Query","Copy all","Forget it")
DO CASE
CASE m->choice = 1   && tag
   DO WHILE .T.
      PRIVATE tag[100]
      tagit(m->tag)
      IF messyn("Copy marked records to a DBF ?")
         the_dbf = SPACE(12)
         one_read("Name of datafile to copy to : ","the_dbf","@!")
         IF EMPTY(m->the_dbf)
            EXIT
         ENDIF
         the_dbf = Alltrim(m->the_dbf)
         the_dbf =IIF(.NOT. ".DBF" $ m->the_dbf, m->the_dbf+".DBF",m->the_dbf)
         
         *- if it already exists, don't overwrite it
         *- loop around and get another filespec
         IF FILE(m->the_dbf)
            IF messyn("Database "+m->the_dbf+" already exists - ","Use another name","Overwrite")
               the_dbf = ''
               LOOP
            ENDIF
         ENDIF
         plswait(.T.,"Copying....")
         COPY TO (m->the_dbf) FOR (Ascan(m->tag,RECNO())> 0)
         plswait(.F.)
      ENDIF
      EXIT
   ENDDO
CASE choice = 2         && copy for query
   IF EMPTY(m->query_exp)
      msg("No Query set")
      RETURN ''
   ENDIF
   PRIVATE newfile,tnf
   newfile = SPACE(40)
   one_read("New DBF file name (use PATH)                     ","newfile","@!")
   IF LASTKEY() = 27
      RETURN ''
   ENDIF
   newfile = Alltrim(m->newfile)
   IF ! AT('.',m->newfile) > 0
      newfile = m->newfile+'.dbf'
   ENDIF
   IF FILE(m->newfile)
      IF !messyn(m->newfile+' already exists - overwrite?')
         RETURN ''
      ENDIF
   ENDIF
   plswait(.T.,"Copying....")
   COPY TO (m->newfile) FOR &query_exp
   plswait(.F.)
   RETURN ''
   
CASE choice = 3         && copy all
   DO WHILE .T.
      the_dbf = SPACE(12)
      one_read("Name of datafile to copy to : ","the_dbf","@!")
      IF EMPTY(m->the_dbf)
         EXIT
      ENDIF
      the_dbf = Alltrim(m->the_dbf)
      the_dbf =IIF(.NOT. ".DBF" $ m->the_dbf, m->the_dbf+".DBF",m->the_dbf)
      
      *- if it already exists, don't overwrite it
      *- loop around and get another filespec
      IF FILE(m->the_dbf)
         IF messyn("Database "+m->the_dbf+" already exists - ","Use another name","Overwrite")
            the_dbf = ''
            LOOP
         ENDIF
      ENDIF
      plswait(.T.,"Copying....")
      COPY TO (m->the_dbf)
      plswait(.F.)
      EXIT
   ENDDO
   
CASE choice = 4  && quit
ENDCASE
RETURN ''

*!*********************************************************************
*!
*!       Function: SF_APPEND()
*!
*!      Called by: SF.PRG                        
*!
*!          Calls: POPEX()        (function in SUPER.LIB)
*!               : MSG()          (function in SUPER.LIB)
*!               : MESSYN()       (function in SUPER.LIB)
*!
*!           Uses: (M->TTDBF).DBF 
*!               : &TTDBF         
*!
*!*********************************************************************
FUNCTION sf_append
PRIVATE ttdbf,presel
ttdbf  =popex('*.dbf')

*- save query for this area
prequ = m->query_exp
IF !EMPTY(m->ttdbf) .AND. !(m->ttdbf=m->dbfname)
   presel = SELE()
   SELE 0
   USE (m->ttdbf)
   IF EMPTY(ALIAS())
      msg("UNABLE TO OPEN DATABASE  - POSSIBLY CORRUPT OR .DBT FILE MISSING  ")
      SELE (m->presel)
      RETURN ''
   ENDIF
   appq = '.t.'
   IF messyn("Append -","for Query Condition","All records")
      *- build query for other area
      appq = QUERY()
      appq = IIF(EMPTY(m->appq),'.t.',m->appq)
      query_exp = m->prequ
      
   ENDIF
   USE
   SELE (m->presel)
   IF messyn("Go ahead with APPEND FROM "+m->ttdbf+" into "+dbfname+" ?")
      APPEND FROM &ttdbf FOR &appq
   ENDIF
ENDIF
RETURN ''

*!*********************************************************************
*!
*!       Function: SF_SHOW()
*!
*!      Called by: SF.PRG                        
*!
*!          Calls: DRIVE()        (function in SUPER.LIB)
*!
*!*********************************************************************
FUNCTION sf_show
*- display the dbfs and indices
Scroll(20,1,23,78,0)
IF m->isfopen
   n_recs =IIF(!EMPTY(m->dbfname),' Containing '+Alltrim(STR(RECC()))+' RECORDS','')
    @20,03 SAY   "Datafile in use   -  "+m->dbfname+m->n_recs
   IF !EMPTY(m->ndx_string)
      @21,03 SAY "Indices in use    -  "+m->ndx_string
      @22,03 SAY "Controlling index -  "+sf_acndx[m->ndx_order]
   ENDIF
ENDIF
@23,3 SAY        'Current Directory -  '+drive()+':'+Curdir()
RETURN ''
*: EOF: SF.PRG




