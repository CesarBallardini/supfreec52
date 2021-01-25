; => MASM MOUSE;
;    (MASM 5.1)
.MODEL large
       EXTRN   __parinfo:far
       EXTRN   __parni:far
       EXTRN   __retl:far
       EXTRN   __retni:far
       EXTRN   __ret:far

       ; public procs
       PUBLIC   rat_on
       PUBLIC   rat_off
       PUBLIC   rat_exist
       PUBLIC   rat_reset
       PUBLIC   rat_leftb
       PUBLIC   rat_rightb
       PUBLIC   rat_row
       PUBLIC   rat_col
       PUBLIC   rat_posit
       PUBLIC   rat_rowl
       PUBLIC   rat_coll
       PUBLIC   rat_rowr
       PUBLIC   rat_colr
       PUBLIC   rat_lbhd
       PUBLIC   rat_rbhd
       PUBLIC   rat_area
       PUBLIC   RAT_NOMOUS
       PUBLIC   rat_force

.DATA

ismouse         dw      0
checked         dw      0
lastrowleft     dw      0
lastcolleft     dw      0
lastrowright    dw      0
lastcolright    dw      0
areatop         dw      0
arealeft        dw      0
areabottom      dw      0
arearight       dw      0

.CODE

;-------------------------------------------------------------
; This resets the mouse driver     rat_reset()
;-------------------------------------------------------------
rat_reset  PROC    FAR
       mov  ax,0
       int  33h
       cmp  ax,0
       jne  rs_ismouse
       mov  ismouse,0
       jmp  rs_end
rs_ismouse:
       mov  ismouse,1
rs_end:
       mov  checked,1
       RET
rat_reset  ENDP
;-------------------------------------------------------------
; This forces the mouse flag OFF
;-------------------------------------------------------------
RAT_NOMOUS  PROC FAR
       mov  ismouse,0
       mov  checked,1
       call __ret
       RET
RAT_NOMOUS ENDP
;-------------------------------------------------------------
; This forces the mouse flag ON
;-------------------------------------------------------------
rat_force  PROC FAR
       mov  ismouse,1
       mov  checked,1
       call __ret
       RET
rat_force ENDP
;-------------------------------------------------------------
; This turns the mouse text cursor on     rat_on()
;-------------------------------------------------------------
rat_on  PROC FAR
       call rat_is
       cmp  ismouse,0
       je   on_skip

       mov  ax,1
       int  33h
on_skip:
       call __ret
       RET
rat_on ENDP
;-------------------------------------------------------------
; This turns the mouse text cursor off     rat_off()
;-------------------------------------------------------------
rat_off  PROC FAR
       call rat_is
       cmp  ismouse,0
       je   off_skip
       mov  ax,2
       int  33h
off_skip:
       call __ret
       RET
rat_off ENDP

;-------------------------------------------------------------
; This gives the current mouse row       ?rat_row()
;-------------------------------------------------------------
rat_row PROC    FAR
       mov  ax,3
       int  33h
       shr  dx,1
       shr  dx,1
       shr  dx,1
       push dx
       call __retni
       add  sp,2
       RET
rat_row ENDP

;-------------------------------------------------------------
; This gives the mouse row at the last left press   ?rat_rowl()
;-------------------------------------------------------------
rat_rowl PROC FAR
       push lastrowleft
       call __retni
       add  sp,2
       RET
rat_rowl ENDP

;-------------------------------------------------------------
; This gives the mouse row at the last right press   ?rat_rowr()
;-------------------------------------------------------------
rat_rowr PROC FAR
       push lastrowright
       call __retni
       add  sp,2
       RET
rat_rowr ENDP


;-------------------------------------------------------------
; This gives the current mouse column        ?rat_col()
;-------------------------------------------------------------
rat_col PROC    FAR
       mov  ax,3
       int  33h
       shr  cx,1
       shr  cx,1
       shr  cx,1
       push cx
       call __retni
       add  sp,2
       RET
rat_col ENDP

;-------------------------------------------------------------
; This gives the mouse col at the last left press   ?rat_coll()
;-------------------------------------------------------------
rat_coll PROC FAR
       push lastcolleft
       call __retni
       add  sp,2
       RET
rat_coll ENDP

;-------------------------------------------------------------
; This gives the mouse col at the last right press   ?rat_colr()
;-------------------------------------------------------------
rat_colr PROC FAR
       push lastcolright
       call __retni
       add  sp,2
       RET
rat_colr ENDP


;-------------------------------------------------------------
; This returns .t. if the left button has been pressed
;               if rat_leftb()
;-------------------------------------------------------------
rat_leftb PROC FAR
       mov  ax,0
       call rat_is
       cmp  ismouse,0
       je  leftnomouse

       xor  bx,bx
       mov  ax,5
       int  33h

       mov  ax,bx            ; compare the button press count
       cmp  ax,0
       je   leftbret

       shr  cx,1
       shr  cx,1
       shr  cx,1
       mov  lastcolleft,cx
       shr  dx,1
       shr  dx,1
       shr  dx,1
       mov  lastrowleft,dx
       jmp  leftbret

leftnomouse:
        mov ax,0

leftbret:
       push ax
       call __retl           ; return on/off status
       add sp,2
       RET
rat_leftb ENDP

;-------------------------------------------------------------
; This returns .t. if the right button has been pressed
;               if rat_right()
;-------------------------------------------------------------
rat_rightb PROC FAR
       mov  ax,0
       call rat_is
       cmp  ismouse,0
       je  rightnomouse

       mov  bx,1
       mov  ax,5
       int  33h

       mov  ax,bx            ; compare the button presses
       cmp  ax,0
       je   rightbret

       shr  cx,1
       shr  cx,1
       shr  cx,1
       mov  lastcolright,cx
       shr  dx,1
       shr  dx,1
       shr  dx,1
       mov  lastrowright,dx
       jmp  rightbret

rightnomouse:
       mov ax,0

rightbret:
       push ax
       call __retl           ; return on/off status
       add sp,2
       RET
rat_rightb ENDP

;-------------------------------------------------------------
; This moves the mouse to <row>,<col>     rat_posit(10,2)
;-------------------------------------------------------------
rat_posit  PROC FAR
        mov  ax,0
        push ax
        call __parinfo
        add sp,2

        cmp ax,2
        jl  badpar

        mov  ax,1
        push ax
        call __parni
        add sp,2
        shl  ax,1
        shl  ax,1
        shl  ax,1
        push ax

        mov  ax,2
        push ax
        call __parni
        add  sp,2
        shl  ax,1
        shl  ax,1
        shl  ax,1
        mov  cx,ax
        pop  dx

	mov  ax,4		;function number
	int  33h		;set the cursor
badpar:
        call __ret
        RET

rat_posit ENDP


;-------------------------------------------------------------
; This tells if a mouse is present      if rat_exist()
;-------------------------------------------------------------
rat_exist PROC    FAR
       call rat_is
       push ismouse
       call __retl           ; return on/off status
       add sp,2
       RET
rat_exist ENDP

;-------------------------------------------------------------
; this is internal
;-------------------------------------------------------------
rat_is  PROC NEAR
       cmp  checked,1       ; check/set the checked flag
       je   ichecked
       mov  checked,1
       push bp
       push es

       mov  ax,03533h       ;service 35h, get address of interrupt
       int  21h             ;routine for int 33 via int 21
       mov  ax,es           ;if 0 or IRET, no mouse driver there
       or   ax,bx
       jz   nomouse
       mov  bl,es:[bx]
       cmp  bl,0cfh
       je   nomouse

       mov  bx,0            ;as a double check, call INT 33, service
       mov  ax,15h          ;15h (return driver storage requirements)
       int  33h
       cmp  bx,0            ;if it is 0, then somebody else is using
       je   nomouse         ;int 33, and no mouse driver is there

       mov  ismouse,1       ;set ismouse flag false
       jmp  retstate
nomouse:
       mov  ismouse,0       ; set ismouse flag false
retstate:
       pop es
       pop bp
ichecked:
       RET
rat_is ENDP

;-------------------------------------------------------------
; This tells if the mouse left button is currently pressed
; by calling INT 33 service 3 which gives tells the current
; status of the mouse
;-------------------------------------------------------------
rat_lbhd PROC    FAR
          mov  ax,0
          call rat_is
          cmp  ismouse,0
          je   lhdnot

          mov  bx,0
          mov  ax,3
          int  33h
          and  bx,1
          cmp  bx,1
          jne  lhdnot
          push bx
          call __retl
          add  sp,2
          jmp  lhdreturn
lhdnot:
          mov  ax,0
          push ax
          call __retl
          add  sp,2
lhdreturn:
          RET
rat_lbhd ENDP

;-------------------------------------------------------------
; This tells if the mouse right button is currently pressed
; by calling INT 33 service 3 which gives tells the current
; status of the mouse
;-------------------------------------------------------------
rat_rbhd PROC    FAR
          mov  ax,0
          call rat_is
          cmp  ismouse,0
          je   rhdnot

          mov  bx,0
          mov  ax,3
          int  33h
          and  bx,2
          cmp  bx,2
          jne  rhdnot
          mov  bx,1
          push bx
          call __retl
          add  sp,2
          jmp  rhdreturn
rhdnot:
          mov  ax,0
          push ax
          call __retl
          add  sp,2
rhdreturn:
          RET
rat_rbhd ENDP
;-------------------------------------------------------------
; This sets the mouse motion area to <top>,<left>,<bott>,<right>
;     rat_area(10,10,20,20)
;-------------------------------------------------------------
rat_area   PROC FAR
        mov  ax,0
        push ax
        call __parinfo
        add sp,2

        cmp ax,4
        jl  abadpar

        mov  ax,1
        push ax
        call __parni
        add sp,2
        shl  ax,1
        shl  ax,1
        shl  ax,1
        mov  areatop,ax

        mov  ax,2
        push ax
        call __parni
        add  sp,2
        shl  ax,1
        shl  ax,1
        shl  ax,1
        mov arealeft,ax

        mov  ax,3
        push ax
        call __parni
        add  sp,2
        shl  ax,1
        shl  ax,1
        shl  ax,1
        mov areabottom,ax

        mov  ax,4
        push ax
        call __parni
        add  sp,2
        shl  ax,1
        shl  ax,1
        shl  ax,1
        mov arearight,ax

        mov  ax,7               ;function number
        mov  cx,arealeft
        mov  dx,arearight
        int  33h                ;set horizontal
        mov  ax,8               ;function number
        mov  cx,areatop
        mov  dx,areabottom
        int  33h                ;set vertical
abadpar:
        call __ret
        RET
rat_area  ENDP




END

