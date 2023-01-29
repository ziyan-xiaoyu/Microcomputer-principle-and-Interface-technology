.386
; YLIB  PROC
;-------------------------------------------------

PUBLIC  READDEC,READINT,WRITEDEC,WRITEINT,WRITEHEX,CRLF

;-------------------------------------------------

CODE1   SEGMENT USE16

        ASSUME  CS:CODE1,DS:CODE1

;-------------------------------------------------
c10     dd      10
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
;-------------------------------------------------
READDEC PROC    FAR
        
        PUSH    EDX
        PUSH    DS
        PUSH    EBX
        
        CMP     DX, 0FFFFH
        JE      RDEC0
        MOV     AH, 09H
        INT     21H
RDEC0:
        PUSH    CS
        POP     DS
        MOV     EBX, 0
RDEC1:
        MOV     AH, 1
        INT     21H
        CMP     AL, 0DH
        JE      RDECDONE
        CMP     AL,'0'
        JB      RDECERR
        CMP     AL, '9'
        JA      RDECERR
        AND     EAX, 0FH
        XCHG    EAX, EBX
        MUL     C10
        ADD     EBX, EAX
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

        MOV     EAX, EBX
        POP     EBX
        POP     DS
        POP     EDX

        RET
READDEC ENDP

;-------------------------------------------------

READINT PROC    FAR
        push    ds
        push    edx
        push    ebx

        cmp     dx, 0ffffh
        je      rintskip
        mov     ah, 09h
        int     21h

rintskip:
        push    cs
        pop     ds

rint00: mov     sign,0
        mov     ebx, 0

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
rint4:  and     eax, 0fh
        xchg    eax, ebx
        mul     c10
        add     ebx, eax
        jmp     rint3
rint5:  cmp     sign, 0
        je      rint6
        neg     ebx
rint6:  mov     eax, ebx
        pop     ebx
        pop     edx
        pop     ds
        RET

rinterr db      0dh,0ah,'Input error ! Try again. ',0dh,0ah,'$'

READINT ENDP

;-------------------------------------------------                    s

WRITEDEC        PROC    FAR
        PUSH    DS
        PUSH    EDX
        PUSH    ECX
        PUSH    EAX

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

        POP     EAX
        PUSH    EAX
WDEC2:  MOV     EDX, 0
        DIV     C10
        INC     CX
        PUSH    DX
        CMP     EAX, 0
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

        POP     EAX
        POP     ECX
        POP     EDX
        POP     DS
        RET
WRITEDEC        ENDP

;-------------------------------------------------

WRITEINT        PROC    FAR
        push    ds
        push    eax
        push    edx
        push    ecx
        push    eax

        cmp     dx,0ffffh
        je      wint0
        mov     ah,09h
        int     21h

wint0:  push    cs
        pop     ds

        mov     dl, ' '
        mov     ah, 2
        int     21h

        pop     eax
        cmp     eax, 0
        jge     wint1
        neg     eax
        push    eax
        mov     dl,'-'
        mov     ah,2
        int     21h
        pop     eax

wint1:  mov     cx, 0        

wint2:  mov     edx,0
        div     c10
        push    dx
        inc     cx
        cmp     eax, 0
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

        pop     ecx
        pop     edx
        pop     eax
        pop     ds

        RET
WRITEINT        ENDP

;-------------------------------------------------

WRITEHEX        PROC    FAR
        push    ds
        push    eax
        push    edx
        push    ebx
        push    ecx
        push    esi
        push    eax

        cmp     dx, 0ffffh
        je      whex00
        mov     ah, 09h
        int     21h

whex00: push    cs
        pop     ds
        mov     dl,' '
        mov     ah, 02h
        int     21h

whex0:  pop     esi
        mov     cx, 8
        lea     bx, hextab

whex1:  rol     esi, 4
        mov     eax,esi
        and     eax, 0fh
        xlat
        mov     dl, al
        mov     ah, 2
        int     21h
        loop    whex1

        mov     dl, 'H'
        mov     ah, 2
        int     21h
        mov     dl, ' '
        mov     ah,2
        int     21h
        
        pop     esi
        pop     ecx
        pop     ebx
        pop     edx
        pop     eax
        pop     ds
        RET
WRITEHEX        ENDP

;-------------------------------------------------

; CRLF    DB      0DH,0AH,'$'

RDECMSS DB      0DH,0AH,'Input Decimal Number(0~9):$'

;-------------------------------------------------

CODE1   ENDS

;-------------------------------------------------

        END

