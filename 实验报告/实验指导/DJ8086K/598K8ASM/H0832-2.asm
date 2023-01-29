CODE SEGMENT        ;H0832-2.ASM 0-->5v
ASSUME CS:CODE
DAPORT  EQU 0FF80h
PA      EQU 0FF20H ;字位口
PB      EQU 0FF21H ;字形口
PC      EQU 0FF22H ;键入口
        ORG 1110H
START:  JMP START0
BUF     DB ?,?,?,?,?,?
data1:  db 0c0h,0f9h,0a4h,0b0h,99h,92h,82h,0f8h,80h,90h,88h,83h,0c6h,0a1h
        db 86h,8eh,0ffh,0ch,89h,0deh,0c7h,8ch,0f3h,0bfh,8FH

START0: call buf1
DACON0: MOV AL,00H
DACON1: MOV DX,DAPORT
        OUT DX,AL
        push ax
        call conv
        MOV CX,0010H
DISCON: PUSH CX
        call disp
        POP CX
        LOOP DISCON
        pop ax
        INC AL
        CMP AL,00H
        JNZ DACON1
        MOV AL,0FFH
DACON2: MOV DX,DAPORT
        OUT DX,AL
        push ax
        call conv
        MOV CX,0010H
DISCON2:PUSH CX
        call disp
        POP CX
        LOOP DISCON2
        pop ax
        DEC AL
        CMP AL,0FFH
        JNZ DACON2
        JMP DACON0
CONV:   MOV AH,AL
        AND AL,0FH
        MOV BX,OFFSET BUF
        MOV [BX+5],AL
        MOV AL,AH
        AND AL,0F0H
        MOV CL,04H
        SHR AL,CL
        MOV [BX+4],AL
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
DELAY:  LOOP DELAY
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
BUF1:   MOV BUF,00H
        MOV BUF+1,08H
        MOV BUF+2,03H
        MOV BUF+3,02H
        MOV BUF+4,00H
        MOV BUF+5,00H
        RET
DELY:   PUSH CX
DEL2:   PUSH CX
DEL3:   PUSH CX
        LOOP $
        POP CX
        LOOP DEL3
        POP CX
        LOOP DEL2
        POP CX
        LOOP DELY
        RET
CODE ENDS
END START
