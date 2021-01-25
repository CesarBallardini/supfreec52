/*
ี์อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
ณ FUNCTION ATT()
ฦออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ 
ณ 
ณ  Short:
ณ  ------
ณ  ATT() Colors a section of the screen, leaving the text intact
ณ 
ณ 
ณ  Returns:
ณ  --------
ณ  <cUnder> => Underlying screen before change
ณ 
ณ  Syntax:
ณ  -------
ณ  Att(nTop,nLeft,nBottom,nRight,nColorAttribute)
ณ 
ณ  Description:
ณ  ------------
ณ  <nTop>             - top row
ณ  <nLeft>            - left col
ณ  <nBottom>          - bottom row
ณ  <nRight>           - right column
ณ  <nColorAttribute>  - attribute to set area  (numeric color )
ณ 
ณ  Saves and returns the underlying screen at <ntop,nLeft,nBottom,nRight>
ณ 
ณ  Examples:
ณ  ---------
ณ   ATT(5,5,10,10,79)   // sets 5,5,10,10 to +W/R
ณ
ณ  Notes:
ณ  ------
ณ  This was a C file previously
ณ
ณ
ณ
ณ  Source:
ณ  -------
ณ  S_ATT.PRG
ณ
ิํอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
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
