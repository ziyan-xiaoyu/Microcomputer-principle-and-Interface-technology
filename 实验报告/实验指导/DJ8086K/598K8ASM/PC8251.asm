CODE SEGMENT       ;PC8251.ASM,8251TXD-->PCRXD
ASSUME CS:CODE
SECOPORT EQU 03F9H
SEDAPORT EQU 03F8H
PA      EQU 0FF20H ;字位口
PB      EQU 0FF21H ;字形口
PC      EQU 0FF22H ;键入口
	 ORG 1A00H
START:  JMP START0
BUF     DB ?,?,?,?,?,?
KZ      DB ?
lcntkz  dw ?
;lkey    db ?
zp      dw ?
data1:  db 0c0h,0f9h,0a4h,0b0h,99h,92h,82h,0f8h,80h,90h,88h,83h,0c6h,0a1h
        db 86h,8eh,0ffh,0ch,89h,0deh,0c7h,8ch,0f3h,0bfh,8FH
START0: call for8251
        mov zp,offset buf
        CALL BUF1       ;DISP:8251-1
redikey:call dispkey
	cmp KZ,10h
	jc wattxd
	jmp funckey
WATTXD: MOV DX,SECOPORT
	IN AL,DX
	TEST AL,01H
	JZ WATTXD
	MOV AL,KZ
	MOV DX,SEDAPORT
	OUT DX,AL
        mov bx,zp
        mov [bx],al
        cmp bx,offset buf+5
        jz zp1
        inc bx
        mov zp,bx
        jmp redikey
zp1:    mov zp,offset buf
        jmp redikey
funckey:CMP KZ,1FH
	JNZ REDIKEY
        call buf2       ;good
monit:	CALL DISP
	JMP monit
dispkey:call disp
	call key
 XD:    MOV BX,lcntkz
	MOV CX,[BX]
	MOV AH,AL
	CMP AL,CH
	JE XD1
	MOV CL,88H
XD1:    DEC CL
	CMP CL,82H
	JE XD3
	CMP CL,0EH
	JE XD3
	CMP CL,00H
	JE XD2
	MOV AL,20H
	JMP XD3
XD2:    MOV CL,0FH
XD3:    MOV BX,lcntkz
	MOV CH,AH
	MOV [BX],CX
        mov kz,al
	RET
key:	mov al,0ffh
	mov dx,PB    ;0ff22h
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
	mov dx,PC  ;0ff23h
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

for8251:call t8253
	mov al,65h
	out dx,al
	mov dx,03f9h
	mov al,25h
	out dx,al
	mov dx,03f9h
	mov al,65h
	out dx,al
	mov dx,03f9h
	mov al,4eh
	out dx,al
	mov dx,03f9h
	mov al,25h
	out dx,al
	ret
T8253:	  MOV DX,43H     ;9600
	  MOV AL,76H
	  out dx,al
	  MOV DX,41H
	  MOV AL,0CH
	  out dx,al
	  MOV DX,41H
	  MOV AL,00H
	  out dx,al
	  mov dx,03F9H
	  mov dx,03f9h
	  RET
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
DIS2:	MOV CX,00A0H
        LOOP $
        POP CX
	CMP CL,0FEH  ;01H
	JZ LX1
	INC BX
	ROR CL,1     ;SHR CL,1
	JMP DIS1
LX1:    MOV AL,0FFH
	MOV DX,PB
	OUT DX,AL
	RET
BUF1:   MOV BUF,08H
        MOV BUF+1,02H
        MOV BUF+2,05H
        MOV BUF+3,01H
        MOV BUF+4,17H
        MOV BUF+5,01H
        RET
BUF2:   MOV BUF,09H
        MOV BUF+1,00H
        MOV BUF+2,00H
        MOV BUF+3,0dH
        MOV BUF+4,10H
        MOV BUF+5,10H
        RET
BUF3:   MOV BUF,0eH
        MOV BUF+1,18H
        MOV BUF+2,18H
        MOV BUF+3,10H
        MOV BUF+4,10H
        MOV BUF+5,10H
        RET

CODE ENDS
END  START
