#include "extend.api"
#include "vm.api"


static unsigned int offset     = 0;

CLIPPER s_mlsetpos()
{
    offset+=_parni(1);
    _ret();
}

/*컴컴컴컴컴clear offset 컴컴컴컴컴*/
CLIPPER s_mclear()
{
  offset       = 0;
}

#define CH_141 141
#define CH_13  13
#define CH_10  10
#define CH_SP  32

/*컴컴컴컴컴get next line, return nil if none컴컴컴컴컴컴*/
CLIPPER s_getline()
{
  HANDLE hSegment;
  char *outstr ;
  char *string = _parc(1);
  unsigned int strlen   = _parclen(1);
  int linelen  = _parni(2);
  int gotten   = 0;
  int findsp   = 0;
  int findgot  = 0;
  int endchar = CH_13;
  unsigned int i;

  if (hSegment = _xvalloc(linelen,0 ))
     {
     outstr = _xvlock(hSegment);
     if (offset+1 < strlen)
        {
        for ( i=offset; (i < strlen) && (gotten<linelen) && (string[i]!=CH_141) && (string[i]!=CH_13) ;)
           {
           outstr[gotten]    = string[i];
           gotten++;
           i++;
           }


        if ( (string[i]==CH_141) || (string[i]==CH_13))
           {
           endchar = string[i];
           i+=2;
           }
        else if (string[i]!=CH_SP)
           {
            endchar = CH_13;
            findsp  = i;
            findgot = gotten;
            while ((string[findsp]!=CH_SP) && (findsp > offset) )
                {
                findsp--;
                findgot--;
                }
            if (findsp > offset)
               {
               findsp++;
               findgot++;
               i = findsp;
               gotten = findgot;
               endchar = CH_141;
               }


           }

        offset = i;

        _storni(endchar,3);

        _retclen(outstr,(gotten) );
        }
     else
        _ret();

     _xvunlock(hSegment);
     _xvfree(hSegment);

     }
  else
     _retclen("",0);
}
