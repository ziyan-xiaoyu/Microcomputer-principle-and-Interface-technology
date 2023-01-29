; YLIB  PROC
;-------------------------------------------------

PUBLIC  READDEC,READINT,WRITEDEC,WRITEINT,WRITEHEX,CRLF

;-------------------------------------------------

CODE1   SEGMENT USE16

        ASSUME  CS:CODE1,DS:CODE1

;-------------------------------------------------
c10     dw      10
sign    db      ?
hextab  db      '0123456789ABCDEF'
CF	DB	0DH, 0AH,'$'
;-------------------------------------------------
CRLF	PROC	FAR
	PUSH	DX
	PUSH	AX
	PUSH	DS
	PUSH	CS
	POP	DS
	LEA	DX, CF
	MOV	AH, 09H
	INT	21H
	POP	DS
	POP	AX
	POP	DX
	RET
CRLF	ENDP
;------------------------------------------------
READDEC PROC    FAR
        
        PUSH    DX
        PUSH    DS
        PUSH    BX
        
        CMP     DX, 0FFFFH
        JE      RDEC0
        MOV     AH, 09H
        INT     21H
RDEC0:
        PUSH    CS
        POP     DS
        MOV     BX, 0
RDEC1:
        MOV     AH, 1
        INT     21H
        CMP     AL, 0DH
        JE      RDECDONE
        CMP     AL,'0'
        JB      RDECERR
        CMP     AL, '9'
        JA      RDECERR
        AND     AX, 0FH
        XCHG    AX, BX
        MUL     C10
        ADD     BX, AX
        JMP     RDEC1
RDECERR:
        LEA     DX,RDECMSS
        MOV     AH, 9
        INT     21H
        JMP     RDEC1
RDECDONE:
        MOV     DL, 0AH
        MOV     AH, 2
        INT     21H

        MOV     AX, BX
        POP     BX
        POP     DS
        POP     DX

        RET
READDEC ENDP

;-------------------------------------------------

READINT PROC    FAR
        push    ds
        push    dx
        push    bx

        cmp     dx, 0ffffh
        je      rintskip
        mov     ah, 09h
        int     21h

rintskip:
        push    cs
        pop     ds

rint00: mov     sign,0
        mov     bx, 0

rint0:  mov     ah, 1   ;Input  first char
        int     21h

        cmp     al, 0dh
        je      rint5
        cmp     al,'+'
        je      rint3
        cmp     al,'-'
        jne     rint1
        mov     sign,1
        jmp     rint3

rint2:  lea     dx,rinterr
        mov     ah, 9
        int     21h
        jmp     rint00
rint3:  mov     ah,1
        int     21h
rint1:  cmp     al, 0dh
        je      rint5
        cmp     al,'0'
        jb      rint2
        cmp     al,'9'
        ja      rint2
rint4:  and     ax, 0fh
        xchg    ax, bx
        mul     c10
        add     bx, ax
        jmp     rint3
rint5:  cmp     sign, 0
        je      rint6
        neg     bx
rint6:  mov     ax, bx
        pop     bx
        pop     dx
        pop     ds
        RET

rinterr db      0dh,0ah,'Input error ! Try again. ',0dh,0ah,'$'

READINT ENDP

;-------------------------------------------------                    s

WRITEDEC        PROC    FAR
        PUSH    DS
        PUSH    DX
        PUSH    CX
        PUSH    AX

        CMP     DX, 0FFFFH
        JE      WDEC0
        MOV     AH, 09H
        INT     21H
WDEC0:
        PUSH    CS
        POP     DS
        MOV     CX, 0
WDEC1:
        MOV     DL, ' '
        MOV     AH, 2
        INT     21H

        POP     AX
        PUSH    AX
WDEC2:  MOV     DX, 0
        DIV     C10
        INC     CX
        PUSH    DX
        CMP     AX, 0
        JNZ     WDEC2

WDEC3:
        POP     DX
        AND     DX, 0FH
        OR      DX, 30H
        MOV     AH, 2
        INT     21H
        LOOP    WDEC3

        MOV     DL, ' '
        MOV     AH, 2
        INT     21H

        POP     AX
        POP     CX
        POP     DX
        POP     DS
        RET
WRITEDEC        ENDP

;-------------------------------------------------

WRITEINT        PROC    FAR
        push    ds
        push    ax
        push    dx
        push    cx
        push    ax

        cmp     dx,0ffffh
        je      wint0
        mov     ah,09h
        int     21h

wint0:  push    cs
        pop     ds

        mov     dl, ' '
        mov     ah, 2
        int     21h

        pop     ax
        cmp     ax, 0
        jge     wint1
        neg     ax
        push    ax
        mov     dl,'-'
        mov     ah,2
        int     21h
        pop     ax

wint1:  mov     cx, 0        

wint2:  mov     dx,0
        div     c10
        push    dx
        inc     cx
        cmp     ax, 0
        jnz     wint2
                       
wint3:  pop     dx
        and     dx, 0fh
        or      dx, 30h
        mov     ah, 2
        int     21h
        loop    wint3
        mov     dl, ' '
        mov     ah, 2
        int     21h

        pop     cx
        pop     dx
        pop     ax
        pop     ds

        RET
WRITEINT        ENDP

;-------------------------------------------------

WRITEHEX        PROC    FAR
        push    ds
        push    ax
        push    dx
        push    bx
        push    cx
        push    si
        push    ax

        cmp     dx, 0ffffh
        je      whex00
        mov     ah, 09h
        int     21h

whex00: push    cs
        pop     ds
        mov     dl,' '
        mov     ah, 02h
        int     21h

whex0:  pop     si
        mov     cx, 4
        lea     bx, hextab
whex1:  push    cx
        mov     cl,4
        rol     si, cl
        mov     ax,si
        and     ax, 0fh
        xlat
        mov     dl, al
        mov     ah, 2
        int     21h
        pop     cx
        loop    whex1
        mov     dl, 'H'
        mov     ah, 2
        int     21h
        mov     dl, ' '
        mov     ah,2
        int     21h
        
        pop     si
        pop     cx
        pop     bx
        pop     dx
        pop     ax
        pop     ds
        RET
WRITEHEX        ENDP

;-------------------------------------------------

;CRLF    DB      0DH,0AH,'$'

RDECMSS DB      0DH,0AH,'Input Decimal Number(0~9):$'

;-------------------------------------------------

CODE1   ENDS

;-------------------------------------------------

        END

