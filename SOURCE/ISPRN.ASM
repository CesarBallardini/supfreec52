
; => MASM ISPRN;
;    (MASM 5.1)
.MODEL large
       EXTRN   __parinfo:far
       EXTRN   __parni:far
       EXTRN   __retl:far
       EXTRN   __ret:far

       ; public procs
       PUBLIC   isprn

.DATA
isprinter       dw      0
pport           dw      0

.CODE

;-------------------------------------------------------------
isprn      PROC    FAR
       mov  isprinter,0
       mov  pport,0

       mov  ax,0
       push ax
       call __parinfo
       add sp,2

       cmp ax,1
       jl  nopar

       mov  ax,1
       push ax
       call __parni
       add sp,2
       mov pport,ax


nopar:
       mov ah,2
       mov dx,pport
       int 17h

       cmp ah, 90h
       jne return
       mov isprinter,1
return:

       push isprinter
       call __retl           ; return on/off status
       add sp,2
       RET
isprn      ENDP
END
