/*
ΥμΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
³ FUNCTION ATT()
ΖΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ 
³ 
³  Short:
³  ------
³  ATT() Colors a section of the screen, leaving the text intact
³ 
³ 
³  Returns:
³  --------
³  <cUnder> => Underlying screen before change
³ 
³  Syntax:
³  -------
³  Att(nTop,nLeft,nBottom,nRight,nColorAttribute)
³ 
³  Description:
³  ------------
³  <nTop>             - top row
³  <nLeft>            - left col
³  <nBottom>          - bottom row
³  <nRight>           - right column
³  <nColorAttribute>  - attribute to set area  (numeric color )
³ 
³  Saves and returns the underlying screen at <ntop,nLeft,nBottom,nRight>
³ 
³  Examples:
³  ---------
³   ATT(5,5,10,10,79)   // sets 5,5,10,10 to +W/R
³
³  Notes:
³  ------
³  This was a C file previously
³
³
³
³  Source:
³  -------
³  S_ATT.PRG
³
ΤνΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ
*/
#ifdef CLIPPER53           // if this is Clipper 5.3, check for graphics
   function att(nTop,nLeft,nBottom,nRight,nAttribute)
   local nLength := (nRight-nLeft+1)*(nBottom-nTop+1)
   local cSaved  := SaveScreen(nTop,nLeft,nBottom,nRight)
   local cAtt    := chr(nAttribute)
   local i, cAlternate, nLenS
   if valtype(cSaved)=="C"    // save if character, but graphic mode
                              // returns an array and this won't work
     if upper(cAtt)$"!#A9LNXY"   // interferes with template chars
       cAlternate = ""           // have to do it the slow way
       nLenS = len(cSaved)-1
       i = 1
       while i <= nLenS
         cAlternate += subst(cSaved,i,1)
         cAlternate += cAtt
         i+=2
       end
       restscreen(nTop,nLeft,nBottom,nRight,cAlternate)
     else                        // do it the fast way
       restscreen(nTop,nLeft,nBottom,nRight,;
               trans(cSaved,REPL("X"+chr(nAttribute),nLength)))
     endif
   endif
   return cSaved

#else
   function att(nTop,nLeft,nBottom,nRight,nAttribute)
   local nLength := (nRight-nLeft+1)*(nBottom-nTop+1)
   local cSaved  := SaveScreen(nTop,nLeft,nBottom,nRight)
   local cAtt    := chr(nAttribute)
   local i, cAlternate, nLenS
   if upper(cAtt)$"!#A9LNXY"   // interferes with template chars
     cAlternate = ""           // have to do it the slow way
     nLenS = len(cSaved)-1
     i = 1
     while i <= nLenS
       cAlternate += subst(cSaved,i,1)
       cAlternate += cAtt
       i+=2
     end
     restscreen(nTop,nLeft,nBottom,nRight,cAlternate)
   else                        // do it the fast way
     restscreen(nTop,nLeft,nBottom,nRight,;
             trans(cSaved,REPL("X"+chr(nAttribute),nLength)))
   endif
   return cSaved
#endif
