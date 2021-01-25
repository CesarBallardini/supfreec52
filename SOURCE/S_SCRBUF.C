
#include "extend.h"

CLIPPER getscrow()
{
   char *inscreenstring;                  /* saved screen */
   char *ret_scr;

   int top,left,bottom,right,i;
   int cols,rows,getrow,count;


   inscreenstring    = _parc(1);
   top               = _parni(2);
   left              = _parni(3);
   bottom            = _parni(4);
   right             = _parni(5);
   cols              = right-left+1;
   rows              = bottom-top+1;
   getrow            = _parni(6)-1;
   top               = top*80;
   count             = 0;
   ret_scr           =  _xgrab(cols*2);

   for(i=getrow*cols*2; i< (getrow+1)*cols*2;i++)
       ret_scr[count++] = inscreenstring[i];
   _retclen( ret_scr,cols*2);
   _xfree(ret_scr);
}

CLIPPER getsccol()
{
   char *inscreenstring;                  /* saved screen */
   char *ret_scr;

   int top,left,bottom,right,i;
   int cols,rows,getcol,count;
   int lastcol;


   inscreenstring    = _parc(1);
   top               = _parni(2);
   left              = _parni(3);
   bottom            = _parni(4);
   right             = _parni(5);
   cols              = right-left+1;
   rows              = bottom-top+1;
   getcol            = _parni(6)-1;
   count             = 0;
   ret_scr           =  _xgrab(rows*2);
   lastcol           = (cols*(rows-1)+(getcol)+1)*2 ;

   for(i=getcol*2; i< lastcol ;i+=(cols*2))
     {
       ret_scr[count++] = inscreenstring[i];
       ret_scr[count++] = inscreenstring[i+1];
     }
   _retclen( ret_scr,rows*2);
   _xfree(ret_scr);
}


CLIPPER ssprinkle()
{
   char *oldscreen;                  /* saved screen */
   char *newscreen;
   char *outscreen;

   int every,scrlen,i,columns,attpos,charpos;


   oldscreen   = _parc(1);
   newscreen   = _parc(2);
   every       = _parni(3);
   scrlen      = _parclen(1);
   columns     =  scrlen/2;
   outscreen   = _xgrab(scrlen);

   for(i=0; i< columns;i++)
     {
       if (i%every==0)
       {
         charpos = i*2;
         attpos = charpos+1;
         outscreen[charpos] = oldscreen[charpos];
         outscreen[attpos] = oldscreen[attpos];
       }
       else
         {
           charpos = i*2;
           attpos = charpos+1;
           outscreen[charpos] = newscreen[charpos];
           outscreen[attpos] = newscreen[attpos];
         }
      }
   _retclen(outscreen,scrlen);
   _xfree(outscreen);

}

