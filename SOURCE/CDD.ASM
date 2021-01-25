;Function:     Cdir()
;Purpose :     Change to new directory
;Usage	 :     Cdir(<expC>)
;Params  :     <expC> a valid directory on current drive
;Returns :     .t. if succesful, .f. otherwise
;Found in:     cdd.asm

;INCLUDE EXTENDA.INC
PUBLIC cdir

EXTRN __PARC:FAR
EXTRN __RETL:FAR



_PROG   segment         'CODE'
        ASSUME  cs:_PROG

CDIR     PROC    FAR
        ; push registers
        push    bp
        mov     bp,sp
        push    ds
        push    es
        push    di
        push    si

        ; get paramater
        push    cx
        push    dx
        mov     ax, 1
        push    ax
        call    __parc
        mov     bx, ax
        mov     ax, dx
        add     sp, 2
        pop     dx
        pop     cx


        mov     ds, ax
        mov     dx, bx

clp_:

        mov     al, byte ptr ds:[bx]
        cmp     al, 0
        je      cdn_
        inc     bx
        cmp     al, ' '
        jne     clp_
        mov     byte ptr ds:[bx], 0

cdn_:
        mov     ah,59
        int     21h
        jc      _error
        mov     ax,1
        jmp     outahere
        ; restore registers
_error:
        xor     ax, ax
outahere:
        pop     si
        pop     di
        pop     es
        pop     ds
        pop     bp
        push    ax
        call __RETL
        pop     ax
        ret
CDIR     ENDP

_prog   ENDS
        END


