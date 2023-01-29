CODE SEGMENT            ;H8250.ASM
ASSUME CS:CODE          ;H8250.ASM
DATA	EQU	0ff80H	;BTS-LSB
MSB	EQU	0ff81H
LINE	EQU 	0ff83H
LSTAT	EQU	0ff85H
PA      EQU 0FF20H ;字位口
PB      EQU 0FF21H ;字形口
PC      EQU 0FF22H ;键入口
	ORG 29A0H
START:  JMP START0
BUF     DB ?,?,?,?,?,?
data1:  db 0c0h,0f9h,0a4h,0b0h,99h,92h,82h,0f8h,80h,90h,88h,83h,0c6h,0a1h
        db 86h,8eh,0ffh,0ch,89h,0deh,0c7h,8ch,0f3h,0bfh,8FH
START0: MOV AL,80H	;DLAB=1
	MOV DX,LINE
	OUT DX,AL
	MOV AL,18H	;BTS=4800
	MOV DX,DATA     ;8000H
	OUT DX,AL
	MOV DX,MSB
	MOV AL,00
	OUT DX,AL
;-----------------------------------------------------
	MOV AL,03H	;8- BIT ,1-STOP
	MOV DX,LINE
	OUT DX,AL
;--------------------------------------------------
	MOV AL,00	;NO-INT
	MOV DX,MSB      ;8001H
	OUT DX,AL
	MOV AH,10H
	MOV BX,4000H
MAIN:	CALL TXD
	CALL RCV
	MOV [BX],AL
	INC BX
	INC AH
	CMP AH,00H
	JNZ MAIN
	CALL BUF1
	MOV CX,00FFH
S3:	PUSH CX
	CALL DISP
	POP CX
	LOOP S3
	CALL BUF3
S1:	CALL DISP
	JMP S1
TXD:	MOV DX,LSTAT
WAIT1:	IN AL,DX
	TEST AL,20H
	JZ WAIT1
	MOV AL,AH
	MOV DX,DATA
	OUT DX,AL
	RET
RCV:	MOV DX,LSTAT
WAIT2:	IN AL,DX
	TEST AL,01H
	JZ WAIT2
	TEST AL,0EH
	JNZ ERR
	MOV DX,DATA
	IN AL,DX
	RET
ERR:	CALL BUF2
S2:	CALL DISP
	JMP S2
;------------------------------------------------------
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
BUF1:   MOV BUF,08H
        MOV BUF+1,02H
        MOV BUF+2,05H
        MOV BUF+3,00H
        MOV BUF+4,17H
        MOV BUF+5,17H
        RET
;-------------------------------------------------------------
BUF2:   MOV BUF,08H
        MOV BUF+1,02H
        MOV BUF+2,05H
        MOV BUF+3,00H
        MOV BUF+4,0EH
        MOV BUF+5,18H
        RET
BUF3:   MOV BUF,09H
        MOV BUF+1,00H
        MOV BUF+2,00H
        MOV BUF+3,0DH
        MOV BUF+4,10H
        MOV BUF+5,10H
        RET

CODE ENDS
END  START
