	CODE SEGMENT    ;S7.ASM,LOOK FOR MAX & MIN
	ASSUME CS:CODE	
	ORG 2E70H	;INPUT DATA 4000H--4007H
START:	JMP START0
PA      EQU 0FF20H ;字位口
PB      EQU 0FF21H ;字形口
PC      EQU 0FF22H ;键入口
BUF	DB ?,?,?,?,?,?
data1:  db 0c0h,0f9h,0a4h,0b0h,99h,92h,82h,0f8h,80h,90h,88h,83h,0c6h,0a1h
        db 86h,8eh,0ffh,0ch,89h,0deh,0c7h,8ch,0f3h,0bfh,8FH
START0:	MOV SI,4000H
	MOV CX,0008H
	CALL MAXMIN
	CALL BUF1
CON1:	CALL DISP
	JMP CON1
MAXMIN:	JCXZ EXIT
	PUSH SI
	PUSH CX
	PUSH BX
	MOV BH,[SI]
	MOV BL,BH
CON2:	LODSB
	CMP AL,BH
	JNA X1
	MOV BH,AL
	JMP X2
X1:	CMP AL,BL
	JNB X2
	MOV BL,AL
X2:	LOOP CON2
	MOV AX,BX
	POP BX
	POP CX
	POP SI
EXIT:	RET
DISP:   	MOV AL,0FFH         ;00H
	MOV DX,PA
	OUT DX,AL
	MOV CL,0DFH        ;显示子程序 ,5ms
	MOV BX,OFFSET BUF
DIS1:   	MOV AL,[BX]
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
        MOV AL,0FFH         ;00H
	MOV DX,PA
	OUT DX,AL
	INC BX
	ROR CL,1     ;SHR CL,1
	JMP DIS1
LX1:    	MOV AL,0FFH
	MOV DX,PB
	OUT DX,AL
	RET
BUF1:	MOV BH,AH
	CALL ZH
      	MOV BUF+5,AL
      	MOV BUF+4,AH
	MOV AL,BH
	CALL ZH
      	MOV BUF,AH
      	MOV BUF+1,AL
        	MOV BUF+2,17H
      	MOV BUF+3,17H
	RET
;------------------------------------------------------------------------------------
ZH:	MOV BL,AL
	MOV CL,4
	ROL AL,CL
	AND AL,0FH
	MOV AH,AL
	MOV AL,BL
	AND AL,0FH
	RET
;-------------------------------------------------------
	CODE ENDS
END  START

