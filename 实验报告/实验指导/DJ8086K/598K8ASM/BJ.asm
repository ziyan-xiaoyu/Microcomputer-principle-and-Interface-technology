CODE SEGMENT            ;BJ.ASM
ASSUME CS:CODE
IOCONPT EQU 0FF2BH
IOBPT	EQU 0FF29H
IOAPT	EQU 0FF28H
PA      EQU 0FF20H ;字位口
PB      EQU 0FF21H ;字形口
PC      EQU 0FF22H ;键入口
	ORG 1630H
START:  JMP START0
BUF     DB ?,?,?,?,?,?
KZ      DB ?
ltime   db ?
lkey    db ?
data1:  db 0c0h,0f9h,0a4h,0b0h,99h,92h,82h,0f8h,80h,90h,88h,83h,0c6h,0a1h
        db 86h,8eh,0ffh,0ch,89h,0deh,0c7h,8ch,0f3h,0bfh,8FH,0F1H
START0: CALL BUF1
        MOV AL,88H
	MOV DX,IOCONPT
	OUT DX,AL
redikey:call dispkey
	cmp KZ,01h
        JZ ZZ
	cmp KZ,02h
        JZ FZ
	cmp KZ,03h
        JZ STX
        JMP REDIKEY
STX:    JMP ST
ZZ:     CALL BUFZ
ZZ1:    MOV DX,IOAPT
	MOV AL,03H
        MOV DX,IOAPT
	OUT DX,AL
        CALL DELPZ
	MOV AL,06H
        MOV DX,IOAPT
	OUT DX,AL
        CALL DELPZ
	MOV AL,0CH
        MOV DX,IOAPT
	OUT DX,AL
        CALL DELPZ
	MOV AL,09H
        MOV DX,IOAPT
	OUT DX,AL
        CALL DELPZ
	MOV AL,03H
        MOV DX,IOAPT
	OUT DX,AL
        CALL DELPZ
	MOV AL,06H
        MOV DX,IOAPT
	OUT DX,AL
        CALL DELPZ
	MOV AL,0CH
        MOV DX,IOAPT
	OUT DX,AL
        CALL DELPZ
	MOV AL,09H
        MOV DX,IOAPT
	OUT DX,AL
        CALL DELPZ
	JMP ZZ1
;-------------------------
FZ:     CALL BUFF
FZ1:    MOV DX,IOAPT
	MOV AL,0CH
	OUT DX,AL
	CALL DELPF
	MOV AL,06H
        MOV DX,IOAPT
	OUT DX,AL
	CALL DELPF
        MOV DX,IOAPT
	MOV AL,03H
	OUT DX,AL
	CALL DELPF
	MOV AL,09H
        MOV DX,IOAPT
	OUT DX,AL
	CALL DELPF
	MOV AL,0CH
        MOV DX,IOAPT
	OUT DX,AL
	CALL DELPF
	MOV AL,06H
        MOV DX,IOAPT
	OUT DX,AL
	CALL DELPF
	MOV AL,03H
        MOV DX,IOAPT
	OUT DX,AL
	CALL DELPF
	MOV AL,09H
        MOV DX,IOAPT
	OUT DX,AL
	CALL DELPF
        JMP FZ1
;-----------------
ST:     CALL BUFS
        MOV DX,IOAPT
	MOV AL,00H
	OUT DX,AL
ST1:    call dispkey
	cmp KZ,01h
        JZ ZZMON
	cmp KZ,02h
        JZ FZMON
        JMP ST1
delpZ:  mov cx,02h
con1:   push cx
	CALL dispkey
        pop cx
	cmp KZ,02h
        JZ FZMON
	cmp KZ,03h
        JZ STMON
        loop con1
        RET
delpF:  mov cx,02h
con2:   push cx
	CALL dispkey
        pop cx
	cmp KZ,01h
        JZ ZZMON
	cmp KZ,03h
        JZ STMON
        loop con2
        RET
ZZMON:  POP CX
        JMP ZZ
FZMON:  POP CX
        JMP FZ
STMON:  POP CX
        JMP ST
;-------------------------
dispkey:call disp
	call key
	mov ah,al	     ;newkey
	mov bl,ltime    ;ltime
	mov bh,lkey    ;lkey
	mov al,01h
	mov dx,PA ;0ff21h
	out dx,al
	cmp ah,bh
	mov bh,ah	     ;bh=new key
	mov ah,bl	     ;al=time
	jz disk4
	mov bl,88h
	mov ah,88h
disk4:	dec ah
	cmp ah,82h
	jz disk6
	cmp ah,0eh
	jz disk6
	cmp ah,00h
	jz disk5
	mov ah,20h
	dec bl
	jmp disk7
disk5:	mov ah,0fh
disk6:	mov bl,ah
	mov ah,bh
disk7:	mov ltime,bl
	mov lkey,bh
	mov KZ,bh
	mov al,ah
	ret
key:	mov al,0ffh
	mov dx,PB  ;0FF22H
	out dx,al
	mov bl,00h
	mov ah,0feh
	mov cx,08h
key1:	mov al,ah
	mov dx,PA  ;0ff21h
	out dx,al
	rol al,01h
	mov ah,al
	nop
	nop
	nop
	nop
	nop
	nop
	mov dx,PC ;0ff23h
	in al,dx
	not al
	nop
	nop
	and al,0fh
	jnz key2
	inc bl
	loop key1
	jmp nkey
key2:	test al,01h
	je key3
	mov al,00h
	jmp key6
key3:	test al,02h
	je key4
	mov al,08h
	jmp key6
key4:	test al,04h
	je key5
	mov al,10h
	jmp key6
key5:	test al,08h
	je nkey
	mov al,18h
key6:	add al,bl
	cmp al,10h
	jnc fkey
	mov bl,al
	mov bh,0h
        mov si,offset data2
	mov al,[bx+si]
	ret
nkey:	mov al,20h
fkey:	ret
data2:	db 07h,04h,08h,05h,09h,06h,0ah,0bh
	DB 01h,00h,02h,0fh,03h,0eh,0ch,0dh
DISP:   MOV AL,0FFH         ;00H
	MOV DX,PA
	OUT DX,AL
	MOV CL,0DFH     ;20H           ;显示子程序 ,5ms
	MOV BX,OFFSET BUF
DIS1:   MOV AL,[BX]
        MOV AH,00H
	PUSH BX
	MOV BX,OFFSET DATA1
        ADD BX,AX
        MOV AL,[BX]
	POP BX
	MOV DX,PB
	OUT DX,AL
	MOV AL,CL
	MOV DX,PA
	OUT DX,AL
	PUSH CX
DIS2:	MOV CX,0a0H
        LOOP $
        POP CX
	CMP CL,0FEH
	JZ LX1
	INC BX
	ROR CL,1
	JMP DIS1
LX1:    MOV AL,0FFH
	MOV DX,PB
	OUT DX,AL
	RET
BUF1:   MOV BUF,0BH
        MOV BUF+1,019H
        MOV BUF+2,17H
        MOV BUF+3,17H
        MOV BUF+4,17H
        MOV BUF+5,17H
        RET
BUFZ:   MOV BUF,0BH
        MOV BUF+1,19H
        MOV BUF+2,17H
        MOV BUF+3,17H
        MOV BUF+4,17H
        MOV BUF+5,0FH
        RET
BUFF:   MOV BUF,0BH
        MOV BUF+1,19H
        MOV BUF+2,17H
        MOV BUF+3,17H
        MOV BUF+4,17H
        MOV BUF+5,18H
        RET
BUFS:   MOV BUF,0BH
        MOV BUF+1,19H
        MOV BUF+2,17H
        MOV BUF+3,17H
        MOV BUF+4,17H
        MOV BUF+5,05H
        RET

CODE ENDS
END  START