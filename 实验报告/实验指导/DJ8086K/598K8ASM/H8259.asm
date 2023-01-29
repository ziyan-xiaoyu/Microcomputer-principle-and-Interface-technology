CODE SEGMENT            ;H8259.ASM
ASSUME CS:CODE
INTPORT1 EQU 0FF80H
INTPORT2 EQU 0FF81H
INTQ3	 EQU INTREEUP3
INTQ7	 EQU INTREEUP7
PA      EQU 0FF20H ;字位口
PB      EQU 0FF21H ;字形口
PC      EQU 0FF22H ;键入口
	ORG 12D0H
START:  JMP START0
BUF     DB ?,?,?,?,?,?
intcnt  db ?
data1:  db 0c0h,0f9h,0a4h,0b0h,99h,92h,82h,0f8h,80h,90h,88h,83h,0c6h,0a1h
        db 86h,8eh,0ffh,0ch,89h,0deh,0c7h,8ch,0f3h,0bfh,8FH
START0:	CLD
	CALL BUF1
	CALL WRINTVER		     ;WRITE INTRRUPT
	MOV AL,13H
	MOV DX,INTPORT1
	OUT DX,AL
	MOV AL,08H
	MOV DX,INTPORT2
	OUT DX,AL
	MOV AL,09H
	OUT DX,AL
	MOV AL,0F7H
	OUT DX,AL
	MOV intcnt,01H	;TIME=1
	STI
WATING: CALL DISP		     ;DISP 8259-1
	JMP WATING
WRINTVER:MOV AX,0H
	 MOV ES,AX
	 MOV DI,002CH
	 LEA AX,INTQ3
	 STOSW
	 MOV AX,0000h
	 STOSW
	 MOV DI,003CH
	 LEA AX,INTQ7
	 STOSW
	 MOV AX,0000h
	 STOSW
	 RET
INTREEUP3:CLI
             push ax
             push bx
             push cx
             push dx
	  MOV AL,INTCNT
	  CALL CONVERS
	  MOV BX,OFFSET BUF  ;077BH
	  MOV AL,10H
	  MOV CX,05H
INTRE0:   MOV [BX],AL
	  INC BX
	  LOOP INTRE0
	  MOV AL,20H
	  MOV DX,INTPORT1
	  OUT DX,AL
	  ADD INTCNT,01H
	  CMP INTCNT,0AH
	  JNA INTRE2
          CALL BUF2     ;DISP:good
INTRE1:   CALL DISP
	  JMP INTRE1
CONVERS:  AND AL,0FH
	  MOV BX,offset buf    ;077AH
	  MOV [BX+5],AL
	  RET
INTRE2:   MOV AL,20H
	  MOV DX,INTPORT1
	  OUT DX,AL
          pop dx
          pop cx
          pop bx
          pop ax
	  STI
	  IRET
INTREEUP7: CLI
	   MOV AL,20H
	   MOV DX,INTPORT1
	   OUT DX,AL
           call buf3            ;disp:err
INTRE3:    CALL DISP
	   JMP INTRE3
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
        MOV BUF+3,09H
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
