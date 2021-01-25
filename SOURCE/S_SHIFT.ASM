.MODEL large
       EXTRN   __parinfo:far
       EXTRN   __parni:far
       EXTRN   __retl:far
       EXTRN   __ret:far

       ; public procs
       PUBLIC   shifty

.DATA
ison            dw      0
thisflag        db      0
flagbyte        db      0
andbyte         db      0

.CODE

;-------------------------------------------------------------
shifty     PROC    FAR
       mov  ison,0
       mov  thisflag,0

       mov  ax,0          ; correct # params ?
       push ax
       call __parinfo
       add sp,2
       cmp ax,1
       jl returnval

       mov  ax,1          ; get param
       push ax
       call __parni
       add sp,2
       mov thisflag,al

       cmp ax,1           ; between 1 and 8 ?
       jl returnval
       cmp ax,8
       jg returnval

       mov ah,2           ; do the interrupt
       int 16h
       mov flagbyte,AL

       mov andbyte,00000001b
       sub thisflag,1
       cmp thisflag,0
       je  noshift
       mov CL,thisflag
       SHL andbyte,CL
noshift:
       MOV BL,andbyte
       AND flagbyte,BL
       CMP flagbyte,BL
       jne returnval
       mov  ison,1

returnval:

       push ison
       call __retl           ; return on/off status
       add sp,2
       RET
shifty     ENDP
END


