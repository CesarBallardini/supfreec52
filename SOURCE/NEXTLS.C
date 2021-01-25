#include "extend.h"


/*컴컴컴컴컴get next line, return nil if none컴컴컴컴컴컴*/
CLIPPER nextls()
{
  char *string = _parc(1);
  unsigned int strlen   = _parclen(1);
  int offset   = _parni(2);
  char a141    = 141;
  char a13     = 13;
  unsigned int i;

  if (offset+1 < strlen)
    {
    for ( i=offset; (i < strlen) && (string[i]!=a141) && (string[i]!=a13) ;)
       {
          i++;
       }
    offset = i+2;
    if (offset >= strlen)
        offset = -1;

    _retni(offset);
    }
  else
    _retni(-1);
}

