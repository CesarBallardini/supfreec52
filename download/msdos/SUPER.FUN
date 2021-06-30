                    
                    
             Expanded Function Listing
     --------------------------------------------
  -------------------------------------------------
  Function            ABORT()
  Action              Pops up dialog box asking Abort ? Yes/No
  Returns             expL True for Yes False for No
  Category            Popup
  Syntax              ABORT([expC],[expN1],[expN2],[expN3],[expN4])
  Description         Pop up a dialog box asking Abort  Don't Abort
                      Box color is C_POPCOL or optionally [expC]
                      Box dimensions are: 9,29,13,51 or optionally
                      [expN1],[expN2],[expN3],[expN4].
  Examples            if ABORT()
                         exit
                      endif
  Notes               First tests for last key = 27, if so, does dialog box.
                      Returns .t. if Abort  , .f. if Don't Abort or .f. if
                      last key not 27
  Warnings            Uses MENU TO so may blow get stack if called in
                      the middle of a READ. Cursor is left on.
 
  Found in : S_ABORT.PRG
  
  -------------------------------------------------
  Function            ADDSPACE()
  Action              Pads string with spaces
  Returns             <expC> String padded with spaces.
  Category            String
  Syntax              ADDSPACE(<expC>,<expN>)
  Description         Pads right side of <expC> with <expN> spaces.
                      Truncates string if <expN> is shorter than
                      original string length.
  Examples            ADDSPACE("GARRY",10)
                      results in "GARRY     "
 
  Found in : S_ADDSP.PRG
  
  -------------------------------------------------
  Function            ALENGTH()
  Action              Determines initialized length of an array
  Returns             <expN> length of initialized array
  Category            Array
  Syntax              ALENGTH(<array>)
  Description         Determines # of contiguous declared elements
                      in <array>
  Examples            declare friends[10]
                      friends[1] = "WYN"
                      friends[2] = "DAVE"
                      friends[3] = "JUDY"
                      friend_kount = ALENGTH(m->friends)
 
  Found in : S_ALENG.PRG
  
  -------------------------------------------------
  Function            BLDARR()
  Action              Builds an array from a delimited string
  Returns
  Category            Array
  Syntax              BLDARR(<array>|<expC>,<expN>,<expC>)
  Description         Fills in the elements of an existing array
                      <expC>|<array> with <expN> character values
                      extracted from a delimited string <expC> of
                      the form "Garry:Wyn:Ralph:Ed". The colon [:]
                      is the delimiter.
  Options             The first parameter may be either an array
                      OR the name of an array (to retain
                      compatibility with an older version when I knew
                      even less about parameters than I do now)
  Examples            declare lunch[3]
                      BLDARR(m->lunch,3,"Pizza:Chicken:Burgers")
  Notes               Array must be declared prior to calling
  
 
  Found in : S_BLDAR.PRG
  
  -------------------------------------------------
  Function            BLDDBF()
  Action              Create a DBF from a delimited string
  Returns             <expL> based on success.
  Category            DBF
  Syntax              BLDDBF(<expC1>,<expC2>|<array>)
  Description         Creates DBF file named <expC1> from delimited
                      strings in <expC2>|<array>.
  
                      Parameter 2 is either:
                      1. a Delimited string in the
                        form  "name,type,[size],[decimals]:name,type..."
                        Fields delimited by colon, field elements
                        delimited by commas.
                                  -- or --
                      2. an array of delimited strings in
                      the form "name,type,[size],[decimals]". One field
                      per array element, field elements delimited
                      by commas.
  Examples            1. Passing long delimited string
                         BLDDBF('CUSTOMER','LNAME,C,15:FNAME,C,10:
                         AGE,N,2:PROSPECT,L:')
  
                      2. Passing array of short delimited strings
                         declare newdbf[4]
                         newdbf[1]="LNAME,C,15"
                         newdbf[2]="FNAME,C,10"
                         newdbf[3]="AGE,N,2"
                         newdbf[4]="PROSPECT,L"
  
                         BLDDBF('CUSTOMER',M->newdbf)
  
  Notes               I'd stick to small DBFs on this one 5 - 10 fields.
                      if using a long delimited string.
  
                      BLDDBF() expects an unused area to work in, and
                      will return .f. if it detects a DBF open in
                      the current area. An overwrite will not be
                      allowed.
 
  Found in : S_BLDBF.PRG
  
  -------------------------------------------------
  Function            BLDNDX()
  Action              Interactively create a new index
  Returns             <expC> New index name less extension
  Category            Metafunction
  Syntax              BLDNDX([array])
  Description         Allows point and shoot building of a new
                      index.
  Options             <array> - an array of legal field
                      names. If not passed, all fields in current
                      DBF will be used.
  
  Examples            BLDNDX()
                       -- or --
                      declare ndxflds[4]
                      ndxflds[1]="LASTNAME"
                      ndxflds[2]="FIRSTNAME"
                      ndxflds[3]="CITY"
                      ndxflds[4]="ZIP"
                      BLDNDX(m->ndxflds)
  
  Notes               All fields are converted to type Character.
                      The function NBR2STR() is used to create a usable
                      character expression from a numeric field by first
                      adding 1,000,000 to the number.
  
  Warnings            Indexes created with this function will require
                      the functions DTOS() and NBR2STR() be loaded prior
                      to use.
                      Key -9 is unset on exit (F10)
                      Cursor is left ON
 
  Found in : S_BLDNDX.PRG
  
  -------------------------------------------------
  Function            CLABEL()
  Action              Menu driven module for label management
  Returns
  Category            Metafunction
  Syntax              CLABEL()
  Description         This function requires no parameters and is
                      entirely menu driven. Clipper compatible LBL
                      files are created and maintained. Labels may
                      be printed by Query matches, by Tagging, or
                      all records. All Clipper formats are supported.
  Examples            use CUSTOMER
                      CLABEL()
  Notes               Requires datafile to be open.
                      Creates and modifies Clipper compatible LBL files.
                      NEW (version 1.50) - does not call LABEL FORM - this
                      pulls in 18K extra - instead, uses its own label
                      printing routine. Label printing routine compresses
                      blank lines (i.e. a 2nd address), as well as
                      removing all but single space in a line (i.e. for
                      FIRSTNAME+LASTNAME)
  
  Warnings            Key -9 is unset on exit (F10)
                      Key -1 is unset on exit (F2)
                      Key -2 is unset on exit (F3)
 
  Found in : S_CLAB.PRG
  
  -------------------------------------------------
  Function            CLS()
  Action              Clear the screen with optional color,character
  Returns
  Category            Screen
  Syntax              CLS([expN],[expC])
  Description         Clear the screen.
  Options             Optional color [expN] and character [expC].
  Examples            CLS()     && clears screen with current color
                      CLS(48)   && clears screen with black on cyan
                      CLS(8,chr(177))  && clears screen grey on black
                                       && with character 177 (±)
 
  Found in : S_CLS.PRG
  
  -------------------------------------------------
  Function            CTRLW()
  Action              Sends chr(23) (Control-W) to the keyboard
  Returns
  Category            Keyboard
  Syntax              SET KEY XXX to CTRLW
  Description         Allows remapping a key to Ctrl-W - a common
                      Clipper EXIT key. CTRL-W is not a really
                      intuitive key, but is often required by
                      Clipper. I'll often set F10 to act as
                      Ctrl-W.
  Examples            SET KEY 27 to CTRLW  && remaps ESCAPE to CTRL-W
  
  Notes               Declare as EXTERNAL i.e.
                      EXTERNAL CTRLW
  
 
  Found in : S_CTRLW.PRG
  
  -------------------------------------------------
  Function            DELARRAY()
  Action              Deletes all elements of an array
  Returns
  Category            Array
  Syntax              DELARRAY(<array>)
  Description         Deletes all elements of an array. Basically
                      un-initializes the array.
  Examples            * Say you wish to re-use an array, passing
                      * it to ACHOICE() each time around, and it
                      * may have different lengths each time. What
                      * you want to do is get rid of any extra
                      * elements before re-filling the array.
                      * e.g.
                      declare reuse[200]
                      *
                      DO WHILE .t.
                        * (code to pick and open dbf)
                        * (code to pick and open dbf)
                        afields(m->reuse)
                        fieldpick = achoice(10,10,20,40,m->reuse)
                        * (do something with field selected)
                        * (do something with field selected)
                        DELARRAY(m->reuse)
                      ENDDO
 
  Found in : S_DELAR.PRG
  
  -------------------------------------------------
  Function            DELREC()
  Action              Dialog box to delete/undelete current record
  Returns             <expN> If deleted 1, if undeleted-1, if no action 0
  Category            Popup
  Syntax              DELREC()
  Description         Asks for delete/undelete record with menu prompt
                      and then deletes/undeletes or not
                      If current record is not deleted, prompt will be
                      DELETE  NOACTION
                      If current record is deleted, prompt will be
                      UNDELETE  NOACTION
  Examples            IF m->choice = 6
                            delcount = DELREC()
                      ENDIF
  Warnings            Cursor is left ON
 
  Found in : S_DELET.PRG
  
  -------------------------------------------------
  Function            DOITALL()
  Action              Generic menu driven data entry module
  Returns
  Category            Metafunction
  Syntax              DOITALL([array1],[array2],[array3],[array4])
  Description         Presents a menu driven data entry screen for
                      the current dbf, with options for Next Previous
                      Search Lookup Edit Add Delete and Other.
                      By default uses all fields in the current
                      DBF, but may be passed two arrays
                      to restrict field access:
  
  Options             Optional Parameters are:
                      1. Array of options for 'Other' menu
                      2. Procs to perform to match these options
                      3. Array of field names
                      4. Array of field descriptions
  
                      Both arrays 1 and 2 must be passed if one is passed.
                      Both arrays 3 and 4 must be passed if one is passed.
                      Last menu item must be QUIT or EXIT. An exit
                      from the OTHER menu is performed if the last
                      item is selected.
  Examples
                      use Customer index Customer
                      Doitall()
  
                      * or....
  
                      use Customer index Customer
                      private a1[3],a2[3]
                      a1[1]= "Query"
                      a1[2]= "Print"
                      a1[3]= "Quit"
  
                      EXTERNAL QUERY,LISTER
                      a2[1]= "QUERY"       && call QUERY()
                      a2[2]= "LISTER"      && call LISTER()
                      a2[3]= " "           && NOTE: no parentheses.
  
                      DOITALL(m->a1,m->a2)
  
                      * or with optional field arrays.....
  
                      declare useflds[3],flddesc[3]
                      useflds[1]="LAST"
                      useflds[2]="FIRST"
                      useflds[3]="MI"
                      flddesc[1]="Last Name"
                      flddesc[2]="First Name"
                      flddesc[3]="Middle Init"
  
                      DOITALL(m->a1,m->a2,m->useflds,m->flddesc)
  
  Notes
                      I would use this, normally, if my program was
                      not going to know ahead of time what a dbf might
                      look like - or even what dbf will be used.
                      Obviously if you know what your dbf is going to
                      look like you can come up with a slicker, customized
                      interface.
  
                      DOITALL() takes over the PGUP PGDN keys during
                      its menu phase by SETing KEYs to them. So be
                      careful of any popup procs you may be using - PGUP
                      and PGDN will not be available.
  
                      If passing arrays for the OTHER menu, be sure the
                      procs to be called are known to the compiler, either
                      by being called elsewhere in the program, or by
                      using EXTERNAL. (see above)
  
  Warnings            Key -9 is unset on exit (F10), Cusor is left ON.
 
  Found in : S_DOALL.PRG
  
  -------------------------------------------------
  Function            DRIVE()
  Action              Gets currently selected drive letter
  Returns             <expC> drive letter ABCDEF etc
  Category            File
  Syntax              DRIVE()
  Description         Returns current drive (ABCDEF etc) as a letter
                      without the colon [:].
  Options
  Examples            @24,0 say "Current Drive is "+DRIVE()+":"
  
 
  Found in : S_DRIVE.PRG
  
  -------------------------------------------------
  Function            DUPLOOK()
  Action              Locates possible duplicates based on user criteria
  Returns
  Category            Metafunction
  Syntax              DUPLOOK([expC])
  Description         Searches current dbf for exact duplicates of
                      field(s) selected by user. User picks a field
                      or fields, DUPLOOK() creates an index and prepares
                      a possible duplicates report.
  
  Options             <expC> Character expression as additional info for
                      each report line printed. (report normally only
                      refers to record# and the fields selected )
  
  Examples            DUPLOOK("Lastname+'  '+Firstname")
                      * whatever fields the user picks to check duplicates
                      * on, the LASTNAME and FIRSTNAME fields are also
                      * printed on the report.
  
                      Sample Output:
  
                      Record #   FNAME
                          1      GARRY
                          2      GARRY
  
  Warnings            THIS FUNCTION CLOSES ANY OPEN INDEXES.
                      YOU WILL NEED TO RE-OPEN INDEXES ON EXIT.
  
  Warnings            Key -9 is unset on exit (F10), cursor is left ON
 
  Found in : S_DUP.PRG
  
  -------------------------------------------------
  Function            EDITDB()
  Action              Customized DBEDIT() with UDF
  Returns
  Category            Metafunction
  Syntax              EDITDB([expL],[expN],[array],[array])
  Description         Customized DBEDIT() interface allowing searching,
                      goto, vertical view and (if <expL> is True) add
                      edit delete.
                      Also allows limiting of fields viewed.
  Options             [expL] allows add-edit-delete or not. Number
                      of fields is contained in [expN]. The two arrays
                      are of field names and field descriptions. Default
                      is all fields, field names as descriptions.
  Examples
                      USE CUSTOMER
                      private flds[3],fdes[3]
                      flds[1] = "fname"
                      flds[2] = "lname"
                      flds[3] = "mi"
                      fdes[1] = "First Name"
                      fdes[2] = "Last Name"
                      fdes[3] = "Middle Initial"
                      editdb(.t.,3,flds,fdes)
                      ...
                      or
                      ...
                      USE CUSTOMER
                      editdb()
                      ...
  Notes               Allows record deletion, but does not pack.
                      Does not 'SET DELETED' one way or the other.
  
  Warnings            Key -9 is unset on exit (F10),cursor is left ON
 
  Found in : S_EDIT.PRG
  
  -------------------------------------------------
  Function            EDITMEMO()
  Action              Performs a windowed memoedit() on a memo field
  Returns
  Category            Popup
  Syntax              EDITMEMO([expC],[expN1],[expN2],[expN3],[expN4])
  Description         Pops up a box allowing editing of a memo field.
                      Escape exits, F10 saves.
  Options             Edits field named MEMO by default, otherwise
                      fieldname passed as [expC]. Uses coordinates
                      2,10,20,69 unless passed coordinates as
                      [expN1..expn4] (top,left,bottom,right)
  Examples            editmemo()
                      editmemo("NOTES")
                      editmemo("NOTES",2,2,22,78)
  
  Notes               Sets key -9 to CTRLW  (F10)
  
  Warnings            Key -9 is unset on exit (F10),cursor is left ON
 
  Found in : S_EDITM.PRG
  
  -------------------------------------------------
  Function            ED_G_PIC()
  Action              Returns appropriate picture for a get
  Returns             <expC> picture clause
  Category            Editing
  Syntax              ED_G_PIC(<expC>)
  Description         Returns a picture clause appropriate for
                      editing field where <expC> is the name of the
                      field.
  Options
  Examples            @10,10 GET AMOUNT PICT ED_G_PIC("AMOUNT")
                      * would return a picture of "9999.99" depending
                      * on length and decimals
  
  Examples found in   S_EDIT.PRG S_GLOBR.PRG S_QUERY.PRG S_LOOKF.PRG
                      S_GENED.PRG
  
 
  Found in : S_EDPICT.PRG
  
  -------------------------------------------------
  Function            ENHANCED()
  Action              Returns color integer for ENHANCED setting
  Returns             <expN> color integer for ENHANCED setting
  Category            Screen
  Syntax              enh = ENHANCED()
  Description         Gets the 2nd part of the color string and
                      converts it to color
  Options
  Examples            enh = ENHANCED()
                      ATT(10,10,10,20,m->enh)
 
  Found in : S_ENHAN.PRG
  
  -------------------------------------------------
  Function            FORMDATE()
  Action              Returns formatted date (i.e. September 10, 1989)
  Returns             Date as words
  Category            String
  Syntax              FORMDATE(<expD>)
  Description         Returns a string of words when passed a date.
  Options
  Examples            FORMDATE(DTOC("09/10/89"))
                      will return "September 10, 1989"
  
  Notes               I use this to imbed date in form letters.
  
 
  Found in : S_FDATE.PRG
  
  -------------------------------------------------
  Function            FASTFORM()
  Action              Prints a selected formletter for current record
  Returns
  Category            Metafunction
  Syntax              FASTFORM()
  Description         Presents a picklist of formletters to print
                      against contents of current record.
  Examples            If m->choice = 4   && form letter
                          FASTFORM()
                      endif
  Notes               Utilizes a form created by FORMLETR() and plugs
                      in values from the current record.
                      Interface is a picklist of forms available.
                      Depends on the current DBF to match the field
                      values in the form.
  
 
  Found in : S_FFORM.PRG
  
  -------------------------------------------------
  Function            FGETLEN()
  Action              Get length of a field in current DBF
  Returns
  Category            DBF
  Syntax              FGETLEN(<expC>)
  Description         Pass a field name in the currently open
                      DBF to get the length of it.
  
  Examples            FGETLEN("FNAME")
  
 
  Found in : S_FGETLE.PRG
  
  -------------------------------------------------
  Function            FILEREAD()
  Action              Lists a text file of unlimited size
  Returns
  Category            Metafunction
  Syntax              FILEREAD([expN1],[expN2],[expN3],[expN4],[expC])
  Description         Lists a text file [expC] of unlimited size in a user
                      definable window. [expN1..expN4]  (top,left bottom,
                      right) Allows up down right left scrolling. I use this
                      for reports or output sent to a disk file.
  Options             If [expN1..expN4] are not passed, a default of
                      window of dimensions 2,2,22,78 is used. If no
                      filename [expC] is passed, a popup picklist is
                      used to get a file name from the current
                      directory.
  Examples
                      REPORT FORM summary TO summary.txt
                      FILEREAD(2,2,22,78,"SUMMARY.TXT")
  
  Notes               Unlimited file size. Won't bomb like memoedit.
                      However, not nearly as fast as memoedit and
                      no editing capabilities.
  
                      Fileread uses a 98% Clipper code routine to
                      list text files.
  Warning             Cursor is left ON
 
  Found in : S_FILER.PRG
  
  -------------------------------------------------
  Function            FORMLETR()
  Action              Interactive formletter and mailmerge utility
  Returns
  Category            Metafunction
  Syntax              FORMLETTER([array],[array])
  Description         Provides a menu driven interface to the
                      creation, modification and merging of form
                      letters with DBFs.
  Options             Two arrays may be passed - array 1 is an array
                      of allowable field names. Array two is an array
                      of field descriptions. All fields are used as
                      a default, with field names being the default
                      field descriptions.
  Examples
                      USE CUSTOMER
                      private flds[3],fdes[3]
                      flds[1] = "fname"
                      flds[2] = "lname"
                      flds[3] = "mi"
                      fdes[1] = "First Name"
                      fdes[2] = "Last Name"
                      fdes[3] = "Middle Initial"
                      formletr(flds,fdes)
                      ...
                      ....or....
                      USE CUSTOMER
                      formletr()
                      ...
  
  Warnings            Key -9 is unset on exit (F10)
                      Key -1 is unset on exit (F2)
                      Key 23 is unset on exit (F1)
                      Cursor is left ON
 
  Found in : S_FORML.PRG
  
  -------------------------------------------------
  Function            FULLDIR()
  Action              Interactively navigate directories
  Returns             <expL> True if directory change occurred
  Category            Metafunction
  Syntax              FULLDIR()
  Description         Interactively navigates directories on the
                      current drive.
                      Allows pop-up list of files in a directory.
                      Allows reading of a file ( with FILEREAD() )
                      in a directory.
                      If file is DBF, does a DBEDIT browse (watch
                      your memory..)
  Examples
                      if FULLDIR()
                          ?"New directory is:"
                          ?Curdir()
                      endif
  
 
  Found in : S_FULLD.PRG
  
  -------------------------------------------------
  Function            GENED()
  Action              Generic dbf editing screen
  Returns
  Category            Metafunction
  Syntax              GENED([expL],[expN1],[expN2],[array1],[array2])
  Description         Edit ( [expL]=.f.) current record or
                      Add  ( [expL]=.t.) new record.
  Options             Window top [expN1] and bottom [expN2] default to
                      centered.
  
                      Use optional [array1] (field names) and
                      [array2] (field descriptions), or use all fields
                      in dbf.
  
  Examples            use Customer index Customer
                      Gened(.f.,2,20)             && edit
                      ...
                      or
                      use Customer index Customer
                      Gened(.t.,3,15)             && add
                      ...
                      or
                      use Customer index Customer
                      Gened()                     && edit
                      ...
  
  Notes               Sets keys -9 (F10) and -1 (F2)
                      Allows memo editing (multiple memo fields)
  
  Warnings            Key -9 is unset on exit (F10)
                      Key -2 is unset on exit (F3)
                      Cursor is left ON
 
  Found in : S_GENED.PRG
  
  -------------------------------------------------
  Function            GENVAL()
  Action              Generic VALID clause validation with message
  Returns             <expL> logical result of passed condition
  Category            Editing
  Syntax              GENVAL(<expC1>,<expC2>)
  Description         Evaluates macro expansion of <expC1> as a logical
                      value. If result is False, displays message <expC2>
                      and waits for a keypress.
  Examples
                      if genval("fcount() < 60","Too many fields")
                         COPY TO TEMP
                      endif
  
                      * ...or as a VALID CLAUSE
  
                      @10,10 get m->lname VALID GENVAL("!empty(m->lname)",;
                        "Need a last name,please")
  
 
  Found in : S_GENVA.PRG
  
  -------------------------------------------------
  Function            GETAKEY()
  Action              Gets intent of last keystroke
  Returns             <expC> as key direction (FWD,BWD,ESC,CTW,UNK)
  Category            Editing
  Syntax              GETAKEY(lastkey())
  Description         Gives key direction of last key, for evaluating
                      what direction in a read the user is heading.
  Examples            If GETAKEY(LASTKEY())="FWD"
                          active_field = active_field+1
                      elseif GETAKEY(LASTKEY())="BWD"
                          active_field = active_field+1
                      endif
  
  
 
  Found in : S_GETKEY.PRG
  
  -------------------------------------------------
  Function            GLOBREP()
  Action              Performs global selective replace of a field
  Returns
  Category            Metafunction
  Syntax              GLOBREP([array])
  Description         Allows user to point to a field, optionally field
                      given in [array], and then enter a replacement
                      value for it. Replacement can be executed for
                      all records, query matches, or tagged records.
  
  Options             Optional field array [array] with default being
                      all fields in dbf.
  
  Examples            If choice = 9  && Global replace
                          GLOBREP()
                      endif
  Warnings            These changes are, of course, permanent.
  
  
 
  Found in : S_GLOBR.PRG
  
  -------------------------------------------------
  Function            HELP()
  Action              Provides context sensitive popup help
  Returns
  Category            Help
  Syntax              SET KEY xxx TO HELP
  Description         By setting a key xxx to this function, the
                      current PROC and VARIABLE are passed to it
                      when the key is pressed during the program.
                      By comparing the PROC and VARIABLE parameters
                      against entries in the HELP.DBF, HELP() can
                      then provide the appropriate help screen for
                      the user. If no matching record is found, HELP()
                      displays a 'No Help Found' message to the user.
  
                      HELP() works in conjunction with HELPMOD() which
                      is used to create help screen records for the
                      HELP.DBF. HELPMOD() allows online creation and
                      modification of the size, location and contents
                      of the help screen for the current PROC,VARIABLE
                      combination.
  
                      It is important to issue the following statement
                      in your code: EXTERNAL HELP
                      This is due to Clipper not recognizing and linking
                      in procs that are only referenced as SET KEY's.
  Examples            EXTERNAL HELP
                      SET KEY 28 to HELP
  Notes               This approach has two major limitations. When a SET
                      KEY function is called while the program is in
                      ACHOICE(), only the ACHOICE is passed as a PROC, and
                      no variable is passed. Thus, only one help screen
                      for the proc ACHOICE is definable for an entire
                      system.
  
                      The 2nd is a difficulty with MENU TO. The PROC and
                      VARIABLE allow 1 help screen per MENU TO, as the
                      PROC,VARIABLE stays the same no matter which option
                      is hilited.
  
                      Both FUNCKY and GET-IT (libraries) have functions
                      which would help get around these limitations.
  
                      For READS, however, this HELP works pretty well.
  
  Warnings            The 'HELP' key is still active while in this
                      proc. If you have a means of turning the
                      help key off and on, do so here.
  
 
  Found in : S_HELP.PRG
  
  -------------------------------------------------
  Function            HELPMOD()
  Action              Interactively build and modify help screens
  Returns
  Category            Development
  Syntax              SET KEY xxx TO HELPMOD
  Description         HELPMOD() creates and modifies help screens for
                      HELP() which are stored in HELP.DBF.
                      HELPMOD() allows online creation and
                      modification of the size, location and contents
                      of the help screen for the current PROC,VARIABLE
                      combination, and stores the results in HELP.DBF.
  
                      HELPMOD() is intended to be used online, during
                      program execution, by the developer/programmer.
                      It can be removed after development.
  
                      By setting a key xxx to this function, the
                      current PROC and VARIABLE are passed to it
                      when the key is pressed during the program.
                      By comparing the PROC and VARIABLE parameters
                      against entries in the HELP.DBF, HELPMOD() can
                      then provide the appropriate help screen for
                      modification, or, if no matching record is found,
                      allow creation of a new help screen record.
  
                      It is important to issue the following statement
                      in your code: EXTERNAL HELPMOD
                      This is due to Clipper not recognizing and linking
                      in procs that are only referenced as SET KEY's.
  
                      HELP.DBF is created if not present.
  
  Examples            EXTERNAL HELPMOD
                      SET KEY -30 TO HELPMOD   && alt-F1
  Notes               This approach has two major limitations. When a SET
                      KEY function is called while the program is in
                      ACHOICE(), only the ACHOICE is passed as a PROC, and
                      no variable is passed. Thus, only one help screen
                      for the proc ACHOICE is definable for an entire
                      system.
  
                      The 2nd is a difficulty with MENU TO. The PROC and
                      VARIABLE allow 1 help screen per MENU TO, as the
                      PROC,VARIABLE stays the same no matter which option
                      is hilited.
  
                      Both FUNCKY and GET-IT (libraries) have functions
                      which would help get around these limitations.
  
                      For READS, however, this HELP works pretty well.
  
  Warnings            HELP.DBF is a common enough name. If problems
                      arise, make sure there is not an old HELP.DBF
                      with a different file sctructure in the directory.
  
  Warnings            Key -9 is unset on exit (F10),Cursor is left ON
 
  Found in : S_HELPM.PRG
  
  -------------------------------------------------
  Function            INITSUP()
  Action              Initialized global variables and conditions
  Returns
  Category            Environment
  Syntax              INITSUP()
  Description         INITSUP() simply initializes the global colors
                      expected by Metafunction functions if they are
                      not already present, and sets the TYPEAHEAD to
                      100 to accomodate SCROLLER and SMALLS.
  Examples            * beginning of top level program
                      INITSUP()
  Examples found in   Almost all Metafunction functions.
  
  Notes               Its always a good idea to call this at your
                      top level program.
  
 
  Found in : S_INIT.PRG
  
  -------------------------------------------------
  Function            INITCOL()
  Action              Initializes global colors for the library
  Returns
  Category            Environment
  Syntax              INITCOL()
  Description         Sets up as PUBLIC the global color and screen
                      variables used by the Metafunctions
  Examples            if type("C_NORMCOL")<>"C"
                         INITCOL()
                      endif
  Notes               No real need to call this, as it is called if
                      needed by INITSUP()
  
 
  Found in : S_INITC.PRG
  
  -------------------------------------------------
  Function            ISLOADED()
  Action              Determines  function is loaded or not
  Returns             <expL> is ISLOADED(<expC>) loaded
  Category            Other
  Syntax              <expL> = ISLOADED(<expC>)
  Description         This function will test for <expC> being loaded
                      into memory. <expC> can be any function in the form
                      "FUNCTION()" but must refer to a function NOT in
                      CLIPPER.LIB.
  Examples            if ISLOADED("QUERY()")
                         @row()+1,3 prompt "Build Query"
                      endif
  
 
  Found in : S_ISLOAD.PRG
  
  -------------------------------------------------
  Function            ISPART()
  Action              Determines if a number is part of a set
  Returns             <expL> if number is part of set
  Category            Other
  Syntax              ISPART(<expN1>,<expN2>,<expN3>,...<expN10>)
  Description         Compares a number <expN1> to a set of numbers
                      <expN2..expN10> to determine if it is equal to
                      any of them. Returns True if it is, False otherwise.
  Options             Up to 9 numbers to compare.
  Examples            If ISPART(choice,5,6,7,12)
                        MSG("Need a DBF open")
                        loop
                      endif
  
 
  Found in : S_ISPART.PRG
  
  -------------------------------------------------
  Function            KBD_ESCAPE()
  Action              Keyboards character 27 (escape) when key pressed
  Returns
  Category            Keyboard
  Syntax              SET KEY xxx TO KBD_ESCAPE
  
  Description         Allows setting an alternate key to the ESCAPE
                      key. ESCAPE normally means 'get me outta here',
                      but sometimes is the key you need to indicate
                      the user is done selecting or some such. This
                      function allows setting another key (e.g. F10)
                      to act as the ESCAPE key.
  
  Examples found in   EXTERNAL KBD_ESCAPE
                      SET KEY -9 TO KBD_ESCAPE
  
  Notes               Declare as EXTERNAL i.e.
                      EXTERNAL KBD_ESCAPE
  
  Warnings            Be sure to issue a SET KEY xxx TO command to
                      un-map this function when done
  
 
  Found in : S_KBDESC.PRG
  
  -------------------------------------------------
  Function            LISTER()
  Action              Build, format and print lists to printer,screen,file
  
  Category            Metafunction
  
  Syntax              LISTER([array1],[array2],[array3],[array4])
  
  Description         A menu driven utility for creation, printing and
                      storage of list definitions.
  
                      The user is asked to pick the fields to be
                      included on the list. The selected fields, in the
                      order in which they will be listed, are shown in
                      the bottom information box.
  
                      The user may select which records are to be
                      included in the list - all records, query matches
                      or tagged records.
  
                      The user may select output as PRINTER, SCREEN or
                      FILE, and choose the maximum line length to avoid
                      printer wraparound.
  
                      The user may save list definitions to PLIST.DBF
                      and later restore them.
  
  Options             Four arrays may be passed - fieldnames [array1],
                      field descriptions [array2], field types [array3],
                      and field lengths [array4]. All or none must be
                      passed. Normally, field names are used as the
                      column headings for the list, but if [array2] is
                      passed, these descriptions are used in the column
                      headings of their corresponding fields.
  
                      By default, all fields are used, field names are
                      used for descriptions and AFIELDS() is used to
                      get the types and lengths.
  Examples
                      USE CUSTOMER
                      private flds[3],fdes[3],ftype[3],flen[3]
                      afields(m->flds,m->ftype,m->flen)
                      fdes[1] = "First Name"
                      fdes[2] = "Last Name"
                      fdes[3] = "Middle Initial"
                      lister(flds,fdes,dtype,flen)
                      ...
                      or
                      ...
                      USE CUSTOMER
                      lister()
                      ...
  Notes               This is a 2nd generation of PRNTLST(). I like it
                      better in that it is easier to go into the code
                      and follow what's going on with it. It makes more
                      use of arrays, and less use of MACROS. Its also
                      a better foundation to build more intelligent
                      report capabilities on top of.
  
  Warnings            Key -9 is unset on exit (F10)
  
 
  Found in : S_LIST.PRG
  
  -------------------------------------------------
  Function            LOOKFLD()
  Action              Interactive locate on any field
  Returns
  Category            Metafunction
  Syntax              LOOKFLD([array1],[array2])
  Description
                      Lookfld() pops up a window of the fields, and then
                      asks for a <range of> value(s) to search for.
                      If a LOCATE is successful, the next call to
                      lookfld() will optionally do a CONTINUE.
  Options
                      Arrays of FIELDS [array1] and FIELD DESCRIPTION
                      [array2] may be sent as params, and the selection is
                      then limited to the fields in these arrays
  Examples
                      if choice = 5 && search for date
                        LOOKFLD()
                      endif
                      ....or
                      * assumes fields[] and fdesc[] exist
                      if choice = 5 && search for date
                        LOOKFLD(m->fields,m->fdesc)
                      endif
  
  Notes               RECORD POINTER IS LEFT ON NEW RECORD IF FOUND
  
                      The variable lf_cont_  is made public. lf_cont_
                      determines if a CONTINUE is appropriate.
  
                      The variables lk_fld_ and lk_lookr are declared public
                      as they are a variable part of the LOOKUP command to be
                      given. Since we will exit this function but we want
                      these vars to survive for a CONTINUE, they are declared
                      public. If they were not declared public, a continue
                      would not be possible.
  
                      Best description: open a DBF and call LOOKFLD()
  
  Warnings            Cursor is left ON
 
  Found in : S_LOOKF.PRG
  
  -------------------------------------------------
  Function            LOOPER()
  Action              Emulate multiple reads with single reads
  Returns
  Category            Editing
  Syntax              LOOPER(<array>)
  Description         Allows a group of gets to be READ individually,
                      but appear to be a single READ.
  
                      This function allows complex functions to be called for
                      VALID which can use their own READs and not
                      interrupt a read stack. This can give the apparancy
                      of nested READs. Recursive calls to this function
                      can be done as well.
  
                      Each element of <array> is a delimited string of
                      row,col,get,picture,valid clause.
                      ( "row:col:getname:picture:valid"  )
  Examples            .
                      *- first declare any called functions external
                      EXTERNAL YOURFUNC
                      *- initialize an array
                      private sayg[3]
  
                      *  initialize the memvars to be read - IMPORTANT
                      PHONE = space(14)
                      CHARGE = 0
                      NAME= SPACE(20)
  
                      *       column-|
                      *        row   | get name  picture       valid
                      *          |   |   |       |              |
                      sayg[1]="10:10:M->phone:(999)999-9999:!empty(m->phone)"
                      sayg[2]="11:10:M->charge:@K 99.99"
                      sayg[3]="12:10:M->name:!:YOURFUNC()"
  
                      LOOPER(m->sayg)
  
  
 
  Found in : S_LOOP.PRG
  
  -------------------------------------------------
  Function            MAKEBOX()
  Action              Draws a shadow box on the screen, saves the screen
  Returns             <expC> string containing underlying screen & colors
  Category            Popup
  Syntax              MAKEBOX(<expN1>,<expN2>,<expN3>,<expN4>,[expC],[expN5])
  
  Description         Draws a box on the screen at coordinates <expN1..expN4>
                      (top,left,bottom,right). Returns a string containing
                      the underlying screen and previous color. Box will
                      explode or not based on the global variable C_XPLODE.
                      To bypass the global C_XPLODE setting, save C_XPLODE
                      to another variable, set C_XPLODE to the desired
                      setting, call MAKEBOX() and ensuing code. Then restore
                      C_XPLODE to its prior global status.
  
  Options             Default color is C_POPCOL and default shadow position
                      is the global variable C_SHADPOS. These may be passed
                      as options . Shadow position [expN5] has allowable
                      values of (1,3,7,9,0) to match the corner positions on
                      the numeric keypad. 0 is no shadow. [expC] is a valid
                      color string or variable.
  
  Examples            box = MAKEBOX(5,5,10,10)
                      * draws a box at 5,5,10,10. Color is C_POPCOL. Shadow
                      * position is based on C_SHADPOS.
  
                      box = MAKEBOX(5,5,10,10,C_POPCOL)
                      * draws a box at 5,5,10,10. Color is C_POPCOL. Shadow
                      * position is based on C_SHADPOS.
  
                      box = MAKEBOX(5,5,10,10,C_POPCOL,9)
                      * draws a box at 5,5,10,10. Color is C_POPCOL. Shadow
                      * position is 9 (upper right hand corner).
  
  Notes               UNBOX() removes the box and restores the
                      underlying screen and prior colors.
  
  Warnings            USE ONLY UNBOX() TO REMOVE SCREENS STORED WITH
                      MAKEBOX.
  
 
  Found in : S_MAKEB.PRG
  
  -------------------------------------------------
  Function            MCHOICE()
  Action              Creates a box for an Achoice call
  Returns             <expN> Achoice selection
  Category            Popup
  Syntax              MCHOICE(<expC1>|<array>,<expN1..expN4>,[expC2],[expL])
  Description         Provides a box for an achoice on array named <expC1>
                      or array <array>
                      of dimensions <expN1..expN4> (top,left,bott,right)
  
  Options             Title <expC2> i.e. "Select One"
                      <expL> determines (yes or no) whether a return is
                      to be executed on a first letter match. (default .f.)
  
  Examples            *
                      declare MEALS[3]
                      meals[1]= "Pizza"
                      meals[2]= "Chicken"
                      meals[3]= "Chinese"
  
                      * box only, no title
                      selection = MCHOICE(m->meals,10,10,5,25)
                           *or
                      * box with title
                      selection = MCHOICE("meals",10,10,5,25,"Pick-a-Meal")
                           *or
                      * box with title, first letter match = return
                      selection = MCHOICE(m->meals,10,10,5,25,"Pick-a-Meal",.f.)
  
  Notes               Bottom of window adjusts (shrinks) to adjust to
                      array size.
  
                      Yes, I know. I could have just passed the array
                      instead of the name of the array. Well, live and
                      learn. I've left it this way for compatibility with
                      the option to pass an actual array as well.
  Warning             Cursor is left ON
 
  Found in : S_MCHOI.PRG
  
  -------------------------------------------------
  Function            MENU_V()
  Action              Vertical popup menu from variable # parameters
  Returns             <expN> selection - 0 for no selection
  Category            Menu
  Syntax              MENU_V(<expC1>,<expC2>,<expC3>,...<expC16>)
  Description         Creates a popup vertical menu in a centered
                      box, using <expC1> as the title, and performing
                      a menu to on <expC1...expC16> (variable #)
                      <expC1> may be passed as "" for no title.
  Examples
                      choice = menu_v("Selection","Edit","Add","Quit")
                      *-or-
                      choice =menu_v("","Edit","Add","Quit")
  
  Warnings            A MENU TO is performed which tends to blow
                      active gets. Be careful if doing this during
                      a READ.
                      Cursor is left ON
  
 
  Found in : S_MENUV.PRG
  
  -------------------------------------------------
  Function            MESSYN()
  Action              Popup YesNo prompt box
  Returns             <expL> True for yes, False for No
  Category            Popup
  Syntax              MESSYN(<expC1>,[expN1],[expN2],[expC3],[expC4])
  Description         Pops up a box and displays a question <expC1>
                      and two prompts.
  
  Options             [expN1] and [expN2] are optional box top and left
                      coordinates. Default is centered. [expC3] and [expC4]
                      are optional prompts 1 and 2. Default is YES and NO.
  
                      The options can be given in any of the following
                      arrangements:
                        [expN1],[expN2],[expC3],[expC4]
                        [expC3],[expC4],[expN1],[expN2]
                        [expC3],[expC4]
                        [expN1],[expN2]
  
  Examples            if messyn("Are you done")
                or    if messyn("Are you done",10,10)
                or    if messyn("Are you done",10,10,"Not yet","Almost")
                or    if messyn("Are you done","Not yet","Almost",10,10)
                or    if messyn("Are you done","Not Yet","Almost"
  
  Warnings            Cursor is left ON
 
  Found in : S_MESSYN.PRG
  
  -------------------------------------------------
  Function            MFIELDS()
  Action              Pops up an achoice for current dbf fields
  Returns             <expC> field name or "" if none selected
  Category            Popup
  Syntax              <expC> = Mfields([expC],[expN1..expN4])
  Description         Popus up a box and presents an achoice() for the
                      current dbf fields.
  Options             [expC] title for box. [expN1..expN4]  coordinates
                      of the box. Default is centered.
  Examples            fieldname = MFIELDS()
                      *or
                      fieldname = MFIELDS("Pick a Field")
                      *or
                      fieldname = MFIELDS("Pick a Field",10,10,20,40)
  
  
  Warnings            Cursor is left ON
 
  Found in : S_MFLD.PRG
  
  -------------------------------------------------
  Function            MODIS()
  Action              Interactive modify or create structure
  Returns             Name of the dbf, less extension
  Category            Metafunction
  Syntax              MODIS([expC1],[expC2]|[array])
  Description         Interactive create or modify structure for DBF
                      files. If creating, allows import of an existing
                      structure.
  
  Options             [expC1] is "C" or "M" for Create or Modify. Default
                      is to prompt the user. [expC2]|[array] is either
                      the name of the dbf file or an array of allowable
                      dbf files.
  
  Examples            MODIS("C")
                      * create, prompt for name
                      *or
  
                      MODIS("M","CUSTOMER.DBF")
                      * modify customer.dbf
                      *or
  
                      declare okdbfs[3]
                      okdbfs[1]="CUSTOMER.DBF"
                      okdbfs[2]="INVOICE.DBF"
                      okdbfs[3]="TEMP.DBF"
  
                      MODIS("M",m->okdbfs)
                      * modify , selecting from array of dbfs
  
  Warnings            Make sure there is sufficient diskspace.
  
  Warnings            Key -9 is unset on exit (F10), DELETED is
                      left OFF
  
 
  Found in : S_MODIS.PRG
  
  -------------------------------------------------
  Function            MSG()
  Action              Displays up to a 9 line message in a window
  Returns
  Category            Popup
  Syntax              Up to 9 character strings as lines in the message .
  Description         Displays in a popup box up to 9 lines of a message.
                      Then waits for a keypress or optionally a time-out.
  Options             First parameter can be a number equalling a time-out
                      value in seconds
  Examples            MSG("An error has been detected","...don't move!")
                      MSG("A","B","C","D","E","F")
                      MSG(5,"A","B","C","D","E","F")
  Examples found in   S_CLAB.PRG S_DOALL.PRG S_DUP.PRG S_FILER.PRG S_FORML.PRG
                      S_FULLD.PRG S_GENVA.PRG S_GLOBR.PRG S_HELP.PRG S_LIST.PRG
                      S_LOOKF.PRG S_MODIS.PRG S_NEWDIR.PRG S_PREAD.PRG
                      S_PRINT.PRG S_QUERY.PRG S_SCROLL.PRG S_SUMAV.PRG
                      S_TAG.PRG S_ISPART.PRG
  Notes               Message is centered on screen in a box
                      Once message is displayed, waits for keypress and
                      then removes window, restoring screen underneath.
                      Or waits for time-out value.
  
  Warnings            Cursor is left ON
 
  Found in : S_MSG.PRG
  
  -------------------------------------------------
  Function            NKEY()
  Action              Gets key of an index file
  Returns             <expC> index key expression
  Category            File
  Syntax              NKEY(<expC>)
  Description         Gets key expression of index <expC>. <expC> is
                      the name of the index including extension. The
                      function operates differently from .ntx to .ndx.
  Examples            ndxknt = adir("*.ndx")
                      declare ind[ndxknt]
                      adir(ind,"*.ndx")
                      for i = 1 to ndxknt
                          ?"Key for index: "+ind[i]+" is "+NKEY(ind[i])
                      next
  
  Warnings            Uses up a file handle temporarily.
  
 
  Found in : S_NKEY.PRG
  
  -------------------------------------------------
  Function            OCCUR()
  Action              Build and display frequenty analysis for field
  Returns
  Category            Metafunction
  Syntax              Occur([array1],[array2])
  Description         Allows selection of a field and builds a
                      frequency count for values in that field.
                      A frequency count here being the number of
                      times each unique value for a given field
                      occurs in a database.
  Options             [array1] and [array2] are optional arrays of
                      field names and descriptions to use.
  
  Examples            OCCUR()
                       * or
                      USE CUSTOMER
                      private flds[3],fdes[3]
                      flds[1] = "fname"
                      flds[2] = "lname"
                      flds[3] = "mi"
                      fdes[1] = "First Name"
                      fdes[2] = "Last Name"
                      fdes[3] = "Middle Initial"
                      OCCUR(m->flds,m->fdes)
  
  Warnings            Cursor is left ON
  
 
  Found in : S_OCCUR.PRG
  
  -------------------------------------------------
  Function            ONE_READ()
  Action              Pop-up window with 1-4 Say/Get combinations
  Returns
  Category            Popup
  Syntax              ONE_READ(<expC1>,<expC2>,<expC3>,...)
  
  Description         For 1-4 iterations of <expC1..expC3>, a popup
                      window will display a Say <expC1>, do a Get on
                      the variable named in <expC2> with a Picture
                      of <expC3>. A read will then be issued.
  Examples            c_date = date()
                      c_time = space(8)
                      fun  = .t.
                      ONE_READ("Current Date","C_DATE","@D",;
                               "Current Time","C_TIME","99:99:99")
                               "Having Fun ?","FUN","Y")
  
  Notes               What I've since realised is that <expC2> should
                      actually be passed by reference (@). This would
                      cut down on all the macro-expansionitis.
  
                      ASSUMES GET VARIABLES HAVE BEEN INITIALIZED
                      IN CALLING PROGRAM
                      (I use this where I just need a quick read and don't
                       want to alter my current screen)
  
                      I've found it necessary to use odd variable names
                      as just a PRIVATE declare won't do. (this comes
                      about when a variable name such as WIDTH is
                      passed - if this proc has a variable named WIDTH,
                      (which it did), then the wrong WIDTH would be
                      READ. So, the variables have some very strange
                      names.
  
  
 
  Found in : S_ONER.PRG
  
  -------------------------------------------------
  Function            PLSWAIT()
  Action              Pops up a 'Please Wait' window or removes it
  Returns
  Category            Popup
  Syntax              PLSWAIT(<expL>,[expC],[expN1..expN4])
  Description         Pops up a window with a 'please wait' message
                      or removes a previous 'please wait' window.
                      <expL> True = popup window. <expL> False means
                      remove window.
  Options             [expC] - message. Default is 'Please wait...'
                      [expN1..expN4] box coordinates. Defaults are
                      10,20,12,60 (top,left,bottom,right)
  Examples
                      PLSWAIT(.T.,"I'm thinking...")
                      ...code...
                      ...code...
                      ...code...
                      PLSWAIT(.F.)
  
  Notes               Makes public the variables :
                      pls_top,pls_left,pls_bot,pls_right,pl_wait
                      And releases them when called with .f.
  
  
 
  Found in : S_PLSW.PRG
  
  -------------------------------------------------
  Function            POPEX()
  Action              Pops up an achoice for a certain filespec
  Returns             <expC> file name or "" for none
  Category            Popup
  Syntax              <expC> = Popex(<expC>,[expC])
  Description         Pops up a picklist for all files matching the
                      skeleton given as <expC>. i.e. "*.dbf"
  Options             Optional title string - displays at top of box
  Examples            opendbf = POPEX("*.DBF")
  
  Warnings            Cursor is left ON
 
  Found in : S_POPEX.PRG
  
  -------------------------------------------------
  Function            P_READY()
  Action              Determines if printer is ready, prompts user
  Returns             <expL> True if printer is ready
  Category            Popup
  Syntax              if p_ready()
  Description         Checks for printer ready, and prompts user to
                      ready the printer until it is ready, or until
                      user presses escape to abort printing.
  
                      Uses Clipper function ISPRINTER(), so is as
                      reliable as that.
  Examples            if P_READY()
                        REPORT FORM yayaya TO PRINT
                      ENDIF
  
 
  Found in : S_PREAD.PRG
  
  -------------------------------------------------
  Function            PRNTFRML()
  Action              Prints a formletter created by formletr()
  Returns
  Category            Popup
  Syntax              PRNTFRML(<expC>,<expN>)
  Description         Prints the form <expC> from FORMS.DBF with a
                      pagewidth of <expN>.
  Examples            This is used internally by FORMLETR() and
                      FASTFORM(). Refer to its usage there.
  
 
  Found in : S_PRNTF.PRG
  
  -------------------------------------------------
  Function            PULLDN()
  Action              Pulldown menu creator, handler
  Returns             A number in the form menu.prompt (i.e. 2.04)
  Category            Menu
  Syntax              <expN> = PULLDN(<expN>,<array1>,[array2],[array3])
  Description         Draws a pulldown menu with up to 8 seperate
                      boxes. Selection process starts with <expN>.
  
                      Each element of <array1> defines a menu.
                      A menu definition is a delimited string in the
                      form "TITLE:prompt:prompt:prompt" with up to 99
                      prompts per string.
  
  Options             [array2] is a box definition array. It is 7
                      elements long and defines the following:
  
                      Element:   1. <expL> Draw top bar box? T/F
                                 2. <expC> Top bar color
                                 3. <expC> Menu Box color
                                 4. <expC> Menu Box frame
                                 5. <expN> Menu Box shadow position
                                           (0,1,3,7,9)
                                 6. <expN> Menu Box shadow attribute
                                 7. <expN> Row to start menu bar
  
                      [array3] is an array of title column positions
                      to override the internal 'figerin algorithm.
  
  Examples
                      declare box[6],bdata[7]
                      box[1] = "Datafiles:Use Datafile"
                      box[2] = "Indices:Select Indices:Index order"
                      box[3] = "Editing:Field Replacement:Tabular Edit"
                      box[4] = "Reporting:Build Query:Print Lists"
                      box[5] = "Other:List text file:Change Directory"
                      box[6] = "Quit"
                      sf_sel = 1.01
  
                      *- define menu boxes
                      bdata[1]= .t.              && draw the top bar box
                      bdata[2]= 'W/B,GR/R,,,W/N' && top bar color string
                      bdata[3]= 'W/B,N/R,,,W/N'  && drop box color
                      bdata[4]= "ÚÄ¿³ÙÄÀ³ "      && drop box frame
                      bdata[5]= 3                && drop box shadow position
                      bdata[6]= 8                && drop box shadow attribute
                      bdata[7]= 0                && row # of menu bar
  
                      do while .t.
                           sf_sel = PULLDN(sf_sel,box,bdata)
                           do case
                              case sf_sel = 1
                              case sf_sel = 2
                              case sf_sel = 3
                              case sf_sel = 4
                           endcase
                      enddo
  
  Notes               First letter selection takes place on the following
                      priority: next matching element first letter, next
                      matching box title first letter.
  
                      Passing a menu array element with title only will
                      result in no menu box, with the title being
                      the only selection and returning a selection
                      value of <MENU>.1.
                      (i.e. a 'Quit' box)
  
  Warnings            It takes some work to start all options and
                      titles with a first letter that is unique so that
                      first letter selection may take place.
  Warnings            Cursor is left ON
  
  
 
  Found in : S_PULLDN.PRG
  
  -------------------------------------------------
  Function            QUERY()
  Action              Interactive query by example condition builder
  Returns             <expC> macro expandable logical condition expression
  Category            Metafunction
  Syntax              expC = QUERY([ExpN],[array1],[array2])
  Description         A point and shoot condition builder. Complex
                      conditions are allowed with multiple .and./.or.
  
                      Called without parameters, all fields in the
                      current dbf are presented for condition building.
  
  Options             [ExpN],[array1],[array2] give field count, field
                      array and field description array. These, if passed
                      will be used in place of the default of all dbf
                      fields.
  
  Examples
                      USE CUSTOMER
                      private flds[3],fdes[3]
                      flds[1] = "fname"
                      flds[2] = "lname"
                      flds[3] = "mi"
                      fdes[1] = "First Name"
                      fdes[2] = "Last Name"
                      fdes[3] = "Middle Initial"
                      qcond = "lastname > 'CCCC' "
                      filt = query(3,flds,fdes)
                      set filter to &filt
                      ...
                      or
                      ...
                      USE CUSTOMER
                      looker = query()
                      locate for &looker
  
  Notes               Makes variable 'QUERY_EXP' public. This contains the
                      current query expression, which is retained between
                      calls of query, and is looked for by other
                      SUPER functions.
  
  Warnings            Macro expanding the QUERY_EXP variable lengthens
                      the command line on which it is expanded. If the
                      command line goes beyond 254 characters, the
                      program will bomb. If this becomes a problem, create
                      a function called EVAL() or some such that you pass
                      QUERY_EXP to and it just does a return(&query_exp).
                      Then use it like so:
  
                      LOCATE FOR EVAL(m->query-exp)
  
  Warnings            Key -1 is unset on exit (F2)
                      Key -2 is unset on exit (F3)
  
 
  Found in : S_QUERY.PRG
  
  -------------------------------------------------
  Function            SCMOD()
  Action              Maintains scroller.dbf - see scroller()
  Returns
  Category            Development
  Syntax              SET KEY xxx to SCMOD
  Description         SCMOD() is a tool for online building and
                      modifying of the SCROLLER.DBF used for
                      SCROLLER() lookup tables.
  
                      When called by a SET KEY, it recieves the
                      PROCEDURE and VARIABLE parameters from the
                      calling PROCEDURE. It then determines if there
                      exists a matching record in the SCROLLER.DBF.
                      If so, the lookup definition may be modified.
                      Otherwise, a new lookup definition may be created.
  
  Options
  Examples            EXTERNAL SCMOD
                      SET KEY -31 TO SCMOD  && ALT-F2
  
  Examples found in   No examples in the library. This is a development
                      tool.
  
  Notes               Be sure to declare SCMOD external.
  
  Warnings            SCMOD() will blow your get stack. It is primarily
                      for development, so this should not be a problem.
                      If you have a library that saves and restores gets,
                      this would be an indicated place to use them.
  
  Dbfs/indexes used
                      SCROLLER.DBF has the structure :
  
                       Structure for database : SCROLLER.DBF
                       Field  Field Name  Type       Width    Dec
                       calling procedure......... 1  SMODULE     C  8
                       calling variable.......... 2  SFIELD      C  10
                       description............... 3  SDESCR      C  25
                       display string............ 4  SSTRING     C  160
                       return string............. 5  SRETURN     C  75
                       dbf file to lookup into... 6  SDBFILE     C  8
                       index to use with dbf..... 7  SIND        C  8
  
                      SCMOD() will create SCROLLER.DBF if it doesn't exist.
  
  Warnings            Key -1 is unset on exit (F2)
  Warnings            Cursor is left ON
 
  Found in : S_SCMOD.PRG
  
  -------------------------------------------------
  Function            SCROLLER()
  Action              Hotkey lookup tables with dbf storage
  Returns
  Category            Lookup
  Syntax              SET KEY xxx TO SCROLLER
                      Scroller([expC1],[expN],[expC2],[expC3], ;
                               [expC4],[expC5],[expC6],[expC7])
  
  Description         Scroller is primarily a hotkey lookup table
                      engine, although it can be called directly
                      as well. Scroller is data-driven (although
                      that sure is becoming a buzzword) , meaning
                      it can operate on data stored external to
                      the EXE in SCROLLER.DBF.
  
                      SCROLLER() is normally called via a SET KEY.
                      When called, it recieves the parameters
                      PROCNAME and VARIABLE from Clipper, telling
                      it the proc and variable the user was sitting
                      on when he pressed the hotkey. The actual
                      parameters rec'd are PROCNAME,LINE,VARIABLE.
                      Line is ignored, but it is included as the
                      2nd parameter because it is passed.
  
                      SCROLLER() attemps to find a corresponding
                      record in SCROLLER.DBF (which contains fields
                      for PROCNAME and VARIABLE). SCROLLER.DBF is
                      a storage place for lookup definitions. It
                      contains:
                        
                       SMODULE C   8   Procname from SET KEY
                       SFIELD  C  10   Variable name from SET KEY
                       SDESCR  C  25   Description field used as title
                       SSTRING C 160   Say string - what is displayed
                                       in the lookup box
                       SRETURN C  75   Return string - what is sent to
                                       the keyboard via KEYBOARD
                       SDBFILE C   8   Lookup DBF file name
                       SIND    C   8   Lookup Index file name
  
                      If SCROLLER does not find a matching record, it
                      simply closes SCROLLER.DBF and returns to the
                      previous area. It then displays a 'lookup table
                      not found' message.
  
                      If SCROLLER finds a matching record, it loads the
                      values into memory and closes SCROLLER.DBF. It then
                      opens the DBF [and index] of the lookup dbf in
                      the next available area. If it is unable to open
                      the dbf, it displays an error message and goes back
                      to the previously selected area.
  
                      SCROLLER then draws a box, using the DESCRIPTION
                      field as the title, ititializes a 1 element array
                      composed of the SSTRING expression and calls
                      DBEDIT() with a udf. While in the DBEDIT(), first
                      letter searches can be done if the dbf is indexed
                      with a character index. Pressing ENTER will KEYBOARD
                      the expression in SRETURN (unless its empty), close
                      up the current area and return to the old area.
                      Pressing escape just closes things up and returns to
                      the old area.
  
                      The KEYBOARD then takes over, feeding the SRETURN
                      expression into the keyboard and into the current
                      GET or GETS.
  
                      Scroller may ALSO be called directly with the
                      parameters being:
  
                      1. ""     ÄÄ¿  to account for the
                      2. 0        ÃÄ set key parameters
                      3. ""     ÄÄÙ
                      4. [expC1]   lookup box display line
                      5. [expC2]   lookup box value to keyboard
                      6. [expC3]   dbf file to do lookup into
                      7. [expC4]   index file to use with lookup dbf
                      8. [expC5]   description - used as box header
  
                      If no parameters are passed, the user is prompted
                      for the lookup values.
  
                      If [expC1] is passed, the current DBF is used
                      for the lookup. If [expC2] is also passed, a
                      value is sent to the keyboard. If [expC3] and
                      optionally [expC4] are passed, a DBF and optionally
                      and index are opened for the lookup. [expC5] if
                      passed is used as a title.
  
  
  Options
  Examples            EXTERNAL SCROLLER
                      SET KEY -1 TO SCROLLER   && F2
                      ..or
  
                      SCROLLER()     && for user prompting
                      ..or
  
                      SCROLLER("",0,"","LASTNAME+' '+FIRSTNAME","","CUST")
                      ** would open up CUST.DBF and present a lookup
                      ** table of the expression "LASTNAME+' '+FIRSTNAME"
  
  Examples found in   Well personally I've taken to using SMALLS(), a
                      smaller, streamlined lookup engine.
  
  Notes               See SMALLS() - an alternate to SCROLLER().
                      SCROLLER is the most difficult function in the
                      library. As such, it may find itself replaced
                      by a set of smaller, simpler replacement functions.
  
  Warnings            Be sure to declare SCROLLER EXTERNAL!
  
 
  Found in : S_SCROLL.PRG
  
  -------------------------------------------------
  Function            SETCOLORS()
  Action              Interactive color setting interface
  Returns
  Category            Development
  Syntax              SETCOLORS()
  Description         This is a development tool for finding nice
                      combinations of colors for the global super.lib
                      colors. I would not give this to an end user, as
                      is just TOO MANY CHOICES!
  
                      I normally select 10-15 nice combinations of the
                      colors and give the user a selection of those,
                      giving them such names as 'Hawaiian Blue' or
                      'Royal Red'.
  
                      First, a word on the Super.Lib color scheme:
  
                      This is not the perfect color scheme. It is the one
                      on which this library runs. (hey - I hadda pick
                      something) I also realize full well that color
                      selection is more art than it is technical, and
                      it is difficult to get two people to agree on a
                      color scheme.
  
                      Several global (public) color variables are used by
                      the functions. These are:
  
                      c_normcol   -  For normal input/output
                      c_normmenu  -  For normal 'menu to' operations
                      c_popcol    -  For popup box colors
                      c_popmenu   -  For popup box menus
                      c_frame     -  Frame string ("ÚÄ¿³ÙÄÀ³ ")
                      c_shadatt   -  Shadow color attribute (numeric)
                      c_shadpos   -  Shadow position (0,1,3,7,9)
                      c_xplode    -  Logical - explode windows?
  
                      All are of the format "f/b,f/b,,,f/b"
                      (f-foreground b-background)
  
                      The functions INITCOL() or INITSUP() will initialise
                      these colors, and INITSUP() called if a function
                      detects the colors have not already been set.
  
                      SETCOLORS() allows interactive setting of these colors.
                      The variables are stored in COLORS.MEM - which is
                      created if needed by SETCOLORS().
  
                      If COLORS.MEM is not present, INITSUP() will
                      initialise a default set of colors, otherwise it
                      will restore from colors.mem
  
  Options
  Examples            SETCOLORS()
  
                      * then initialize the colors
                      restore from colors.mem addit
  
                      * then set the colors
                      SET COLOR TO (C_normcol)
  
  Notes               SETCOLORS() does not effect the current color
                      setting. It manipulates COLORS.MEM. To utilize
                      colors selected by SETCOLORS(), a restore from
                      COLORS.MEM must be done.
  
  Warnings            I've had problems with old copies of COLORS.MEM
                      (from previous versions) and also with COLORS.MEM
                      created by other programs. If you run into
                      troubles, try erasing COLORS.MEM.
  
                      Lots of direct screen writing here. You'll need
                      an IBM compatible.
  
  
 
  Found in : S_SETCOL.PRG
  
  -------------------------------------------------
  Function            SMALLS()
  Action              Lookup tables on dbf - no call to dbedit <small>
  Returns
  Category            Lookup
  Syntax              Smalls(expC,[expC],[expC/N],[expC],[expC/N],[expC/N)
  Description         This is a next generation lookup engine, and is
                      the Son of Scroller(). (smalls = small scroller)
  
                      It is called directly as follows:
                      1. ExpC       - the display string for the
                                      lookup box.
  
  Options             2. ExpC       - a title for the lookup box
                      3. ExpC/ExpN  - A. alias name             or
                                      B. numeric work area      or
                                      C. dbf/ndx in the format:
                                         "%dbfname%ndxname"
                      4. ExpC       - expression to keyboard if ENTER
                                      pressed
                      5. ExpC/N     - numeric   - starting record
                                      character - starting key
                                      (only if indexed)
  
                      6. ExpC/N     - numeric   - ending record
                                      character - ending key
                                      (only if indexed)
  Examples
                      (assumes dbf fields of LNAME and FNAME)
  
                      * lookup on "LNAME+' '+FNAME" in current area
                      smalls("LNAME+' '+FNAME")
                      ...or
  
                      * lookup on "LNAME+' '+FNAME" in current area
                      * use "Name" as box title
                      smalls("LNAME+' '+FNAME","Name")
                      ...or
  
                      * lookup on "LNAME+' '+FNAME" in current area
                      * use "Name" as box title
                      * go to area 5 for the lookup
                      * send LNAME to the keyboard if CR pressed
                      smalls("LNAME+' '+FNAME","Name",5,"LNAME")
                      ...or
  
                      * lookup on "LNAME+' '+FNAME" in current area
                      * use "Name" as box title
                      * go to alias CUSTOMER for the lookup
                      smalls("LNAME+' '+FNAME","Name","CUSTOMER")
                      ...or
  
                      * open customer.dbf and do a lookup on it
                      * lookup on "LNAME+' '+FNAME"
                      * use "Name" as box title
                      smalls("LNAME+' '+FNAME","Name","%CUSTOMER")
  
                      * open customer.dbf and do a lookup on it
                      * lookup on "LNAME+' '+FNAME"
                      * use "Name" as box title
                      * limit lookup to between records 50 and 60
                      smalls("LNAME+' '+FNAME","Name","%CUSTOMER",50,60)
  
                      * open CUSTOMER.DBF with LNAME.NDX and do a lookup
                      * lookup on "LNAME+' '+FNAME"
                      * use "Name" as box title
                      smalls("LNAME+' '+FNAME","Name","%CUSTOMER%LNAME")
  
                      * open CUSTOMER.DBF with LNAME.NDX and do a lookup
                      * lookup on "LNAME+' '+FNAME"
                      * use "Name" as box title
                      * limit lookup to JAAAA-ZZZZZ
                      smalls("LNAME+' '+FNAME","Name","%CUSTOMER%LNAME", ;
                         "JAAAAA","ZZZZZ")
  
  Notes               Very shortly (if not already done) I will be
                      modifying SCROLLER() to call SMALLS() instead
                      of DBEDIT(), thus reducing the weight of
                      SCROLLER() considerably.
  
                      The display string must evaluate to a character
                      expression when macro-expanded. For instance, a
                      date field called CDATE would crash if passed as
                      smalls("CDATE"), as it would evaluate to date type,
                      but if passed as smalls("dtoc(CDATE)" all would be
                      well.
                      The KEYBOARD expression must also evaluate to
                      type CHARACTER
  
  
 
  Found in : S_SMAL.PRG
  
  -------------------------------------------------
  Function            STANDARD()
  Action              Returns color integer for standard setting
  Returns             nothing
  Category            Screen
  Syntax              <expN> = STANDARD()
  Description         Returns numeric color integer for use with
                      functions which require it like ATT(), PRNT().
  Examples            stan = standard()+128   && blinking
                      PRNT(10,10,"Waiting...",m->stan)
 
  Found in : S_STAN.PRG
  
  -------------------------------------------------
  Function            SUM_AVE()
  Action              Interactive sum or average on a dbf field
  Returns
  Category            Metafunction
  Syntax              SUM_AVE([expC])
  Description         Does a SUM or AVERAGE on a selected numeric
                      field
  
  Options             [expC] "SUM" or "AVE". Default is "SUM"
  
  Examples            case choice = 3  && sum
                        SUM_AVE("SUM")
                      case choice = 4  && average
                        SUM_AVE("AVE")
  
  Notes
                      If QUERY_EXP is present  - public variable
                      created by QUERY() - optional SUM or AVERAGE
                      for QUERY_EXP can be done.
  
 
  Found in : S_SUMAV.PRG
  
  -------------------------------------------------
  Function            TAGIT()
  Action              Allows tagging of dbf records for later action
  Returns
  Category            Metafunction
  Syntax              TAGIT(<array1>,[array2],[array3])
  Description         Performs a no-touch tag on records in the dbf.
                      It does this by filling <array1> - an array
                      which you need to initialize to the max # of
                      records you want to tag - with tagged record
                      numbers.
  
                      DBEDIT() is called with a UDF to show on
                      screen what records have been tagged.
  
                      Ascan may then be used with the array to
                      evaluate to a logical condition for searches,
                      copies, printing etc. with the general
                      syntax of: (ascan(<array1>,recno()) > 0)
  
  
  Options             [array2] and [array3] may be passed as fields
                      and field descriptions. These are then passed
                      to DBEDIT() as the fields and titles arrays.
  
  Examples            private tag[100]
                      tagit(tag)
                      copy to temp for (ascan(tag,recno()) > 0)
  
 
  Found in : S_TAG.PRG
  
  -------------------------------------------------
  Function            UNBOX()
  Action              Removes a box created by makebox()
  Returns
  Category            Popup
  Syntax              Unbox(<expC>,[expN1..expN4])
  Description         UNBOX restores the screen <expC> saved by
                      MAKEBOX(). MAKEBOX() stores the dimensions
                      and color in the returned string, so it is not
                      necessary to pass these to UNBOX(). If the dimensions
                      are passed, UNBOX() assumes these are not part of
                      the saved string, and assumes the string is a
                      savescreen() string. If the string and any other
                      single param are passed, UNBOX() assumes it is
                      a full screen (0,0,24,79) restore and does so.
  
  Options             [expN1..expN4] - the dimensions of the box.
                      Use these to UNBOX() a screen saved with SAVESCREEN().
  
  Examples            msg = MAKEBOX(10,40,12,60,'W/R,+GR/R')
                      @11,42 SAY "What's up, Doc ?"
                      inkey(0)
                      UNBOX(m->msg)
  
                      ..or unboxing a SAVESCREEN() screen
                      msg = savescreen(5,5,10,10)
                      *code
                      *code
                      *code
                      unbox(msg,5,5,10,10)
  
                      ..or unboxing a full screen
                      save screen to msg
                      *code
                      *code
                      *code
                      unbox(msg,<anyparam>)
  
  Notes               This replaces KILLWIND(), as MAKEBOX() replaces
                      MAKEWIND().
  
 
  Found in : S_UNBOX.PRG
  
  -------------------------------------------------
  Function            UNSELECTED()
  Action              Returns color integer for UNSELECTED setting
  Returns             <expN> numeric color integer
  Category            Screen
  Syntax              <expN> = unsel
  Description         Returns numeric color integer for use with
                      functions which require it like ATT(), PRNT().
  Examples            enhan= enhanced()+128   && blinking
                      PRNT(10,10,"Waiting...",m->enhan)
 
  Found in : S_UNSEL.PRG
  
  -------------------------------------------------
  Function            VAR2CHAR()
  Action              Converts any type variable to character type
  Returns             <expC> character
  Category            String
  Syntax              Var2char(<expC>)
  Description         Converts variable named in <expC> to type
                      character
  Options
  Examples            dtype = ctod("01/01/80")
                      ntype = 128.45
                      ltype = .t.
                      VAR2CHAR("dtype") returns "01/01/80"
                      VAR2CHAR("ntype") returns "128.45"
                      VAR2CHAR("ltype") returns ".t."
  
  Notes               Returns memo types as ""
  
 
  Found in : S_VAR2.PRG
  
  -------------------------------------------------
  Function            VARLENGTH()
  Action              Returns length of a variable  of any type
  Returns             Length of variable
  Category            String
  Syntax              Varlength(exp?]
  Description         Converts exp? to character with VAR2CHAR() and
                      then returns its length
  Options
  Examples            VARLENGTH(123.45) returns 6
                      VARLENGTH(.F.)    returns 3
                      VARLENGTH(DATE()) returns 8
  
 
  Found in : S_VARLEN.PRG
  
  -------------------------------------------------
  Function            WRITEFILE()
  Action              Writes a line or lines  to a text file
  Returns
  Category            File
  Syntax              Writefile(<expC1|expN>,<expC2>)
  Description         Writes line(s) of text with CR LF to
                      a file referenced either as a file handle
                      <expN> or a filename <expC1>. Writes either
                      a single line contained in <expC2> or all
                      of the contents of a character array named
                      as <expC2> to the file.
  
  Examples
                      1. WRITEFILE('ERROR.TXT','THERE WAS AN ERROR')
  
                      2. declare errors[3]
                         errors[1] = 'There was an error'
                         errors[2] = 'Error # 61765     '
                         errors[3] = dtoc(date)
                         writefile('ERROR.TXT','ERRORS')
  
                      3. handle = fopen("error.txt",1)
                         declare errors[3]
                         errors[1] = 'There was an error'
                         errors[2] = 'Error # 61765     '
                         errors[3] = dtoc(date())
                         writefile(handle,'ERRORS')
  
  Notes               IF A FILENAME IS PASSED, THE FILE IS OPENED AND
                      CLOSED BY THE FUNCTION.
  
                      IF A FILE HANDLE IS PASSED, THE FILE IS LEFT OPEN.
  
                      IF A CHARACTER ARRAY IS PASSED, EACH ELEMENT IS
                      WRITTEN TO A SEPERATE LINE IN THE FILE.
  
                      DO NOT PASS AN ARRAY - PASS AN ARRAY NAME IN QUOTES
  
                      IF THE FILE DOES NOT EXIST, IT IS CREATED.
 
  Found in : S_WRITEF.PRG
  
