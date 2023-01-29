CODE SEGMENT            ;RAM.ASM
ASSUME CS:CODE
PA      EQU 0FF20H ;字位口
PB      EQU 0FF21H ;字形口
PC      EQU 0FF22H ;键入口
	ORG 1850h
START:  JMP START0
BUF     DB ?,?,?,?,?,?
data1:  db 0c0h,0f9h,0a4h,0b0h,99h,92h,82h,0f8h,80h,90h,88h,83h,0c6h,0a1h
        db 86h,8eh,0ffh,0ch,89h,0deh,0c7h,8ch,0f3h,0bfh,8FH
START0:	MOV AX,0H
	MOV DS,AX
	MOV BX,4000H
	MOV AX,55AAH
	MOV CX,0200H
RAMW1:	MOV DS:[BX],AX
	ADD BX,0002H
	LOOP RAMW1
	MOV AX,4000H
	MOV SI,AX
	MOV AX,5000H
	MOV DI,AX
	MOV CX,0400H
	CLD
	REP MOVSB
        call buf1
        mov cx,0ffh
con1:   push cx
        call disp
        pop cx
        loop con1
        call buf2
con2:   call disp
        jmp con2
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
BUF1:   MOV BUF,06H
        MOV BUF+1,02H
        MOV BUF+2,02H
        MOV BUF+3,05H
        MOV BUF+4,06H
        MOV BUF+5,17H
        RET
BUF2:   MOV BUF,17H
        MOV BUF+1,17H
        MOV BUF+2,09H
        MOV BUF+3,00H
        MOV BUF+4,00H
        MOV BUF+5,0dH
        RET
CODE ENDS
END  START
