/*
Function:     Takeout()
Purpose :     Extract section of a string between delimiters
Usage   :     Takeout(<expC1>, <expC2>, <expN>)
Params  :     expC1 - string
              expC2 - delimiter  (beginning and end of string are considered
                                  delimiters)
              expN  - occurance
Example :     takeout("Next:Previous:First:Quit",":",3)
              returns "First"
Returns :     Section of string between delimiters, occurance <expN>.
Found in:     between.c
*/


#include "extend.h"
CLIPPER takeout()
{
   char *string;
   char *delim;
   char *result;
   char *empty = 0;

   quant i;
   quant occur;
   quant knt;
   quant fnd;
   quant strstart=0;
   quant strlen;
   quant strend;
   quant size;

   occur        = _parni(3);
   occur        =  occur-1;    /* beginning of string = first delim */
   delim        = _parc(2);
   string       = _parc(1);
   strlen       = _parclen(1);
   strend       = strlen-1;

   i = 0;
   knt = 0;
   fnd = 0;

   /* first find occurrance */
   while (i < strlen && knt < occur)     /* not null, kount < occurance */
     {
     knt = (delim[0] == string[i]) ? knt+1 : knt ;
     strstart = (knt == occur) ? i+1 : strend ;
     i++;
     }

   fnd = (knt == occur);

   while (i < strlen && (strend == strlen-1) && (fnd))
     {
     strend  = (delim[0] == string[i]) ? i-1 : strend ;
     i++;
     }

   knt = 0;


   if (strend >= strstart && (fnd))
   {
     size = (strend-strstart+2);
     result = _xgrab(size);
     for(i = strstart; i <= strend  ;i++)
       result[knt++] = string[i];
     result[knt] = NIL;
     _retclen(result,knt);
     _xfree(result);
   }
   else
     _retclen(empty,0);
}




