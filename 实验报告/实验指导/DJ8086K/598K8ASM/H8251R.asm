CODE SEGMENT            ;H8251R.ASM
ASSUME CS:CODE
SECOPORT EQU 03F9H
SEDAPORT EQU 03F8H
PA      EQU 0FF20H ;×ÖÎ»¿Ú
PB      EQU 0FF21H ;×ÖÐÎ¿Ú
PC      EQU 0FF22H ;¼üÈë¿Ú
	 ORG 1510H
START:  JMP START0
BUF     DB ?,?,?,?,?,?
ZP      DW ?
data1:  db 0c0h,0f9h,0a4h,0b0h,99h,92h,82h,0f8h,80h,90h,88h,83h,0c6h,0a1h
        db 86h,8eh,0ffh,0ch,89h,0deh,0c7h,8ch,0f3h,0bfh,8FH
START0: call for8251
        MOV ZP,OFFSET BUF
        CALL BUF1
watrxd: call disp
	MOV DX,SECOPORT
	IN AL,DX
	TEST AL,02H
	JZ watrxd
	MOV DX,SEDAPORT
	IN AL,DX
	PUSH AX
wattxd: MOV DX,SECOPORT
	IN AL,DX
	TEST AL,01H
	JZ WATTXD
	MOV DX,SEDAPORT
	POP AX
	OUT DX,AL
	MOV BX,ZP
	mov [BX],AL
	CMP BX,OFFSET BUF+5
	jz serial1
	INC BX
	MOV ZP,BX
	jmp watrxd
serial1:mov ZP,OFFSET BUF
	jmp watrxd
DISP:   MOV AL,0FFH         ;00H
	MOV DX,PA
	OUT DX,AL
	MOV CL,0DFH     ;20H           ;ÏÔÊ¾×Ó³ÌÐò ,5ms
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
T8253:	  MOV DX,43H
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
BUF1:   MOV BUF,08H
        MOV BUF+1,02H
        MOV BUF+2,05H
        MOV BUF+3,01H
        MOV BUF+4,17H
        MOV BUF+5,02H
        RET
code ends
END  START
7lP
