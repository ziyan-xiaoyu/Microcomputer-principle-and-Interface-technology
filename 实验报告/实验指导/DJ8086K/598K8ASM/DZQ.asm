CODE SEGMENT            ;DZQ.ASM
ASSUME CS:CODE,ds:code
CONTROL equ 43h
COUNT0  equ 40h
COUNT1  equ 41h
COUNT2  equ 42h
IOCONPT EQU 0FF2BH
IOBPT	EQU 0FF29H
IOAPT	EQU 0FF28H
PA      EQU 0FF20H ;��λ��
PB      EQU 0FF21H ;���ο�
PC      EQU 0FF22H ;�����
	ORG 18F0H
START:  JMP START0
BUF     DB ?,?,?,?,?,?
KZ      DB ?
ltime   db ?
lkey    db ?
ZP      DW ?
data1:  db 0c0h,0f9h,0a4h,0b0h,99h,92h,82h,0f8h,80h,90h,88h,83h,0c6h,0a1h
        db 86h,8eh,0ffh,0ch,89h,0deh,0c7h,8ch,0f3h,0bfh,8FH,0F1H
data3:  dw   2273, 2024, 1805, 1704
        dw   1517, 1353, 1205, 1136
START0: mov ax,cs
        mov ds,ax
        CALL BUF1
        MOV AL,88H
        MOV DX,IOCONPT
	OUT DX,AL
        mov dx,IOBPT
        mov al,00
        out dx,al
        mov zp,offset buf
redikey:call dispkey
	cmp KZ,09h
        JNC redikey
        cmp kz,01h
        jc redikey
        mov bx,zp
        mov al,kz
        mov [bx],al
        cmp bx,offset buf+5
        jz zp1
        inc bx
        mov zp,bx
        jmp outtone
zp1:    mov zp,offset buf
outtone:mov dx,IOBPT
        mov al,0ffh
        out dx,al
        mov al,kz
        mov ah,00h
        dec ax
        shl ax,1
        mov bx,offset data3
        add bx,ax
        mov ax,[bx]
        call t8253
        mov cx,20h
con1:   push cx
        call disp
        pop cx
        loop con1
        mov dx,IOBPT
        mov al,00
        out dx,al
        jmp redikey
t8253:  push  ax
        mov   al, 76h          ; ������1, 16λ������,��ʽ3��
        mov   dx, CONTROL
        out   dx, al
        pop   ax
        mov   dx, COUNT1
        out   dx, al
        mov   al, ah
        out   dx, al
        ret
;-------------------------
dispkey:call disp
	call key
	mov ah,al	     ;newkey
	mov bl,ltime    ;ltime
	mov bh,lkey    ;lkey
	mov al,01h
	mov dx,PA      ;0ff21h
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
	mov dx,PB   ;0ff22h
	out dx,al
	mov bl,00h
	mov ah,0feh
	mov cx,08h
key1:	mov al,ah
	mov dx,PA    ;0ff21h
	out dx,al
	rol al,01h
	mov ah,al
	nop
	nop
	nop
	nop
	nop
	nop
	mov dx,PC    ;0ff23h
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
	MOV CL,0DFH     ;20H           ;��ʾ�ӳ��� ,5ms
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
BUF1:   MOV BUF,11H
        MOV BUF+1,10H
        MOV BUF+2,10H
        MOV BUF+3,10H
        MOV BUF+4,10H
        MOV BUF+5,10H
        RET

CODE ENDS
END  START
